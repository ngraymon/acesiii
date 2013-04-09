       SUBROUTINE SSTGEN(WIN,WOUT,NSIZE,POP1,POP2,POP3,
     &                   POP4,IPOS,IRREPX,TYPE)
C
C THIS ROUTINE RESORTS A W(PQ,RS) SYMMETRY-PACKED QUANTITY TO
C W(PS,RQ) [INTERCHANGE OF Q AND S].  
C
C INPUT :
C         WIN - THE W(PQ,RS) QUANTITY [ALL IRREPS]
C       NSIZE - THE SIZE OF THE W QUANTITY
C        POP1 - POPULATION VECTOR FOR P
C        POP2 - POPULATION VECTOR FOR Q
C        POP3 - POPULATION VECTOR FOR R
C        POP4 - POPULATION VECTOR FOR S
C      IRREPX - THE OVERALL SYMMETRY OF THE LIST (USUALLY 1)
C
C SCRATCH:
C        IPOS - A SCRATCH VECTOR OF THE MAXIMUM PS DISTRIBUTION LENGTH
C
C OUTPUT:
C        WOUT - THE RESORTED P(PS,RQ) QUANTITY
C         
CEND
      IMPLICIT INTEGER (A-Z)
      CHARACTER*4 TYPE
      DOUBLE PRECISION WIN(NSIZE),WOUT(NSIZE)
      DIMENSION POP1(8),POP2(8),POP3(8),POP4(8),IPOS(100)
      DIMENSION INUMLFT(8),INUMRHT(8),IABSOFF(9)
      DIMENSION IPOSRHT(8,8),IPOSLFT(8,8)
C
      COMMON /SYMINF/ NSTART,NIRREP,IRRVEC(255,2),DIRPRD(8,8)
      COMMON /SYMPOP/ IRPDPD(8,22),ISYTYP(2,500),ID(18)
C
      IF(TYPE.EQ.'1432')THEN
C
C            P Q R S -> P S R Q
C
C COMPUTE SIZE OF PS AND RQ DISTRIBUTIONS FOR EACH IRREP
C
       CALL IZERO(INUMLFT,8)
       CALL IZERO(INUMRHT,8)
       DO 100 IRREP=1,NIRREP
        DO 110 IRR1=1,NIRREP
         IRR2=DIRPRD(IRR1,IRREP)
         INUMLFT(IRREP)=INUMLFT(IRREP)+POP1(IRR2)*POP4(IRR1)
         INUMRHT(IRREP)=INUMRHT(IRREP)+POP3(IRR2)*POP2(IRR1)
110     CONTINUE        
100    CONTINUE
C
C NOW COMPUTE ABSOLUTE OFFSETS TO BEGINNING OF EACH DPD IRREP
C
       IABSOFF(1)=1
       DO 120 IRRRHT=1,NIRREP
        IRRLFT=DIRPRD(IRRRHT,IRREPX)
        IABSOFF(IRRRHT+1)=IABSOFF(IRRRHT)+
     &                    INUMLFT(IRRLFT)*INUMRHT(IRRRHT) 
        IPOSRHT(1,IRRRHT)=0
        IPOSLFT(1,IRRLFT)=0
        DO 125 IRREP1=1,NIRREP-1
         IRREP2R=DIRPRD(IRREP1,IRRRHT)
         IRREP2L=DIRPRD(IRREP1,IRRLFT)
         IPOSRHT(IRREP1+1,IRRRHT)=IPOSRHT(IRREP1,IRRRHT)+
     &                            POP3(IRREP2R)*POP2(IRREP1)*
     &                            INUMLFT(IRRLFT)
         IPOSLFT(IRREP1+1,IRRLFT)=IPOSLFT(IRREP1,IRRLFT)+
     &                           POP1(IRREP2L)*POP4(IRREP1)
125     CONTINUE
120    CONTINUE
       IOFFW=1
C
C FIRST LOOP OVER RIGHT-HAND SIDE IRREPS 
C
       DO 10 IRRRHT=1,NIRREP
        IRRLFT=DIRPRD(IRRRHT,IRREPX) 
C
C NOW LOOP OVER RS PAIRS
C
        DO 20 IRREP4=1,NIRREP
         IRREP3=DIRPRD(IRREP4,IRRRHT)
         DO 30 INDEX4=1,POP4(IRREP4)
          DO 35 INDEX3=1,POP3(IRREP3)
C
C NOW COMPUTE ADDRESSES FOR ALL DISTRIBUTION ELEMENTS IN TARGET
C VECTOR (pqrs -> psrq MAPPING) AND SCATTER DISTRIBUTION INTO
C OUTPUT ARRAY
C
           ITHRU=1
           DO 40 IRREP2=1,NIRREP
            IRREP1=DIRPRD(IRREP2,IRRLFT)
            IRREPL0=DIRPRD(IRREP1,IRREP4)
            IRREPR0=DIRPRD(IRREP3,IRREP2)
C OFFSET TO THIS IRREP OF Q WITHIN THIS RQ IRREP
            IOFF0 =IABSOFF(IRREPR0)+IPOSRHT(IRREP2,IRREPR0)
            DO 50 INDEX2=1,POP2(IRREP2)
C OFFSET TO THIS Q WITHIN THIS IRREP OF Q WITHIN THIS RQ IRREP
             IOFF =IOFF0+(INDEX2-1)*POP3(IRREP3)*INUMLFT(IRREPL0)
C OFFSET TO THIS R WITHIN ...
             IOFF =IOFF +(INDEX3-1)*INUMLFT(IRREPL0)
C OFFSET TO THIS IRREP OF S WITHIN THIS IRREP OF PS
             IOFF =IOFF+IPOSLFT(IRREP4,IRREPL0)
C OFFSET TO THIS PARTICULAR VALUE OF S WITHIN THIS IRREP OF S 
C WITHIN THIS IRREP OF PS
             IOFF =IOFF+(INDEX4-1)*POP1(IRREP1)-1 
             DO 55 INDEX1=1,POP1(IRREP1)
              IPOS(ITHRU)=IOFF+INDEX1
              ITHRU=ITHRU+1
55           CONTINUE
50          CONTINUE
40         CONTINUE
           CALL SCATTER(ITHRU-1,WOUT,IPOS,WIN(IOFFW))
           IOFFW=IOFFW+ITHRU-1
35        CONTINUE
30       CONTINUE
20      CONTINUE
10     CONTINUE 
C
      ELSEIF(TYPE.EQ.'1324')THEN
C
C            P Q R S -> P S R Q
C
C COMPUTE SIZE OF PS AND RQ DISTRIBUTIONS FOR EACH IRREP
C
       CALL IZERO(INUMLFT,8)
       CALL IZERO(INUMRHT,8)
       DO 1100 IRREP=1,NIRREP
        DO 1110 IRR1=1,NIRREP
         IRR2=DIRPRD(IRR1,IRREP)
         INUMLFT(IRREP)=INUMLFT(IRREP)+POP1(IRR2)*POP3(IRR1)
         INUMRHT(IRREP)=INUMRHT(IRREP)+POP2(IRR2)*POP4(IRR1)
1110    CONTINUE        
1100   CONTINUE
C
C NOW COMPUTE ABSOLUTE OFFSETS TO BEGINNING OF EACH DPD IRREP
C
       IABSOFF(1)=1
       DO 1120 IRRRHT=1,NIRREP
        IRRLFT=DIRPRD(IRRRHT,IRREPX)
        IABSOFF(IRRRHT+1)=IABSOFF(IRRRHT)+
     &                    INUMLFT(IRRLFT)*INUMRHT(IRRRHT) 
        IPOSRHT(1,IRRRHT)=0
        IPOSLFT(1,IRRLFT)=0
        DO 1125 IRREP1=1,NIRREP-1
         IRREP2R=DIRPRD(IRREP1,IRRRHT)
         IRREP2L=DIRPRD(IRREP1,IRRLFT)
         IPOSLFT(IRREP1+1,IRRLFT)=IPOSLFT(IRREP1,IRRLFT)+
     &                            POP1(IRREP2L)*POP3(IRREP1)
         IPOSRHT(IRREP1+1,IRRRHT)=IPOSRHT(IRREP1,IRRRHT)+
     &                            POP2(IRREP2R)*POP4(IRREP1)*
     &                            INUMLFT(IRRLFT)
1125    CONTINUE
1120   CONTINUE
       IOFFW=1
C
C FIRST LOOP OVER RIGHT-HAND SIDE IRREPS 
C
       DO 1010 IRRRHT=1,NIRREP
        IRRLFT=DIRPRD(IRRRHT,IRREPX) 
C
C NOW LOOP OVER RS PAIRS
C
        DO 1020 IRREP4=1,NIRREP
         IRREP3=DIRPRD(IRREP4,IRRRHT)
         DO 1030 INDEX4=1,POP4(IRREP4)
          DO 1035 INDEX3=1,POP3(IRREP3)
C
C NOW COMPUTE ADDRESSES FOR ALL DISTRIBUTION ELEMENTS IN TARGET
C VECTOR (pqrs -> prqs MAPPING) AND SCATTER DISTRIBUTION INTO
C OUTPUT ARRAY
C
           ITHRU=1
           DO 1040 IRREP2=1,NIRREP
            IRREP1=DIRPRD(IRREP2,IRRLFT)
            IRREPL0=DIRPRD(IRREP1,IRREP3)
            IRREPR0=DIRPRD(IRREP2,IRREP4)
C OFFSET TO THIS IRREP OF S WITHIN THIS QS IRREP
            IOFF0 =IABSOFF(IRREPR0)+IPOSRHT(IRREP4,IRREPR0)
            DO 1050 INDEX2=1,POP2(IRREP2)
C OFFSET TO THIS S WITHIN THIS IRREP OF S WITHIN THIS QS IRREP
             IOFF =IOFF0+(INDEX4-1)*POP2(IRREP2)*INUMLFT(IRREPL0)
C OFFSET TO THIS Q WITHIN ...
             IOFF =IOFF +(INDEX2-1)*INUMLFT(IRREPL0)
C OFFSET TO THIS IRREP OF R WITHIN THIS IRREP OF PR
             IOFF =IOFF+IPOSLFT(IRREP3,IRREPL0)
C OFFSET TO THIS PARTICULAR VALUE OF R WITHIN THIS IRREP OF R
C WITHIN THIS IRREP OF PR
             IOFF =IOFF+(INDEX3-1)*POP1(IRREP1)-1 
             DO 1055 INDEX1=1,POP1(IRREP1)
              IPOS(ITHRU)=IOFF+INDEX1
              ITHRU=ITHRU+1
1055         CONTINUE
1050        CONTINUE
1040       CONTINUE
           CALL SCATTER(ITHRU-1,WOUT,IPOS,WIN(IOFFW))
           IOFFW=IOFFW+ITHRU-1
1035      CONTINUE
1030     CONTINUE
1020    CONTINUE
1010   CONTINUE 
C
      ELSEIF(TYPE.EQ.'1342')THEN
C
C            P Q R S -> P S Q R
C
C COMPUTE SIZE OF PS AND RQ DISTRIBUTIONS FOR EACH IRREP
C
       CALL IZERO(INUMLFT,8)
       CALL IZERO(INUMRHT,8)
       DO 6100 IRREP=1,NIRREP
        DO 6110 IRR1=1,NIRREP
         IRR2=DIRPRD(IRR1,IRREP)
         INUMLFT(IRREP)=INUMLFT(IRREP)+POP1(IRR2)*POP3(IRR1)
         INUMRHT(IRREP)=INUMRHT(IRREP)+POP4(IRR2)*POP2(IRR1)
6110    CONTINUE        
6100   CONTINUE
C
C NOW COMPUTE ABSOLUTE OFFSETS TO BEGINNING OF EACH DPD IRREP
C
       IABSOFF(1)=1
       DO 6120 IRRRHT=1,NIRREP
        IRRLFT=DIRPRD(IRRRHT,IRREPX)
        IABSOFF(IRRRHT+1)=IABSOFF(IRRRHT)+
     &                    INUMLFT(IRRLFT)*INUMRHT(IRRRHT) 
        IPOSRHT(1,IRRRHT)=0
        IPOSLFT(1,IRRLFT)=0
        DO 6125 IRREP1=1,NIRREP-1
         IRREP2R=DIRPRD(IRREP1,IRRRHT)
         IRREP2L=DIRPRD(IRREP1,IRRLFT)
         IPOSLFT(IRREP1+1,IRRLFT)=IPOSLFT(IRREP1,IRRLFT)+
     &                            POP1(IRREP2L)*POP3(IRREP1)
         IPOSRHT(IRREP1+1,IRRRHT)=IPOSRHT(IRREP1,IRRRHT)+
     &                            POP4(IRREP2R)*POP2(IRREP1)*
     &                            INUMLFT(IRRLFT)
6125    CONTINUE
6120   CONTINUE
       IOFFW=1
C
C FIRST LOOP OVER RIGHT-HAND SIDE IRREPS 
C
       DO 6010 IRRRHT=1,NIRREP
        IRRLFT=DIRPRD(IRRRHT,IRREPX) 
C
C NOW LOOP OVER RS PAIRS
C
        DO 6020 IRREP4=1,NIRREP
         IRREP3=DIRPRD(IRREP4,IRRRHT)
         DO 6030 INDEX4=1,POP4(IRREP4)
          DO 6035 INDEX3=1,POP3(IRREP3)
C
C NOW COMPUTE ADDRESSES FOR ALL DISTRIBUTION ELEMENTS IN TARGET
C VECTOR (pqrs -> prsq MAPPING) AND SCATTER DISTRIBUTION INTO
C OUTPUT ARRAY
C
           ITHRU=1
           DO 6040 IRREP2=1,NIRREP
            IRREP1=DIRPRD(IRREP2,IRRLFT)
            IRREPL0=DIRPRD(IRREP1,IRREP3)
            IRREPR0=DIRPRD(IRREP2,IRREP4)
C OFFSET TO THIS IRREP OF Q WITHIN THIS SQ IRREP
            IOFF0 =IABSOFF(IRREPR0)+IPOSRHT(IRREP2,IRREPR0)
            DO 6050 INDEX2=1,POP2(IRREP2)
C OFFSET TO THIS Q WITHIN THIS IRREP OF Q WITHIN THIS SQ IRREP
             IOFF =IOFF0+(INDEX2-1)*POP4(IRREP4)*INUMLFT(IRREPL0)
C OFFSET TO THIS S WITHIN ...
             IOFF =IOFF +(INDEX4-1)*INUMLFT(IRREPL0)
C OFFSET TO THIS IRREP OF R WITHIN THIS IRREP OF PR
             IOFF =IOFF+IPOSLFT(IRREP3,IRREPL0)
C OFFSET TO THIS PARTICULAR VALUE OF R WITHIN THIS IRREP OF R
C WITHIN THIS IRREP OF PR
             IOFF =IOFF+(INDEX3-1)*POP1(IRREP1)-1 
             DO 6055 INDEX1=1,POP1(IRREP1)
              IPOS(ITHRU)=IOFF+INDEX1
              ITHRU=ITHRU+1
6055         CONTINUE
6050        CONTINUE
6040       CONTINUE
           CALL SCATTER(ITHRU-1,WOUT,IPOS,WIN(IOFFW))
           IOFFW=IOFFW+ITHRU-1
6035      CONTINUE
6030     CONTINUE
6020    CONTINUE
6010   CONTINUE 
C
      ELSEIF(TYPE.EQ.'1423')THEN
C
C            P Q R S -> P S R Q
C
C COMPUTE SIZE OF PS AND QR DISTRIBUTIONS FOR EACH IRREP
C
       CALL IZERO(INUMLFT,8)
       CALL IZERO(INUMRHT,8)
       DO 2100 IRREP=1,NIRREP
        DO 2110 IRR1=1,NIRREP
         IRR2=DIRPRD(IRR1,IRREP)
         INUMLFT(IRREP)=INUMLFT(IRREP)+POP1(IRR2)*POP4(IRR1)
         INUMRHT(IRREP)=INUMRHT(IRREP)+POP2(IRR2)*POP3(IRR1)
2110    CONTINUE        
2100   CONTINUE
C
C NOW COMPUTE ABSOLUTE OFFSETS TO BEGINNING OF EACH DPD IRREP
C
       IABSOFF(1)=1
       DO 2120 IRRRHT=1,NIRREP
        IRRLFT=DIRPRD(IRRRHT,IRREPX)
        IABSOFF(IRRRHT+1)=IABSOFF(IRRRHT)+
     &                    INUMLFT(IRRLFT)*INUMRHT(IRRRHT) 
        IPOSRHT(1,IRRRHT)=0
        IPOSLFT(1,IRRLFT)=0
        DO 2125 IRREP1=1,NIRREP-1
         IRREP2R=DIRPRD(IRREP1,IRRRHT)
         IRREP2L=DIRPRD(IRREP1,IRRLFT)
         IPOSRHT(IRREP1+1,IRRRHT)=IPOSRHT(IRREP1,IRRRHT)+
     &                            POP2(IRREP2R)*POP3(IRREP1)*
     &                            INUMLFT(IRRLFT)
         IPOSLFT(IRREP1+1,IRRLFT)=IPOSLFT(IRREP1,IRRLFT)+
     &                            POP1(IRREP2L)*POP4(IRREP1)
2125    CONTINUE
2120   CONTINUE
       IOFFW=1
C
C FIRST LOOP OVER RIGHT-HAND SIDE IRREPS 
C
       DO 2010 IRRRHT=1,NIRREP
        IRRLFT=DIRPRD(IRRRHT,IRREPX) 
C
C NOW LOOP OVER RS PAIRS
C
        DO 2020 IRREP4=1,NIRREP
         IRREP3=DIRPRD(IRREP4,IRRRHT)
         DO 2030 INDEX4=1,POP4(IRREP4)
          DO 2035 INDEX3=1,POP3(IRREP3)
C
C NOW COMPUTE ADDRESSES FOR ALL DISTRIBUTION ELEMENTS IN TARGET
C VECTOR (pqrs -> psrq MAPPING) AND SCATTER DISTRIBUTION INTO
C OUTPUT ARRAY
C
           ITHRU=1
           DO 2040 IRREP2=1,NIRREP
            IRREP1=DIRPRD(IRREP2,IRRLFT)
            IRREPL0=DIRPRD(IRREP1,IRREP4)
            IRREPR0=DIRPRD(IRREP3,IRREP2)
C OFFSET TO THIS IRREP OF R WITHIN THIS QR IRREP
            IOFF0 =IABSOFF(IRREPR0)+IPOSRHT(IRREP3,IRREPR0)
C OFFSET TO THIS R WITHIN THIS IRREP OF R WITHIN THIS QR IRREP
            IOFF0 =IOFF0+(INDEX3-1)*POP2(IRREP2)*INUMLFT(IRREPL0)
            DO 2050 INDEX2=1,POP2(IRREP2)
C OFFSET TO THIS Q WITHIN ...
             IOFF =IOFF0+(INDEX2-1)*INUMLFT(IRREPL0)
C OFFSET TO THIS IRREP OF S WITHIN THIS IRREP OF PS
             IOFF =IOFF+IPOSLFT(IRREP4,IRREPL0)
C OFFSET TO THIS PARTICULAR VALUE OF S WITHIN THIS IRREP OF S 
C WITHIN THIS IRREP OF PS
             IOFF =IOFF+(INDEX4-1)*POP1(IRREP1)-1 
             DO 2055 INDEX1=1,POP1(IRREP1)
              IPOS(ITHRU)=IOFF+INDEX1
              ITHRU=ITHRU+1
2055         CONTINUE
2050        CONTINUE
2040       CONTINUE
           CALL SCATTER(ITHRU-1,WOUT,IPOS,WIN(IOFFW))
           IOFFW=IOFFW+ITHRU-1
2035      CONTINUE
2030     CONTINUE
2020    CONTINUE
2010   CONTINUE 
C
      ELSEIF(TYPE.EQ.'3214')THEN
C
C            P Q R S -> R Q P S
C
C COMPUTE SIZE OF PS AND QR DISTRIBUTIONS FOR EACH IRREP
C
       CALL IZERO(INUMLFT,8)
       CALL IZERO(INUMRHT,8)
       DO 3100 IRREP=1,NIRREP
        DO 3110 IRR1=1,NIRREP
         IRR2=DIRPRD(IRR1,IRREP)
         INUMRHT(IRREP)=INUMRHT(IRREP)+POP1(IRR2)*POP4(IRR1)
         INUMLFT(IRREP)=INUMLFT(IRREP)+POP3(IRR2)*POP2(IRR1)
3110    CONTINUE        
3100   CONTINUE
C
C NOW COMPUTE ABSOLUTE OFFSETS TO BEGINNING OF EACH DPD IRREP
C
       IABSOFF(1)=1
       DO 3120 IRRRHT=1,NIRREP
        IRRLFT=DIRPRD(IRRRHT,IRREPX)
        IABSOFF(IRRRHT+1)=IABSOFF(IRRRHT)+
     &                    INUMLFT(IRRLFT)*INUMRHT(IRRRHT) 
        IPOSRHT(1,IRRRHT)=0
        IPOSLFT(1,IRRLFT)=0
        DO 3125 IRREP1=1,NIRREP-1
         IRREP2R=DIRPRD(IRREP1,IRRRHT)
         IRREP2L=DIRPRD(IRREP1,IRRLFT)
         IPOSLFT(IRREP1+1,IRRLFT)=IPOSLFT(IRREP1,IRRLFT)+
     &                            POP3(IRREP2L)*POP2(IRREP1)
         IPOSRHT(IRREP1+1,IRRRHT)=IPOSRHT(IRREP1,IRRRHT)+
     &                            POP1(IRREP2R)*POP4(IRREP1)*
     &                            INUMLFT(IRRLFT)
3125    CONTINUE
3120   CONTINUE
       IOFFW=1
C
C FIRST LOOP OVER RIGHT-HAND SIDE IRREPS 
C
       DO 3010 IRRRHT=1,NIRREP
        IRRLFT=DIRPRD(IRRRHT,IRREPX) 
C
C NOW LOOP OVER RS PAIRS
C
        DO 3020 IRREP4=1,NIRREP
         IRREP3=DIRPRD(IRREP4,IRRRHT)
         DO 3030 INDEX4=1,POP4(IRREP4)
          DO 3035 INDEX3=1,POP3(IRREP3)
C
C NOW COMPUTE ADDRESSES FOR ALL DISTRIBUTION ELEMENTS IN TARGET
C VECTOR (pqrs -> rqps MAPPING) AND SCATTER DISTRIBUTION INTO
C OUTPUT ARRAY
C
           ITHRU=1
           DO 3040 IRREP2=1,NIRREP
            IRREP1=DIRPRD(IRREP2,IRRLFT)
            IRREPL0=DIRPRD(IRREP2,IRREP3)
            IRREPR0=DIRPRD(IRREP1,IRREP4)
C OFFSET TO THIS IRREP OF S WITHIN THIS PS IRREP
            IOFF0 =IABSOFF(IRREPR0)+IPOSRHT(IRREP4,IRREPR0)
C OFFSET TO THIS S WITHIN THIS IRREP OF S WITHIN THIS RS IRREP
            IOFF0 =IOFF0+(INDEX4-1)*POP1(IRREP1)*INUMLFT(IRREPL0)
            DO 3050 INDEX2=1,POP2(IRREP2)
             DO 3055 INDEX1=1,POP1(IRREP1)
C OFFSET TO THIS P WITHIN ...
              IOFF =IOFF0+(INDEX1-1)*INUMLFT(IRREPL0)
C OFFSET TO THIS IRREP OF Q WITHIN THIS IRREP OF RQ
              IOFF =IOFF+IPOSLFT(IRREP2,IRREPL0)
C OFFSET TO THIS PARTICULAR VALUE OF Q WITHIN THIS IRREP OF Q 
C WITHIN THIS IRREP OF RQ
              IOFF =IOFF+(INDEX2-1)*POP3(IRREP3)-1 
              IPOS(ITHRU)=IOFF+INDEX3
              ITHRU=ITHRU+1
3055         CONTINUE
3050        CONTINUE
3040       CONTINUE
           CALL SCATTER(ITHRU-1,WOUT,IPOS,WIN(IOFFW))
           IOFFW=IOFFW+ITHRU-1
3035      CONTINUE
3030     CONTINUE
3020    CONTINUE
3010   CONTINUE 
C
      ELSEIF(TYPE.EQ.'2413')THEN
C
C            P Q R S -> Q S P R
C            1 2 3 4    2 4 1 3
C
C COMPUTE SIZE OF QS AND PR DISTRIBUTIONS FOR EACH IRREP
C
       CALL IZERO(INUMLFT,8)
       CALL IZERO(INUMRHT,8)
       DO 4100 IRREP=1,NIRREP
        DO 4110 IRR1=1,NIRREP
         IRR2=DIRPRD(IRR1,IRREP)
         INUMRHT(IRREP)=INUMRHT(IRREP)+POP1(IRR2)*POP3(IRR1)
         INUMLFT(IRREP)=INUMLFT(IRREP)+POP2(IRR2)*POP4(IRR1)
4110    CONTINUE        
4100   CONTINUE
C
C NOW COMPUTE ABSOLUTE OFFSETS TO BEGINNING OF EACH DPD IRREP
C
       IABSOFF(1)=1
       DO 4120 IRRRHT=1,NIRREP
        IRRLFT=DIRPRD(IRRRHT,IRREPX)
        IABSOFF(IRRRHT+1)=IABSOFF(IRRRHT)+
     &                    INUMLFT(IRRLFT)*INUMRHT(IRRRHT) 
        IPOSRHT(1,IRRRHT)=0
        IPOSLFT(1,IRRLFT)=0
        DO 4125 IRREP1=1,NIRREP-1
         IRREP2R=DIRPRD(IRREP1,IRRRHT)
         IRREP2L=DIRPRD(IRREP1,IRRLFT)
         IPOSLFT(IRREP1+1,IRRLFT)=IPOSLFT(IRREP1,IRRLFT)+
     &                            POP2(IRREP2L)*POP4(IRREP1)
         IPOSRHT(IRREP1+1,IRRRHT)=IPOSRHT(IRREP1,IRRRHT)+
     &                            POP1(IRREP2R)*POP3(IRREP1)*
     &                            INUMLFT(IRRLFT)
4125    CONTINUE
4120   CONTINUE
       IOFFW=1
C
C FIRST LOOP OVER RIGHT-HAND SIDE IRREPS 
C
       DO 4010 IRRRHT=1,NIRREP
        IRRLFT=DIRPRD(IRRRHT,IRREPX) 
C
C NOW LOOP OVER PR PAIRS
C            P Q R S -> Q S P R
C            1 2 3 4    2 4 1 3
C
        DO 4020 IRREP4=1,NIRREP
         IRREP3=DIRPRD(IRREP4,IRRRHT)
         DO 4030 INDEX4=1,POP4(IRREP4)
          DO 4035 INDEX3=1,POP3(IRREP3)
C
C NOW COMPUTE ADDRESSES FOR ALL DISTRIBUTION ELEMENTS IN TARGET
C VECTOR (pqrs -> qspr MAPPING) AND SCATTER DISTRIBUTION INTO
C OUTPUT ARRAY
C 1234->2413
C
           ITHRU=1
           DO 4040 IRREP2=1,NIRREP
            IRREP1=DIRPRD(IRREP2,IRRLFT)
            IRREPL0=DIRPRD(IRREP2,IRREP4)
            IRREPR0=DIRPRD(IRREP1,IRREP3)
C OFFSET TO THIS IRREP OF R WITHIN THIS PR IRREP
            IOFF0 =IABSOFF(IRREPR0)+IPOSRHT(IRREP3,IRREPR0)
C OFFSET TO THIS R WITHIN THIS IRREP OF R WITHIN THIS PR IRREP
            IOFF0 =IOFF0+(INDEX3-1)*POP1(IRREP1)*INUMLFT(IRREPL0)
            DO 4050 INDEX2=1,POP2(IRREP2)
             DO 4055 INDEX1=1,POP1(IRREP1)
C OFFSET TO THIS P WITHIN ...
              IOFF =IOFF0+(INDEX1-1)*INUMLFT(IRREPL0)
C OFFSET TO THIS IRREP OF S WITHIN THIS IRREP OF QS
              IOFF =IOFF+IPOSLFT(IRREP4,IRREPL0)
C OFFSET TO THIS PARTICULAR VALUE OF S WITHIN THIS IRREP OF S 
C WITHIN THIS IRREP OF QS
              IOFF =IOFF+(INDEX4-1)*POP2(IRREP2)-1 
              IPOS(ITHRU)=IOFF+INDEX2
              ITHRU=ITHRU+1
4055         CONTINUE
4050        CONTINUE
4040       CONTINUE
           CALL SCATTER(ITHRU-1,WOUT,IPOS,WIN(IOFFW))
           IOFFW=IOFFW+ITHRU-1
4035      CONTINUE
4030     CONTINUE
4020    CONTINUE
4010   CONTINUE 
C
      ELSEIF(TYPE.EQ.'2314')THEN
C
C            P Q R S -> Q R P S
C
C COMPUTE SIZE OF PS AND QR DISTRIBUTIONS FOR EACH IRREP
C
       CALL IZERO(INUMLFT,8)
       CALL IZERO(INUMRHT,8)
       DO 5100 IRREP=1,NIRREP
        DO 5110 IRR1=1,NIRREP
         IRR2=DIRPRD(IRR1,IRREP)
         INUMRHT(IRREP)=INUMRHT(IRREP)+POP1(IRR2)*POP4(IRR1)
         INUMLFT(IRREP)=INUMLFT(IRREP)+POP2(IRR2)*POP3(IRR1)
5110    CONTINUE        
5100   CONTINUE
C
C NOW COMPUTE ABSOLUTE OFFSETS TO BEGINNING OF EACH DPD IRREP
C
       IABSOFF(1)=1
       DO 5120 IRRRHT=1,NIRREP
        IRRLFT=DIRPRD(IRRRHT,IRREPX)
        IABSOFF(IRRRHT+1)=IABSOFF(IRRRHT)+
     &                    INUMLFT(IRRLFT)*INUMRHT(IRRRHT) 
        IPOSRHT(1,IRRRHT)=0
        IPOSLFT(1,IRRLFT)=0
        DO 5125 IRREP1=1,NIRREP-1
         IRREP2R=DIRPRD(IRREP1,IRRRHT)
         IRREP2L=DIRPRD(IRREP1,IRRLFT)
cold         IPOSLFT(IRREP1+1,IRRRHT)=IPOSLFT(IRREP1,IRRRHT)+
cold     &                            POP2(IRREP2R)*POP3(IRREP1)
cold         IPOSRHT(IRREP1+1,IRRLFT)=IPOSRHT(IRREP1,IRRLFT)+
cold     &                            POP1(IRREP2L)*POP4(IRREP1)*
cold     &                            INUMLFT(IRRLFT)
         IPOSLFT(IRREP1+1,IRRLFT)=IPOSLFT(IRREP1,IRRLFT)+
     &                            POP2(IRREP2L)*POP3(IRREP1)
         IPOSRHT(IRREP1+1,IRRRHT)=IPOSRHT(IRREP1,IRRRHT)+
     &                            POP1(IRREP2R)*POP4(IRREP1)*
     &                            INUMLFT(IRRLFT)
5125    CONTINUE
5120   CONTINUE
       IOFFW=1
C
C FIRST LOOP OVER RIGHT-HAND SIDE IRREPS 
C
       DO 5010 IRRRHT=1,NIRREP
        IRRLFT=DIRPRD(IRRRHT,IRREPX) 
C
C NOW LOOP OVER RS PAIRS
C
        DO 5020 IRREP4=1,NIRREP
         IRREP3=DIRPRD(IRREP4,IRRRHT)
         DO 5030 INDEX4=1,POP4(IRREP4)
          DO 5035 INDEX3=1,POP3(IRREP3)
C
C NOW COMPUTE ADDRESSES FOR ALL DISTRIBUTION ELEMENTS IN TARGET
C VECTOR (pqrs -> qrps MAPPING) AND SCATTER DISTRIBUTION INTO
C OUTPUT ARRAY 1234->2314
C
           ITHRU=1
           DO 5040 IRREP2=1,NIRREP
            IRREP1=DIRPRD(IRREP2,IRRLFT)
            IRREPL0=DIRPRD(IRREP2,IRREP3)
            IRREPR0=DIRPRD(IRREP1,IRREP4)
C OFFSET TO THIS IRREP OF S WITHIN THIS PS IRREP
            IOFF0 =IABSOFF(IRREPR0)+IPOSRHT(IRREP4,IRREPR0)
C OFFSET TO THIS S WITHIN THIS IRREP OF S WITHIN THIS RS IRREP
            IOFF0 =IOFF0+(INDEX4-1)*POP1(IRREP1)*INUMLFT(IRREPL0)
            DO 5050 INDEX2=1,POP2(IRREP2)
             DO 5055 INDEX1=1,POP1(IRREP1)
C OFFSET TO THIS P WITHIN ...
              IOFF =IOFF0+(INDEX1-1)*INUMLFT(IRREPL0)
C OFFSET TO THIS IRREP OF R WITHIN THIS IRREP OF QR
              IOFF =IOFF+IPOSLFT(IRREP3,IRREPL0)
C OFFSET TO THIS PARTICULAR VALUE OF R WITHIN THIS IRREP OF R 
C WITHIN THIS IRREP OF QR
              IOFF =IOFF+(INDEX3-1)*POP2(IRREP2)-1 
              IPOS(ITHRU)=IOFF+INDEX2
              ITHRU=ITHRU+1
5055         CONTINUE
5050        CONTINUE
5040       CONTINUE
           CALL SCATTER(ITHRU-1,WOUT,IPOS,WIN(IOFFW))
           IOFFW=IOFFW+ITHRU-1
5035      CONTINUE
5030     CONTINUE
5020    CONTINUE
5010   CONTINUE 
      ELSEIF(TYPE.EQ.'2431')THEN
C
C            P Q R S -> Q S R P
C            1 2 3 4    2 4 3 1
C
C COMPUTE SIZE OF QS AND PR DISTRIBUTIONS FOR EACH IRREP
C
       CALL IZERO(INUMLFT,8)
       CALL IZERO(INUMRHT,8)
       DO 7100 IRREP=1,NIRREP
        DO 7110 IRR1=1,NIRREP
         IRR2=DIRPRD(IRR1,IRREP)
         INUMRHT(IRREP)=INUMRHT(IRREP)+POP3(IRR2)*POP1(IRR1)
         INUMLFT(IRREP)=INUMLFT(IRREP)+POP2(IRR2)*POP4(IRR1)
7110    CONTINUE        
7100   CONTINUE
C
C NOW COMPUTE ABSOLUTE OFFSETS TO BEGINNING OF EACH DPD IRREP
C
       IABSOFF(1)=1
       DO 7120 IRRRHT=1,NIRREP
        IRRLFT=DIRPRD(IRRRHT,IRREPX)
        IABSOFF(IRRRHT+1)=IABSOFF(IRRRHT)+
     &                    INUMLFT(IRRLFT)*INUMRHT(IRRRHT) 
        IPOSRHT(1,IRRRHT)=0
        IPOSLFT(1,IRRLFT)=0
        DO 7125 IRREP1=1,NIRREP-1
         IRREP2R=DIRPRD(IRREP1,IRRRHT)
         IRREP2L=DIRPRD(IRREP1,IRRLFT)
         IPOSLFT(IRREP1+1,IRRLFT)=IPOSLFT(IRREP1,IRRLFT)+
     &                            POP2(IRREP2L)*POP4(IRREP1)
         IPOSRHT(IRREP1+1,IRRRHT)=IPOSRHT(IRREP1,IRRRHT)+
     &                            POP3(IRREP2R)*POP1(IRREP1)*
     &                            INUMLFT(IRRLFT)
7125    CONTINUE
7120   CONTINUE
       IOFFW=1
C
C FIRST LOOP OVER RIGHT-HAND SIDE IRREPS 
C
       DO 7010 IRRRHT=1,NIRREP
        IRRLFT=DIRPRD(IRRRHT,IRREPX) 
C
C NOW LOOP OVER PR PAIRS
C            P Q R S -> Q S R P
C            1 2 3 4    2 4 3 1
C
        DO 7020 IRREP4=1,NIRREP
         IRREP3=DIRPRD(IRREP4,IRRRHT)
         DO 7030 INDEX4=1,POP4(IRREP4)
          DO 7035 INDEX3=1,POP3(IRREP3)
C
C NOW COMPUTE ADDRESSES FOR ALL DISTRIBUTION ELEMENTS IN TARGET
C VECTOR (pqrs -> qsrp MAPPING) AND SCATTER DISTRIBUTION INTO
C OUTPUT ARRAY
C 1234->2413
C
           ITHRU=1
           DO 7040 IRREP2=1,NIRREP
            IRREP1=DIRPRD(IRREP2,IRRLFT)
            IRREPL0=DIRPRD(IRREP2,IRREP4)
            IRREPR0=DIRPRD(IRREP1,IRREP3)
C OFFSET TO THIS IRREP OF P WITHIN THIS RP IRREP
            IOFF0 =IABSOFF(IRREPR0)+IPOSRHT(IRREP1,IRREPR0)
            DO 7050 INDEX2=1,POP2(IRREP2)
             DO 7055 INDEX1=1,POP1(IRREP1)
C OFFSET TO THIS P WITHIN THIS IRREP OF P WITHIN THIS RP IRREP
              IOFF =IOFF0+(INDEX1-1)*POP3(IRREP3)*INUMLFT(IRREPL0)
C OFFSET TO THIS R WITHIN ...
              IOFF =IOFF+(INDEX3-1)*INUMLFT(IRREPL0)
C OFFSET TO THIS IRREP OF S WITHIN THIS IRREP OF QS
              IOFF =IOFF+IPOSLFT(IRREP4,IRREPL0)
C OFFSET TO THIS PARTICULAR VALUE OF S WITHIN THIS IRREP OF S 
C WITHIN THIS IRREP OF QS
              IOFF =IOFF+(INDEX4-1)*POP2(IRREP2)-1 
              IPOS(ITHRU)=IOFF+INDEX2
              ITHRU=ITHRU+1
7055         CONTINUE
7050        CONTINUE
7040       CONTINUE
           CALL SCATTER(ITHRU-1,WOUT,IPOS,WIN(IOFFW))
           IOFFW=IOFFW+ITHRU-1
7035      CONTINUE
7030     CONTINUE
7020    CONTINUE
7010   CONTINUE 
C
      ENDIF
      RETURN
      END
