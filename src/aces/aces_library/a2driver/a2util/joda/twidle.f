      SUBROUTINE TWIDLE(A,H,F,C,Rref,RPlus,RMinus,Scratch,T)
C
C DOES RECTILINEAR --> CURVILINEAR TRANSFORMATION OF THE HESSIAN
C  MATRIX.  SOMEDAY, A BETTER ALGORITHM MAY COME UP, BUT THIS WILL
C  DO FOR NOW.  TAKES AS INPUT THE RECTILINEAR HESSIAN AND GRADIENT
C  (IN INTERNAL COORDINATES), AND PASSES BACK OUT THE CURVILIINEAR
C  HESSIAN.  THIS WILL ALSO BE USEFUL FOR COMPUTING ROTATIONALLY
C  PROJECTED FREQUENCIES.
C
      IMPLICIT DOUBLE PRECISION (A-H, O-Z)
C MXATMS     : Maximum number of atoms currently allowed
C MAXCNTVS   : Maximum number of connectivites per center
C MAXREDUNCO : Maximum number of redundant coordinates.
C
      INTEGER MXATMS, MAXCNTVS, MAXREDUNCO
      PARAMETER (MXATMS=200, MAXCNTVS = 10, MAXREDUNCO = 3*MXATMS)
C coord.com : begin
C
      DOUBLE PRECISION Q, R, ATMASS
      INTEGER NCON, NR, ISQUASH, IATNUM, IUNIQUE, NEQ, IEQUIV,
     &        NOPTI, NATOMS
      COMMON /COORD/ Q(3*MXATMS), R(MAXREDUNCO), NCON(MAXREDUNCO),
     &     NR(MXATMS),ISQUASH(MAXREDUNCO),IATNUM(MXATMS),
     &     ATMASS(MXATMS),IUNIQUE(MAXREDUNCO),NEQ(MAXREDUNCO),
     &     IEQUIV(MAXREDUNCO,MAXREDUNCO),
     &     NOPTI(MAXREDUNCO), NATOMS

C coord.com : end


c
C     Main OPTIM control data
C     IPRNT   Print level - not used yet by most routines
C     INR     Step-taking algorithm to use
C     IVEC    Eigenvector to follow (TS search)
C     IDIE    Ignore negative eigenvalues
C     ICURVY  Hessian is in curviliniear coordinates
C     IMXSTP  Maximum step size in millibohr
C     ISTCRT  Controls scaling of step
C     IVIB    Controls vibrational analysis
C     ICONTL  Negative base 10 log of convergence criterion.
C     IRECAL  Tells whether Hessian is recalculated on each cyc
C     INTTYP  Tells which integral program is to be used
C              = 0 Pitzer
C              = 1 VMol
C     XYZTol  Tolerance for comparison of cartesian coordinates
C
      COMMON /OPTCTL/ IPRNT,INR,IVEC,IDIE,ICURVY,IMXSTP,ISTCRT,IVIB,
     $   ICONTL,IRECAL,INTTYP,IDISFD,IGRDFD,ICNTYP,ISYM,IBASIS,
     $   XYZTol
 
 
      COMMON /USINT/ NX, NXM6, IARCH, NCYCLE, NUNIQUE, NOPT
      DIMENSION RREF(NX),RPLUS(NX),RMINUS(NX),C(NX,NXM6),A(NX,NXM6)
      DIMENSION SCRATCH(NX*NX),H(NXM6,NXM6),F(NXM6),T(NXM6,NXM6)
      PARAMETER(DELX=1.D-3)
      PARAMETER(TWO=2.D0)
c io_units.par : begin

      integer    LuOut
      parameter (LuOut = 6)

      integer    LuErr
      parameter (LuErr = 6)

      integer    LuBasL
      parameter (LuBasL = 1)
      character*(*) BasFil
      parameter    (BasFil = 'BASINF')

      integer    LuVMol
      parameter (LuVMol = 3)
      character*(*) MolFil
      parameter    (MolFil = 'MOL')
      integer    LuAbi
      parameter (LuAbi = 3)
      character*(*) AbiFil
      parameter    (AbiFil = 'INP')
      integer    LuCad
      parameter (LuCad = 3)
      character*(*) CadFil
      parameter    (CadFil = 'CAD')

      integer    LuZ
      parameter (LuZ = 4)
      character*(*) ZFil
      parameter    (ZFil = 'ZMAT')

      integer    LuGrd
      parameter (LuGrd = 7)
      character*(*) GrdFil
      parameter    (GrdFil = 'GRD')

      integer    LuHsn
      parameter (LuHsn = 8)
      character*(*) HsnFil
      parameter    (HsnFil = 'FCM')

      integer    LuFrq
      parameter (LuFrq = 78)
      character*(*) FrqFil
      parameter    (FrqFil = 'FRQARC')

      integer    LuDone
      parameter (LuDone = 80)
      character*(*) DonFil
      parameter    (DonFil = 'JODADONE')

      integer    LuNucD
      parameter (LuNucD = 81)
      character*(*) NDFil
      parameter    (NDFil = 'NUCDIP')

      integer LuFiles
      parameter (LuFiles = 90)

c io_units.par : end
      DEL=DELX
C
C GET REFERENCE INTERNAL COORDINATES
C
      IF(IPRNT.GE.666)WRITE(LUOUT,3123)
      CALL XTOR(RREF,0)
C
C LOOP THROUGH INTERNAL COORDINATES; BUILD A PARTICULAR J,K MEMBER
C                  jk
C                 T
C                  i
C  FOR *ALL* I ON EACH PASS.  I REFERES TO THE INTERNAL COORDINATE.
C  IDIHED GETS TURNED ON IF THE INTERNAL COORDINATE IS A DIHEDRAL
C  ANGLE
C
C
C GET DIAGONAL ELEMENTS FIRST.  NEED THESE FOR OFF DIAGS.
C
      CALL ZERO(SCRATCH,NX*NXM6)
      CALL VADD(SCRATCH,SCRATCH,Q,NX,1.D0)
      DO 10 J=1,NXM6
       CALL ZERO(SCRATCH(NX+1),NX)
       CALL VADD(SCRATCH(NX+1),A(1,J),SCRATCH(NX+1),NX,1.D0)
       CALL xscal(NX,DEL,SCRATCH(NX+1),1)
       CALL VADD(Q,Q,SCRATCH(NX+1),NX,1.D0)
       CALL XTOR(RPLUS,0)
       CALL DCHECK(RREF,RPLUS,NXM6)
       CALL xscal(NX,TWO,SCRATCH(NX+1),1)
       CALL VADD(Q,Q,SCRATCH(NX+1),NX,-1.D0)
       CALL XTOR(RMINUS,0)
       CALL DCHECK(RREF,RMINUS,NXM6)
       CALL ZERO(Q,NX)
       CALL VADD(Q,Q,SCRATCH,NX,1.D0)
C
C NOW CAN GENERATE T(I)(J,J) FOR ALL I.  STORE THESE IN C(I,J)
C
       DO 55 I=1,NXM6
        C(I,J)=(RPLUS(I)+RMINUS(I)-2.D0*RREF(I))/DEL**2
        H(J,J)=H(J,J)-F(I)*C(I,J)
        IF(IPRNT.EQ.666)WRITE(LUOUT,3121)I,J,J,C(I,J)
 55    CONTINUE
 10    CONTINUE
       CALL ZERO(Q,NX)
       CALL VADD(Q,Q,SCRATCH,NX,1.D0)
C
C NOW GET OFF DIAGONALS
C
       CALL ZERO(SCRATCH(NX+1),NX*2)
       DO 30 J=1,NXM6
        DO 30 K=1,J-1
        CALL ZERO(SCRATCH(NX+1),2*NX)
        CALL ZERO(Q,NX)
        CALL VADD(Q,SCRATCH,Q,NX,1.D0)
        CALL VADD(SCRATCH(NX+1),A(1,J),SCRATCH(NX+1),NX,1.D0)
        CALL xscal(NX,DEL,SCRATCH(NX+1),1)
        CALL VADD(SCRATCH(2*NX+1),A(1,K),SCRATCH(2*NX+1),NX,1.D0)
        CALL xscal(NX,DEL,SCRATCH(2*NX+1),1)
        CALL VADD(Q,Q,SCRATCH(NX+1),NX,1.D0)
        CALL VADD(Q,Q,SCRATCH(2*NX+1),NX,1.D0)
        CALL XTOR(RPLUS,0)
        CALL DCHECK(RREF,RPLUS,NXM6)
        CALL xscal(NX*2,TWO,SCRATCH(NX+1),1)
        CALL VADD(Q,Q,SCRATCH(NX+1),NX,-1.D0)
        CALL VADD(Q,Q,SCRATCH(2*NX+1),NX,-1.D0)
        CALL XTOR(RMINUS,0)
        CALL DCHECK(RREF,RMINUS,NXM6)
C
C CONTINUE
C
       DO 56 I=1,NXM6
       P1=RPLUS(I)+RMINUS(I)-2.D0*RREF(I)-C(I,J)*DEL**2-
     &C(I,K)*DEL**2
       T(J,K)=0.5D0*P1/DEL**2
       T(K,J)=T(J,K)
       IF(IPRNT.EQ.666)WRITE(LUOUT,3121)I,J,K,T(J,K)
       H(J,K)=H(J,K)-F(I)*T(J,K)
       H(K,J)=H(J,K)
 56    CONTINUE
 30    CONTINUE
       CALL ZERO(Q,NX)
       CALL VADD(Q,Q,SCRATCH,NX,1.D0)
       ICURVY=1
 3123  FORMAT(T3,' Dump of rectilinear => curvilinear T tensor ',
     &'follows:')
 3121  FORMAT(T3,'[',I3,',',I3,',',I3,']',2X,F20.12)
 
      RETURN
      END
