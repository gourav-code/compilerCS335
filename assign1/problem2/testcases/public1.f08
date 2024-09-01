program LogicalLiteralExample
  implicit none

  ! Declare logical variables
  logical :: isTrue, isFalse

  ! Assign values using logical literal constants
  isTrue = .true.
  isFalse = .false.

  ! Print the values
  write(*,*) 'isTrue:', isTrue
  write(*,*) 'isFalse:', isFalse

end program LogicalLiteralExample

