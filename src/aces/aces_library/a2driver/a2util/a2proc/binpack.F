      subroutine binpack(ca, Nshells, Nprims_shell, 
     &                   Orig_nprims_shell, Reorder_Shell,
     &                   Iscr, Dscr, Nrows, Ncolumns)

      Implicit Double Precision (A-H, O-Z)

      Dimension Ca(Nrows, Ncolumns), Nprims_shell(Nshells),
     &          Orig_nprims_shell(Nshells)
      Integer   Reorder_Shell(Nshells)
      Dimension Iscr(Nrows), Dscr(Nrows)

#ifdef _DEBUG_LVLM
      Write(6,*) Nrows, Ncolumns,Nshells,(Nprims_shell(i), i=1,Nshells)
      Write(6,*)
      Write(6,*) (reorder_shell(i), i=1,Nshells)
      Write(6,*)
#endif
      if (Nrows .gt. 0) then

         do i = 1, nshells
            Orig_nprims_shell(Reorder_Shell(i)) = Nprims_shell(i)
         enddo

c--------------------------------------------------------------------------
c   Build a basis function index array from the shell index array.
c--------------------------------------------------------------------------

         istart = 1
         do i = 1, nshells
            ishell = Reorder_Shell(i)

c---------------------------------------------------------------------------
c   Calculate the starting basis function.
c---------------------------------------------------------------------------

            n = 0
            do j = 1, ishell-1
               n = n + Orig_Nprims_shell(j)
            enddo

c----------------------------------------------------------------------------
c   Store the next "nfps(ishell)" indices in the index array.
c----------------------------------------------------------------------------

            do j = 1, Orig_Nprims_shell(ishell)
               IScr(istart) = n + j
               istart = istart + 1
            enddo
         enddo

         do j = 1, Ncolumns 

c--------------------------------------------------------------------------
c   Save column "j".
c--------------------------------------------------------------------------

            do i = 1, Nrows
               Dscr(i) = ca(i,j)
            enddo

            do i = 1, Nrows
               ca(i,j) = Dscr(Iscr(i))
            enddo
         enddo

      endif

      return
      end
