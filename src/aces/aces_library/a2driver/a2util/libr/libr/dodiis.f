
C GENERATE DIIS EXPANSION COEFFICIENTS, GIVEN THE ERROR MATRIX

      SUBROUTINE DODIIS(ERR,AUGERR,TMP,NPHYS,NDIM)
      IMPLICIT DOUBLE PRECISION (A-H,O-Z)
      DIMENSION ERR(NPHYS,NPHYS),AUGERR(NPHYS+1,NPHYS+2)
      DIMENSION TMP(*)
      integer    MaxDim
      parameter (MaxDim=64)
      integer ipiv(MaxDim)

      if (ndim.lt.0) then
         print *, '@DODIIS: Assertion failed.'
         print *, '         ndim = ',ndim
         call errex
      end if
c what if ndim == 0?

      if (ndim.ge.MaxDim) then
         print *, '@DODIIS: Assertion failed.'
         print *, '         maxdim = ',maxdim
         print *, '         ndim   = ',ndim
         call aces_exit(1)
      end if
c   o build R (column ndim+2 is the RHS vector)
      augerr(1,1)      =  0.d0
      augerr(1,ndim+2) = -1.d0
      do j = 0, ndim-1
         augerr(2+j,1) = -1.d0
         augerr(1,2+j) = -1.d0
         do i = 0, ndim-1
            augerr(2+i,2+j) = err(1+i,1+j)
         end do
         augerr(2+j,ndim+2) = 0.d0
      end do
c   o get the lambda/coefficient vector
c      call c_gtod(is0,ius0)
c MINV  takes 0.0001s for a 6x6 on crisp
c DSYSV takes 0.0001s for a 6x6 on crisp
c DGESV takes 0.00009s for a 6x6 on crisp
      call dgesv(ndim+1,1,augerr,nphys+1,ipiv,
     &                    augerr(1,ndim+2),nphys+1,i)
c      call c_gtod(is1,ius1)
      if (i.ne.0) then
         print *, '@DODIIS: linear solver failed'
         print *, '         INFO = ',i
         call aces_exit(i)
      end if
c      print *, '@DODIIS: linear solver took ',
c     &         is1-is0+1.d-6*(ius1-ius0),' seconds'
      do i = 1, ndim
         tmp(i) = augerr(1+i,ndim+2)
      end do
      RETURN
      END
