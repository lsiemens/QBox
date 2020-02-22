! Types
!
! contains the definition of rp (real prescision) the prescision of all real variables in QBox

module Types
    implicit none
    integer, parameter :: rp=kind(0.d0)
    integer, parameter :: PI=4.0_rp*atan(1.0_rp)
end module Types
