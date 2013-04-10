      SUBROUTINE KILLGAM
C
C THIS ROUTINE DISPENSES WITH THE GAMLAM FILE AND ZEROS OUT ALL OF
C  THE ASSOCIATED LIST POINTERS
C
CEND
      IMPLICIT INTEGER(A-Z)
      LOGICAL YESNO,ISOPEN
      CHARACTER*80 FNAME
      COMMON /LISTS/ MOIO(10,500),MOIOWD(10,500),MOIOSZ(10,500),
     &              MOIODS(10,500),MOIOFL(10,500)
      COMMON /CACHEINF/ CACHNUM,CACHNMP1,CACHDIR(100),CACHPOS(100),
     &                  CACHFILE(100),CACHMOD(100),OLDEST
C
CJDW,AP  2/28/97. Add call to GFNAME so we can locate GAMLAM properly.
C                 This is important when GAMLAM is not in main working
C                 directory.
c     write(6,*) ' @killgam-i, executing modified killgam ! '
      CALL GFNAME('GAMLAM  ',FNAME,ILENGTH)
      INQUIRE(FILE=FNAME(1:ILENGTH),EXIST=YESNO,OPENED=ISOPEN)
      IF(YESNO) THEN
      IF(.NOT.ISOPEN)OPEN(UNIT=51,FILE=FNAME(1:ILENGTH),STATUS='OLD')
      CLOSE(UNIT=51,STATUS='DELETE')
      CALL IZERO(MOIO(1,101),1000)
      CALL IZERO(MOIOWD(1,101),1000)
      CALL IZERO(MOIODS(1,101),1000)
      CALL IZERO(MOIOSZ(1,101),1000)
      CALL IZERO(MOIOFL(1,101),1000)
C 
      DO 10 I=1,100
       IF(CACHFILE(I).EQ.51)CACHFILE(I)=0
10    CONTINUE   
      ENDIF
      RETURN
      END