! ----------------------------------------------------------------
! file: met_time_series.f90
! ----------------------------------------------------------------
! ----------------------------------------------------------------
! Battelle Memorial Institute
! Pacific Northwest Laboratory
! ----------------------------------------------------------------
! ----------------------------------------------------------------
! Created March  1, 2013 by William A. Perkins
! Last Change: Thu Jun  3 06:45:08 2010 by William A. Perkins <d3g096@PE10900.pnl.gov>
! ----------------------------------------------------------------

! ----------------------------------------------------------------
! MODULE met_time_series
! ----------------------------------------------------------------
MODULE met_time_series

  USE time_series

  IMPLICIT NONE

  CHARACTER (LEN=80), PRIVATE, SAVE :: rcsid = "$Id$"

  ! The number of met data values
  INTEGER, PARAMETER, PUBLIC :: met_fields = 5

  TYPE met_time_series_rec
     TYPE (time_series_rec), POINTER :: ts
     DOUBLE PRECISION, POINTER :: current(:)
  END type met_time_series_rec

  ! A more readable way to refer to the fields 
  INTEGER, PARAMETER, PUBLIC :: &
       &MET_AIRT = 1, &
       &MET_DEWT = 2, &
       &MET_WIND = 3, &
       &MET_BARO = 4, &
       &MET_SWRAD = 5

CONTAINS

  ! ----------------------------------------------------------------
  ! TYPE(MET_TIME_SERIES_REC) FUNCTION met_time_series_read
  ! ----------------------------------------------------------------
  TYPE(MET_TIME_SERIES_REC) FUNCTION met_time_series_read(filename) RESULT (metts)

    IMPLICIT NONE

    POINTER metts
    CHARACTER (LEN=*), INTENT(IN) :: filename

    ALLOCATE(metts)
    metts%ts => time_series_read(filename, met_fields, 50)
    metts%current => metts%ts%current

  END FUNCTION met_time_series_read

  ! ----------------------------------------------------------------
  ! SUBROUTINE met_time_series_destroy
  ! ----------------------------------------------------------------
  SUBROUTINE met_time_series_destroy(metts)

    IMPLICIT NONE

    TYPE (met_time_series_rec), POINTER, INTENT(INOUT) :: metts

    IF (.NOT. ASSOCIATED(metts)) RETURN

    CALL time_series_destroy(metts%ts)
    DEALLOCATE(metts)
    NULLIFY(metts)

  END SUBROUTINE met_time_series_destroy


  ! ----------------------------------------------------------------
  ! SUBROUTINE met_time_series_update
  ! ----------------------------------------------------------------
  SUBROUTINE met_time_series_update(metts, datetime)

    IMPLICIT NONE

    TYPE (met_time_series_rec), POINTER, INTENT(INOUT) :: metts
    DOUBLE PRECISION, INTENT(IN) :: datetime

    CALL time_series_interp(metts%ts, datetime)

  END SUBROUTINE met_time_series_update


END MODULE met_time_series
