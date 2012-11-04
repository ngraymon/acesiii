      SUBROUTINE SQSYM(IRREP,NUM,DSZA,DSZB,NUMSIZ,A,B)
C
C     THIS ROUTINE SQUEEZES A SYMMETRY PACKED ARRAY
C
C     A(AB,IJ) = B(AB,IJ)  A<B IN A AND A,B IN B
C
C     B IS AN ARRAY WITH ALL A,B ELEMENTS STORED
C     A AN ARRAY WITH ALL A<B ELEMENTS STORED
C
C     INPUT : IRREP = IRREP OF (A,B) BLOCK
C             NUM = POPULATION IN EACH IRREP FOR I AND J
C             DSZA = DISTRIBUTION SIZE IN OUTPUT ARRAY
C             DSZB = DISTRIBUTION SIZE IN INPUT ARRAY
C             NUMSIZ = NUMBER OF DISTRIBUTIONS IN A AND B
C             B = INPUT ARRAY WITh ELEMENTS TO BE ANTISYMMTRIZED
C     OUTPUT : A = ANTISYMMETRIZED OUTPUT ARRAY
C
CEND
C
C   CODED JUNE/90  JG
C
      IMPLICIT DOUBLE PRECISION (A-H,O-Z)
      INTEGER DSZA,DSZB,DIRPRD
      DIMENSION A(DSZA,NUMSIZ),B(DSZB,NUMSIZ),NUM(8)
      DIMENSION IP(8),IPFULL(8)
C
      COMMON/SYMINF/NSTART,NIRREP,IRREPA(255),IRREPB(255),
     &              DIRPRD(8,8)
C
C     TAKE CARE, IF WE ARE HANDLING IRREP = 1 OR
C     SOMETHING ELSE
C
      IF(IRREP.EQ.1) THEN
C
C     GET FIRST POINTERS FOR OLD AND NEW INDICES
C
       IPFULL(1)=0
       IP(1)=0
       DO 10 IRREPJ=1,NIRREP-1
        IP(IRREPJ+1)=IP(IRREPJ)+NUM(IRREPJ)*(NUM(IRREPJ)-1)/2
        IPFULL(IRREPJ+1)=IPFULL(IRREPJ)+NUM(IRREPJ)**2
10     CONTINUE
C
C     NOW LOOP OVER ALL IRREPS
C
       DO 1 IRREPJ=1,NIRREP
        NUMJ=NUM(IRREPJ)
        IND=IP(IRREPJ)
        IPF=IPFULL(IRREPJ)
C
C     LOOP OVER ORBITALS
C
        DO 2 J=2,NUMJ 
        DO 2 I=1,J-1
         IND=IND+1
         IND1=IPF+(J-1)*NUMJ+I
         DO 3 L=1,NUMSIZ
          A(IND,L)=B(IND1,L)
3        CONTINUE
2       CONTINUE
1      CONTINUE
      ELSE
C
C     IRREP NE 1
C
C     FILL FIRST POINTERS
C
      IP(1)=0
      IPFULL(1)=0
      DO 1001 IRREPJ=1,NIRREP-1
       IRREPI=DIRPRD(IRREP,IRREPJ)
       NUMJ=NUM(IRREPJ)
       NUMI=NUM(IRREPI)
       IPFULL(IRREPJ+1)=IPFULL(IRREPJ)+NUMJ*NUMI
       IF(IRREPI.LT.IRREPJ) THEN
        IP(IRREPJ+1)=IP(IRREPJ)+NUMJ*NUMI
       ELSE
        IP(IRREPJ+1)=IP(IRREPJ)
       ENDIF
1001  CONTINUE
C
C     NOW LOOP OVER ALL IRREPS
C
      DO 1002 IRREPJ=1,NIRREP
      IRREPI=DIRPRD(IRREPJ,IRREP)
      IF(IRREPI.LT.IRREPJ) THEN
C
       NUMJ=NUM(IRREPJ)
       NUMI=NUM(IRREPI)
C
       IPNEW=IP(IRREPJ)
       IPJ=IPFULL(IRREPJ)
C
C      LOOP OVER ORBITALS
C
       DO 1003 J=1,NUMJ
        DO 1003 I=1,NUMI
         IND=IPNEW+(J-1)*NUMI+I
         IND1=IPJ+(J-1)*NUMI+I
         DO 1004 L=1,NUMSIZ
          A(IND,L)=B(IND1,L)
1004     CONTINUE
1003   CONTINUE
      ENDIF
1002  CONTINUE
      ENDIF
C
C    ALL DONE
C
      RETURN
      END
