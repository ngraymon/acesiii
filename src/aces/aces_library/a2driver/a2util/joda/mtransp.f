      SUBROUTINE MTRANSP(A,AT,NR,NC,NTR,NTC)
      IMPLICIT DOUBLE PRECISION (A-H,O-Z)
      DIMENSION A(NR,NC),AT(NC,NR)
      DO I=1,NTR
      DO J=1,NTC
         AT(J,I)=A(I,J)
      END DO
      END DO
      RETURN
      END
