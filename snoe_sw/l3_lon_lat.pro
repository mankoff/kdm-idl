; $Id: l3_lon_lat.pro,v 1.5 2002/09/24 21:26:25 mankoff Exp $
;
; $Author: mankoff $
; $Revision: 1.5 $
; $Date: 2002/09/24 21:26:25 $
;

PRO L3_LON_LAT, coords, yyyyddd, data, altitude=altitude, $
                verbose=verbose

;+
; NAME:
;	L3_LON_LAT
;
; PURPOSE:
;       This procedure opens the L3 files, and returns one days worth
;       of data in a regularly gridded lon/lat array
;
; CATEGORY: SNOE, Database
;
; CALLING SEQUENCE:
;       L3_LON_LAT, coords, yyyyddd, data, altitude=altitude
;
; INPUTS:
;       coords:  'geo' or 'mag'
;       yyyyddd: the date of the data to return
;
; KEYWORD PARAMETERS:
;       ALTITUDE: Set this to the altitude (in kilometers) to
;       use. Defaults to 106km.
;
; OUTPUTS:
;       data: An array
;
; PROCEDURE:
;	You can describe the foobar superfloatation method being used here.
;	You might not need this section for your routine.
;
; EXAMPLE:
;       L3_LON_LAT, 'geo', 1998079, d, alt=106
;
; MODIFICATION HISTORY:
;   Written by:	CAB; 1999.
;   2002-09-01: KDM; /swap_if_big_endian, partial documentation
;   2002-09-09; KDM; added _EXTRA=e to OPEN
;
;-

IF ( N_PARAMS() NE 3 ) THEN BEGIN
    message, 'Usage: L3_LON_LAT, coords, yyyyddd, data', /cont
    message, "Use DOC_LIBRARY for help", /CONT
    return
ENDIF

IF ( NOT KEYWORD_SET( altitude ) ) THEN altitude = 106
alt_ind = max( where( !SNOE.f.l3_alt GT altitude ) )

IF ( KEYWORD_SET( verbose ) ) THEN $
  print, 'Altitude/Index: ' + $
  STRTRIM( !SNOE.f.l3_alt[alt_ind], 2 ) + '   ' + $
  STRTRIM( alt_ind, 2 )

file = STRCOMPRESS( 'NO_2_den_' + coords + '.dat', /REMOVE_ALL)
OPENR, lun, file , /GET_LUN,/SWAP_IF_BIG_ENDIAN, _EXTRA=e
dd = ASSOC( lun, !SNOE.f.l3 )
dom = SNOE_DATE( yyyyddd, /from_yyyyddd, /to_dom )
on_ioerror, eof_err
ddd = dd[ dom ]
FREE_LUN, lun

;;; day requested past end of file 
IF ( 0 ) THEN BEGIN
    eof_err:
    message, "End Of File", /CONT
    free_lun, lun
    data = fltarr( 16, 37 ) -999
    return
ENDIF

den = REFORM( ddd[ 7:43, alt_ind, * ] )
den_sum = FLTARR( 15, 37 )

FOR latIndex = 2, 34 DO BEGIN
    lonRow = REFORM( ddd[ latIndex, 32, * ] )
    lonIndex = 0
    FOR lon = -180, ( 180 - 24 ), 24 DO BEGIN
        thisLon = WHERE(( lonRow GT lon ) AND ( lonRow LE (lon+24)) $
         AND ( lonRow NE 0.0 ) AND (reform(den[latIndex,*]) GT 1e6 ))
        
        IF ( thisLon[ 0 ] NE -1 ) THEN BEGIN
            thisDen = REFORM( den[ latIndex, thisLon ] )
            den_sum[ lonIndex, latIndex ] = $
              TOTAL( thisDen ) / $
              N_ELEMENTS( thisDen )
        ENDIF
        
        lonIndex = lonIndex + 1
    ENDFOR
ENDFOR        

data = FLTARR( (15+1), 37 )
data[0:14,*] = den_sum[0:14,*]
data[15,*] = den_sum[0,*]
data[*,0:2] = total(data[1:7,2])/7
data[*,34:36] = total(data[9:15,34])/7

IF ( KEYWORD_SET( verbose ) ) THEN BEGIN
    PRINT, "North", max(data(*,24:34))/1e7, !c mod 16, !c/16+24
    PRINT, "South", max(data(*, 2:12))/1e7, !c mod 16, !c/16+2
ENDIF

RETURN
END

;
; $Log: l3_lon_lat.pro,v $
; Revision 1.5  2002/09/24 21:26:25  mankoff
; added check for accessing day past EOF
;
; Revision 1.4  2002/09/20 23:41:23  mankoff
; L3 DB is now has 52 lats (-55 to 55). Changed code to handle this
;
; Revision 1.3  2002/09/10 07:08:02  mankoff
; added _EXTRA=e to open, so it can be use on old LASP (big_endian) data
; withou modification
;
; Revision 1.2  2002/09/01 22:58:52  mankoff
; /swap_if_big_endian. Partial documentation
;
; Revision 1.1  2002/07/26 20:08:19  mankoff
; Initial revision
;
;
