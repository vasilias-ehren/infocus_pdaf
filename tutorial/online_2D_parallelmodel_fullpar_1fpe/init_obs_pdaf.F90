!$Id: init_obs_pdaf.F90 1565 2015-02-28 17:04:41Z lnerger $
!BOP
!
! !ROUTINE: init_obs_pdaf --- Initialize observation vector
!
! !INTERFACE:
SUBROUTINE init_obs_pdaf(step, dim_obs_p, observation_p)

! !DESCRIPTION:
! User-supplied routine for PDAF.
! Used in the filters: SEEK/SEIK/EnKF/ETKF/ESTKF
!
! The routine is called during the analysis step. 
! It has to provide the PE-local observation vector 
! for the current time step.
!
! Implementation for the 2D online example
! with or without parallelization.
!
! !REVISION HISTORY:
! 2013-02 - Lars Nerger - Initial code
! Later revisions - see svn log
!
! !USES:
  USE mod_assimilation, &
       ONLY: obs_p

  IMPLICIT NONE

! !ARGUMENTS:
  INTEGER, INTENT(in) :: step             ! Current time step
  INTEGER, INTENT(in) :: dim_obs_p        ! PE-local dimension of obs. vector
  REAL, INTENT(out)   :: observation_p(dim_obs_p) ! PE-local observation vector

! !CALLING SEQUENCE:
! Called by: PDAF_seek_analysis    (as U_init_obs)
! Called by: PDAF_seik_analysis, PDAF_seik_analysis_newT
! Called by: PDAF_enkf_obs_ensemble
!EOP


! ***************************************************************
! *** Initialize observation vector for PE-local model domain ***
! ***************************************************************
  
  observation_p = obs_p

END SUBROUTINE init_obs_pdaf

