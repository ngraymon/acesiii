C  Copyright (c) 1997-1999, 2003 Massachusetts Institute of Technology
C 
C  This program is free software; you can redistribute it and/or modify
C  it under the terms of the GNU General Public License as published by
C  the Free Software Foundation; either version 2 of the License, or
C  (at your option) any later version.

C  This program is distributed in the hope that it will be useful,
C  but WITHOUT ANY WARRANTY; without even the implied warranty of
C  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
C  GNU General Public License for more details.

C  You should have received a copy of the GNU General Public License
C  along with this program; if not, write to the Free Software
C  Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307
C  USA
         SUBROUTINE  OED__GENER_XYZ_DERV_BATCH
     +
     +                    ( IMAX,ZMAX,
     +                      NALPHA,NCOEFF,NCSUM,
     +                      NCGTO1,NCGTO2,
     +                      NPGTO1,NPGTO2,
     +                      SHELL1,SHELL2,
     +                      X1,Y1,Z1,X2,Y2,Z2,
     +                      DER1X,DER1Y,DER1Z,
     +                      DER2X,DER2Y,DER2Z,
     +                      XMOMD,YMOMD,ZMOMD,             ! Watson Added
     +                      XC,YC,ZC,
     +                      ALPHA,CC,CCBEG,CCEND,
     +                      SPHERIC,
     +                      SCREEN,
     +                      ICORE,
     +
     +                                NBATCH,
     +                                NFIRST,
     +                                ZCORE )
     +
C------------------------------------------------------------------------
C  OPERATION   : OED__GENER_XYZ_DERV_BATCH
C  MODULE      : ONE ELECTRON INTEGRALS DIRECT
C  MODULE-ID   : OED
C  SUBROUTINES : OED__XYZ_DERV_CSGTO
C  DESCRIPTION : Main operation that drives the calculation of a batch
C                of differentiated contracted electron x, y, or z
C                integrals.
C
C
C                  Input (x = 1 and 2):
C
C                    IMAX,ZMAX    =  maximum integer + flp memory
C                    NALPHA       =  total # of exponents
C                    NCOEFF       =  total # of contraction coeffs
C                    NCSUM        =  total # of contractions
C                    NCGTOx       =  # of contractions for csh x
C                    NPGTOx       =  # of primitives per contraction
C                                    for csh x
C                    SHELLx       =  the shell type for csh x
C                    Xy,Yy,Zy     =  the x,y,z-coordinates for centers
C                                    y = 1 and 2 and C. 
C                    DERyp        =  the order of differentiation on
C                                    centers y = 1 and 2 with respect
C                                    to the p = x,y,z coordinates
C                    pMOMD        =  the type of moment integral
C                                    with p = x, y, or z
C                    ALPHA        =  primitive exponents for csh
C                                    1 and 2 in that order
C                    CC           =  contraction coefficient for csh
C                                    1 and 2 in that order, for each
C                                    csh individually such that an
C                                    (I,J) element corresponds to the
C                                    I-th primitive and J-th contraction.
C                    CC(BEG)END   =  (lowest)highest nonzero primitive
C                                    index for contractions for csh
C                                    1 and 2 in that order. They are
C                                    different from (1)NPGTOx only for
C                                    segmented contractions
C                    SPHERIC      =  is true, if spherical integrals
C                                    are wanted, false if cartesian
C                                    ones are wanted
C                    SCREEN       =  is true, if screening will be
C                                    done at primitive integral level
C                    ICORE        =  integer scratch space
C                    ZCORE (part) =  flp scratch space
C
C
C                  Output:
C
C                    NBATCH       =  # of derivative integrals in batch
C                    NFIRST       =  first address location inside the
C                                    ZCORE array containing the first
C                                    derivative integral
C                    ZCORE        =  full batch of contracted (1|2)
C                                    derivative overlap integrals over
C                                    cartesian or spherical gaussians
C                                    starting at ZCORE (NFIRST)
C
C
C
C                            !!! IMPORTANT !!!
C
C                For performance tuning, please see the include file
C                'oed__tuning.inc'.
C
C
C  AUTHOR      : Norbert Flocke
C
C  MODIFIED    : Thomas Watson
C                   - Changed to do derivatives of moment integrals
C              : Ajith Perere                p    q    r
C                  - Modified to handle (X-C)(Y-C)(Z-C)
C------------------------------------------------------------------------
C
C
C             ...include files and declare variables.
C
C
         IMPLICIT    NONE

         INCLUDE     'oed__tuning.inc'

         LOGICAL     SCREEN
         LOGICAL     SPHERIC

         INTEGER     DER1X,DER1Y,DER1Z
         INTEGER     DER2X,DER2Y,DER2Z
         INTEGER     XMOMD,YMOMD,ZMOMD                     ! Watson Added
         INTEGER     IMAX,ZMAX
         INTEGER     NALPHA,NCOEFF,NCSUM
         INTEGER     NBATCH,NFIRST
         INTEGER     NCGTO1,NCGTO2
         INTEGER     NPGTO1,NPGTO2
         INTEGER     SHELL1,SHELL2

         INTEGER     CCBEG (1:NCSUM)
         INTEGER     CCEND (1:NCSUM)
         INTEGER     ICORE (1:IMAX)

         DOUBLE PRECISION  X1,Y1,Z1,X2,Y2,Z2,XC,YC,ZC

         DOUBLE PRECISION  ALPHA (1:NALPHA)
         DOUBLE PRECISION  CC    (1:NCOEFF)
         DOUBLE PRECISION  ZCORE (1:ZMAX)
C
C
C------------------------------------------------------------------------
C
C
C             ...call csgto routine.
C
C
         CALL  OED__XYZ_DERV_CSGTO
     +
     +              ( IMAX,ZMAX,
     +                NALPHA,NCOEFF,NCSUM,
     +                NCGTO1,NCGTO2,
     +                NPGTO1,NPGTO2,
     +                SHELL1,SHELL2,
     +                X1,Y1,Z1,X2,Y2,Z2,
     +                DER1X,DER1Y,DER1Z,
     +                DER2X,DER2Y,DER2Z,
     +                XMOMD,YMOMD,ZMOMD,                   ! Watson Added
     +                XC,YC,ZC,
     +                ALPHA,CC,CCBEG,CCEND,
     +                L1CACHE,TILE,NCTROW,
     +                SPHERIC,SCREEN,
     +                ICORE,
     +
     +                          NBATCH,
     +                          NFIRST,
     +                          ZCORE )
     +
     +
C
C
C             ...ready!
C
C
         RETURN
         END
