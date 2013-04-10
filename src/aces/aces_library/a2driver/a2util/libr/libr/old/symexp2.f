      SUBROUTINE SYMEXP2(IRREP,NUM,DSZ1,DSZ,DIS,A1,A)
C
C     THIS ROUTINE EXPANDS THE A COMPRESSED ARRAY A(AB,IJ) WITH
C     A < B TO AN ARRAY A(AB,IJ) WITH A,B. NOTE THAT THIS ROUTINE
C     EXPECTS THAT THE ARRAY A IS SYMMETRY PACKED
C
C  USAGE :
C
C          IRREP ....... IRREDUCIBLE REPRESENTATION OF THE BLOCKS
C          NUM ......... POPULATION IN EACH IRREP FOR THE ORBITALS
C                        (EITHER VIRTUAL OR OCCUPIED IN DEPENDENCE
C                        IF A VIRTUAL-VIRTULA OR OCCUPIED-OCCUPIED      
C                        BLOCK MUST BE EXTENDED
C          DSZ1 ........ DISTRIBUTION SIZE OF EXPANDED ARRAY
C          DSZ ......... DISTRIBUTION SIZE OF OLD ARRAY
C          DIS ......... NUMBER OF DISTRIBUTIONS IN A AND A1
C          A1 .......... EXPANDED ARRAY (OUTPUT)
C          A ........... OLD ARRAY (INPUT)
C
C NOTE THAT THIS IS A IN PLACE EXPANSION, HOWEVER THE SAME ADDRESS
C HAS TO BE PASSED TWO TIMES TO THIS ROUTINE ( AS A1 AND A) IN ORDER
C TO DEAL WITH THE DIFFREENT DIMENSIONS OF THE INPUT AND OUTPUT ARRAY
C
CEND
C
C  CODED JG JUNE/90
C
      IMPLICIT DOUBLE PRECISION (A-H,O-Z)
      INTEGER DIS,DIRPRD,DSZ1,DSZ
      DIMENSION A(DSZ,DIS),A1(DSZ1,DIS),NUM(8)
      DIMENSION IPOLD(8),IPNEW(8)
C
      COMMON /SYMINF/NSTART,NIRREP,IRREPA(255),IRREPB(255),
     &DIRPRD(8,8)
C
      IND(J,I)=((J-1)*(J-2))/2+I
C 
      DATA ZERO /0.0D0/
C
C    COPY FIRST A TO A1
C
      DO 1000 L=DIS,1,-1
      DO 1000 I=DSZ,1,-1
       A1(I,L) = A(I,L) 
1000  CONTINUE
C
C     TAKE HERE CARE, IF WE ARE HANDLING IRREP=1 (TOTAL SYMMETRIC)
C     OR IRREP=1 (OTHERWISE)
C
      IF(IRREP.EQ.1) THEN
C
C     GET FIRST POINTERS FOR OLD AND NEW INDICES
C
       IPOLD(1)=0
       IPNEW(1)=0
       DO 10 IRREPJ=1,(NIRREP-1)
        IPOLD(IRREPJ+1)=IPOLD(IRREPJ)+(NUM(IRREPJ)*(NUM(IRREPJ)-1))/2
        IPNEW(IRREPJ+1)=IPNEW(IRREPJ)+NUM(IRREPJ)**2
10     CONTINUE
C
C     NOW LOOP BACKWARDS FROM THE HIGHEST TO THE LOWEST IRREP
C
       DO 1 IRREPJ=NIRREP,1,-1
        NUMJ=NUM(IRREPJ)
        IPO=IPOLD(IRREPJ)
        IPN=IPNEW(IRREPJ)
C
C     LOOP OVER ORBITALS, BUT ALSO IN BACKWARD ORDER
C
        DO 100 J=NUMJ,2,-1
         DO 100 I=J-1,1,-1
          IND1=IND(J,I)+IPO
          IND2=(J-1)*NUMJ+I+IPN
          DO 101 L=1,DIS
          A1(IND2,L)=A1(IND1,L)
101       CONTINUE
100     CONTINUE
C
C    FILL NOW DIAGONAL ELEMENTS WITH ZERO
C
       DO 200 I=1,NUMJ
        IND1=(I-1)*NUMJ+I+IPN
        DO 201 L=1,DIS
        A1(IND1,L)=ZERO
201     CONTINUE
200    CONTINUE
C
C     EXPAND NOW THE ARRAY
C
       DO 300 J=2,NUMJ
CDIR$ NOVECTOR
*VOCL LOOP,SCALAR
        DO 300 I=1,J-1
         IND1=(J-1)*NUMJ+I+IPN
         IND2=(I-1)*NUMJ+J+IPN
C
CDIR$ VECTOR
*VOCL LOOP,VECTOR
         DO 301 L=1,DIS
         A1(IND2,L)=-A1(IND1,L)
301      CONTINUE
300    CONTINUE
1      CONTINUE
C
      ELSE
C
C     FILL THE POINTERS OF THE OLD AND NEW ARRAY
C
      IPOLD(1)=0
      IPNEW(1)=0
      DO 1001 IRREPJ=1,NIRREP-1
       IRREPI=DIRPRD(IRREP,IRREPJ)
       NUMJ=NUM(IRREPJ)
       NUMI=NUM(IRREPI)
       IPNEW(IRREPJ+1)=IPNEW(IRREPJ)+NUMJ*NUMI
       IF(IRREPI.LT.IRREPJ) THEN
        IPOLD(IRREPJ+1)=IPOLD(IRREPJ)+NUMJ*NUMI
       ELSE
        IPOLD(IRREPJ+1)=IPOLD(IRREPJ)
       ENDIF
1001  CONTINUE
C
C     NOW COPY OLD ARRAYS TO NEW LOCATION
C
      DO 2000 IRREPJ=NIRREP,1,-1
       IRREPI=DIRPRD(IRREP,IRREPJ)
       NUMJ=NUM(IRREPJ)
       NUMI=NUM(IRREPI)
       IF(IRREPJ.GT.IRREPI) THEN
        IPN=IPNEW(IRREPJ)
        IPO=IPOLD(IRREPJ)
        DO  2100 IJ=NUMJ*NUMI,1,-1
         DO 2101 L=1,DIS
         A1(IPN+IJ,L)=A1(IPO+IJ,L)
2101     CONTINUE
2100    CONTINUE
       ELSE
        IPN=IPNEW(IRREPJ)
        IPO=IPNEW(IRREPI)
        DO 2200 J=1,NUMJ
CDIR$ NOVECTOR
*VOCL LOOP,SCALAR
         DO 2200 I=1,NUMI
          IND1=(I-1)*NUMJ+J+IPO
          IND2=(J-1)*NUMI+I+IPN
C
CDIR$ VECTOR
*VOCL LOOP,VECTOR
          DO 2201 L=1,DIS
          A1(IND2,L)=-A1(IND1,L)
2201      CONTINUE
2200    CONTINUE
       ENDIF
2000  CONTINUE
      ENDIF
      RETURN
      END