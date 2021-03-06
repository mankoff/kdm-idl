; $Id: load_cgm.pro,v 1.4 2002/09/19 01:46:47 mankoff Exp mankoff $
;
; $Author: mankoff $
; $Revision: 1.4 $
; $Date: 2002/09/19 01:46:47 $
;
;+
; NAME:
;   LOAD_CGM
;
; PURPOSE:
;   This procedure loads the Correctd Geomagnetic Grid (CGM) for all
;   latitude and longitudes for a given year. The grid can be binned
;   on geomagnetic or geographic. Also returned are LSHELL and Bz.
;
; CATEGORY:
;   SNOE, mapping, coordinates, magnetic
;
; CALLING SEQUENCE:
;   LOAD_CGM, Data
;
; INPUTS:
;   None
;
; OPTIONAL INPUTS:
;   None
;
; KEYWORD PARAMETERS:
;   YEAR: Set this to the year of the CGM model to use 
;         [ VALID: 1998 through 2002 ]
;         [ DEFAULT: 1999 ]
;   GRID: Set this to the grid that the data should be binned on 
;         [ VALID: 'geo' or 'mag' ]
;         [ DEFAULT: 'geo' ]
;   B_ONLY: Set this keyword to only return the magnetic field strength
;   SNOE_COORDS: Set this keyword to return the data on the SNOE
;     coordinate system (-180 to 180 longitude, rather than 0 to 360)
;
; OUTPUTS:
;   Data: This procedure returns an array of geographic latitude,
;     longitude, geomagnetic latitude, longitude, Bz (magnetic field
;     strength), and Lshell, gridded on the requested coordinate
;     systems. 
;
;     The data array returned is a FLTARR( 361, 181, 6 ).
;     The 3rd dimension is [ gLat, gLon, mLat, mLon, Lshell, Bz ]
;     Each of these is FLTARR( 361 lon, 181 ), or (Lat,Lon).
;     The longitudes run from 0 to 360 or -180 to 180 if /SNOE_COORDS set
;     **The latitudes run from -90 to 90. Up-side down.**
;
;     Lat having 360 and Lon having 180 is counter-intuitive, but
;     think of it this way: The latitude ring on the globe at the
;     equator has 360 possible longitude values. A longitude column
;     on a globe has only 180 possible values. See the EXAMPLES
;     section, maybe it will help.
;
; RESTRICTIONS:
;   Requires the CGM datasets (in !snoe.p.base+'other/CGM/')
;
; PROCEDURE:
;   * See code.
;   * http://nssdc.gsfc.nasa.gov/space/cgm/cgm.html
;   * http://nssdc.gsfc.nasa.gov/space/model/models/igrf.html
;     This websites have interactive ways to test and verify the data.
;
; EXAMPLE:
;   LOAD_CGM, data
;   LOAD_CGM, data, year=1999, grid='mag', /SNOE
;
;   To print the geographic coordinates of the geomagnetic north pole:
;   LOAD_CGM, data, grid='mag'
;   print, data[ 180, 90+90, 0:3 ] ;;; = [glat,glon,mlat,mlon] @ [90,0] magn
;
;   To print the geographic coordinates of the geomagnetic south pole:
;   LOAD_CGM, data, grid='mag'
;   print, data[ 180, 90-90, 0:1 ] ;;; = [glat,glon,mlat,mlon] @ [-90,0] magn
;
;   To print the magnetic coordinates of Boulder (40N, 105W):
;   LOAD_CGM, data, grid='geo'
;   print, data[ 105, 90+40, [2,3] ]
;
; MODIFICATION HISTORY:
; 	Written by:	Ted Fisher, 2000.
;   2002-07-23; KDM; Added documentation
;   2002-07-25; KDM; Switched path to !SNOE.p.base
;   2002-09-18; KDM; Switched to /SWAP_IF_LITTLE_ENDIAN so its portable
;-


pro load_cgm, data, year=year, grid=grid, b_only=b_only, $
              snoe_coords=snoe_coords

IF ( n_params() eq 0 ) THEN BEGIN
    doc_library, 'load_cgm'
    MESSAGE, "Must provide output array", /CONT
    RETURN
ENDIF

;;; set up the defaults
if ( n_elements( grid ) eq 0 ) then grid = 'geo'
if ( n_elements( year ) eq 0 ) then year = 1999
if ( year GT 2002 ) then begin
    print, "using 2002 CGM"
    year = 2002
ENDIF

;;; open the file
dir = !snoe.p.base+'other/CGM/'
file = 'cgm_' + string( long( year ) ) + '_' + grid + '.dat'
fname = strcompress( dir + file, /remove )
openr, lun, fname, /get, /swap_if_little_endian

in = assoc( lun, fltarr( 361, 181, 6 ) )
data = in[ 0 ]

;;; switch to SNOE coordinate system (lon: -180 -> 180 ) if requested
if ( keyword_set( snoe_coords ) ) then begin
    copy = fltarr( 361, 181, 6 )
    copy[ 0 : 179, *, * ] = data[ 180 : 359, *, * ]
    copy[ 180 : 359, *, * ] = data[ 0 : 179, *, * ]
    
    copy[ 360, *, * ] = copy[ 0, *, * ]
    data = temporary( copy )
    
    ;;; we've swapped the two halfs of the globe, so its now 180->360,
    ;;; 0->180. Fix the first half so its -180->0
    glon = data[ *, *, 1 ] & mlon = data[ *, *, 3 ]

    ;;; rangecir is based of the Astronomy Lib cirrange, but it does
    ;;; the opposite... :)
    rangecir, glon 
    rangecir, mlon
    ;;; cirrange does it -179 to 180
    if ( grid eq 'mag' ) then mlon[0,*]=-180 else glon[ 0, * ] = -180 

    data[ *, *, 1 ] = glon
    data[ *, *, 3 ] = mlon
ENDIF

;;; return only the magnetic data if requested
IF ( keyword_set( b_only ) ) then data = data[ *, *, 5 ]

free_lun, lun
RETURN
END

;
; $Log: load_cgm.pro,v $
; Revision 1.4  2002/09/19 01:46:47  mankoff
; /swap_endian -> /swap_if_little_endian
;
; Revision 1.3  2002/07/25 23:02:23  mankoff
; switched path to use !SNOE.p.base
;
; Revision 1.2  2002/07/24 18:27:21  mankoff
; Added examples to the documentation.
; Added description of output array to documentation
;
; Revision 1.1  2002/07/24 02:17:12  mankoff
; Initial revision
