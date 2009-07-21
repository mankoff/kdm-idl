; $Id: l4_day_lat_alt.pro,v 1.6 2002/09/13 18:54:13 mankoff Exp $
;
; $Author: mankoff $
; $Revision: 1.6 $
; $Date: 2002/09/13 18:54:13 $
;

PRO L4_day_lat_alt, coords, yyyyddd0, yyyyddd1, $
                    lv=lv, sv=sv, ps=ps, ch=ch, $
                    log=log, altitude=altitude, $
                    verbose=verbose, fixs=fix, $
                    _EXTRA=e

;+
; NAME:
;	L4_DAY_LAT_ALT
;
; PURPOSE:
;   This routine displays a keogram (x=time, y=lat) of L4 data.
;
; CATEGORY:
;   SNOE, image
;
; CALLING SEQUENCE:
;   L4_DAY_LAT_ALT_DAY, Coord, YYYYDDD0, YYYYDDD1
;
; INPUTS:
;   COORD: The coordinate system of the data, either 'geo' or 'mag'
;   YYYYDDD0: The start date
;   YYYYDDD1: The stop  date
;
; KEYWORD PARAMETERS:
;   LV: The large value of the data [ !SNOE.f.l4_lv ]
;   SV: The small value of the data [ lv / 20. ] used with /LOG only
;   PS: Set this keyword to produce a POSTSCRIPT image
;   CH: Set this to the desired channel to view [ 2 ]
;   LOG: Set this if the log of the data should be imaged
;   ALTITUDE: The altitude plane (in km) to use for the image
;   FIX: Set this to linear interpolate over gaps of size 2 or
;             less in the X direction
;
;   EXTRA=e is used for:
;       IMDISP: (INTERP, OUT_POS, etc. )
;       DEVICE: (FILENAME, BITS_PER_PIXEL, PORTRAIT, LANDSCAPE, etc. )
;       others...
;
; OUTPUTS:
;   An image, or a PS file
;
; SIDE EFFECTS:
;   Uses the PS device if /PS set. Uses the current WINDOW
;
; RESTRICTIONS:
;   Must be in a L4-type directory (needs NO_?_day_???.dat)
;
; EXAMPLE:
;   To generate an image:
;   L4_day_lat_alt_day, 'geo', 1998079, 1999079
;   L4_day_lat_alt_day, 'mag', 1998070, 2002150, /LOG, /PS, /INTERP, $
;
; MODIFICATION HISTORY:
;   Written by: KDM; 2002-07-26
;   KDM; 2002-08-27; yrange now represents latitude exactly [92.5]
;   KDM; 2002-09-01; /swap_if_big_endian    
;   KDM; 2002-09-02; Added FIX keyword, and fixed xaxis tick values
;   KDM; 2002-09-10; Added _EXTRA=e to OPENR for any-endian usability
;   KDM; 2002-09-13; Fix: cbar text was wrong color in PS
;
;-

IF ( N_PARAMS() LT 3 ) THEN BEGIN
    MESSAGE, "Usage: L4_DAY_LAT_ALT, COORDS, YYYYDDD0, YYYYDDD1", /CONT
    MESSAGE, "Use DOC_LIBRARY for help"
    RETURN
END

IF ( NOT KEYWORD_SET( ch ) ) THEN ch = 2
file = STRCOMPRESS('NO_' + STRING(ch) + '_day_' + coords + '.dat', /REMOVE_ALL)
IF ( coords EQ 'geo' ) THEN ytitle = 'Geographic ' ELSE ytitle = 'Geomagnetic '
ytitle = ytitle + 'Latitude'

IF ( NOT KEYWORD_SET( lv ) ) THEN lv = !SNOE.f.l4_lv
IF ( NOT KEYWORD_SET( sv ) ) THEN sv = lv / 20.
dom0 = SNOE_DATE( yyyyddd0, /from_yyyyddd, /to_dom )
dom1 = SNOE_DATE( yyyyddd1, /from_yyyyddd, /to_dom )

IF ( NOT KEYWORD_SET( altitude ) ) THEN altitude = 106
alt_ind = max( where( !SNOE.f.l3_alt GT altitude ) )
IF ( KEYWORD_SET( verbose ) ) THEN $
  print, 'Altitude/Index: ' + $
  STRTRIM( !SNOE.f.l3_alt[alt_ind], 2 ) + '   ' + $
  STRTRIM( alt_ind, 2 )

OPENR, lun, file, /SWAP_IF_BIG_ENDIAN, /GET_LUN, _EXTRA=e
datafile = ASSOC( lun, FLTARR( 38, 29, (fstat(lun)).size/(38*29*4.)) )

IF ( KEYWORD_SET( ps ) ) THEN BEGIN
    disp = !d.name
    SET_PLOT, 'ps'
    DEVICE, /COLOR, BITS=8, /LANDSCAPE, _EXTRA=e
    ss = 4
ENDIF ELSE ss = 1
charsize = 1.1
charthick = ss & pth = ss & xth = ss & yth = ss

data = transpose( reform( datafile[ 0:36, alt_ind, dom0:dom1, 0 ] ) )
IF ( KEYWORD_SET( mask ) ) THEN BEGIN
   MESSAGE, "MASK not yet implemented", /CONT
ENDIF
if ( keyword_set( fix ) ) then data = fix_gaps( data, /x, gap=2 )

IF ( KEYWORD_SET( log ) ) THEN BEGIN
    data = (ALOG10( (data/ (sv) )>1) )
    data = (255./ALOG10( lv/sv )) * data
ENDIF ELSE data = ( data * 254 / lv) > 0 ;;; LINEAR

;;;
;;; XRANGE code BEGIN
;;;
dates = [ [79,172,266,355]+1998000, $
          [79,172,266,355]+1999000, $
          [79,172,266,355]+2000000, $
          [79,172,266,355]+2001000, $
          [79,172,266,355]+2002000 ]
xtickn = ['079!c(1998)','172','266','355',$
          '079!c(1999)','172','266','355',$
          '079!c(2000)','172','266','355',$
          '079!c(2001)','172','266','355',$
          '079!c(2002)','172','266','355']
xtickv = [ 79,172,266,355, $
           [79,172,266,355]+365, $
           [79,172,266,355]+365*2, $
           [79,172,266,355]+365*2+366, $
           [79,172,266,355]+365*3+366 ] - 70

range = where( yyyyddd0 LE dates AND yyyyddd1 GE dates ) > 0

xtickn = xtickn[ range ]
xticks = n_elements( range )-1
xtitle = '!cDay of Year'

md = dates
FOR i = 0, 15 DO md[i] = snoe_date( dates[i], /from_yyyyddd, /to_mission )
start_md = snoe_date( yyyyddd0, /from_yyyyddd, /to_mission )
xtickv = xtickv - start_md
;;; chop off neg numbers
gt0 = min( where( xtickv GE 0, count ) )
if ( count gt 0 ) then xtickv=xtickv[gt0:*]
if ( n_elements( xtickn ) eq 1 ) then begin
   xtickn = ''
   xtitle = '!cDay Since ' + STRTRIM(yyyyddd0,2)
endif
;;;
;;; XRANGE code END
;;;

foo = 42 ; breakpoint

;;; IMAGE and CBAR positions
ipos=[ 0.13, 0.18, 0.85, 0.85 ]
cpos=[ ipos[2]+0.05, ipos[1], ipos[2]+0.07, ipos[3] ]

ititle = 'SNOE Nitric Oxide Density (Alt '+STRTRIM(FIX(ROUND(altitude)),2)+')'
ctitle = 'x10!u7!n molecules / cm!u3!n'

imdisp, data, /ERASE, $
  /NOSCALE, /AXIS, $
  xrange=xrange, xtickn=xtickn, xtickv=xtickv, xticks=xticks, $
  xtitle=xtitle, xstyle=1, xticklen=-0.02, $
  yrange=[-92.5,92.5], yticks=6, yminor=3, ystyle=1, yticklen=-0.02, $
  ytickv=makex(-90,90,30), ytickn=STRTRIM(FIX(makex(-90,90,30)),2), $
  ytitle=ytitle, title=ititle, $
  ythick=yth, xthick=xth, thick=pth, charsize=charsize, charthick=charthick, $
  position=ipos, /USE, $
  _EXTRA=e

;;; CBAR
IF ( KEYWORD_SET( log ) ) THEN BEGIN
    tickv = [3e7,6e7,1e8,3e8,6e8] / 1e7 & tickn = [' 3',' 6','10','30','60']
ENDIF ELSE BEGIN ;;; LINEAR
    tickv = MAKEX( CEIL(  sv/1.0e8 ) * 1e8, FLOOR( lv/1.0e8 )>1 * 1e8, 1e8 )
    tickn = STRTRIM( FIX(tickv / 1e7), 2 )
ENDELSE

CBAR, /VERTICAL, /RIGHT, YLOG=KEYWORD_SET( log ), $
  /YST, YRANGE=[ sv,lv ]/1.0e7, $
  ytickv=tickv, ytickn=tickn, yticks=n_elements(tickv)-1, $
  POSITION=cpos, $
  CHARSIZE=charsize, $
  charth=charthick, $
  ytitle=ctitle

IF ( KEYWORD_SET( ps ) ) THEN BEGIN
    DEVICE, /CLOSE
    SET_PLOT, disp
ENDIF

FREE_LUN, lun
END

;
; $Log: l4_day_lat_alt.pro,v $
; Revision 1.6  2002/09/13 18:54:13  mankoff
; Fixed CBAR color in PS mode
;
; Revision 1.5  2002/09/11 03:04:00  mankoff
; added _EXTRA=e to OPENR so it can be used with BIG_ENDIAN files
;
; Revision 1.4  2002/09/03 01:24:38  mankoff
; Added /FIX keyword for FIX_GAPS(), and fixed x-axis tick values (xtickv)
;
; Revision 1.3  2002/09/01 22:27:02  mankoff
; /swap_if_big_endian because L4 files have been re-written
;
; Revision 1.2  2002/08/27 21:24:34  mankoff
; yrange now goes from -92.5 to 92.5, so that latitude is exact w.r.t ticks
;
; Revision 1.1  2002/08/01 23:33:33  mankoff
; Initial revision
;
;
