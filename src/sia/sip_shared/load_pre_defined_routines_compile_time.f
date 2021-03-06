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
      subroutine load_pre_defined_routines_compile_time()
      implicit none

      integer dummy, load_user_sub
c
      dummy = load_user_sub('sip_barrier' // char(0),
     *                       0)
      dummy = load_user_sub('energy_denominator' // char(0),
     *                       0)
      dummy = load_user_sub('udenominator'//char(0), 0)
      dummy = load_user_sub('energy_product' // char(0),
     *                       0)
      dummy = load_user_sub('energy_reg_denominator' // char(0),
     *                       0)
      dummy = load_user_sub('energy_reg_product' // char(0),
     *                       0)
      dummy = load_user_sub('energy_denominator_reg_deriv' // char(0),
     *                       0)
      dummy = load_user_sub('print_scalar' // char(0),
     *                       0)
      dummy = load_user_sub('trace_on' // char(0),
     *                       0)
      dummy = load_user_sub('trace_off' // char(0),
     *                       0)
      dummy = load_user_sub('dump_block' // char(0),
     *                       0)
      dummy = load_user_sub('load_balance_on' // char(0),
     *                       0)
      dummy = load_user_sub('load_balance_off' // char(0),
     *                       0)
      dummy = load_user_sub('blocks_to_list' // char(0),
     *                       0)
      dummy = load_user_sub('list_to_blocks' // char(0),
     *                       0)
      dummy = load_user_sub('fmult' // char(0),
     *                       0)
      dummy = load_user_sub('der_int_setup' // char(0),
     *                       0)
      dummy = load_user_sub('compute_derivative_integrals'//char(0),
     *                       0)
      dummy = load_user_sub('server_barrier'//char(0),
     *                       0)
      dummy = load_user_sub('scont1'//char(0), 0)
      dummy = load_user_sub('hcont1'//char(0), 0)
      dummy = load_user_sub('dcont2'//char(0), 0)
      dummy = load_user_sub('eig'//char(0), 0)
      dummy = load_user_sub('eig_inv'//char(0), 0)
      dummy = load_user_sub('eig_sr'//char(0), 0)
      dummy = load_user_sub('eig_sr_inv'//char(0), 0)
      dummy = load_user_sub('copy_fock'//char(0), 0)
      dummy = load_user_sub('diis_setup'//char(0), 0)
      dummy = load_user_sub('compute_diis'//char(0), 0)
      dummy = load_user_sub('write_blocks_to_list'//char(0), 
     *             0)
      dummy = load_user_sub('read_list_to_blocks'//char(0), 
     *             0)
      dummy = load_user_sub('remove_diagonal'//char(0), 0)
      dummy = load_user_sub('return_diagonal'//char(0), 0)
      dummy = load_user_sub('fock_denominator'//char(0),
     *            0)
      dummy = load_user_sub('set_flags'//char(0), 0)
      dummy = load_user_sub('set_flags2'//char(0), 0)
      dummy = load_user_sub('der2_comp'//char(0), 0)
      dummy = load_user_sub('fock_der'//char(0), 0)
      dummy = load_user_sub('overlap_der'//char(0), 0)
      dummy = load_user_sub('scontxy'//char(0), 0)
      dummy = load_user_sub('hcontxy'//char(0), 0)
      dummy = load_user_sub('compute_sderivative_integrals'//char(0),
     *                       0)
      dummy = load_user_sub('read_hess'//char(0), 0)
      dummy = load_user_sub('return_h1'//char(0), 0)

      dummy = load_user_sub('smon_on'//char(0), 
     *                       0)
      dummy = load_user_sub('smon_off'//char(0), 
     *                       0)
      dummy = load_user_sub('scf_rhf'//char(0), 0)
      dummy = load_user_sub('array_copy'//char(0), 0)
      dummy = load_user_sub('energy_adenominator'//char(0),
     *                       0) 
      dummy = load_user_sub('energy_bdenominator'//char(0),
     *                       0) 
      dummy = load_user_sub('energy_abdenominator'//char(0),
     *                       0) 
      dummy = load_user_sub('remove_xd'//char(0), 0)
      dummy = load_user_sub('remove_ds'//char(0), 0)
      dummy = load_user_sub('remove_ss'//char(0), 0)
      dummy = load_user_sub('remove_dd'//char(0), 0)
      dummy = load_user_sub('removeoo_dd'//char(0), 0)
      dummy = load_user_sub('removevv_dd'//char(0), 0)
      dummy = load_user_sub('remove_sd'//char(0), 0)
      dummy = load_user_sub('remove_sx'//char(0), 0)
      dummy = load_user_sub('remove_dx'//char(0), 0)
c     dummy = load_user_sub('copy_ab'//char(0), copy_ab)
c     dummy = load_user_sub('copy_ba'//char(0), copy_ba)
      dummy = load_user_sub('copy_ff'//char(0), 0)
c     dummy = load_user_sub('open_amp'//char(0), open_amp)
      dummy = load_user_sub('dump_amp'//char(0), 0)
      dummy = load_user_sub('comp_ovl3c'//char(0), 0)
      dummy = load_user_sub('check_dconf'//char(0), 0)
      dummy = load_user_sub('dropmo_expand_basis'//char(0), 
     *                       0)
      dummy = load_user_sub('square_root'//char(0), 0)
      dummy = load_user_sub('norm_fac'//char(0), 0)
      dummy = load_user_sub('return_sval'//char(0), 0)
      dummy = load_user_sub('return_diagonal4'//char(0),
     *                      0)
      dummy = load_user_sub('symm_force_a'//char(0),
     *                      0)
      dummy = load_user_sub('symm_force_i'//char(0),
     *                      0)
      dummy = load_user_sub('place_sval'//char(0), 0)
      dummy = load_user_sub('place_one'//char(0), 0)
      dummy = load_user_sub('place_one2'//char(0), 0)
      dummy = load_user_sub('place_one3'//char(0), 0)
      dummy = load_user_sub('place_one4'//char(0), 0)
      dummy = load_user_sub('place_one5'//char(0), 0)
      dummy = load_user_sub('place_one6'//char(0), 0)
      dummy = load_user_sub('place_oneb'//char(0), 0)
      dummy = load_user_sub('place_one2b'//char(0), 0)
      dummy = load_user_sub('place_one3b'//char(0), 0)
      dummy = load_user_sub('place_one4b'//char(0), 0)
      dummy = load_user_sub('place_one5b'//char(0), 0)
      dummy = load_user_sub('place_one6b'//char(0), 0)
      dummy = load_user_sub('place_one_dip'//char(0),
     *                                      0)
      dummy = load_user_sub('place_one_dip_2'//char(0),
     *                                      0)
      dummy = load_user_sub('place_one_dip_3'//char(0),
     *                                      0)
      dummy = load_user_sub('place_one_dip_4'//char(0),
     *                                      0)
      dummy = load_user_sub('place_one_dip_5'//char(0),
     *                                      0)
      dummy = load_user_sub('place_one_dip_6'//char(0),
     *                                      0)
      dummy = load_user_sub('place_one_dip_7'//char(0),
     *                                      0)
      dummy = load_user_sub('place_one_dip_8'//char(0),
     *                                      0)
      dummy = load_user_sub('place_one_dea'//char(0),
     *                                      0)
      dummy = load_user_sub('place_one_dea_2'//char(0),
     *                                      0)
      dummy = load_user_sub('place_one_dea_3'//char(0),
     *                                      0)
      dummy = load_user_sub('place_one_dea_4'//char(0),
     *                                      0)
      dummy = load_user_sub('place_one_dea_5'//char(0),
     *                                      0)
      dummy = load_user_sub('place_one_dea_6'//char(0),
     *                                      0)
      dummy = load_user_sub('place_one_dea_7'//char(0),
     *                                      0)
      dummy = load_user_sub('place_one_dea_8'//char(0),
     *                                      0)
      dummy = load_user_sub('eomroot_print'//char(0), 0)
      dummy = load_user_sub('eomroot_print_new'//char(0), 
     *                       0)
c     dummy = load_user_sub('smooth'//char(0), smooth)
c     dummy = load_user_sub('smooth4'//char(0), smooth4)
      dummy = load_user_sub('eig_nonsymm'//char(0),
     *                       0)
      dummy = load_user_sub('apply_den2'//char(0), 0)
      dummy = load_user_sub('apply_den2_nor'//char(0), 0)
      dummy = load_user_sub('apply_den4'//char(0), 0)
      dummy = load_user_sub('apply_den4_nodiag'//char(0),
     *                       0)
      dummy = load_user_sub('energy_tdenominator'//char(0),
     *                       0)
      
c     dummy = load_user_sub('compute_aaaa_batch'//char(0),
c    *                       compute_aaaa_batch)
c     dummy = load_user_sub('compute_aaab_batch'//char(0),
c    *                       compute_aaab_batch)
      dummy = load_user_sub('compute_aabb_batch'//char(0),
     *                       0)
c     dummy = load_user_sub('compute_aabc_batch'//char(0),
c    *                       compute_aabc_batch)
c     dummy = load_user_sub('compute_abab_batch'//char(0),
c    *                       compute_abab_batch)
c     dummy = load_user_sub('compute_abac_batch'//char(0),
c    *                       compute_abac_batch)
      dummy = load_user_sub('compute_abcd_batch'//char(0),
     *                       0)
      dummy = load_user_sub('compute_no4c_batch'//char(0),
     *                       0)
      dummy = load_user_sub('remove_atom_rud1'//char(0),
     *                       0)
      dummy = load_user_sub('remove_atom_rud2'//char(0),
     *                       0)
      dummy = load_user_sub('der4_comp'//char(0), 0)
      dummy = load_user_sub('set_flags4'//char(0), 0)
      dummy = load_user_sub('timestamp'//char(0), 0)
      dummy = load_user_sub('c1_print'//char(0), 0)
      dummy = load_user_sub('c1b_print'//char(0), 0)
      dummy = load_user_sub('c2aa_print'//char(0), 0)
      dummy = load_user_sub('c2ab_print'//char(0), 0)
      dummy = load_user_sub('c2bb_print'//char(0), 0)
      dummy = load_user_sub('pardo_sects'//char(0), 0)
      dummy = load_user_sub('get_ijk'//char(0), 0)
      dummy = load_user_sub('set_ijk_aaa'//char(0), 0)
      dummy = load_user_sub('set_ijk_aaa_nosymm'//char(0), 0)
      dummy = load_user_sub('stripi'//char(0), 0)
      dummy = load_user_sub('sum_64ss'//char(0), 0)
      dummy = load_user_sub('set_ijk_aab'//char(0), 0)
      dummy = load_user_sub('set_ijk_aab_nosymm'//char(0), 0)
      dummy = load_user_sub('get_my_rank'//char(0), 0)
      dummy = load_user_sub('broadcast_array'//char(0), 0)
      dummy = load_user_sub('checkpoint'//char(0), 0)
      dummy = load_user_sub('get_restart_status'//char(0), 
     *                       0)
      dummy = load_user_sub('commit_checkpoint'//char(0), 
     *                       0)
      dummy = load_user_sub('crash'//char(0), 0)
C
C
C             ...Watson: XYZ moment integrals
C
      dummy = load_user_sub('return_ovl'//char(0), 0)
      dummy = load_user_sub('return_derv_xyz'//char(0), 0)
      dummy = load_user_sub('dipole_moment'//char(0), 0)
      dummy = load_user_sub('second_moment'//char(0), 0)
      dummy = load_user_sub('energy_ty_denominator'//char(0),
     *                       0)
      dummy = load_user_sub('reorder_energy'//char(0), 0)
      dummy = load_user_sub('return_1st_mom'//char(0), 0)
      dummy = load_user_sub('return_2nd_mom'//char(0), 0)

      dummy = load_user_sub('nuc_dipole_moment'//char(0),
     *                       0)
      dummy = load_user_sub('nuc_dipole_derivative'//char(0),
     *                       0)

      dummy = load_user_sub('return_x'//char(0), 0)
      dummy = load_user_sub('return_y'//char(0), 0)
      dummy = load_user_sub('return_z'//char(0), 0)

      dummy = load_user_sub('return_xx'//char(0), 0)
      dummy = load_user_sub('return_yy'//char(0), 0)
      dummy = load_user_sub('return_zz'//char(0), 0)

      dummy = load_user_sub('return_xy'//char(0), 0)
      dummy = load_user_sub('return_xz'//char(0), 0)
      dummy = load_user_sub('return_yz'//char(0), 0)

      dummy = load_user_sub('print_eom_dens_info'//char(0),
     +                       0)
c
c -------------------------------------------------------------------- 
c VFL Instructions needed to perform 'fast' scf calculations 
c -------------------------------------------------------------------- 
c
      dummy = load_user_sub('compute_batch1'//char(0), 0)
      dummy = load_user_sub('compute_batch2'//char(0), 0)
      dummy = load_user_sub('compute_batch3'//char(0), 0)
      dummy = load_user_sub('compute_batch4'//char(0), 0)
      dummy = load_user_sub('compute_batch5'//char(0), 0)
      dummy = load_user_sub('compute_batch6'//char(0), 0)
      dummy = load_user_sub('compute_batch7'//char(0), 0)
      dummy = load_user_sub('compute_batch8'//char(0), 0)

      dummy = load_user_sub('compute_ubatch1'//char(0), 0)
      dummy = load_user_sub('compute_ubatch2'//char(0), 0)
      dummy = load_user_sub('compute_ubatch3'//char(0), 0)
      dummy = load_user_sub('compute_ubatch4'//char(0), 0)
      dummy = load_user_sub('compute_ubatch5'//char(0), 0)
      dummy = load_user_sub('compute_ubatch6'//char(0), 0)
      dummy = load_user_sub('compute_ubatch7'//char(0), 0)
      dummy = load_user_sub('compute_ubatch8'//char(0), 0)

      dummy = load_user_sub('form_iad'//char(0), 0)
      dummy = load_user_sub('form_ibd'//char(0), 0)

      dummy = load_user_sub('set_itol'//char(0), 0)
      dummy = load_user_sub('fassign'//char(0), 0)
c
c -------------------------------------------------------------------- 
c VFL Instructions needed to perform 'super' T calculations 
c -------------------------------------------------------------------- 
c
      dummy = load_user_sub('set_t3blocks_a'//char(0), 0)
      dummy = load_user_sub('set_t3blocks_i'//char(0), 0)
      dummy = load_user_sub('compt3_a'//char(0), 0)
      dummy = load_user_sub('compt3_i'//char(0), 0)
      dummy = load_user_sub('prefetch_on'//char(0), 0)
      dummy = load_user_sub('prefetch_off'//char(0), 0)
c
c -------------------------------------------------------------------- 
c VFL Instruction needed to perform atomic density guess  
c -------------------------------------------------------------------- 
c
      dummy = load_user_sub('scf_atom'//char(0), 0) 
c
c -------------------------------------------------------------------- 
c VFL Instruction needed for printing, FNO, ect.. updated FEB. 29 2012  
c -------------------------------------------------------------------- 
c
      dummy = load_user_sub('print_rel_info'//char(0),
     *                       0)
      dummy = load_user_sub('temp_x'//char(0), 0)
      dummy = load_user_sub('corder'//char(0), 0)
      dummy = load_user_sub('form_fno'//char(0), 0)
      dummy = load_user_sub('form_fnob'//char(0), 0)
      dummy = load_user_sub('maxamp_print'//char(0), 0)
      dummy = load_user_sub('form_fock_rohf'//char(0), 0)
c
c --------------------------------------------------------------------
c VFL Instruction needed for DEA/DIP updated AUG. 14 2012
c --------------------------------------------------------------------
c
      dummy = load_user_sub('write_scfdata'//char(0), 0)
      dummy = load_user_sub('set_np2'//char(0), 0)
      dummy = load_user_sub('sdrop'//char(0), 0)
      dummy = load_user_sub('asymm_force_a'//char(0), 0)
      dummy = load_user_sub('asymm_force_i'//char(0), 0)
      dummy = load_user_sub('symm_force_ij'//char(0), 0)
      dummy = load_user_sub('return_h1_nodiag'//char(0),
     *                       0)
c
c --------------------------------------------------------------------
c Watson instruction needed to write out density
c --------------------------------------------------------------------
c
      dummy = load_user_sub('dens2jobarc'//char(0), 0)
      dummy = load_user_sub('change_occ_dens'//char(0), 0)
      dummy = load_user_sub('change_vrt_dens'//char(0), 0)
      dummy = load_user_sub('add_scal2diag'//char(0), 0)
      dummy = load_user_sub('calc_trace'//char(0), 0)
      dummy = load_user_sub('v_nuc_nuc'//char(0), 0)
c      dummy = load_user_sub('vccs_change_x'//char(0), vccs_change_x)
      dummy = load_user_sub('write_coefficients'//char(0),
     +                       0)
      dummy = load_user_sub('read_coefficients'//char(0),
     +                       0)
      dummy = load_user_sub('scf_atom_coeff'//char(0), 0)
c
c -------------------------------------------------------------------- 
c Instructions needed in the CCSD(T) gradient  
c --------------------------------------------------------------------
C Ajith Perera, miscellaneous developments. 

      dummy = load_user_sub('sum_2d_array'//char(0), 0)

      dummy = load_user_sub('compute_1soi_xbatch'//char(0),0)
      dummy = load_user_sub('compute_1soi_ybatch'//char(0),0)
      dummy = load_user_sub('compute_1soi_zbatch'//char(0),0)

      dummy = load_user_sub('compute_2soi_xbatch'//char(0),0)
      dummy = load_user_sub('compute_2soi_ybatch'//char(0),0)
      dummy = load_user_sub('compute_2soi_zbatch'//char(0),0)

      dummy = load_user_sub('compute_angmom_xbatch'//char(0),0)
      dummy = load_user_sub('compute_angmom_ybatch'//char(0),0)
      dummy = load_user_sub('compute_angmom_zbatch'//char(0),0)

      dummy = load_user_sub('compute_dshield_xxbatch'//char(0),0)
      dummy = load_user_sub('compute_dshield_xybatch'//char(0),0)
      dummy = load_user_sub('compute_dshield_yxbatch'//char(0),0)
      dummy = load_user_sub('compute_dshield_xzbatch'//char(0),0)
      dummy = load_user_sub('compute_dshield_zxbatch'//char(0),0)
      dummy = load_user_sub('compute_dshield_yybatch'//char(0),0)
      dummy = load_user_sub('compute_dshield_yzbatch'//char(0),0)
      dummy = load_user_sub('compute_dshield_zybatch'//char(0),0)
      dummy = load_user_sub('compute_dshield_zzbatch'//char(0),0)

      dummy = load_user_sub('compute_kin_batch'//char(0),0)

      dummy = load_user_sub('write_vecs2jarc'//char(0),0)

      dummy = load_user_sub('level_shift'//char(0),0)

      dummy = load_user_sub('return_occupation'//char(0),0)

      dummy = load_user_sub('get_init_occupation'//char(0),0)

      dummy = load_user_sub('mult_array_byc'//char(0),0)

      dummy = load_user_sub('david_damp_factor'//char(0),0)

      dummy = load_user_sub('antihermitize_pqrs'//char(0),0)

      dummy = load_user_sub('init_fockdiags'//char(0),0)
      dummy = load_user_sub('fock_denominator_dynamic'//char(0),0)

      dummy = load_user_sub('compute_2dshield_xxbatch'//char(0),0)
      dummy = load_user_sub('compute_2dshield_xybatch'//char(0),0)
      dummy = load_user_sub('compute_2dshield_yxbatch'//char(0),0)
      dummy = load_user_sub('compute_2dshield_xzbatch'//char(0),0)
      dummy = load_user_sub('compute_2dshield_zxbatch'//char(0),0)
      dummy = load_user_sub('compute_2dshield_yybatch'//char(0),0)
      dummy = load_user_sub('compute_2dshield_yzbatch'//char(0),0)
      dummy = load_user_sub('compute_2dshield_zybatch'//char(0),0)
      dummy = load_user_sub('compute_2dshield_zzbatch'//char(0),0)

      dummy = load_user_sub('report_maximum'//char(0),0)
      dummy = load_user_sub('place_constanta'//char(0),0)
      dummy = load_user_sub('place_constantb'//char(0),0)
c -----------------------------------------------------------------
c Prakash instructions need for delta integrals
c ------------------------------------------------------------------
      dummy = load_user_sub('compute_delta_int'//char(0), 0)
      dummy = load_user_sub('print_esr_tensors'//char(0), 0)
c ------------------------------------------------------------------
      dummy = load_user_sub('index_match'//char(0), 0)
      dummy = load_user_sub('ecp_dercont'//char(0), 0) 
c--------------------------------------------------------------------
c VFL Instruction needed for restricted pardo  updated JULY 22012
c--------------------------------------------------------------------
      dummy = load_user_sub('init_section'//char(0), 0)
      dummy = load_user_sub('prestrict'//char(0), 0)
      dummy = load_user_sub('doprestrict'//char(0), 0)
c--------------------------------------------------------------------
c Jason Byrd misc. development additions
c--------------------------------------------------------------------
      dummy = load_user_sub('sort_fno'//char(0), 0)
      dummy = load_user_sub('dropcore_fno'//char(0), 0)
c-------------------------------------------------------------------- 
c
      return
      end
