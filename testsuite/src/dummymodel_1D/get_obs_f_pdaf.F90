!$Id$
!BOP
!
! !ROUTINE: get_obs_f_pdaf --- get vector of synthetic observations from PDAF
!
! !INTERFACE:
SUBROUTINE get_obs_f_pdaf(step, dim_obs_f, observation_f)

! !DESCRIPTION:
! User-supplied routine for PDAF.
! The routine is called when synthetic observations
! are generated with PDAF. With the call, the user
! is provided with a generated observation vetor. 
! This can then e.g. be written to a file.
!
! The routine is called by all filter processes.
!
! Version for the dummy model with domain 
! decomposition. Here, the state is fully observed.
!
! !REVISION HISTORY:
! 2019-01 - Lars Nerger - Initial code
! Later revisions - see svn log
!
! !USES:
  USE mod_assimilation, &
       ONLY: file_syntobs
  USE mod_parallel, &
       ONLY: mype_filter

  IMPLICIT NONE

! !ARGUMENTS:
  INTEGER, INTENT(in) :: step        ! Currrent time step
  INTEGER, INTENT(in) :: dim_obs_f   ! Dimension of full observation vector
  REAL, INTENT(out)   :: observation_f(dim_obs_f) ! Full observation vector

! !CALLING SEQUENCE:
! Called by: PDAF_gen_obs   (as U_get_obs_f)
!EOP


! *********************************
! *** write observation to file ***
! *********************************

  IF (mype_filter==0) THEN
     CALL write_syn_obs(step, file_syntobs, dim_obs_f, observation_f, 1)
  END IF

END SUBROUTINE get_obs_f_pdaf

