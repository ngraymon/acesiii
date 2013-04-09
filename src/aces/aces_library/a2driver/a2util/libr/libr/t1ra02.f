      SUBROUTINE T1RA02(ICORE,MAXCOR,IUHF,LAMBDA)
C
C THIS SUBROUTINE COMPUTES ONE OF TWO T1*W CONTRIBUTIONS TO THE
C  W(mbej) INTERMEDIATE.  
C
C           W(MBEJ) = - SUM T(J,F) * <FE||BM> + SUM T(N,B) * <NM||JE>    (1)
C           W(mbej) = - SUM T(j,f) * <fe||bm> + SUM T(n,b) * <nm||je>    (2)
C
C ALSO COMPUTED IS THE T1*W CONTRIBUTIONS TO THE F(ea) INTERMEDIATE
C
C           F(EA)   =  SUM T(M,F) * <FE||MA> = - SUM T(M,F) * <FE||AM>  (3)
C           F(ea)   =  SUM T(m,f) * <fe||ma> = - SUM T(m,f) * <fe||am>  (4)
C
C WHICH ARE OBTAINED BY TAKING GENERALIZED TRACES (N**3 DEPENDENCE) OVER THE
C TERMS CALCULATED IN EQS 1 AND 2.
C
C
CEND
      IMPLICIT INTEGER (A-Z)
      LOGICAL LAMBDA
      DOUBLE PRECISION ONE,ONEM,ZILCH,ALPHA,BETA,FACTOR
      CHARACTER*4 SPCASE(2)
      LOGICAL INCORE
      DIMENSION ICORE(MAXCOR),IOFFT1(8,2),ABFULL(8),MNFULL(8)
      COMMON /MACHSP/ IINTLN,IFLTLN,IINTFP,IALONE,IBITWD
      COMMON /SYMINF/ NSTART,NIRREP,IRREPA(255),IRREPB(255),
     &                DIRPRD(8,8)
      COMMON /SYMPOP/ IRPDPD(8,22),ISYTYP(2,500),ID(18)
      COMMON /SYM/ POP(8,2),VRT(8,2),NTAA,NTBB,NF1AA,NF2AA,
     &             NF1BB,NF2BB
      COMMON /INFO/ NOCCO(2),NVRTO(2)
      DATA ONE /1.0/
      DATA ZILCH /0.0/
      DATA ONEM /-1.0/
      DATA SPCASE /'AAAA','BBBB'/
      integer  aces_list_rows, aces_list_cols
      external aces_list_rows, aces_list_cols
C
C FIRST PICK UP T1 VECTOR.
C
      CALL GETT1(ICORE,MAXCOR,MXCOR,IUHF,IOFFT1)
C
C SPIN CASES AAAA AND BBBB
C
      LSTFEA=92
      DO 10 ISPIN=1,1+IUHF
       LSTTAR=53+ISPIN
       IF(LAMBDA)THEN
        LSTOUT=122+ISPIN
        FACTOR=ONEM
       ELSE
        LSTOUT=LSTTAR
        FACTOR=ONE
       ENDIF
C
C COMPUTE A,B DPD SIZE FOR ALL IRREPS
C
       DO 1000 IRREP=1,NIRREP
        ICOUNT=0
        ICOUNT2=0
        DO 1001 IRREPE=1,NIRREP
         IRREPF=DIRPRD(IRREPE,IRREP)
         ICOUNT=ICOUNT+VRT(IRREPF,ISPIN)*VRT(IRREPE,ISPIN)
         ICOUNT2=ICOUNT2+POP(IRREPF,ISPIN)*POP(IRREPE,ISPIN)
1001    CONTINUE
        ABFULL(IRREP)=ICOUNT
        MNFULL(IRREP)=ICOUNT2
1000   CONTINUE
C
C LOOP OVER IRREPS - IN THE FIRST BLOCK OF CODE THIS CORRESPONDS TO BM,
C                    WHILE IT IS JE IN THE SECOND BLOCK.
C
       DO 20 IRREPDO=1,NIRREP
        DISTAR=aces_list_cols(IRREPDO,22+ISPIN)
        DSZTAR=aces_list_rows(IRREPDO,22+ISPIN)
        CALL IZERO(ICORE,IINTFP*DISTAR*DSZTAR)
C
C FIRST DO THE   W(MBEJ) =  SUM T(J,F) * <FE||BM>  CONTRIBUTION.
C
C THIS PRODUCT IS INITIALLY PACKED J,E-B,M
C
        LSTINT=26+ISPIN
        IF(IUHF.EQ.0) LSTINT=30
        DISW  =aces_list_cols(IRREPDO,LSTINT)
        DSZW  =aces_list_rows(IRREPDO,LSTINT)
        DSZEXP=ABFULL(IRREPDO)
C
C I000 HOLDS THE W(JEBM) TARGET FOR GAMMA(BM).
C I010 HOLDS AREA EVENTUALLY USED AS SCRATCH IN SYMTR AND THE F(ea)
C          CONTRIBUTION COMPUTED BY TRACEOO.
C I020 HOLDS THE <EF||BM> INTEGRALS (ENOUGH SPACE IS ALLOCATED TO HOLD
C      FULL LIST (E,F;B,M)).
C
        I000  =1
        I010  =I000+IINTFP*DISTAR*DSZTAR
        I011  =I010+IINTFP*MAX(DSZTAR,DSZEXP,ABFULL(1))
        I012  =I011+IINTFP*DSZTAR
        I020  =I012+IINTFP*DSZTAR
        I030  =I020+IINTFP*DSZEXP*DISW
        I040  =I030+IINTFP*MAX(DSZEXP,DISW)*(1-IUHF)
        IEND  =I040+IINTFP*MAX(DSZEXP,DISW)*(1-IUHF)
        IF(IEND.LE.MXCOR)THEN
         INCORE=.TRUE.
         CALL GETLST(ICORE(I020),1,DISW,2,IRREPDO,LSTINT)
         IF(IUHF.NE.0) THEN
          CALL SYMEXP2(IRREPDO,VRT(1,ISPIN),DSZEXP,DSZW,DISW,
     &                ICORE(I020),ICORE(I020))
         ELSE
          CALL ASSYM2A(IRREPDO,VRT(1,ISPIN),DSZEXP,DISW,
     &                ICORE(I020),ICORE(I030),ICORE(I040))
         ENDIF
        ELSE
         INCORE=.FALSE.
         I030=I020+IINTFP*DSZW
         I040=I030+IINTFP*MAX(DSZEXP,DISW)*(1-IUHF)
         IEND=I040+IINTFP*MAX(DSZEXP,DISW)*(1-IUHF)
         IF(IEND.GE.MXCOR) CALL INSMEM('T1RA02',IEND,MXCOR)
        ENDIF
        DO 30 INUMBM=1,DISW
         IF(INCORE)THEN
          IOFFW1R=(INUMBM-1)*DSZEXP*IINTFP+I020
         ELSE
          CALL GETLST(ICORE(I020),INUMBM,1,2,IRREPDO,LSTINT)
          IF(IUHF.NE.0) THEN
           CALL SYMEXP2(IRREPDO,VRT(1,ISPIN),DSZEXP,DSZW,1,
     &                  ICORE(I020),ICORE(I020))
          ELSE
           CALL ASSYM2A(IRREPDO,VRT(1,ISPIN),DSZEXP,1,
     &                 ICORE(I020),ICORE(I030),ICORE(I040))
          ENDIF
          IOFFW1R=I020
         ENDIF
         IOFFW1L=0
         IOFFZL=0
         IOFFZR=(INUMBM-1)*DSZTAR*IINTFP+I000
         DO 40 IRREPE=1,NIRREP
          IRREPT=DIRPRD(IRREPE,IRREPDO)
          IOFFT=IOFFT1(IRREPT,ISPIN)
          IOFFW1=IOFFW1R+IOFFW1L
          IOFFZ=IOFFZR+IOFFZL
          NROW=POP(IRREPT,ISPIN)
          NCOL=VRT(IRREPE,ISPIN)
          NSUM=VRT(IRREPT,ISPIN)
          ALPHA=ONEM*FACTOR
          BETA=ZILCH
          IF(MIN(NROW,NCOL,NSUM).GT.0)THEN
           CALL XGEMM('T','N',NROW,NCOL,NSUM,ALPHA,ICORE(IOFFT),NSUM,
     &                ICORE(IOFFW1),NSUM,BETA,ICORE(IOFFZ),NROW)
          ENDIF
          IOFFW1L=IOFFW1L+NCOL*NSUM*IINTFP
          IOFFZL=IOFFZL+NROW*NCOL*IINTFP
40       CONTINUE
30      CONTINUE
C
C NOW GET CONTRIBUTION TO F(ea) INTERMEDIATE FROM TRACEOO.
C
        IF(.NOT.LAMBDA) THEN
        CALL TRACEOO('OVVO',IRREPDO,POP(1,ISPIN),VRT(1,ISPIN),
     &               DISTAR,ABFULL(1),ICORE(I000),
     &               ICORE(I010))
        CALL SUMSYM3(ICORE(I010),ICORE(I020),ABFULL(1),1,ISPIN,LSTFEA)
        ENDIF
C
C NOW TRANSPOSE IT TO GET IT IN THE SAME ORDERING AS THE NEXT PIECE.
C                           (B,M-J,E)
C  
        CALL MTRAN2(ICORE(I000),DSZTAR)
C
C NOW DO THE  -SUM(N,B) * <NM||JE>  CONTRIBUTION - THIS IS ORDERED
C          B,M-J,E
C
        DISW  =aces_list_cols(IRREPDO,6+ISPIN)
        DSZW  =aces_list_rows(IRREPDO,6+ISPIN)
        DSZEXP=MNFULL(IRREPDO)
C
C I020 HOLDS THE <NM||JE> INTEGRALS (ENOUGH SPACE IS ALLOCATED TO HOLD
C      FULL LIST (N,M;J,E).
C
        I020  =I010+IINTFP*MAX(DSZEXP,MNFULL(1))
        I030  =I020+IINTFP*DSZEXP*DISW
        IF(I030.LE.MXCOR)THEN
         INCORE=.TRUE.
         CALL GETLST(ICORE(I020),1,DISW,2,IRREPDO,6+ISPIN)
         CALL SYMEXP2(IRREPDO,POP(1,ISPIN),DSZEXP,DSZW,DISW,
     &               ICORE(I020),ICORE(I020))
        ELSE
         INCORE=.FALSE.
         I030=I020+IINTFP*DSZW
        ENDIF
        DO 50 INUMJE=1,DISW
         IF(INCORE)THEN
          IOFFW2R=(INUMJE-1)*DSZEXP*IINTFP+I020
         ELSE
          CALL GETLST(ICORE(I020),INUMJE,1,2,IRREPDO,6+ISPIN)
          CALL SYMEXP2(IRREPDO,POP(1,ISPIN),DSZEXP,DSZW,1,
     &                 ICORE(I020),ICORE(I020))
          IOFFW2R=I020
         ENDIF
         IOFFW2L=0
         IOFFZR=(INUMJE-1)*DSZTAR*IINTFP+I000
         IOFFZL=0
         DO 60 IRREPM=1,NIRREP
          IRREPT=DIRPRD(IRREPM,IRREPDO)
          IOFFT=IOFFT1(IRREPT,ISPIN)
          IOFFW2=IOFFW2R+IOFFW2L
          IOFFZ=IOFFZR+IOFFZL
          NROW=VRT(IRREPT,ISPIN)
          NCOL=POP(IRREPM,ISPIN)
          NSUM=POP(IRREPT,ISPIN)
          ALPHA=ONE*FACTOR
          BETA=ONE
          IF(MIN(NROW,NCOL,NSUM).GT.0)THEN
           CALL XGEMM('N','N',NROW,NCOL,NSUM,ALPHA,ICORE(IOFFT),NROW,
     &                ICORE(IOFFW2),NSUM,BETA,ICORE(IOFFZ),NROW)
          ENDIF
          IOFFW2L=IOFFW2L+NCOL*NSUM*IINTFP
          IOFFZL=IOFFZL+NROW*NCOL*IINTFP
60       CONTINUE
50      CONTINUE
C
C NOW SWITCH ORDERING TO B,M-E,J AND WRITE THESE QUANTITIES TO DISK FOR
C  EACH IRREP.
C
        CALL SYMTR1(IRREPDO,POP(1,ISPIN),VRT(1,ISPIN),
     &             DSZTAR,ICORE(I000),ICORE(I010),
     &             ICORE(I011),ICORE(I012))
        CALL PUTLST(ICORE(I000),1,DISTAR,1,IRREPDO,LSTOUT)
20     CONTINUE
C
C NOW SWITCH ORDERING TO B,J-E,M
C
       ISCSIZ=NOCCO(ISPIN)*NVRTO(ISPIN)*2
       TARSIZ=ISYMSZ(ISYTYP(1,LSTTAR),ISYTYP(2,LSTTAR))
       I000=1
       I010=I000+TARSIZ*IINTFP
       I020=I010+TARSIZ*IINTFP
       I030=I020+ISCSIZ
       IF(I030.GT.MXCOR)CALL INSMEM('WMBEJ2',I030,MXCOR)
       CALL GETALL(ICORE(I010),TARSIZ,1,LSTOUT)
       CALL SSTRNG(ICORE(I010),ICORE(I000),TARSIZ,TARSIZ,ICORE(I020),
     &             SPCASE(ISPIN))
C
C NOW DO TRANSPOSITION TO GET E,M-B,J ORDERING IRREP BY IRREP.
C
       IOFF=1
       DO 5000 IRREP=1,NIRREP
        DSZTAR=aces_list_rows(IRREP,LSTTAR)
        DISTAR=DSZTAR
        CALL MTRAN2(ICORE(IOFF),DSZTAR)
C
C  FOR LAMBDA UPDATE TARGET LIST AND COPY ORIGINAL INTERMEDIATES TO LSTOUT
C
        IF(LAMBDA) THEN 
         CALL GETLST(ICORE(I010),1,DISTAR,2,IRREP,LSTTAR)
         CALL PUTLST(ICORE(I010),1,DISTAR,2,IRREP,LSTOUT)
         CALL SAXPY(DISTAR*DSZTAR,ONE,ICORE(I010),1,ICORE(IOFF),1)
        ENDIF
C
        CALL PUTLST(ICORE(IOFF),1,DISTAR,2,IRREP,LSTTAR)
        IOFF=IOFF+IINTFP*DISTAR*DSZTAR
5000   CONTINUE
10    CONTINUE
      RETURN
      END
