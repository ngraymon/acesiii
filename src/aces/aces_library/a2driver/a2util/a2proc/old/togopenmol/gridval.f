      SUBROUTINE GRIDVAL(PCOORD,NPTS,PVAL,ITFCT,NBASP,
     $     ACOORD,NATOM,ALPHA,PCOEFFN,MOMFCT,MAXANG,
     $     NTANGM,NBAS,DENSN,DENSNCUB,ISFLAG,
     $     TMONCUB,PVAL2,IPCNT,APDX,APDY,
     $     APDZ,APDR,DENSNMAT,
     $     PCOEFSO,FINMO,FINSALC,IBIGLOOP,JBIGLOOP,IDORO,
     $     NORBOUTN)
C
      IMPLICIT DOUBLE PRECISION (A-H,O-Z)
C
      DIMENSION PCOORD((NPTS+1)*3)
      DIMENSION DENSNCUB(NPTS+1)
      DIMENSION PVAL(ITFCT*NBASP),PCOEFFN(ITFCT*NBASP)
      DIMENSION PVAL2(ITFCT*NBASP)
      DIMENSION ACOORD(3*NATOM)
      DIMENSION ALPHA(ITFCT)
      DIMENSION MOMFCT(NATOM*NTANGM)
      DIMENSION DENSN(NBASP*NBASP)
      DIMENSION DENSNMAT(NBASP,NBASP)
      DIMENSION TMONCUB((NPTS+1)*NBASP)
      DIMENSION IPCNT(NBAS)
      DIMENSION APDX(NATOM),APDY(NATOM),APDZ(NATOM),
     &   APDR(NATOM)
      DIMENSION PCOEFSO(ITFCT*NBASP)
      DIMENSION FINMO(NBASP),FINSALC(NBASP)
C     
      CALL ONED2TWOD(DENSN,DENSNMAT,NBASP,NBASP)
C Scroll over each point
      DO 10 KK=0,NPTS
C
C Evaluate the coefficient of each mo and sale at
C that point in the ao basis
         CALL ATPT(PCOORD,NPTS,KK+1,ACOORD,NATOM,ALPHA,
     $        PCOEFFN,MOMFCT,MAXANG,NTANGM,ITFCT,NBASP,PVAL,
     $        NBAS,PVAL2,IPCNT,APDX,APDY,
     $        APDZ,APDR,PCOEFSO,FINMO,FINSALC,IDORO,NORBOUTN)
C WRITE(*,*)
C
C IF (KK+l.EQ.1) THEN
C WRITE(*,*) "in gridval"
C DO 6 ILIST1=l,NORBOUTN
C WRITE(*,*) "FINMO(",ILIST1,")=",FINMO(ILIST1)
C 6 CONTINUE
C DO 7 ILIST2=1,NBASP
C WRITE(*,*) "FINSALC(~,ILIST2, n ) = ~ ~ FINSALC(ILIST2)
C 7 CONTINUE
C END IF
C
         IF (IDORO.NE.1) THEN
C Evaluate the density at this point
C
            DENSNCUB(KK+1)=0.0
            DO 40 IR=1,NBASP
               DO 50 IS=1,NBASP
                  DENSNCUB(KK+1)=DENSNCUB(KK+1)+(FINSALC(IR)*
     $                 FINSALC(IS)*DENSNMAT(IR,IS))
 50            CONTINUE
 40         CONTINUE
C
C IF (KK+l.EQ.1) THEN
C IF (ISFLAG.EQ.) THEN
C WRITE(*,*) "alpha density at point ",KK+1," = ",
C $ DENSNCUB(KK+1)
C WRITE(*,*)
C ELSE
C WRITE(*,*) "beta density at point ~,KK+1,~ = .,
C $ DENSNCUB(KK+1)
C WRITE(*,*)
C END IF
C END IF
         END IF
C
         IF (IDORO.NE.0) THEN
C Evaluate each MO Coeff. at this point
            DO 60 IMO=1,NORBOUTN
               TMONCUB(KK*NORBOUTN+IMO)=FINMO(IMO)
C
C IF (KK+l.EQ.l) THEN
C IF (ISFLAG.EQ.) THEN
C WRITE(*,*) "alpha #",IMO," at point ",KK+1," = ",
C $ TMONCUB(KK*NORBOUTN+IMO)
C WRITE(*,*)
C ELSE
C WRITE(*,*) ~beta #",IMO,~ at point ",KK+1," = ",
C $ TMONCUB(KK*NORBOUTN+IMO)
C WRITE(*,*)
C END IF
C END IF
 60         CONTINUE
         END IF
C
 10   CONTINUE
C
      RETURN
      END SUBROUTINE GRIDVAL



