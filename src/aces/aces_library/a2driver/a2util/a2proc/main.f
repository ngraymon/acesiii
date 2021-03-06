
c This program takes command-line arguments and executes subroutines
c accordingly. Essentially, it is a shell environment for processing
c data generated by ACES2.

c#define _DIMARGS 3 /* 3 args required by jarec */









































































































































































































































































































































































































































































































































      program main
      implicit none

c INTERNAL VARIABLES
      integer dimargs, iuhf
      character*80 module
      character*80 args(8)
      Logical OPTARC_EXIST

c COMMON BLOCKS


c icore.com : begin

c icore(1) is an anchor in memory that allows subroutines to address memory
c allocated with malloc. This system will fail if the main memory is segmented
c or parallel processes are not careful in how they allocate memory.

      integer icore(1)
      common / / icore

c icore.com : end





c istart.com : begin
      integer         i0, icrsiz
      common /istart/ i0, icrsiz
      save   /istart/
c istart.com : end
c flags.com : begin
      integer        iflags(100)
      common /flags/ iflags
c flags.com : end
c flags2.com : begin
      integer         iflags2(500)
      common /flags2/ iflags2
c flags2.com : end

c ----------------------------------------------------------------------

      dimargs = 8
      call a2proc_init(module,args,dimargs)

      if ((module(1:5).eq.'help ').or.(module(1:3).eq.'-h ')) then
         print '()'
         print *, 'ACESII PROCESSOR LIST OF USEABLE MODULES'
         print *, '----------------------------------------'
         print *, 'factor <numb> [ <numb> [ <numb> [ ... ]]]'
         print *, 'mem <amount>'
         print *, 'test <file> [ <file> [ <file> [ ... ]]]'
         print *, 'molden'
c         print *, 'gennbo'
         print *, 'hyperchem'
         print *, 'extrap (energy|gradient)'
         print *, 'statthermo'
         print *, 'parfd (update|updump|dump|load <file>)'
         print *, 'jarec datatype RECNAME dimension'
         print *, 'jareq datatype RECNAME dimension (the quiet version)'
         print *, 'jasum'
         print *, 'xyz'
         print *, 'iosum'
         print *, 'clrdirty'
         print *, 'zerorec RECNAME [ RECNAME [ RECNAME [ ... ]]]'
         print *, 'rmfiles'
         print '()'
         stop
      end if


c ----------------------------------------------------------------------

c These modules require nothing from ACES.

      if (module(1:7).eq.'factor ') then
         call factor(args,dimargs)
         goto 9999
      end if
c
      if (module(1:11).eq.'PES_scan ') then
CSSS         Streamin   = .true.
CSSS         Stationary = .true.
CSSS         Drive_IRC  = .true.
C These must be providded the calling program.
      
         call pes_scan_main(.False., .False., .True.)
         goto 9998
      endif

c ----------------------------------------------------------------------

c These modules require JOBARC, but do not require heap space or lists.

      call aces_init_rte
      call aces_com_parallel_aces
      call aces_ja_init
      call getrec(1,'JOBARC','IFLAGS', 100,iflags)
      call getrec(1,'JOBARC','IFLAGS2',500,iflags2)

      if (module(1:6).eq.'jasum ') then
         call aces_ja_summary
         goto 9999
      end if

      if (module(1:8).eq.'zerorec ') then
         call zerorec(args,dimargs)
         goto 9999
      end if

      if (module(1:9).eq.'clrdirty ') then
         call putrec(0,'JOBARC','DIRTYFLG',1,0)
         print *, '@A2PROC: The dirty flag is clear.'
         goto 9999
      end if

      if (module(1:4).eq.'xyz ') then
         call xyz
         goto 9999
      end if

      if (module(1:4).eq.'mem ') then
         call mem(args,dimargs)
         goto 9999
      end if

c ----------------------------------------------------------------------

c These modules require heap space, but do not require lists.

      icrsiz = iflags(36)
      icore(1) = 0
      do while ((icore(1).eq.0).and.(icrsiz.gt.1000000))
         call aces_malloc(icrsiz,icore,i0)
         if (icore(1).eq.0) icrsiz = icrsiz - 1000000
      end do
      if (icore(1).eq.0) then
         print *, '@MAIN: unable to allocate at least ',
     &            1000000,' integers of memory'
         call aces_exit(1)
      end if
C
C This call to xjoda (which should be in the directory where xaces3).
C In addition to the ACES_EXE_PATH usesrs must set the PATH to recignize
C the location of xjoda and xa2proc to do pre/post processing of 
C ACES III files set (JOBARC and JAINDX). 07/2013, Ajith Perera.
C
      Inquire(FILE='OPTARC',EXIST=OPTARC_EXIST)
      If (OPTARC_EXIST) Call runit("rm OPTARC")

      if (module(1:5).ne.'parfd') then
         call runit("xjoda")
         call v2ja(icore(I0), icrsiz)
      endif

      if (module(1:5).eq.'test ') then
         call test(args,dimargs)
         goto 9998
      end if

      if (module(1:7).eq.'molden ') then
         call molden_main(args, dimargs)
         goto 9998
      end if

c This has not been audited.
      if (module(1:7).eq.'gennbo ') then
         call gennbo_main
         goto 9998
      end if

      if (module(1:10).eq.'hyperchem ') then
         call hyprchm_main
         goto 9998
      end if

      if (module(1:6).eq.'parfd ') then
         call parfd(args,dimargs)
         goto 9998
      end if

      if (module(1:6).eq.'jarec ') then
         call jarec(args,dimargs,.true.)
         goto 9998
      end if

      if (module(1:6).eq.'jareq ') then
         call jarec(args,dimargs,.false.)
         goto 9998
      end if

      if (module(1:7).eq.'extrap ') then
         call extrap_main(args, dimargs)
         goto 9998
      end if

      if (module(1:11).eq.'statthermo ') then
         call stat_thermo_main
         goto 9998
      endif 

      if (module(1:7).eq.'dplots ') then
         call den_plots_main(Icore(I0), icrsiz)
         goto 9998
      endif 
C
      if (module(1:7).eq.'a2rate ') then
         call a2rate_main(Icore(I0), icrsiz)
         goto 9998
      endif
C
      if (module(1:11).eq.'vrcoupling ') then
         call vib_rot_coupl(Icore(I0), icrsiz)
         goto 9998
      endif
C
      if (module(1:4).eq.'qta ') then
         call qntm_topl_main(Icore(I0), icrsiz)
         goto 9998
      endif
C      
      if (module(1:7).eq.'wrtprm ') then
         call Wrt_prim_main(Icore(I0), icrsiz)
         goto 9998
      endif
      
      if (module(1:8).eq.'rdfile ') then
         call read_file_main(Icore(I0), icrsiz)
         goto 9998
      endif

      if (module(1:9).eq.'symadapt ') then
         call a3_symadapt_main(Icore(I0), icrsiz)
         goto 9998
      endif

C
C      if (module(1:8).eq.'polyrate') then
C         call polyrate_main(Icore(I0), icrsiz)
C         goto 9998
C      endif
c ----------------------------------------------------------------------

c These modules require lists.

      call aces_io_init(icore,i0,icrsiz,.true.)

      if (module(1:6).eq.'iosum ') then
         call aces_io_summary
         goto 9997
      end if

      if (module(1:8).eq.'rmfiles ') then
         call aces_io_remove(50,'MOINTS')
         call aces_io_remove(51,'GAMLAM')
         call aces_io_remove(52,'MOABCD')
         call aces_io_remove(53,'DERINT')
         call aces_io_remove(54,'DERGAM')
         print *, '@A2PROC: Successfully removed list files.'
         goto 9997
      end if
c
      if (module(1:8) .eq. 'recovery') then
          call aces_init_chemsys
          call aces_io_recovery
          goto 9997
      endif
c ----------------------------------------------------------------------

 9997 continue
      call aces_io_fin
 9998 continue
c      call c_free(icore)
 9999 continue
      call aces_ja_fin
C
      call c_exit(0)
      end

