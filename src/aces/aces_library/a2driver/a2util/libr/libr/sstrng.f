       SUBROUTINE SSTRNG(WIN,WOUT,NSIZIN,NSIZOT,ISCR,SPTYPE)
C
C THIS ROUTINE ACCEPTS A SYMMETRY PACKED FOUR-INDEX LIST AND RETURNS
C   THE SAME LIST BUT WITH AN ALTERNATIVE SCHEME FOR SYMMETRY PACKING.
C
C THE LIST (A,I;B,J) IS PRESUMED TO BE PACKED AI-BJ.  THIS ROUTINE RETUR
C   THE LIST PACKED AJ-BI.  USEFUL FOR RINGS AND ALSO FOR THE T1 CONTRIB
C   TO THE RING INTERMEDIATE.  
C
C INPUT: 
C           WIN  - THE SYMMETRY PACKED AI-BJ LIST.
C         NSIZIN - THE TOTAL SIZE OF THE SYM. PACKED INPUT VECTOR.
C         NSIZOT - THE TOTAL SIZE OF THE SYM. PACKED OUTPUT VECTOR.
C         SPTYPE - THE SPIN TYPE FOR THE INPUT LIST
C
C                        'AAAA' FOR (AI-BJ)  (AJ-BI returned)
C                        'BBBB' FOR (ai-bj)  (aj-bi returned)
C                        'ABAB' FOR (Ai-Bj)  (Aj-Bi returned)
C                        'BABA' FOR (aI-bJ)  (aJ-bI returned)
C                        'ABBA' FOR (Ai-bJ)  (AJ-bi returned (type AABB)
C                        'BAAB' FOR (aI-Bj)  (aj-BI returned (type BBAA)
C                        'AABB' FOR (AI-bj)  (Aj-bI returned (type ABBA)
C                        'BBAA' FOR (ai-BJ)  (aJ-Bi returned (type BAAB)
C
C OUTPUT: 
C          WOUT  - THE SYMMETRY PACKED AJ-BI LIST.
C       
C SCRATCH:
C         ISCR   - SCRATCH AREA TO HOLD THE SYMMETRY VECTORS AND INVERSE
C                   SYMMETRY VECTORS WHICH ARE NEEDED. (SIZE: 2*NOCCI*NV
C                   IF SPCASE IS AAAA, BBBB, ABAB OR BABA; 
C                   NVRTA*(NOCCI+NOCCJ)+NVRTB(NOCCI+NOCCJ) OTHERWISE.
C         
CEND
      IMPLICIT INTEGER (A-Z)
      DOUBLE PRECISION WIN(NSIZIN),WOUT(NSIZOT),X
      CHARACTER*4 SPTYPE
      DIMENSION ISCR(1),ISPIN(4)
      COMMON /SYM/ POP(8,2),VRT(8,2),NT(2),NFMI(2),NFEA(2)
C
      IRREPX=1
C
      DO 10 I=1,4
       IF(SPTYPE(I:I).EQ.'A')ISPIN(I)=1
       IF(SPTYPE(I:I).EQ.'B')ISPIN(I)=2
10    CONTINUE
C
      CALL SSTGEN(WIN,WOUT,NSIZIN,VRT(1,ISPIN(1)),POP(1,ISPIN(2)),
     &            VRT(1,ISPIN(3)),POP(1,ISPIN(4)),ISCR,IRREPX,'1432')
C
      RETURN
      END
