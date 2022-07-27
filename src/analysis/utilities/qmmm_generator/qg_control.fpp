!--------1---------2---------3---------4---------5---------6---------7---------8
!
!  Module   qg_control_mod
!> @brief   read parameters and data for taking snapshots from MD trajectory 
!! @authors Norio Takase (NT)
! 
!  (c) Copyright 2014 RIKEN. All rights reserved.
!
!--------1---------2---------3---------4---------5---------6---------7---------8

#ifdef HAVE_CONFIG_H
#include "../../../config.h"
#endif

module qg_control_mod

  use qg_option_mod
  use fitting_mod
  use trajectory_mod
  use output_mod
  use input_mod
  use select_mod
  use fileio_control_mod
  use string_mod
  use messages_mod

  implicit none
  private

  ! structures
  type, public :: s_ctrl_data

    ! data for section input
    type(s_inp_info)      :: inp_info

    ! data for section output
    type(s_out_info)      :: out_info

    ! data for section trajectory
    type(s_trj_info)      :: trj_info

    ! data for section selection
    type(s_sel_info)      :: sel_info

    ! data for section fitting
    type(s_fit_info)      :: fit_info

    ! data for section option
    type(s_opt_info)      :: opt_info

  end type s_ctrl_data

  ! subroutines
  public  :: usage
  public  :: control

contains

  !======1=========2=========3=========4=========5=========6=========7=========8
  !
  !  Subroutine    usage
  !> @brief        show usage of qmmm_generator
  !! @authors      NT
  !! @param[in]    arg1 : arguments in execution
  !
  !======1=========2=========3=========4=========5=========6=========7=========8

  subroutine usage(arg1)

    ! formal arguments
    character(*),            intent(out) :: arg1

    ! local variables
    character(MaxLine)       :: arg2
    integer                  :: iargc


    call getarg(1, arg1)

    if (iargc() < 1      .or. &
         arg1 == '-help' .or. &
         arg1 == '-h'    .or. &
         arg1 == '-HELP' .or. &
         arg1 == '-H') then

      call getarg(2, arg2)
      call tolower(arg2)
      
      if (iargc() < 2 .or. arg2 /= 'ctrl') then
        write(MsgOut,'(A)') ' '
        write(MsgOut,'(A)') '# normal usage'
        write(MsgOut,'(A)') '  % ./qmmm_generator INPQMMM'
        write(MsgOut,'(A)') ' '
        write(MsgOut,'(A)') '# usage to see control parameters'
        write(MsgOut,'(A)') '  % ./qmmm_generator -h ctrl'
        write(MsgOut,'(A)') ' '

      else

        write(MsgOut,'(A)') '# control parameters in qmmm_generator'
        write(MsgOut,'(A)') ' '

        !call show_ctrl_input ('psf,ref,prmtop,ambcrd,grotop,grocrd')
        call show_ctrl_input ('psf,ref')
        call show_ctrl_output('qmmm_crd,qmmm_psf,qmmm_pdb')
        call show_ctrl_trajectory(tool_name='qg')
        call show_ctrl_selection(tool_name='qg')
        call show_ctrl_fitting(tool_name='qg')
        call show_ctrl_option

      endif

      stop

    else
      write(MsgOut,'(A)')'****************************************************'
      write(MsgOut,'(A)')'*                                                  *'
      write(MsgOut,'(A)')'*                 QMMM_GENERATOR                   *'
      write(MsgOut,'(A)')'*                                                  *'
      write(MsgOut,'(A)')'*   QMMM-Input Generator using Trajectory File(s)  *'
      write(MsgOut,'(A)')'*                                                  *'
      write(MsgOut,'(A)')'*                Developed by RIKEN                *'
      write(MsgOut,'(A)')'*                                                  *'
      write(MsgOut,'(A)')'****************************************************'
      write(MsgOut,'(A)')' '
    end if
    
    return
  
  end subroutine usage

  !======1=========2=========3=========4=========5=========6=========7=========8
  !
  !  Subroutine    control
  !> @brief        open/read/close control files 
  !! @authors      NT
  !! @param[in]    filename  : file name of control file
  !! @param[inout] ctrl_data : information of control parameters
  !
  !======1=========2=========3=========4=========5=========6=========7=========8
  
  subroutine control(filename, ctrl_data)
  
    ! formal arguments
    character(*),            intent(in)    :: filename
    type(s_ctrl_data),       intent(inout) :: ctrl_data
    
    ! local variables
    integer                  :: handle
    

    ! open control file
    ! 
    call open_ctrlfile(filename, handle)

    if (handle == 0) &
      call error_msg('Control_qmmmgen> File IO Error')


    ! read input section
    !
    call read_ctrl_input(handle, ctrl_data%inp_info)

    ! read output section
    !
    call read_ctrl_output(handle, ctrl_data%out_info)

    ! read trajectory section
    !
    call read_ctrl_trajectory(handle, ctrl_data%trj_info)

    ! read selection section
    !
    call read_ctrl_selection(handle, ctrl_data%sel_info)

    ! read fitting section
    !
    call read_ctrl_fitting(handle, ctrl_data%fit_info)

    ! read option section
    !
    call read_ctrl_option(handle, ctrl_data%opt_info)

    ! close control file
    !
    call close_ctrlfile(handle)

    return

  end subroutine control

end module qg_control_mod
