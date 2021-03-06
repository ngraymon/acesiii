      SUBROUTINE BULT_DIHANGCRD(CARTCOORD, BMATRX, DANG, ICON1, 
     &                          ICON2, ICON3, ICON4, IDIHS, 
     &                          TOTREDNCO, NRATMS)
C
C Setup the dihedral angle B-matrix elements. 
C It is some what tedious to write down the elements of the B-matrix for
C torsion. Please refer to Wilson, Decius and Cross page 61, 
C Eqns. 21,22,23,24.
C
      IMPLICIT DOUBLE PRECISION (A-H, O-Z)
      DOUBLE PRECISION VECAB , VECBC , VECBA , DEGPI , VECCD
      INTEGER TOTREDNCO
      DIMENSION CARTCOORD(3*NRATMS), BMATRX(TOTREDNCO, 3*NRATMS),
     &  VECCB(3), VECAB(3), VECBC(3), VECCD(3), VECABC(3), VECBCD(3)
C
      DATA DEGPI /180.0D0/
      DINVPI = (ATAN(DFLOAT(1))*DFLOAT(4))/180.0D0
      PI = (ATAN(DFLOAT(1))*DFLOAT(4))
C



      CALL VEC(CARTCOORD(3*ICON1 - 2), CARTCOORD(3*ICON2 - 2), 
     &         VECAB, 1)
      CALL VEC(CARTCOORD(3*ICON2 - 2), CARTCOORD(3*ICON3 - 2), 
     &         VECBC, 1)
      CALL VEC(CARTCOORD(3*ICON3 - 2), CARTCOORD(3*ICON2 - 2), 
     &         VECCB, 1)
      CALL VEC(CARTCOORD(3*ICON4 - 2), CARTCOORD(3*ICON3 - 2), 
     &         VECCD, 1)
C
      DISTAB = DIST(CARTCOORD(3*ICON1 - 2), CARTCOORD(3*ICON2 - 2))
      DISTBC = DIST(CARTCOORD(3*ICON3 - 2), CARTCOORD(3*ICON2 - 2))
      DISTCD = DIST(CARTCOORD(3*ICON3 - 2), CARTCOORD(3*ICON4 - 2))
C
C First evaluate the dihedral angle. This is calculated as the 
C angle between the two unit vectors that are perpendicular to 
C the ABC and BCD planes for A-B-C-D pattern. 
C
      CALL CROSS(VECAB, VECBC, VECABC, 1)
C
C We need the vector CD, obtain that from vec DC (note the misnomar)
C
      CALL DSCAL(3, -1.0D0, VECCD, 1)
      CALL CROSS(VECBC, VECCD, VECBCD, 1)
      DANG   = (ANGLE(VECABC, VECBCD, 3))*DINVPI
C
C Retain the vector DC for continuation. 
C
      CALL DSCAL(3, -1.0D0, VECCD, 1)
C
C Now re-evalute the unnormalied vectors along the the perpendicular
C directions to the planes ABC and BCD. 
C
      CALL CROSS(VECAB, VECBC, VECABC, 0)
      CALL CROSS(VECCD, VECCB, VECBCD, 0)
C
      DANG1  = ANGLE(VECAB, VECCB, 3)*DINVPI
      DANG2  = ANGLE(VECBC, VECCD, 3)*DINVPI 
C
      SINABC = DSIN(DANG1)
      COSABC = DCOS(DANG1)
      SINBCD = DSIN(DANG2)
      COSBCD = DCOS(DANG2)
C
      DABC = DDOT(3, VECABC, 1, VECABC, 1)
      DBCD = DDOT(3, VECBCD, 1, VECBCD, 1)
C
C--- Obtainig the sign of the dihedral angle:
C
      SENSE = DDOT(3, VECAB, 1, VECBCD, 1)

      IF (SENSE .GT. 0.0D0) DANG = -DANG
C
C
      IF (DABC .GT. 1.0D-16 .AND. DBCD .GT. 1.0D-16) THEN

      DO 10 IXYZ = 1, 3 
C
         BMATRX(IDIHS, (3*ICON1 - 3) + IXYZ) = 
     &                     -(VECABC(IXYZ)/(DISTAB*SINABC*SINABC))
                                            
         BMATRX(IDIHS, (3*ICON2 - 3) + IXYZ) = 
     &                  ((DISTBC - DISTAB*COSABC)*VECABC(IXYZ)/
     &                        (DISTAB*DISTBC*SINABC*SINABC)) + 
     &                            ((COSBCD*VECBCD(IXYZ))/
     &                            (DISTBC*SINBCD*SINBCD)) 
C
         BMATRX(IDIHS, (3*ICON3 - 3) + IXYZ) = 
     &                     ((DISTBC - DISTCD*COSBCD)*VECBCD(IXYZ)/
     &                         (DISTCD*DISTBC*SINBCD*SINBCD)) + 
     &                                 ((COSABC*VECABC(IXYZ))/
     &                                 (DISTBC*SINABC*SINABC)) 
C
         BMATRX(IDIHS, (3*ICON4 - 3) + IXYZ) = 
     &                     -(VECBCD(IXYZ)/(DISTCD*SINBCD*SINBCD))
         
 10   CONTINUE
      ENDIF 
C
      RETURN
      END


      
