      SUBROUTINE PREVIB(NRX,H,SCRATCH,GRAD)
C
C FRONT END TO NORMAL COORDINATE CALCULATION.  COMPRESSES DUMMY
C   ATOMS OUT OF VECTORS PASSED THROUGH COMMON (VARIABLE NAMES,
C   ATOMIC MASSES, COORDINATES) AND RETURNS THE NUMBER OF REAL
C   ATOMS * 3.  ALSO CALCULATE VECTOR WHICH RELATES ABSOLUTE
C   Z-MATRIX POSITION WITH "REAL ATOM" POSITION.
C
      IMPLICIT DOUBLE PRECISION (A-H, O-Z)
C MXATMS     : Maximum number of atoms currently allowed
C MAXCNTVS   : Maximum number of connectivites per center
C MAXREDUNCO : Maximum number of redundant coordinates.
C
      INTEGER MXATMS, MAXCNTVS, MAXREDUNCO
      PARAMETER (MXATMS=200, MAXCNTVS = 10, MAXREDUNCO = 3*MXATMS)
      PARAMETER (TOL = 1.D-3)
      DIMENSION IREPOS(MXATMS)
C     Labels used throughout the program:
C     ZSYM    Atomic symbol given for each line of the Z-matrix
C     VARNAM  Symbols of all variable parameters
C     PARNAM  Symbols of all variables *and* (fixed) parameters
C
C cbchar.com : begin
C
      CHARACTER*5 ZSYM, VARNAM, PARNAM
      COMMON /CBCHAR/ ZSYM(MXATMS), VARNAM(MAXREDUNCO),
     &                PARNAM(MAXREDUNCO)

C cbchar.com : end


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


C
      COMMON /USINT/ NX, NXM6, IARCH, NCYCLE, NUNIQUE, NOPT
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
      COMMON/MACHSP/IINTLN,IFLTLN,IINTFP,IALONE,IBITWD
      COMMON/OPTCTL/IPRNT,INR,IVEC,IDIE,ICURVY,IMXSTP,ISTCRT,IVIB,
     &   ICONTL,IRECAL,INTTYP,IDISFD,IGRDFD,ICNTYP,ISYM,IBASIS,
     &   XYZTOL
      COMMON/FLAGS/IFLAGS(100),IFLAGS2(500)
      COMMON/ORIENT/ORIENT(3,3)
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
      CHARACTER*5 JUNK(MXATMS)
      DIMENSION SCRATCH(3*NX),H(NX,NX),GRAD(NX)
C
C DETERMINE NUMBER OF REAL ATOMS (NOT DUMMIES).  THIS
C  DETERMINES THE RANK OF THE HESSIAN.  ALSO, SIMULTANEOUSLY
C  REMOVE DUMMY ATOM ENTRIES FROM Q,ATMASS AND ZSYM VECTORS.
C
C
C FIRST GENERATE A COMPRESSED HESSIAN.  REMOVE DUMMY ATOM COLUMNS
C  FIRST. CODED SO THAT THE ARRAY CAN SUBSEQUENTLY BE PASSED INTO
C  VIB1 AS A NRX X NRX ARRAY.
C
      IX=0
      JX=1
      DO 100 J=1,NX
      DO 100 I=1,NX
       INK=1+(I-0.1)/3
       JNK=1+(J-0.1)/3
       IF(ATMASS(INK).GT.0.1.AND.ATMASS(JNK).GT.0.1)THEN
       IX=IX+1
       H(IX,JX)=H(I,J)
       IF(IX.EQ.NX)IX=0
       IF(IX.EQ.0)JX=JX+1
      ENDIF
100   CONTINUE
C
      Call Getrec(20,'JOBARC','NREALATM',1,Nreals)
      NRX = 3*NREALS
C
C The Cartesian Hessian ordered according to the input and without dummy 
C atom contributions. Used in Coriolis Coupling modlue in a2proc. 
C Ajith Perera, 02/2009
c
      CALL PUTREC(20,'JOBARC','CARTHESC',NRX*NRX*IINTFP,H)
      CALL ZERO(SCRATCH,3*NX)
C
C      Write(6,*) "@-previb, The Hessian"
       CALL output(h, 1, NRX, 1, NRX, NRX, NRX, 1)
       Write(6,*)
       Write(6,*) "@-previb, The griadients"
       Write(6, "(3F10.5)") (GRAD(I), I=1,NX)
C
C
C NOW COMPRESS THE VARIOUS ARRAYS.
C
 
      NREAL=0
      NRX=0
      CALL ZERO(SCRATCH,3*NX)
      CALL IZERO(IREPOS,NATOMS)
      DO 3 I=1,NATOMS
      IF(ATMASS(I).GE.0.5D0)THEN
       NREAL=NREAL+1
       IREPOS(I)=NREAL
       SCRATCH(NREAL)=ATMASS(I)
       JUNK(NREAL)=ZSYM(I)
       CALL SCOPY(3,GRAD(3*I-2),1,GRAD(3*NREAL-2),1)
       CALL VADD(SCRATCH(NX+3*NREAL-2),SCRATCH(NX+3*NREAL-2)
     &,Q(3*I-2),3,1.D0)
      ENDIF
 3    CONTINUE
      CALL ZERO(Q,NX)
      CALL ZERO(ATMASS,NATOMS)
      NRX=3*NREAL
      CALL VADD(Q,Q,SCRATCH(NX+1),NRX,1.D0)
      CALL VADD(ATMASS,ATMASS,SCRATCH,NREAL,1.D0)
      DO 10 I=1,NREAL
      ZSYM(I)=JUNK(I)
 10   CONTINUE
      DO 11 I=NREAL+1,NATOMS
      ZSYM(I)='     '
 11   CONTINUE
      IF(NREAL.EQ.0)THEN
       WRITE(LUOUT,8702)
 8702  FORMAT(T3,'@PREVIB-F, No real atoms found in ATMASS string.')
       Call ErrEx
      ENDIF
      CALL PUTREC(20,'JOBARC','DUMSTRIP',NATOMS,IREPOS)
C
C COMPRESS DUMMY ATOM STUFF OUT OF BMATRIX
C
      IF(IFLAGS(68).NE.1) THEN
C
       CALL GETREC(20,'JOBARC','BMATRIX ',IINTFP*NX*NXM6,SCRATCH)
       IX=0
       JX=0
       DO 110 I=1,NX
        INK=1+(I-0.1)/3
        JX=JX+1
        IF(IREPOS(INK).NE.0)THEN
         IX=IX+1
         IF(IX.NE.JX)THEN
          IOFF=1+(IX-1)*NXM6
          JOFF=1+(JX-1)*NXM6
          CALL SCOPY(NXM6,SCRATCH(JOFF),1,SCRATCH(IOFF),1)
         ENDIF
        ENDIF
110    CONTINUE
       CALL PUTREC(20,'JOBARC','BMATRIXC',IINTFP*3*NREAL*NXM6,SCRATCH)
C
      ENDIF
C
      RETURN
      END
