; $Id: snoe_date.pro,v 1.16 2004/01/07 15:47:46 mankoff Exp $
;
; $Author: mankoff $
; $Revision: 1.16 $
; $Date: 2004/01/07 15:47:46 $
;
;+
; NAME:
;	SNOE_DATE
;
; PURPOSE:
;   This function translates dates for the SNOE S/C and mission,
;   between various different formats. 
;
; CATEGORY:
;   SNOE, date, time
;
; CALLING SEQUENCE:
;	result = SNOE_DATE( date, /from_xxx, /to_xxx ) 
;
; INPUTS:
;	Date: a date, in one of the formats listed below.
;
; KEYWORD PARAMETERS:
;       FROM_YMD: A keyword specifing that the input is a 3 element
;       vector, where the first element is a four digit year between
;       1998 and 2003. The second element is a month number, and the 
;       third element is the day-of-month. The year can be either 2 or
;       4 digits
;
;       FROM_YYDDD: A keyword specifying that the input is a number
;       of the form YYDDD. 20 represents 00020, or day 20 of year 2000.
;       98070 is the first day of the mission.
;
;       FROM_YYYYDDD: A keyword specifying that the input is a number
;       of the form YYYYDDD. This is a four digit year, followed by a
;       3 digit day-of-year.
;
;       FROM_MISSION: A keyword specifying that the input is in day of
;       mission format, where zero (0) is the first day of the
;       mission.
;
;       FROM_DOM: Same as FROM_MISSION
;
;       FROM_DOY: A keyword specifying that the input is in
;       Day-Of-Year format. 1 is the first day of the year.
;
;       FROM_TODAY: This keword makes the output the current UTC date
;       converted to the format specified by the /TO_xxx keyword. An
;       input argument is OPTIONAL, and will be ignored if this
;       keyword is set.
;
;       TO_DOY: A keyword specifying that the output should be the day
;       of year of the input date. Note that there is no distinction
;       nor way to tell what year this day-of-year belongs to. You
;       must deduce this based upon the input.
;
;       TO_YMD: A keyword specifying that the output should be a 3 element
;       vector of the form [y,m,d].
;
;       TO_YYDDD: Output is in yyddd format
;
;       TO_YYYYDDD: Output is in yyyyddd format
;
;       TO_MISSION: Output is in day of mission format
;
;       TO_DOM: Same as TO_MISSION
;
; OUTPUTS:
;	    This function returns a number representing the date specified
;	    by the /TO_xxx keyword.
;
; SIDE EFFECTS:
;	    Hopefully none.
;
; RESTRICTIONS:
;       Only works through the following dates:
;       START: 1998070(yyyyddd), 98070(yyddd), 0(mission), [1998,03,11](ymd)
;       STOP: 2003365(yyyyddd), 3365(yyddd), 2121(mission),
;       [2003,12,31](ymd)
;
;       Should (?) work if input is [yyyy,1,doy], and keyword from_ymd set.
;
;       NOTE: other undocumented features/bugs may exist. For example,
;       ymd input [1999,01,32], and keyword to_ymd set correctly gives the
;       output as [1999,02,01]. Or, input 0 and output /TO_DOY gives 365.
;
; PROCEDURE:
;	    The code works by translating ALL input formats (ymd, yyyyddd,
;	    doy, etc.) to Day of Mission (or Mission Index, mi). Then, mi
;	    is converted to the output requested by the /FROM_xxx keyword.
;
; EXAMPLE:
;       print, snoe_date( [2003,12,31], /from_ymd, /to_mission )
;        2121.00
;       print, snoe_date( [98,3,11], /from_ymd, /to_yyyyddd )
;        1998070
;       print, snoe_date( 0, /from_mission, /to_yyyyddd )
;        1998070
;       print, snoe_date( 0, /from_mi, /to_yyd )  ; UNIQUE keywords!
;        98070
;
; MODIFICATION HISTORY:
; 	Written by:	Ken Mankoff, 2001.08.28 (2001240,1266,01240,etc.) 
;   09/06/01  TAF;  Added the double keyword so that fractional days
;                   can be handled. Only works for from_yyddd and
;                   from_yyyyddd for now.
;   09/09/01  KDM;  Added Julian day functionality
;   09/13/01  KDM;  Added to_doy keyword, added print warning for
;                   Julian keyword.  
;   09/20/01  KDM;  modified to allow [y,m,d] input to have 2 digit year
;   04/23/02  KDM;  Commented out JULIAN functionality. Removed double
;                   keyword (see 09/06/01 revision). Fixed 2 digit
;                   [y,m,d] error, added comments to code. Added
;                   /FROM_TODAY keyword, added /FROM_DOY keyword.
;   06/24/02  KDM;  Added DOM (analogous to MISSION)
;
;-

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;
;;; Translate mission index (= dom) to yyyyddd via a rather simple
;;; algorithm. Read it to figure it out. NOTE that many other
;;; functions use this algorithm, and then trim off the output to
;;; achieve doy or yyddd, etc.
;;;
FUNCTION mi2yyyyddd, mi
COMPILE_OPT hidden
y = [ 295, 365, 366, 365, 365, 365, 366 ]
y = total( y, /cumulative )
index = min( where( mi LE y ) )
x = [1998070, 1999000, 2000000, 2001000, 2002000, 2003000, 2004000 ]

yyyyddd = x[ index ] + mi
IF ( index NE 0 ) THEN yyyyddd = yyyyddd - y[index-1]
return, long( yyyyddd )
END

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;
;;; Convert mi to yyddd, by converting it to yyyyddd, and then
;;; treating it as a string and trimming the 1st 2 characters.
;;;
FUNCTION mi2yyddd, mi
COMPILE_OPT HIDDEN
yyyyddd = mi2yyyyddd( mi )
yyddd = LONG( STRMID( STRTRIM( yyyyddd, 2 ), 2 ) )
return, yyddd
END


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;
;;; Convert mi to doy, by converting it to yyyyddd, and then treating
;;; it as a string, and trimming the 1st 4 characters (the year).
;;;
FUNCTION mi2doy, mi
COMPILE_OPT hidden
yyyyddd = mi2yyyyddd( mi )
doy = LONG( STRMID( STRTRIM( yyyyddd, 2 ), 4 ) )
return, doy
END


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;
;;; Convert mi to Year, Month, Day-of-Month. This algorithm is very
;;; simple, except that 1998 is a "year" with only 295 days, and a
;;; strange set of months...
;;;
FUNCTION mi2ymd, input
COMPILE_OPT hidden
mi = input

;;; get the year of the mi
year_len = [ 295,  365,  366,  365,  365,  365, 366 ]
year_yyy = [ 1998, 1999, 2000, 2001, 2002, 2003, 2004 ]
days = total( year_len, /cumulative )

index = max( where( mi GT days ) ) + 1
y = year_yyy[ index ]
IF ( y NE 1998 ) THEN BEGIN
    mi = mi - days[ index-1 ]
    ;;; get the month of the year of the mi
    month_len = [31,28,31,30,31,30,31,31,30,31,30,31]
    IF ( ( y EQ 2000 OR y EQ 2004 ) ) THEN month_len[ 1 ] = 29
    days = total( month_len, /cumulative )
    index = max( where( mi GT days ) ) + 1
    m = index + 1
    IF ( m NE 1 ) THEN d = mi - days[ index-1 ] ELSE d = mi
ENDIF ELSE IF ( y EQ 1998 ) THEN BEGIN
    month_len = [20,30,31,30,31,31,30,31,30,31]
    days = total( month_len, /cumulative )
    index = max( where( mi GT days ) ) + 1
    m = index + 3
    IF ( m EQ 3 ) THEN d = mi + 11 ELSE d = mi - days[ index-1 ]
ENDIF
return, FIX( [ y, m, d ] )
END

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;
;;; This is the main function, that converts any of the inputs to Day
;;; of Mission (also called Mission Index, or "mi"). Unfortunately,
;;; this procedure does use a few GOTOs. Sorry!
;;;
FUNCTION sd2mission, input, $
                     from_ymd=from_ymd, $
                     from_yyddd=from_yyddd, $
                     ;from_julian=from_julian, $
                     from_yyyyddd=from_yyyyddd, $
                     from_doy=from_doy
COMPILE_OPT hidden
IF ( keyword_set( from_ymd ) ) THEN BEGIN

    year = input[ 0 ]
    ;;; if the year from the [y,m,d] triplet was specified by a 2
    ;;; digit number, handle that case. Note that '02' is really a 1
    ;;; digit number, hence the "LE 2" clause in the IF statement.
    IF ( strlen( STRTRIM( input[ 0 ], 2 ) ) LE 2 ) THEN BEGIN
        IF ( input[ 0 ] EQ '98' ) THEN year = 1998
        IF ( input[ 0 ] EQ '99' ) THEN year = 1999
        IF ( input[ 0 ] EQ '0' ) THEN year = 2000
        IF ( input[ 0 ] EQ '1' ) THEN year = 2001
        IF ( input[ 0 ] EQ '2' ) THEN year = 2002
        IF ( input[ 0 ] EQ '3' ) THEN year = 2003
        IF ( input[ 0 ] EQ '4' ) THEN year = 2004
    ENDIF ; now we can treat it as [yyyy,m,d]
    month = input[ 1 ]
    dom = input[ 2 ]
    
    months = [ 0, 31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31 ]
    IF ( ( YEAR EQ 2000 ) OR ( year EQ 2004 ) ) THEN MONTHS[ 2 ] = 29 ;ly
    
    MI = 0
    CASE YEAR OF
        1998: MI = -70
        1999: MI = 295
        2000: MI = 295 + 365
        2001: MI = 295 + 365   + 366
        2002: MI = 295 + 365*2 + 366
        2003: MI = 295 + 365*3 + 366
        2004: MI = 295 + 365*4 + 366  ;;this line was added by jnc
    ENDCASE
    MI = MI + TOTAL( MONTHS[ 0:MONTH-1 ] )
    MI = MI + DOM
    RETURN, MI
    ;;; DONE translating [y,m,d] to MI

ENDIF ELSE IF ( keyword_set( from_doy ) ) THEN BEGIN

    ;;; for this case, append the *current* YYYY to the doy, and then
    ;;; pass it off to the /FROM_YYYYDDD algorithm.
    in = input
    cmd = 'date -u +%Y'
    spawn, cmd, out, /sh
    year = long( out[ 0 ] )
    in = (year*1000L) + in 
    GOTO, yr4
    ;;; DONE translating doy to YYYYdoy. Now let someone else deal
    ;;; with it.

ENDIF ELSE IF ( keyword_set( from_yyddd ) ) THEN BEGIN
    
    ;;; for this case, turn the yyddd into a yyyyddd, and then pass it
    ;;; off to the /FROM_YYYYDDD algorithm.
    in = input
    year = FIX( in / 1.0e4 )
    IF ( year EQ 9 ) THEN in = 1900000L + in ELSE in = 2000000L + in
    GOTO, yr4
    ;;; DONE translating yyddd to YYYYDDD. Now let someone else deal
    ;;; with it.

ENDIF ELSE IF ( keyword_set( from_yyyyddd ) ) THEN BEGIN
    
    ;;; for this case (rather simple), translate YYYYDDD to MI. Simple
    ;;; get the offset for the years, and then add the day-of-year
    ;;; offset to that number.
    in = input
    yr4:
    yyyy = FIX( in / 1.0e3 )
    doy = FIX( in - yyyy * 1e3 )
 
    mi = 0
    CASE yyyy OF 
        1998: mi = -70
        1999: mi = 295
        2000: mi = 295 + 365
        2001: mi = 295 + 365 + 366
        2002: mi = 295 + 365*2 + 366
        2003: mi = 295 + 365*3 + 366 
        2004: mi = 295 + 365*4 + 366  ;;this line was added by jnc
    ENDCASE
    RETURN, mi + doy
    ;;; DONE translating YYYYDDD (and DOY, YYDDD) to Mission Index.

ENDIF

;;; *** YOU SHOULD NOT BE HERE ***
print, " "
print, "ERROR..."
print, "From_ keyword NOT set correctly"
print, "Date is NOT valid!"
print, " "
return, -1
END



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;
;;;
FUNCTION snoe_date, input_const, $
                    from_doy=from_doy, $
                    from_ymd=from_ymd, $
                    from_yyddd=from_yyddd, $
                    from_mission=from_mission, $
                    from_dom=from_dom, $
                    from_yyyyddd=from_yyyyddd, $
                    from_today=from_today, $
                    to_doy=to_doy, $
                    to_ymd=to_ymd, $
                    to_yyddd=to_yyddd, $
                    to_mission=to_mission, $
                    to_dom=to_dom, $
                    to_yyyyddd=to_yyyyddd, $
                    _EXTRA=e

;;; if /from_today, then get today in DOY, and treat it as if the
;;; request was /from_doy. A date input is optional if the /from_today
;;; keyword is set.
IF ( keyword_set( from_today ) ) THEN BEGIN
    spawn, 'date -u +%j', d, /sh
    input = d[0]
    from_today = 0 & from_doy = 1
ENDIF ELSE input = input_const

;;; always translate date to mission index (days since 1998070)
IF ( keyword_set( from_mission ) OR keyword_set( from_dom ) ) THEN $
  mi = input[0] ELSE $
  mi = sd2mission( input, $
                   from_ymd=from_ymd, $
                   from_yyddd=from_yyddd, $
                   from_yyyyddd=from_yyyyddd, $
                   from_doy=from_doy, $
                   _EXTRA=e )

;;; translate from mission index to whatever output was requested.
IF ( keyword_set( to_mission ) OR keyword_set( to_dom ) ) then out = mi $
ELSE IF ( keyword_set( to_doy ) ) THEN out = mi2doy( mi ) $
ELSE IF ( keyword_set( to_ymd ) ) THEN out = mi2ymd( mi ) $
ELSE IF ( keyword_set( to_yyddd ) ) THEN out = mi2yyddd( mi ) $
ELSE IF ( keyword_set( to_yyyyddd ) ) THEN out = mi2yyyyddd( mi )

RETURN, out
END

;
; $Log: snoe_date.pro,v $
; Revision 1.16  2004/01/07 15:47:46  mankoff
; added Justin's 2004 compatibility
;
; Revision 1.15  2002/08/01 21:08:44  mankoff
; Added COMPILE_OPT hidden command to functions.
; Removed JULIAN commented-out functions
;
; Revision 1.14  2002/06/24  21:51:15  mankoff
; Added FROM_DOM and TO_DOM (same as FROM_MISSION and TO_MISSION)
;
