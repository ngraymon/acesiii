
C POSITIONS POINTER AT END OF SEQUENTIAL FILE. IUNIT IS THE UNIT NUMBER.

      SUBROUTINE ENDSEQ(IUNIT)
      IMPLICIT INTEGER (A-Z)
      parameter (i = 0)
      do while (i.eq.0)
         READ(IUNIT,END=100,ERR=200,IOSTAT=IER) JUNK
      end do
100   RETURN
200   CALL IOERR('ENDSEQ',IUNIT,IER)
      END
