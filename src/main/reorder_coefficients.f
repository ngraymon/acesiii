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
      subroutine reorder_coefficients(ca, na, epsa, nfps, 
     *                ixshells, nshells)
c--------------------------------------------------------------------------
c   Reorder the transformation coefficients according to an index array.
c--------------------------------------------------------------------------

      implicit none
      integer na, nshells
      integer nfps(nshells)
      integer ixshells(nshells)
      double precision ca(na,na)
      double precision epsa(na)
      double precision xa(na)
      integer ixa(na)

      integer i, j, istart, ishell, n
      
      if (na .gt. 0) then

c--------------------------------------------------------------------------
c   Build a basis function index array from the shell index array.
c--------------------------------------------------------------------------

         istart = 1
         do i = 1, nshells
            ishell = ixshells(i)

c---------------------------------------------------------------------------
c   Calculate the starting basis function.
c---------------------------------------------------------------------------

            n = 0
            do j = 1, ishell-1
               n = n + nfps(j)
            enddo

c----------------------------------------------------------------------------
c   Store the next "nfps(ishell)" indices in the index array.
c----------------------------------------------------------------------------

            do j = 1, nfps(ishell)
               ixa(istart) = n + j
               istart = istart + 1
            enddo
         enddo

         do j = 1, na

c--------------------------------------------------------------------------
c   Save column "j".
c--------------------------------------------------------------------------

            do i = 1, na
               xa(i) = ca(i,j)
            enddo

            do i = 1, na
               ca(i,j) = xa(ixa(i))
            enddo
         enddo

c         do i = 1, na
c            xa(i) = epsa(i)
c         enddo

c         do i = 1, na
c           epsa(i) = xa(ixa(i))
c         enddo

      endif

      return
      end
