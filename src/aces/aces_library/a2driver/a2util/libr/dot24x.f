      SUBROUTINE DOT24X(IRREPCD,Z,D,Y,POPA,POPB,POPC,POPD,LISTG,
     &                  ISYMZ,ISYMD,ISYMY,TYPE,
     &                  IRRZ,IRRD,IRRY)
C
C *****     OUT-OF-CORE VERSION OF DOT24  ******
C
C ... BUT ALSO CAN HANDLE NONSYMMETRIC CASES!
C
C **IMPORTANT** THIS ROUTINE ASSUMES THAT THE SYMLOC COMMON
C BLOCK HAS BEEN FILLED BY CALLING ACES_COM_SYMLOC!!!!!
C
C THIS ROUTINE PERFORMS UNCOMPLICATED BUT MESSY CONTRACTIONS OF
C  THE GENERIC FORM
C
C      Z(P,Q) = D(M,N) * Y(MP,NQ)  [TYPE='STST']
C      
C      Z(P,Q) = D(M,N) * Y(PM,NQ)  [TYPE='TSST']
C
C      Z(P,Q) = D(M,N) * Y(PM,QN)  [TYPE='TSTS']
C
C      Z(P,Q) = D(M,N) * Y(MP,QN)  [TYPE='STTS']
C
C INPUT:
C       IRREPCD - SYMMETRY OF KET INDICES OF I
C       Z       - THE TARGET VECTOR
C       D       - THE TWO-INDEX QUANTITY WHICH WILL BE CONTRACTED WITH
C                 THE FOUR-INDEX LIST.
C       Y       - THE FOUR-INDEX QUANTITY (PROCESSED OUT OF CORE)
C       POPA  - POPULATION VECTOR FOR FASTEST INDEX IN Y.
C       POPB  - POPULATION VECTOR FOR SECOND FASTEST INDEX IN Y.
C       POPC  - POPULATION VECTOR FOR THIRD FASTEST INDEX IN Y.
C       POPD  - POPULATION VECTOR FOR SLOWEST INDEX IN Y.
C       ISYMZ - INDEX TYPE OF Z (SEE ACES_COM_SYMLOC)
C       ISYMD - INDEX TYPE OF D (SEE ACES_COM_SYMLOC)
C       ISYMY - INDEX TYPE OF Y BRA INDICES (SEE ACES_COM_SYMLOC)
C       TYPE  - SPECIFIES THE CONTRACTION TYPE
C       IRRZ  - OVERALL SYMMETRY OF Z
C       IRRD  - OVERALL SYMMETRY OF D
C       IRRY  - OVERALL SYMMETRY OF Y
C
CEND
      IMPLICIT DOUBLE PRECISION (A-H,O-Z)
      CHARACTER*4 TYPE
      INTEGER VRT,POP,DIRPRD,POPA,POPB,POPC,POPD
      DIMENSION Y(*),D(*),Z(*),POPA(*),POPB(*),POPC(*),POPD(*)
      COMMON/MACHSP/IINTLN,IFLTLN,IINTFP,IALONE,IBITWD
      COMMON/SYM/POP(8,2),VRT(8,2),NT(2),NFMI(2),NFEA(2)
      COMMON/SYMINF/NSTART,NIRREP,IRREPY(255,2),DIRPRD(8,8)
      COMMON/SYMLOC/ISYMOFF(8,8,25)
C
      IF(TYPE.EQ.'STTS')THEN
C
C CASE I: Z(bc) = D(ad) * Y(ab,cd) 'STTS'
C
       ITHRU=1
       IRREPAB=DIRPRD(IRRY,IRREPCD)
       DO 20 IRREPD=1,NIRREP
        IRREPC=DIRPRD(IRREPD,IRREPCD)
        IRREPA=DIRPRD(IRRD,IRREPD)
        IRREPB=DIRPRD(IRRZ,IRREPC)
        NUMD=POPD(IRREPD)
        NUMC=POPC(IRREPC)
        NUMB=POPB(IRREPB)
        NUMA=POPA(IRREPA)
        DO 21 INDXD=1,NUMD
         DO 22 INDXC=1,NUMC
          CALL GETLST(Y,ITHRU,1,1,IRREPCD,LISTG)
          ITHRU=ITHRU+1
          IOFFD=NUMA*(INDXD-1)+ISYMOFF(IRREPD,IRRD,ISYMD)
          DO 23 INDXB=1,NUMB 
           IOFFZ=INDXB+NUMB*(INDXC-1)+ISYMOFF(IRREPC,IRRZ,ISYMZ)-1
           IOFFY=NUMA*(INDXB-1)+ISYMOFF(IRREPB,IRREPAB,ISYMY)
           Z(IOFFZ)=Z(IOFFZ)+SDOT(NUMA,D(IOFFD),1,Y(IOFFY),1)
23        CONTINUE
22       CONTINUE
21      CONTINUE
20     CONTINUE
C
      ELSEIF(TYPE.EQ.'TSST')THEN
C
C CASE II: Z(ad) = D(bc) * Y(ab,cd) 'TSST'
C
       ITHRU=1
       IRREPAB=DIRPRD(IRRY,IRREPCD)
       DO 30 IRREPD=1,NIRREP
        IRREPC=DIRPRD(IRREPD,IRREPCD)
        IRREPA=DIRPRD(IRRZ,IRREPD)
        IRREPB=DIRPRD(IRRD,IRREPC)
        NUMD=POPD(IRREPD)
        NUMC=POPC(IRREPC)
        NUMB=POPB(IRREPB)
        NUMA=POPA(IRREPA)
        DO 31 INDXD=1,NUMD
         DO 32 INDXC=1,NUMC
          CALL GETLST(Y,ITHRU,1,1,IRREPCD,LISTG)
          ITHRU=ITHRU+1
          IOFFD=NUMB*(INDXC-1)+ISYMOFF(IRREPC,IRRD,ISYMD)
          DO 33 INDXA=1,NUMA 
           IOFFZ=INDXA+NUMA*(INDXD-1)+ISYMOFF(IRREPD,IRRZ,ISYMZ)-1
           IOFFY=INDXA+ISYMOFF(IRREPB,IRREPAB,ISYMY)-1
           Z(IOFFZ)=Z(IOFFZ)+SDOT(NUMB,D(IOFFD),1,Y(IOFFY),NUMA)
33        CONTINUE
32       CONTINUE
31      CONTINUE
30     CONTINUE
C
      ELSEIF(TYPE.EQ.'STST')THEN
C
C CASE III: Z(bd) = D(ac) * Y(ab,cd) 'STST'
C
       ITHRU=1
       IRREPAB=DIRPRD(IRRY,IRREPCD)
       DO 40 IRREPD=1,NIRREP
        IRREPC=DIRPRD(IRREPD,IRREPCD)
        IRREPA=DIRPRD(IRRD,IRREPC)
        IRREPB=DIRPRD(IRRZ,IRREPD)
        NUMD=POPD(IRREPD)
        NUMC=POPC(IRREPC)
        NUMB=POPB(IRREPB)
        NUMA=POPA(IRREPA)
        DO 41 INDXD=1,NUMD
         DO 42 INDXC=1,NUMC
          CALL GETLST(Y,ITHRU,1,1,IRREPCD,LISTG)
          ITHRU=ITHRU+1
           IOFFD=NUMA*(INDXC-1)+ISYMOFF(IRREPC,IRRD,ISYMD)
          DO 43 INDXB=1,NUMB 
           IOFFZ=INDXB+NUMB*(INDXD-1)+ISYMOFF(IRREPD,IRRZ,ISYMZ)-1
           IOFFY=NUMA*(INDXB-1)+ISYMOFF(IRREPB,IRREPAB,ISYMY)
           Z(IOFFZ)=Z(IOFFZ)+SDOT(NUMA,D(IOFFD),1,Y(IOFFY),1)
43        CONTINUE
42       CONTINUE
41      CONTINUE
40     CONTINUE
C
      ELSEIF(TYPE.EQ.'TSTS')THEN
C
C CASE IV: Z(ac) = D(bd) * Y(ab,cd) 'TSTS'
C
       ITHRU=1
       IRREPAB=DIRPRD(IRRY,IRREPCD)
       DO 50 IRREPD=1,NIRREP
        IRREPC=DIRPRD(IRREPD,IRREPCD)
        IRREPA=DIRPRD(IRRZ,IRREPC)
        IRREPB=DIRPRD(IRRD,IRREPD)
        NUMD=POPD(IRREPD)
        NUMC=POPC(IRREPC)
        NUMB=POPB(IRREPB)
        NUMA=POPA(IRREPA)
        DO 51 INDXD=1,NUMD
         DO 52 INDXC=1,NUMC
          CALL GETLST(Y,ITHRU,1,1,IRREPCD,LISTG)
          ITHRU=ITHRU+1
          IOFFD=NUMB*(INDXD-1)+ISYMOFF(IRREPD,IRRD,ISYMD)
          DO 53 INDXA=1,NUMA 
           IOFFZ=INDXA+NUMA*(INDXC-1)+ISYMOFF(IRREPC,IRRZ,ISYMZ)-1
           IOFFY=INDXA+ISYMOFF(IRREPB,IRREPAB,ISYMY)-1
           Z(IOFFZ)=Z(IOFFZ)+SDOT(NUMB,D(IOFFD),1,Y(IOFFY),NUMA)
53        CONTINUE
52       CONTINUE
51      CONTINUE
50     CONTINUE
C
      ELSE
C
       WRITE(6,1000)TYPE
1000   FORMAT(T3,'@DOT24X-F, Contraction type ',A4,' unknown.')
       CALL ERREX
C
      ENDIF
C
      RETURN
      END