      SUBROUTINE SQUEZ4(VFULL,VPACK,LENGTH,IDIM)
C
C THIS ROUTINE EXPANDS A "PACKED" MATRIX TO FULL FORMAT, WHERE
C   THE PACKED ORDER IS :  V(1,1),V(2,1),...,V(N,1),V(2,2),...
C
C THIS IS USEFUL FOR EXPANDING THE D FUNCTION REPRESENTATIONS TO
C   A FULL 3x3 MATRIX
C
CEND
      IMPLICIT DOUBLE PRECISION (A-H,O-Z)
      DIMENSION VPACK(1),VFULL(LENGTH*LENGTH)
      INTEGER DLOC(6),FLOC(10),GLOC(15),DPAK,FPAK,GPAK,DSIZ,FSIZ,GSIZ
      DIMENSION DFAC(6),FFAC(10),GFAC(15)
C
      PARAMETER (TWO   = 2.0D0)
      PARAMETER (ONE   = 1.0D0)
      PARAMETER (THREE = 3.0D0)
      PARAMETER (SIX   = 6.0D0)
      PARAMETER (FOUR  =4.00D0)
      PARAMETER (TWELVE=12.D0)
C   
      DATA DPAK /6/
      DATA FPAK /10/
      DATA GPAK /15/
      DATA DSIZ /9/
      DATA FSIZ /27/
      DATA GSIZ /81/
      DATA DLOC /1,2,3,5,6,9/
      DATA FLOC /1,2,3,5,6,9,14,15,18,27/
      DATA GLOC /1,2,3,5,6,9,14,15,18,27,41,42,45,54,81/
      DATA DFAC /ONE,TWO,TWO,ONE,TWO,ONE/
      DATA FFAC /ONE,THREE,THREE,THREE,SIX,THREE,ONE,THREE,
     &           THREE,ONE/
      DATA GFAC /ONE,FOUR,FOUR,SIX,TWELVE,
     &           SIX,FOUR,TWELVE,TWELVE,FOUR,
     &           ONE,FOUR,SIX,FOUR,ONE/
C
      INDX2(I,J)=I+3*(J-1)
      INDX3(I,J,K)=I+3*(J-1)+9*(K-1)
      INDX4(I,J,K,L)=I+3*(J-1)+9*(K-1)+27*(L-1) 
C
C CODE FOR TWO DIMENSIONAL MATRICES (SUCH AS d FUNCTIONS)
C
      IF(IDIM.EQ.2)THEN
       CALL GATHER(DPAK,VPACK,VFULL,DLOC)
       CALL VECPRD(DFAC,VPACK,VPACK,DPAK)
C
C CODE FOR THREE DIMENSIONAL MATRICES (SUCH AS f FUNCTIONS)
C
      ELSEIF(IDIM.EQ.3)THEN
       CALL GATHER (FPAK,VPACK,VFULL,FLOC)
       CALL VECPRD (FFAC,VPACK,VPACK,FPAK)
C
C CODE FOR FOUR DIMENSIONAL MATRICES (g FUNCTIONS)
C
      ELSEIF(IDIM.EQ.4)THEN
       CALL GATHER (GPAK,VPACK,VFULL,GLOC)
       CALL VECPRD (GFAC,VPACK,VPACK,GPAK)
C
      ENDIF
C
      RETURN
      END
