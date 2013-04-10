C
C THIS ROUTINE DRIVES THE RESORT OF A LIST ON DISK.  
C
C INPUT :
C       ICORE - WORKING SCRATCH AREA USED IN THIS ROUTINE.  
C      MAXCOR - TOTAL WORKING AREA IN INTEGER WORDS
C        POP1 - POPULATION VECTOR FOR P
C        POP2 - POPULATION VECTOR FOR Q
C        POP3 - POPULATION VECTOR FOR R
C        POP4 - POPULATION VECTOR FOR S
C      IRREPX - THE OVERALL SYMMETRY OF THE LIST (USUALLY 1)
C    LISTFROM - THE LIST HOLDING THE PQRS QUANTITY
C     LISTOUT - THE LIST WHERE THE RESORTED QUANTITY IS WRITTEN
C      SYTYPL - LEFT SYMMETRY TYPE OF RESORTED QUANTITY
C      SYTYPR - RIGHT SYMMETRY TYPE OF RESORTED QUANTITY
C      LHSEXP - LOGICAL FLAG SET TO .TRUE. IF LEFT-HAND SIDE NEEDS
C               TO BE EXPANDED BEFORE RESORTING.
C      LFTTYP - LEFT HAND SYMMETRY TYPE [USED ONLY IF LHSEXP=.TRUE.]
C
      SUBROUTINE SSTLST(ICORE,MAXCOR,POP1,POP2,POP3,
     &                  POP4,IRREPX,TYPE,LISTFROM,
     &                  LISTOUT,SYTYPL,SYTYPR,LHSEXP,LFTTYP)
      IMPLICIT INTEGER (A-Z)
      CHARACTER*4 TYPE
      LOGICAL LHSEXP
      DIMENSION ICORE(MAXCOR)
      DIMENSION POP1(8),POP2(8),POP3(8),POP4(8)
C
      COMMON /SYMINF/ NSTART,NIRREP,IRRVEC(255,2),DIRPRD(8,8)
      COMMON /MACHSP/ IINTLN,IFLTLN,IINTFP,IALONE,IBITWD
      COMMON /SYMPOP/ IRPDPD(8,22),ISYTYP(2,500),ID(18)

      if ((LFTTYP.lt.1).or.(22.lt.LFTTYP)) then
         print *, '@SSTLST: Assertion failed.'
         print *, '   LFTTYP  = ',LFTTYP
         print *, '   LISTOUT = ',LISTOUT
         call aces_exit(1)
      end if

C
C CALCULATE SIZE OF INPUT AND OUTPUT LISTS
C
      IF(.NOT.LHSEXP)THEN
       NSIZEIN=IDSYMSZ(IRREPX,ISYTYP(1,LISTFROM),ISYTYP(2,LISTFROM))
      ELSE
       NSIZEIN=IDSYMSZ(IRREPX,LFTTYP,ISYTYP(2,LISTFROM))
      ENDIF
      NSIZEOUT=IDSYMSZ(IRREPX,SYTYPL,SYTYPR)
C
      DO 10 I=1,NIRREP
       IF(.NOT.LHSEXP)THEN
        DSZIN =IRPDPD(I,ISYTYP(1,LISTFROM))
       ELSE
        DSZIN =IRPDPD(I,LFTTYP)
       ENDIF
       DSZOUT =IRPDPD(I,ISYTYP(1,SYTYPL))
       MAXDSZ=MAX(DSZOUT,DSZIN)
10    CONTINUE
C
C SEE IF THERE IS SUFFICIENT CORE TO DO THIS THE EASY WAY.
C
      ITOP=NSIZEIN+NSIZEOUT+MAXDSZ
      IF(ITOP.LE.MAXCOR/IINTFP.AND..NOT.LHSEXP)THEN
       WRITE(6,1000)LISTFROM
       I000=1
       I010=I000+IINTFP*NSIZEIN
       I020=I010+IINTFP*NSIZEOUT
       I030=I020+IINTFP*MAXDSZ
       CALL GETALL(ICORE(I000),NSIZEIN,IRREPX,LISTFROM)
       CALL SSTGEN(ICORE(I000),ICORE(I010),NSIZEIN,POP1,POP2,POP3,
     &                   POP4,ICORE(I020),IRREPX,TYPE)
       CALL NEWTYP(LISTOUT,SYTYPL,SYTYPR,.TRUE.)
       CALL PUTALL(ICORE(I010),NSIZEOUT,IRREPX,LISTOUT)
      ELSE
       I000=1
       I010=I000+IINTFP*MAXDSZ
       I020=I010+IINTFP*NSIZEOUT
       I030=I020+IINTFP*MAXDSZ
       IF(I030.GT.MAXCOR)THEN
        CALL INSMEM('SSTLST',I030,MAXCOR)
       ELSE
        WRITE(6,2000)LISTFROM
        CALL SSTDSK(ICORE(I000),ICORE(I010),NSIZEIN,POP1,POP2,POP3,
     &              POP4,ICORE(I020),IRREPX,TYPE,LISTFROM,
     &              LISTOUT,SYTYPL,SYTYPR,LHSEXP,LFTTYP)
       ENDIF
C
      ENDIF
C
1000  FORMAT(T3,'@SSTLST-I, Reordering list ',I3,' with in-core ',
     &          'algorithm.')
2000  FORMAT(T3,'@SSTLST-I, Reordering list ',I3,' with out-of-core ',
     &          'algorithm.')
      RETURN
      END