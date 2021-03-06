
C THIS ROUTINE PRINTS THE FIRST LENGTH ELEMENTS OF VECTOR VEC
C AND THEIR INDICES IN I3,F13.10 FORMAT.  USEFUL FOR QUANTITIES
C WHICH HAVE MAGNITUDES COMPARABLE TO INTEGRALS AND AMPLITUDES.

      SUBROUTINE PRVECR(VEC,LENGTH)
      IMPLICIT DOUBLE PRECISION (A-H,O-Z)
      DIMENSION VEC(LENGTH)
      if (length.lt.1) return
      WRITE(*,100) (I,VEC(I),I=1,LENGTH)
100   FORMAT(4(1X,:'[',I3,']',F13.10))
      RETURN
      END
