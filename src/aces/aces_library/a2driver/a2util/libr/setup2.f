      SUBROUTINE SETUP2(ICORE,ICRSIZ,I010,I020,I030,LIST1,LIST2,
     &                  NUMDIS,NDSSIZ)
C
C THIS ROUTINE RETURNS THE SYMMETRY INFORMATION ABOUT THE LIST
C   ON MOIO(LISTT1,LISTT2),ALONG WITH
C   OFFSETS INTO THE CORE ARRAY WHERE THESE LISTS BEGIN.
C
C       ICORE - CORE VECTOR (PASSED IN)
C       ICRSIZ- SIZE OF WORKING AREA.
C       I010  - OFFSET TO BEGINNING OF THE POPULATION COUNT VECTOR FOR
C                THE LIST.
C       I020  - OFFSET TO BEGINNING OF THE SYMMETRY VECTOR FOR
C                THE LIST.
C       I030  - TOTAL CORE REQUIRED FOR SYMMETRY INFORMATION.
C       LIST1 - THE SYMMETRY TYPE FOR THE LIST "SPIN CASE".
C       LIST2 - THE SYMMETRY TYPE FOR THE LIST DISTRIBUTION TYPE.
C       NUMDIS- TOTAL NUMBER OF DISTRIBUTIONS (IN C1).
C       NDSSIZ- SIZE OF DISTRIBUTIONS (IN C1).
C
CEND
      IMPLICIT INTEGER (A-Z)
      DIMENSION ICORE(ICRSIZ)
      COMMON /SYMINF/ NSTART,NIRREP,IRREPA(255),IRREPB(255),
     &                DIRPRD(8,8)
      DISTPL=LIST1
      DISTPR=LIST2
      I010=1
      I020=I010+2*NIRREP
      I030=I020+NUMDIS+NDSSIZ
      IF(MOD(I030,2).EQ.0)I030=I030+1
C
C FETCH POINTERS.
C
      CALL GETGSV(DISTPL,NDSSIZ,DISTPR,NUMDIS,NIRREP,
     &             ICORE(I010),ICORE(I020))
      RETURN
      END

