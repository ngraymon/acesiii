      SUBROUTINE ASSYM2(IRREP,NUM,DSZ,A)
C
C     THIS ROUTINE ANTISYMMETRIZES AN SYMMETRY
C     PACKED ARRAY IN PLACE
C
C     A(AB,IJ) = A(AB,IJ) - A(AB,JI) FOR ALL AB
C
C
C     INPUT : IRREP = IRREP OF (A,B) BLOCK
C             NUM = POPULATION IN EACH IRREP FOR I AND J
C             DSZ = DISTRIBUTION SIZE OF A
C             A   = INPUT MATRIX
C     OUTPUT : A  = ANTISYMMETRIZED OUTPUT MATRIX
C
CEND
C
C   CODED SEPTEMBER/90 JG
C
      IMPLICIT DOUBLE PRECISION (A-H,O-Z)
      INTEGER DSZ,DIRPRD
      DIMENSION A(DSZ,1),NUM(8)
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
        IPF=IPFULL(IRREPJ)
C
C     LOOP OVER ORBITALS
C
        DO 2 J=2,NUMJ 
        DO 2 I=1,J-1
         IND1=IPF+(J-1)*NUMJ+I
         IND2=IPF+(I-1)*NUMJ+J
CDIR$ IVDEP
*VOCL LOOP,NOVREC
         DO 3 L=1,DSZ
          A(L,IND1)=A(L,IND1)-A(L,IND2)
3        CONTINUE
2       CONTINUE
1      CONTINUE
       DO 4 IRREPJ=1,NIRREP
        NUMJ=NUM(IRREPJ)
        IND=IP(IRREPJ)
        IPF=IPFULL(IRREPJ)
        DO 5 J=2,NUMJ
        DO 5 I=1,J-1
         IND=IND+1
         IND1=IPF+(J-1)*NUMJ+I
CDIR$ IVDEP
*VOCL LOOP,NOVREC
         DO 6 L=1,DSZ
          A(L,IND)=A(L,IND1)
6        CONTINUE
5       CONTINUE
4      CONTINUE
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
       IPJ=IPFULL(IRREPJ)
       IPI=IPFULL(IRREPI)
C
C      LOOP OVER ORBITALS
C
       DO 1003 J=1,NUMJ
        DO 1003 I=1,NUMI
         IND1=IPJ+(J-1)*NUMI+I
         IND2=IPI+(I-1)*NUMJ+J
CDIR$ IVDEP
*VOCL LOOP,NOVREC
         DO 1004 L=1,DSZ
          A(L,IND1)=A(L,IND1)-A(L,IND2)
1004     CONTINUE
1003   CONTINUE
      ENDIF
1002  CONTINUE
C
C     NOW LOOP OVER ALL IRREPS
C
      DO 1005 IRREPJ=1,NIRREP
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
       DO 1006 J=1,NUMJ
        DO 1006 I=1,NUMI
         IND=IPNEW+(J-1)*NUMI+I
         IND1=IPJ+(J-1)*NUMI+I
         DO 1007 L=1,DSZ
          A(L,IND)=A(L,IND1)
1007     CONTINUE
1006   CONTINUE
      ENDIF
1005  CONTINUE
      ENDIF
C
C    ALL DONE
C
      RETURN
      END