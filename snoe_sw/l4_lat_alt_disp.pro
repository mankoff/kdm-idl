; $Id: l4_lat_alt_disp.pro,v 1.6 2002/09/01 22:30:10 mankoff Exp $
;
; $Author: mankoff $
; $Revision: 1.6 $
; $Date: 2002/09/01 22:30:10 $
;

PRO L4_lat_alt_disp, data_in, $
                     lv=lv, sv=sv, $
                     log=log, mask=mask, $
                     subtitle=subtitle, $
                     ps=ps, $
                     charsize=charsize, charthick=charthick, $
                    _EXTRA=e


;+
; NAME:
;	L4_LAT_ALT_DISP
;
; PURPOSE:
;   This routine displays one day of L4-formatted data at a time. This
;   means you create an array however you want that is analagous to
;   the L4 data, and then pass it to this procedure for display
;
; CATEGORY:
;   SNOE, image
;
; CALLING SEQUENCE:
;   L4_LAT_ALT_DISP, Data
;
; INPUTS:
;   DATA: An array, FLTARR( 37, 28 )
;         This is the size of the DATA section of L4 (not bookkeepping)
;
; OPTIONAL INPUTS:
;   none
;	
; KEYWORD PARAMETERS:
;   LV: The large value of the data [ !SNOE.f.l4_lv ]
;   SV: The small value of the data [ lv / 20. ] used with /LOG only
;   PS: Set this keyword to produce a POSTSCRIPT image
;   LOG: Set this if the log of the data should be imaged
;   MASK: Set this to mask out part of the data (PMCs)
;   SUBTITLE: A subtitle (in the image) to display
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
;   Must be in a L4-type array (data, not bookkeeping)
;
; EXAMPLE:
;   To generate an image:
;   L4_lat_alt_disp, data
;   L4_lat_alt_disp, data, /LOG, /PS, /INTERP, FILENAME='foo.ps'
;
;   DATA:
;   openr, lun, 'NO_2_day_geo.dat', /GET
;   data = assoc( lun, !SNOE.f.l4 )
;   data = data[ 9 ]             ; day 1998079
;   data = data[ 0:36, 0:27 ]    ; trim off bookkeepping
;
; MODIFICATION HISTORY:
; 	Written by: KDM; 2002-08-10
;       2002-08-29; KDM; Fixed Altitude scale error. Made tickv
;                        exact. Fixed title (cm^3, not cm-3). 
;                        Added PS. Now uses FILE_UNIQ()

;       
;-


data = data_in
IF ( NOT KEYWORD_SET( lv ) ) THEN lv = !SNOE.f.l4_lv
IF ( NOT KEYWORD_SET( sv ) ) THEN sv = lv / 20.

alt_hi = !SNOE.f.l4_alt[ 0 ]
alt_lo = !SNOE.f.l4_alt[ 27 ]

;;; IMAGE and CBAR positions
ipos=[ 0.18, 0.20, 0.90, 0.85 ]
cpos=[ 0.18+0.10, 0.77, 0.90-0.10, 0.79 ]

;;; CBAR labels
IF ( KEYWORD_SET( log ) ) THEN BEGIN
    xtickv = [3e7,6e7,1e8,3e8,6e8]
    xtickn = [' 3',' 6','10','30','60']
ENDIF ELSE BEGIN ;;; LINEAR
    xtickv = MAKEX( CEIL(  sv/1.0e8 ) * 1e8, $
                    (FLOOR( lv/1.0e8 )>1) * 1e8, $
                    1e8 )
    xtickn = STRTRIM( FIX(xtickv / 1e7), 2 )
ENDELSE

data[ *, [0,1,2,3] ] = 0 ;;; zero out top 4 columns
data[ *, [25,26,27] ] = 0 ;;; zero out bot 3 columns
IF ( KEYWORD_SET( mask ) ) THEN BEGIN
    ;    data[ [0,1,35,36], * ] = 0
    ;    data[ [1,35], 26 ] = 0
    ;    data[ [1,2,34,35], 27 ] = 0
    MESSAGE, "MASK not yet implemented", /CONT
ENDIF

IF ( KEYWORD_SET( log ) ) THEN BEGIN
    data = (ALOG10( (data/ (sv) )>1) )
    data = (255./ALOG10( lv/sv )) * data
    logtitle = 'Log ' 
ENDIF ELSE BEGIN
    data = ( data * 254 / lv) > 0 ;;; LINEAR
    logtitle = ''
ENDELSE

charsize = 1.5
charthick = 2
IF ( KEYWORD_SET( ps ) ) THEN BEGIN
    PRINT, "GENERATING PS FILE"
    disp = !d.name
    SET_PLOT, 'ps'
    DEVICE, /COLOR, BITS=8, FILENAME=file_uniq()+'.ps', _EXTRA=e
    charthick = 4
    charsize = 1.5
ENDIF

;;; CREATE IMAGE
imdisp, data, $ ;ERASE=1, $
  /ORDER, /NOSCALE, $
  /AXIS, $
  xrange=[-92.5,92.5], xticks=6, xstyle=1, xminor=3, xticklen=-0.02, $
  xtickv=makex(-90,90,30),xtickn=STRTRIM(FIX(MAKEX(-90,90,30)),2), $
  yrange=[alt_lo-(5/3.),alt_hi+(5/3.)], $
  yticks=4, ystyle=1, yminor=2, yticklen=-0.02, $
  ytickv=makex(alt_lo,alt_hi,20), $
  ytickn=STRTRIM(FIX(MAKEX(alt_lo,alt_hi,20)),2), $
  ytitle='Altitude (km)', $
  charsize=charsize, charthick=charthick, $
  thick=charthick, xthick=charthick, ythick=charthick, $
  POSITION=ipos, /USE, $
  title = logtitle+'Nitric Oxide Density!c(x10!u7!n molecules / cm!u3!n)', $
  xtitle = 'Latitude', $
  _EXTRA=e
    
;;; CBAR
CBAR, /HORIZONTAL, /TOP, XLOG=KEYWORD_SET( log ), $
  /XST, XRANGE=[ sv,lv ], $
  xtickv=xtickv, xtickn=xtickn, xticks=n_elements(xtickv)-1, $
  POSITION=cpos, color=!SNOE.ct.fg, $
  CHARSIZE=charsize, charth=charthick

;;; XYOUTS title
IF ( N_ELEMENTS( subtitle ) NE 0 ) THEN $
  XYOUTS, 0, 153.5, subtitle, /data, $
  alignment=.5, charsize=charsize, charth=charthick, $
  COLOR=!SNOE.ct.fg

IF ( KEYWORD_SET( ps ) ) THEN BEGIN
    DEVICE, /CLOSE
    SET_PLOT, disp
ENDIF

END

;
; $Log: l4_lat_alt_disp.pro,v $
; Revision 1.6  2002/09/01 22:30:10  mankoff
; doc update
;
; Revision 1.5  2002/08/29 23:21:04  mankoff
; uses file_uniq() for PS output
;
; Revision 1.4  2002/08/29 20:35:53  mankoff
; Added PS. Modified so it is now the display program for
; L4_lat_alt_day, but can also be used to display any L4 type data.
;
; Revision 1.3  2002/08/29 18:20:35  mankoff
; foo>1*1e8 is now correctly (foo>1)*1e8
;
; Revision 1.2  2002/08/29 18:00:02  mankoff
; fixed title (cm-3 is now cm^3)
;
; Revision 1.1  2002/08/29 17:55:24  mankoff
; Initial revision
;

