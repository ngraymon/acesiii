
C RETURNS THE FIRST POSITION OF AN INTEGER IN AN INTEGER VECTOR V.

      INTEGER FUNCTION CHKINT(V,LEN,INT)
      IMPLICIT INTEGER(A-Z)
      DIMENSION V(LEN)
      I = 1
      CHKINT = 0
      DO WHILE ((CHKINT.EQ.0).AND.(I.LE.LEN))
         IF (V(I).EQ.INT) CHKINT = I
         I = I + 1
      END DO
      RETURN
      END
