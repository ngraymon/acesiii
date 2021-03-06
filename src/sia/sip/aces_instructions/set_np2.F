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
      subroutine set_np2  
     +                     (array_table, 
     *                      narray_table, index_table,
     *                      nindex_table, segment_table, nsegment_table,
     *                      block_map_table, nblock_map_table,
     *                      scalar_table, nscalar_table, 
     *                      address_table, op)

c--------------------------------------------------------------------------
c Scalar value    ARRAY  
c            1    CA  
c            2    CB  
c            3    FOCK_A   
c            4    FOCK_B   
c--------------------------------------------------------------------------

      implicit none
      include 'interpreter.h'
      include 'trace.h'
      include 'int_gen_parms.h'
#ifdef ALTIX
      include 'sheap.h'
#endif

      integer narray_table, nindex_table, nsegment_table, 
     *        nblock_map_table 
      integer op(loptable_entry)
      integer array_table(larray_table_entry, narray_table)
      integer index_table(lindex_table_entry, nindex_table)
      integer segment_table(lsegment_table_entry, nsegment_table)
      integer block_map_table(lblock_map_entry, nblock_map_table)
      integer type(mx_array_index) 
      integer nscalar_table
      double precision scalar_table(nscalar_table)
      integer*8 address_table(narray_table)

      integer*8 iarray, ievec, get_index_from_base, daddr
      integer i, j, n1, n2, n3, n4  
      integer array, evec_array
      integer array_type, evec_type
      integer nindex, nindex_evec
      integer sind, ind(mx_array_index)
      integer seg, index(mx_array_index), val1(mx_array_index), 
     *        val2(mx_array_index), junk

      integer block, blkndx
      integer find_current_block
      integer*8 get_block_index
      integer stack

      double precision x(1)
#ifdef ALTIX
      pointer (dptr, x)
#else
      common x
#endif

      if (dryrun) return
#ifdef ALTIX
      dptr = dshptr
#endif

c----------------------------------------------------------------------------
c   Locate the scalar. --> what do we want to calculate??   
c---------------------------------------------------------------------------

      evec_array  = op(c_result_array)
      evec_type   = array_table(c_array_type, evec_array)
      nindex_evec = array_table(c_nindex, evec_array)

      if (evec_type .ne. scalar_value) return

      if (evec_array .lt. 1 .or. evec_array .gt. narray_table) then
         print *,'Error: Invalid scalar in set_psect, line ',
     *     current_line
         print *,'Array index is ',array,' Allowable values are ',
     *      ' 1 through ',narray_table
         call abort_job()
      endif 

      sind =  array_table(c_scalar_index, evec_array)
      if (sind .lt. 1 .or. sind .gt. nscalar_table) then
         print *,'Scalar table index out of range in set_psect, ',
     *           'line ',current_line
         print *,'Index for array ',evec_array,' is ',ind,' should be ',
     *           'between 1 and ',nscalar_table
         call abort_job()
      endif

c----------------------------------------------------------------------------
c   Locate the data for the input matrix which is to be analyses.
c---------------------------------------------------------------------------

      array      = op(c_op1_array)

      array_type = array_table(c_array_type, array)
      nindex     = array_table(c_nindex, array)

      daddr = address_table(array)
      iarray  = get_index_from_base(daddr, x, 2)

      if (array .eq. 0) then
         print *,'Error: The first argument in return_sval  
     *            must be an array.'  
         print *,(op(i),i=1,loptable_entry)
         call abort_job()
      endif

      do i = 1, nindex
         ind(i) = array_table(c_index_array1+i-1,array)
      enddo

      n1 = index_table(c_index_size, ind(1))  ! pick up length of index
      n2 = index_table(c_index_size, ind(2))  ! pick up length of index

          call set_ca(x(iarray),scalar_table(sind),
     *             1,n1,1,n2,nindex_table, nsegment_table)

      return 
      end 

      subroutine set_ca(psect,sval,a1,a2,b1,b2, 
     *                       nindex_table, nsegment_table) 

c---------------------------------------------------------------------------
c
c 
c---------------------------------------------------------------------------

      implicit none
      include 'interpreter.h'
      include 'mpif.h'
      include 'trace.h'
      include 'parallel_info.h'
      include 'int_gen_parms.h'
      include 'symbolic_constants.h'
c
      integer ival, i, j, k, l, a, a1, a2, b, b1, b2   
      double precision psect(a1:a2,b1:b2)
      double precision sval, stemp   
      double precision efinal, conv   
      integer narray_table, nindex_table, nsegment_table, 
     *        nblock_map_table 

      integer index_table(lindex_table_entry, nindex_table)
      integer segment_table(lsegment_table_entry, nsegment_table)
      integer ierr, array, array_type, ind, nind
      integer nseg, bseg, eseg, start(100), end(100), maxi

      integer nao_seg, nocc_seg, occ_size_avg, ao_size_avg, b_size  
      integer NW, NS          

       ival = sval 

c      if (me .eq. 0) then 
         if (ival .eq. 1) then 
            open (33,file='ca_data',status='old') 
            do i = 1, a2 
            do j = 1, b2 
               read(33,*) k, l, psect(i,j) 
            enddo 
            enddo 
          endif 
         if (ival .eq. 2) then 
            open (34,file='cb_data',status='old') 
            do i = 1, a2 
            do j = 1, b2 
               read(34,*) k, l, psect(i,j) 
            enddo 
            enddo 
          endif 
         if (ival .eq. 3) then 
            open (35,file='focka_data',status='old') 
            do i = 1, a2 
            do j = 1, b2 
               read(35,*) k, l, psect(i,j) 
            enddo 
            enddo 
          endif 
         if (ival .eq. 4) then 
            open (36,file='fockb_data',status='old') 
            do i = 1, a2 
            do j = 1, b2 
               read(36,*) k, l, psect(i,j) 
            enddo 
            enddo 
          endif 
c      endif 
c 
c------------------------------------------------------------------------


      return
      end


