      SUBROUTINE NEWEVC(EVEC,SCR,NBAS,ISPIN)
C
C THIS ROUTINE REORDERS AN EIGENVECTOR MATRIX FROM THE MO ORDERING
C  TO SCF ORDERING FOR A SPECIFIC SPIN CASE
C
CEND
      IMPLICIT DOUBLE PRECISION (A-H,O-Z)
      INTEGER DIRPRD,POP,VRT
      DIMENSION EVEC(NBAS,NBAS),SCR(NBAS,NBAS)
      COMMON /SYMINF/ NSTART,NIRREP,IRREPS(255,2),DIRPRD(8,8)
      COMMON /SYM/ POP(8,2),VRT(8,2),NT(2),NF(2),NF2(2)
      COMMON /MACHSP/ IINTLN,IFLTLN,IINTFP,IALONE,IBITWD
      COMMON /INFO/ NOCCO(2),NVRTO(2)
C
      ITHRU=1
C
C COPY OCCUPIED MO VECTORS INTO SCR
C
      IOFF0=1
      DO 10 IRREP=1,NIRREP
       IOFF=IOFF0
       NOCC=POP(IRREP,ISPIN)
       DO 20 I=1,NOCC
        CALL SCOPY(NBAS,EVEC(1,ITHRU),1,SCR(1,IOFF),1)
        write(6,*)' copied ',ioff,' to ',ithru
        IOFF=IOFF+1
        ITHRU=ITHRU+1
20     CONTINUE
       IOFF0=IOFF0+POP(IRREP,ISPIN)+VRT(IRREP,ISPIN)
10    CONTINUE
C
C COPY VIRTUAL MO VECTORS INTO SCR
C
      IOFF0=POP(1,ISPIN)+1
      DO 110 IRREP=1,NIRREP
       IOFF=IOFF0
       NVRT=VRT(IRREP,ISPIN)
       DO 120 I=1,NVRT
        CALL SCOPY(NBAS,EVEC(1,ITHRU),1,SCR(1,IOFF),1)
        write(6,*)' copied ',ioff,' to ',ithru
        IOFF=IOFF+1
        ITHRU=ITHRU+1
120    CONTINUE
       IF(IRREP.NE.NIRREP)IOFF0=IOFF0+NVRT+POP(IRREP+1,ISPIN)
110   CONTINUE
C
C NOW OVERWRITE ORIGINAL EIGENVECTORS WITH REORDERED ONES
C
      CALL SCOPY (NBAS*NBAS,SCR,1,EVEC,1)
C
      RETURN
      END  
