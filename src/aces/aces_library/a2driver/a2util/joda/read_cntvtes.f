      SUBROUTINE READ_CNTVTES(IBNDTO, IUNIT, NATOMS)

      IMPLICIT DOUBLE PRECISION (A-H, O-Z)
      LOGICAL FLAG
C
C MXATMS     : Maximum number of atoms currently allowed
C MAXCNTVS   : Maximum number of connectivites per center
C MAXREDUNCO : Maximum number of redundant coordinates.
C
      INTEGER MXATMS, MAXCNTVS, MAXREDUNCO
      PARAMETER (MXATMS=200, MAXCNTVS = 10, MAXREDUNCO = 3*MXATMS)
C
      DIMENSION IBNDTO(NATOMS, NATOMS), NCONPRCNTR(MXATMS),
     &          NCON(MAXCNTVS)

      DATA IONE, IJZERO /1, 0/
   
C Read the connectivites from the file CONNECT if present and
C bypass the automatic genration done in assign_cntvtes.F. 
C This is usefull when dealing with fused rings consists 
C of many atoms.
C
      CALL IZERO(NCON, MAXCNTVS)
      DO IATOMS = 1, NATOMS
         READ(IUNIT, 99) NCONPRCNTR(IATOMS), (NCON(J), J=1, 
     &                   NCONPRCNTR(IATOMS))
         NO_CNTS_PER_CENTER = NCONPRCNTR(IATOMS)
C
         IF (NO_CNTS_PER_CENTER .GE. MAXCNTVS) THEN
            WRITE(6,1000)
            CALL ERREX
         ENDIF
         Write(6, "(a,I2)") "The # of connectivites: ",
     &                       NCONPRCNTR(IATOMS)
         Write(6,*)
         Write(6,"(a,10I3)") "The NCON array: ",
     &                     (NCON(J), J=1, NCONPRCNTR(IATOMS))
      ENDDO
   99 FORMAT (I2, 10(1X,I2))
C
C Create the IBNDTO array. This dicatate everything else that
C proceeds.
C
      DO IATMS = 1, NATOMS
         DO IBNDS = 1, NCONPRCNTR(IATMS)
            IF (NCON(IBNDS) .NE. IJZERO) 
     &          IBNDTO(NCON(IBNDS), IATMS) = IONE
         ENDDO
      ENDDO
C
C Some internal checks. Caution: needs to verify them.
C
      DO IATMS = 1, NATOMS
         DO IBNDS = 1, NCONPRCNTR(IATMS)
            KBNDS = IBNDTO(IBNDS, IATMS)
            DO JBNDS = 1,  NCONPRCNTR(KBNDS)
C
               IF (IBNDTO(JBNDS, KBNDS) .EQ. IATMS) THEN
                   FLAG = .TRUE.
                   WRITE(6, 2000)
                   CALL ERREX
               ENDIF
C
           ENDDO
        ENDDO
      ENDDO
C
CSSS        IF (.NOT. FLAG) THEN
CSSS            NCONPRCNTR(KBNDS) = NCONPRCNTR(KBNDS) + 1
CSSS            IBNDTO(NCONPRCNTR(KBNDS), KBNDS) = IATMS
CSSS        ENDIF
C
 1000 FORMAT("@-Rd_cntvtes - Exceeds the maximum number of
     &        bonds allowed for a center")

 2000 FORMAT("@-Rd_cntvtes - Duplicate connectivity", " I=",I5,
     &      " IB=",I3," J=",I5," JB=",I3,'.')

       RETURN 
       END

