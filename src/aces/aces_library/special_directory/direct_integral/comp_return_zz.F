C  Copyright (c) 2003-2010 University of Florida
C
C  This program is free software; you can redistribute it and/or modify
C  it under the terms of the GNU General Public License as published by
C  the Free Software Foundation; either version 2 of the License, or
C  (at your option) any later version.

C  This program is distributed in the hope that it will be useful,
C  but WITHOUT ANY WARRANTY; without even the implied warranty of
C  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
C  GNU General Public License for more details.

C  The GNU General Public License is included in this distribution
C  in the file COPYRIGHT.
      subroutine comp_return_zz(z, da1, da2, db1, db2, nsend)
c---------------------------------------------------------------------------
c  Computes the set of ZZ integrals
c---------------------------------------------------------------------------
      implicit none
      include 'int_gen_parms.h'
      include 'machine_types.h'
#ifdef ALTIX
      include 'sheap.h'
#endif

      integer me, type
      integer adim, bdim, nsend  
      integer da1, da2, db1, db2
      double precision density(da1:da2, db1:db2)
      double precision z(da1:da2, db1:db2)
      double precision dbuf(1)
      integer ibuf(1)
#ifdef ALTIX
      pointer (iptr, ibuf)
      pointer (dptr, dbuf)
#else
      common dbuf
      equivalence (ibuf, dbuf)
#endif
      double precision sum
      integer icounter, icounter1
      integer i, ix, m, n, nfirst, nints, nalpha, ncoeff, iatom, ncsum
      integer component
      integer a, b, a1,a2,b1,b2,lastao, igrad
      integer m1, m2, n1, n2
      integer der1x, der1y, der1z
      integer der2x, der2y, der2z
      integer dercx, dercy, dercz
      integer ixderc
      integer ind(2)
      integer flopcount
      logical spherical
   
      integer max_dim_coeff
      parameter (max_dim_coeff = 5000)
      integer ccbeg_pack(max_dim_coeff), ccend_pack(max_dim_coeff)
      double precision alpha_pack(max_dim_coeff), 
     *                 pcoeff_pack(max_dim_coeff)
      double precision xn(max_centers), yn(max_centers), 
     *                 zn(max_centers)
      double precision x1,y1,z1,x2,y2,z2, y,xc,yc,zc

#ifdef ALTIX
      iptr = ishptr
      dptr = dshptr
#endif

      spherical = (ispherical .eq. 1)
      lastao    = end_nfps(nshells)

      ind(1) = 1
      ind(2) = 2

c ---------------------------------------------------------------------------
c  Set up send data.
c ---------------------------------------------------------------------------

      adim = da2-da1+1
      bdim = db2-db1+1

      nsend = adim*bdim
      if (nsend .lt. 0) then
         print *,'ERROR IN COMP_FOCK_DER ',me,' nsend = ',nsend
         print *,'adim,bdim = ',adim,bdim
         call abort_job()
      endif

c----------------------------------------------------------------------------
c   Clear the output array.
c----------------------------------------------------------------------------

      do b = db1,db2
      do a = da1,da2
         Z(a,b) = 0.d0
      enddo
      enddo

c-------------------------------------------------------------------------
c   Find the shells we need to loop over for this block of density data.
c--------------------------------------------------------------------------

      call lookup_shell(end_nfps, nshells, da1, m1)
      call lookup_shell(end_nfps, nshells, da2, m2)
      call lookup_shell(end_nfps, nshells, db1, n1)
      call lookup_shell(end_nfps, nshells, db2, n2)
      
c-------------------------------------------------------------------------
c   Build an array of coordinates per atom.
c-------------------------------------------------------------------------

      do m = 1, nshells
         iatom = atom(m)
         xn(iatom) = dbuf(icoord+3*(m-1))
         yn(iatom) = dbuf(icoord+3*(m-1)+1)
         zn(iatom) = dbuf(icoord+3*(m-1)+2)
      enddo

c-------------------------------------------------------------------------
c   Calculate the integrals over the necessary shell blocks.
c-------------------------------------------------------------------------

       icounter = 0
       do m = m1, m2
       do n = n1, n2

            ncsum = ncfps(m) + ncfps(n) 
            x1 = dbuf(icoord+3*(m-1))
            y1 = dbuf(icoord+3*(m-1)+1)
            z1 = dbuf(icoord+3*(m-1)+2)
 
            x2 = dbuf(icoord+3*(n-1))
            y2 = dbuf(icoord+3*(n-1)+1)
            z2 = dbuf(icoord+3*(n-1)+2)

            call pack_coeffs_oed(dbuf(ialpha), ixalpha, dbuf(ipcoeff), 
     *                       ixpcoef, ncfps, npfps, m, n,
     *                       alpha_pack, nalpha, pcoeff_pack,
     *                       ncoeff, ibuf(iccbeg), ibuf(iccend), 
     *                       indx_cc,
     *                       ccbeg_pack, ccend_pack,
     *                       max_dim_coeff)

c ------------------------------------------------------------------------ 
c  Compute the ZZ integrals.
c ------------------------------------------------------------------------ 

              call oed__gener_xyz_batch(intmax, zmax, nalpha, ncoeff,
     *                 ncsum, ncfps(m), ncfps(n), npfps(m),npfps(n),
     *                 ivangmom(m), ivangmom(n), x1,y1,z1,x2,y2,z2,
     *                 alpha_pack,
     *                 pcoeff_pack, ccbeg_pack, ccend_pack,
     *                 spherical, .false., ibuf(ipkgscr),0,0,2,
     *                 xc,yc,zc,
     *                 nints, 
     *                 nfirst, dbuf(dpkgscr))

            if (nints .gt. 0) then
               a2 = end_nfps(m)
               if (m .eq. 1) then
                  a1 = 1
               else
                  a1 = end_nfps(m-1)+1
               endif

               b2 = end_nfps(n)
               if (n .eq. 1) then
                  b1 = 1
               else
                  b1 = end_nfps(n-1)+1
               endif

                call move_integrals2(z, da1,da2,db1,db2,
     *                 dbuf(dpkgscr+nfirst-1),a1,a2,b1,b2)

                icounter = icounter + nints
             endif ! (nints .gt. 0) then
              
         enddo   ! n shells
         enddo   ! m shells

      return
      end
