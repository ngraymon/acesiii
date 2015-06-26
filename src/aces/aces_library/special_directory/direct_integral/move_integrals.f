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
      subroutine move_integrals(v, va1,va2,vb1,vb2,vc1,vc2,vd1,vd2,
     *                          intblk, a1, a2, b1, b2, c1, c2, d1, d2)
      implicit none
      integer va1, va2, vb1,vb2, vc1, vc2, vd1, vd2
      integer a1, a2, b1, b2, c1, c2, d1, d2
      integer a,b,c,d
      integer drange1, drange2
      integer crange1, crange2
      integer brange1, brange2
      integer arange1, arange2

      double precision v(va1:va2,vb1:vb2,vc1:vc2,vd1:vd2)
      double precision intblk(a1:a2,b1:b2,c1:c2,d1:d2)

      drange1 = max(vd1, d1)
      drange2 = min(vd2, d2)
      crange1 = max(vc1, c1)
      crange2 = min(vc2, c2)
      brange1 = max(vb1, b1)
      brange2 = min(vb2, b2)
      arange1 = max(va1, a1)
      arange2 = min(va2, a2)

         do d = drange1, drange2
         do c = crange1, crange2
         do b = brange1, brange2
         do a = arange1, arange2
            v(a,b,c,d) = intblk(a,b,c,d)
         enddo
         enddo
         enddo
         enddo

      return
      end


      subroutine add_integrals(v, va1,va2,vb1,vb2,vc1,vc2,vd1,vd2,
     *                 intblk, a1, a2, b1, b2, c1, c2, d1, d2, fact)
      implicit none
      integer va1, va2, vb1,vb2, vc1, vc2, vd1, vd2
      integer a1, a2, b1, b2, c1, c2, d1, d2
      integer a,b,c,d
      integer drange1, drange2
      integer crange1, crange2
      integer brange1, brange2
      integer arange1, arange2

      double precision v(va1:va2,vb1:vb2,vc1:vc2,vd1:vd2)
      double precision intblk(a1:a2,b1:b2,c1:c2,d1:d2), fact 

      drange1 = max(vd1, d1)
      drange2 = min(vd2, d2)
      crange1 = max(vc1, c1)
      crange2 = min(vc2, c2)
      brange1 = max(vb1, b1)
      brange2 = min(vb2, b2)
      arange1 = max(va1, a1)
      arange2 = min(va2, a2)

         do d = drange1, drange2
         do c = crange1, crange2
         do b = brange1, brange2
         do a = arange1, arange2
            v(a,b,c,d) = intblk(a,b,c,d) + v(a,b,c,d)*fact 
         enddo
         enddo
         enddo
         enddo

      return
      end



      subroutine move_integrals2(v, va1,va2,vb1,vb2,
     *                          intblk, a1, a2, b1, b2)
c---------------------------------------------------------------------------
c   Moves a 2-dimensional tile of integrals into a larger 2-dimensional
c   block, adjusting for ERD-to-VMOL indexing and scaling at the same time.
c---------------------------------------------------------------------------
      implicit none
      integer va1, va2, vb1,vb2
      integer a1, a2, b1, b2
      integer a,b
      integer brange1, brange2
      integer arange1, arange2

      double precision v(va1:va2,vb1:vb2)
      double precision intblk(a1:a2,b1:b2)
      double precision sum

      brange1 = max(vb1, b1)
      brange2 = min(vb2, b2)
      arange1 = max(va1, a1)
      arange2 = min(va2, a2)

         do b = brange1, brange2
         do a = arange1, arange2
            v(a,b) = intblk(a,b)
         enddo
         enddo

      return
      end


      subroutine move_integrals2_scale(v, va1,va2,vb1,vb2,
     *                          intblk, a1, a2, b1, b2, 
     *                          erdind, scale)
c---------------------------------------------------------------------------
c   Moves a 2-dimensional tile of integrals into a larger 2-dimensional
c   block, adjusting for ERD-to-VMOL indexing and scaling at the same time.
c---------------------------------------------------------------------------
      implicit none
      integer va1, va2, vb1,vb2
      integer a1, a2, b1, b2
      integer erdind(*)
      double precision scale(*)
      integer a,b, aa, bb
      integer brange1, brange2
      integer arange1, arange2

      double precision v(va1:va2,vb1:vb2)
      double precision intblk(a1:a2,b1:b2)

      brange1 = max(vb1, b1)
      brange2 = min(vb2, b2)
      arange1 = max(va1, a1)
      arange2 = min(va2, a2)

         do b = b1, b2
            bb = erdind(b)
         do a = a1, a2
            aa = erdind(a)
            if (aa .ge. va1 .and. aa .le. va2 .and.
     *          bb .ge. vb1 .and. bb .le. vb2) then
               v(aa,bb) = intblk(a,b)*scale(a)*scale(b)
            else
               print *,'a,b,aa,bb ',a,b,aa,bb,' out of range ',
     *               va1,va2,vb1,vb2
               call abort_job()
            endif
         enddo
         enddo

      return
      end

       subroutine move_integrals2_delta(v, va1,va2,vb1,vb2,
     *                                  intblk, a1, a2, b1,
     *                                  b2)
      implicit none
      integer va1, va2, vb1,vb2
      integer a1, a2, b1, b2
      integer a,b
      integer brange1, brange2
      integer arange1, arange2

      integer ncenters, Rn
      double precision v(va1:va2,vb1:vb2)
      double precision intblk(a1:a2,b1:b2)
      double precision sum

      brange1 = max(vb1, b1)
      brange2 = min(vb2, b2)
      arange1 = max(va1, a1)
      arange2 = min(va2, a2)

      do b = brange1, brange2
       do a = arange1, arange2
         v(a,b) = intblk(a,b)
c         write(*,*) 'a=',a,'b=',b,V(a,b)
       enddo
      enddo

      return
      end

      subroutine move_integrals2_del(y,z,v, va1,va2,vb1,vb2,
     *                                   a1, a2, b1,
     *                                  b2)
      implicit none
      integer va1, va2, vb1,vb2
      integer a1, a2, b1, b2
      integer a,b
      integer brange1, brange2
      integer arange1, arange2

      integer ncenters, Rn
      double precision v(va1:va2,vb1:vb2)
      double precision z(va1:va2,vb1:vb2) 
      double precision y      

      brange1 = max(vb1, b1)
      brange2 = min(vb2, b2)
      arange1 = max(va1, a1)
      arange2 = min(va2, a2)

      y=0.d0
      do b = brange1, brange2
       do a = arange1, arange2
        y=y+v(a,b)*z(a,b)
CSSS        write(*,*) 'a=',a,'b=',b,z(a,b),v(a,b)
       enddo
      enddo
      
      return
      end

      subroutine add_integrals2(v, va1,va2,vb1,vb2,
     *                          intblk, a1, a2, b1, b2, fact)
c---------------------------------------------------------------------------
c   Moves a 2-dimensional tile of integrals into a larger 2-dimensional
c   block, adjusting for ERD-to-VMOL indexing and scaling at the same time.
c---------------------------------------------------------------------------
      implicit none
      integer va1, va2, vb1,vb2
      integer a1, a2, b1, b2
      integer a,b
      integer brange1, brange2
      integer arange1, arange2

      double precision v(va1:va2,vb1:vb2)
      double precision intblk(a1:a2,b1:b2)
      double precision fact, temp  

      brange1 = max(vb1, b1)
      brange2 = min(vb2, b2)
      arange1 = max(va1, a1)
      arange2 = min(va2, a2)

      if ((va1 .gt. a1) .or. (va2. lt. a2) .or. 
     *    (vb1 .gt. b1) .or. (vb2. lt. b2)) then 
         write(6,*) ' Error in add_integrals2: indices mismatch ' 
         write(6,*) va1, va2, vb1, vb2   
         write(6,*) a1, a2, b1, b2   
      endif 

      do b = brange1, brange2
      do a = arange1, arange2
         v(a,b) = v(a,b) + intblk(a,b)*fact
      enddo
      enddo

      return
      end

      subroutine move_OVL3C(v, va1,va2,vb1,vb2,vc1,vc2,intblk,
     *                      a1, a2, b1, b2, c1, c2)
      implicit none
      integer va1, va2, vb1,vb2, vc1, vc2
      integer a1, a2, b1, b2, c1, c2
      integer a,b,c
      integer crange1, crange2
      integer brange1, brange2
      integer arange1, arange2

      double precision      v(va1:va2,vb1:vb2,vc1:vc2)
      double precision intblk(a1:a2,b1:b2,c1:c2)

      crange1 = max(vc1, c1)
      crange2 = min(vc2, c2)
      brange1 = max(vb1, b1)
      brange2 = min(vb2, b2)
      arange1 = max(va1, a1)
      arange2 = min(va2, a2)

         do c = crange1, crange2
         do b = brange1, brange2
         do a = arange1, arange2
            v(a,b,c) = intblk(a,b,c)
         enddo
         enddo
         enddo

      return
      end

      subroutine add_4cent_integrals(v, va1,va2,vb1,vb2,vc1,vc2,vd1,vd2,
     *                 intblk, a1, a2, b1, b2, c1, c2, d1, d2, fact,
     *                 flag)

      implicit none
      integer va1, va2, vb1,vb2, vc1, vc2, vd1, vd2
      integer a1, a2, b1, b2, c1, c2, d1, d2
      integer a,b,c,d
      integer flag
      integer drange1, drange2
      integer crange1, crange2
      integer brange1, brange2
      integer arange1, arange2

      double precision v(va1:va2,vb1:vb2,vc1:vc2,vd1:vd2)
      double precision intblk(a1:a2,b1:b2,c1:c2,d1:d2), fact
      double precision tmp

      drange1 = max(vd1, d1)
      drange2 = min(vd2, d2)
      crange1 = max(vc1, c1)
      crange2 = min(vc2, c2)
      brange1 = max(vb1, b1)
      brange2 = min(vb2, b2)
      arange1 = max(va1, a1)
      arange2 = min(va2, a2)

      do d = drange1, drange2
      do c = crange1, crange2
      do b = brange1, brange2
      do a = arange1, arange2
         v(a,b,c,d) = intblk(a,b,c,d)*fact + v(a,b,c,d)
      enddo
      enddo
      enddo
      enddo

      if (flag .eq. 1) then
      Write(*,*)
      write(*,*) "Printing from add_4cent_integrals"
      tmp = 0.0D0
      do a = arange1, arange2
         do b = brange1, brange2
         do c = crange1, crange2
         do d = drange1, drange2
         write(*,'(I3,1x,I3,1x,I3,1x,I3,1x,F15.10)')a,b,c,d,
     &             v(a,b,c,d)
         tmp = tmp + v(a,b,c,d) * v(a,b,c,d)
         enddo
         enddo
         enddo
         enddo

      Write(6,"(a,1x,F20.10)")"Check sum of the shell quadra. = :",
     &                      tmp
      endif

      return
      end

      subroutine add_4cent_integrals_dbg(v, va1,va2,vb1,vb2,vc1,
     *                 vc2,vd1,vd2,
     *                 intblk, a1, a2, b1, b2, c1, c2, d1, d2, fact,
     *                 flag)

      implicit none
      integer va1, va2, vb1,vb2, vc1, vc2, vd1, vd2
      integer a1, a2, b1, b2, c1, c2, d1, d2
      integer a,b,c,d
      integer flag
      integer drange1, drange2
      integer crange1, crange2
      integer brange1, brange2
      integer arange1, arange2

      double precision v(va1:va2,vb1:vb2,vc1:vc2,vd1:vd2)
      double precision intblk(a1:a2,b1:b2,c1:c2,d1:d2), fact
      double precision tmp

      drange1 = max(vd1, d1)
      drange2 = min(vd2, d2)
      crange1 = max(vc1, c1)
      crange2 = min(vc2, c2)
      brange1 = max(vb1, b1)
      brange2 = min(vb2, b2)
      arange1 = max(va1, a1)
      arange2 = min(va2, a2)

      do d = drange1, drange2
      do c = crange1, crange2
      do b = brange1, brange2
      do a = arange1, arange2
         v(a,b,c,d) = intblk(a,b,c,d)*fact + v(a,b,c,d)
      enddo
      enddo
      enddo
      enddo

      Write(*,*)
      write(*,*) "Printing from add_4cent_integrals"
      if (flag .eq. 1) then
      tmp = 0.0D0
      do a = arange1, arange2
         do b = brange1, brange2
         do c = crange1, crange2
         do d = drange1, drange2
CSSS         write(*,'(I3,1x,I3,1x,I3,1x,I3,1x,F15.10)')a,b,c,d,
CSSS     &             v(a,b,c,d)
         tmp = tmp + v(a,b,c,d) * v(a,b,c,d)
         enddo
         enddo
         enddo
         enddo

      Write(6,"(a,1x,F20.10)")"Check sum of the shell quadra. = :",
     &                      tmp
      endif 

      return
      end


