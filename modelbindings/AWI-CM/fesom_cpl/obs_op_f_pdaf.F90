!$Id: obs_op_f_pdaf.F90 2136 2019-11-22 18:56:35Z lnerger $
!BOP
!
! !ROUTINE: obs_op_f_pdaf --- Implementation of observation operator 
!
! !INTERFACE:
SUBROUTINE obs_op_f_pdaf(step, dim_p, dim_obs_f, state_p, m_state_f)

! !DESCRIPTION:
! User-supplied routine for PDAF.
! Used in the filters: LSEIK/LETKF/LESTKF
!
! The routine is called in PDAF\_X\_update
! before the loop over all local analysis domains
! is entered.  The routine has to perform the 
! operation of the observation operator acting on 
! a state vector.  The full vector of all 
! observations required for the localized analysis
! on the PE-local domain has to be initialized.
! This is usually data on the PE-local domain plus 
! some region surrounding the PE-local domain. 
! This data is gathered by MPI operations. The 
! gathering has to be done here, since in the loop 
! through all local analysis domains, no global
! MPI operations can be performed, because the 
! number of local analysis domains can vary from 
! PE to PE.
!
! The routine is called by all filter processes, 
! and the operation has to be performed by each 
! these processes for its PE-local domain.
!
! !REVISION HISTORY:
! 2017-07 - Lars Nerger - Initial code for AWI-CM
! Later revisions - see svn log
!
! !USES:
  USE mod_assim_pdaf, &
       ONLY: offset, id_observed_sst_p, dim_obs_p
  USE mod_parallel_pdaf, &
       ONLY: npes_filter, mype_filter, COMM_filter
  USE g_parfe, &
       ONLY: MPI_DOUBLE_PRECISION, MPIerr, mydim_nod2d, mydim_nod3d


  IMPLICIT NONE

! !ARGUMENTS:
  INTEGER, INTENT(in) :: step                 ! Current time step
  INTEGER, INTENT(in) :: dim_p                ! PE-local dimension of state
  INTEGER, INTENT(in) :: dim_obs_f            ! Dimension of observed state
  REAL, INTENT(in)    :: state_p(dim_p)       ! PE-local model state
  REAL, INTENT(inout) :: m_state_f(dim_obs_f) ! PE-local observed state

! !CALLING SEQUENCE:
! Called by: PDAF_lseik_update   (as U_obs_op)
! Called by: PDAF_lestkf_update  (as U_obs_op)
! Called by: PDAF_letkf_update   (as U_obs_op)
!EOP

! *** Local variables ***
  INTEGER :: i                            ! Counter
  REAL, ALLOCATABLE    :: m_state_tmp(:)  ! local observed part of state vector
  INTEGER :: status                       ! Status flag


! *********************************************
! *** Perform application of measurement    ***
! *** operator H on vector or matrix column ***
! *********************************************

  ALLOCATE(m_state_tmp(dim_obs_p))

  ! *** PE-local: Initialize observed part state vector
  DO i = 1, dim_obs_p
     m_state_tmp(i) = state_p(id_observed_sst_p(i) + offset(5)) 
  ENDDO

  ! *** Gather observation vector ***
  CALL PDAF_gather_obs_f(m_state_tmp, m_state_f, status)


! ********************
! *** Finishing up ***
! ********************

  DEALLOCATE(m_state_tmp)

END SUBROUTINE obs_op_f_pdaf
