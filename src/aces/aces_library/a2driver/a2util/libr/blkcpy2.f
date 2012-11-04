      SUBROUTINE BLKCPY2(MATFRM,NROWFRM,NCOLFRM,MATTAR,NROWTAR,NCOLTAR,
     &                  IROWFRM,ICOLFRM)
C
C THIS ROUTINE COPIES AN NROWTAR BY NCOLTAR BLOCK SUBMATRIX 
C  INTO AN NROWTAR BY NCOLTAR TARGET MATRIX (MATTAR) SUCH THAT 
C  THE IROWFRM,ICOLFRM ELEMENT IN MATFRM BECOMES THE (1,1) ELEMENT 
C  IN MATTAR.
C
C THE PHYSICAL DIMENSION OF MATFRM IS (NROWFRM,NCOLFRM)
C THE PHYSICAL DIMENSION OF MATTAR IS THE SAME AS THE SUBMATRIX SIZE
C
CEND
      IMPLICIT INTEGER (A-Z)
      DOUBLE PRECISION MATTAR(NROWTAR,NCOLTAR),MATFRM(NROWFRM,NCOLFRM)
      COMMON /MACHSP/ IINTLN,IFLTLN,IINTFP,IALONE,IBITWD
      DO 10 ICOL=1,NCOLTAR
       ICOL0=ICOL+ICOLFRM-1
       IROW0=IROWFRM
       CALL SCOPY(NROWTAR,MATFRM(IROW0,ICOL0),1,MATTAR(1,ICOL),1)
10    CONTINUE
      RETURN
      END
