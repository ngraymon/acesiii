
      SUBROUTINE CHKVEC(V,LENGTH,NATOMS,PTGRP,SITGRP,IBFATM,IOK)
      IMPLICIT DOUBLE PRECISION (A-H,O-Z)
      PARAMETER (TOL=1.D-6)
      DIMENSION V(LENGTH),IBFATM(NATOMS)
      CHARACTER*4 PTGRP,ISTGP
      CHARACTER*8 SITGRP(NATOMS)
      common /centre/ numcen0
      IOFF=0
      IOK=0
      DO 10 I=1,NATOMS
       LENATM=IBFATM(I)
       IF(LENATM.EQ.-1)GOTO 10
       DO 20 IPOS=1,LENATM
        IOFF=IOFF+1
        Z=ABS(V(IOFF))
        IF(Z.LT.TOL)GOTO 20
        ISTGP=SITGRP(I)(1:3)
        IF(ISTGP.NE.PTGRP.or.numcen0.eq.1)THEN
         IOK=1
        ENDIF
20     CONTINUE
10    CONTINUE
      RETURN
      END
