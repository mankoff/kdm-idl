; $Id: l3_lat_alt_day.pro,v 1.7 2002/09/20 23:41:41 mankoff Exp $
;
; $Author: mankoff $
; $Revision: 1.7 $
; $Date: 2002/09/20 23:41:41 $
;

PRO L3_lat_alt_day, coords, yyyyddd, yyyyddd1, manual=manual, $
                    lv=lv, sv=sv, ps=ps, ch=ch, $
                    log=log, mask=mask, orbit=orbit, $
                    _EXTRA=e

;+
; NAME:
;	L3_LAT_ALT_DAY
;
; PURPOSE:
;   This routine displays one orbit of L3 data at a time. A movie can be
;   generated, or a single day, or a PS file. You can step through the
;   data orbit-by-orbit, or day-by-day but only for a given orbit.
;
; CATEGORY:
;   SNOE, image, movie
;
; CALLING SEQUENCE:
;   L3_LAT_ALT_DAY, Coord, YYYYDDD YYYYDDD1
;
; INPUTS:
;   COORD: The coordinate system of the data, either 'geo' or 'mag'
;   YYYYDDD: The day to display.
;
; OPTIONAL INPUTS:
;   YYYYDDD1: The last day to display in a MOVIE sequence
;	
; KEYWORD PARAMETERS:
;   ORBIT: Set this to the orbit number to view (0 through 15) if you
;       want to see 1 orbit per day. If not set, all orbits are viewed.
;   MANUAL: Set this to control the movie manually
;           ,: prev day (<)
;           q: Quit movie
;           j: Jump to day
;           l: Toggle LOG mode
;           any other key: next day
;   LV: The large value of the data [ !SNOE.f.L3_lv ]
;   SV: The small value of the data [ lv / 20. ] used with /LOG only
;   PS: Set this keyword to produce a POSTSCRIPT image
;   CH: Set this to the desired channel to view [ 2 ]
;   LOG: Set this if the log of the data should be imaged
;   MASK: Set this to mask out part of the data (PMCs)
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
;   Must be in a L3-type directory (needs NO_?_den_???.dat)
;
; EXAMPLE:
;   To generate an image:
;   L3_lat_alt_day, 'geo', 1998079
;   L3_lat_alt_day, 'mag', 2002150, /LOG, /PS, /INTERP, FILENAME='foo.ps'
;
;   To watch a movie:
;   L3_lat_alt_day, 'geo', 1998079, 1999079, /LOG
;   L3_lat_alt_day, 'geo', 1998079, 1999079, /LOG, ORBIT=7
;   
;   To step through:
;   L3_lat_alt_day, 'geo', 1998079, /MANUAL
;   L3_lat_alt_day, 'geo', 1998079, ORBIT=0, /MANUAL
;
; MODIFICATION HISTORY:
;   Written by: KDM; 2002-07-26
;   KDM; 2002-08-21; Fixed orbit movie bug
;   KDM; 2002-08-29; Fixed altitude axis error. Made tickv
;                    exact. Changed title. Fixed linear CBAR 
;   KDM; 2002-09-01; /swap_if_big_endian
;   KDM; 2002-09-09; added _EXTRA=e to OPENR
;   KDM; 2002-09-18; handles L3 files with 16 orbits per day
;-

IF ( N_PARAMS() EQ 0 ) THEN BEGIN
    DOC_LIBRARY, 'L3_lat_alt_day'
    MESSAGE, "Must provide COORDS and YYYYDDD", /CONT
    RETURN
END

IF ( NOT KEYWORD_SET( ch ) ) THEN ch = 2
file = STRCOMPRESS('NO_' + STRING(ch) + '_den_' + coords + '.dat', /REMOVE_ALL)
IF ( coords EQ 'geo' ) THEN xtitle = 'Geographic ' ELSE xtitle = 'Geomagnetic '
xtitle = xtitle + 'Latitude'

IF ( NOT KEYWORD_SET( lv ) ) THEN lv = !SNOE.f.L3_lv
IF ( NOT KEYWORD_SET( sv ) ) THEN sv = lv / 20.
dom = SNOE_DATE( yyyyddd, /from_yyyyddd, /to_dom )
IF ( KEYWORD_SET( manual ) OR KEYWORD_SET( yyyyddd1 ) ) THEN BEGIN
    IF ( KEYWORD_SET( yyyyddd1 ) ) THEN $
      dom1 = SNOE_DATE( yyyyddd1, /from_yyyyddd, /to_dom )
    IF ( KEYWORD_SET( manual ) ) THEN dom1 = !SNOE.d.now_dom
ENDIF ELSE dom1 = dom

OPENR, lun, file, /SWAP_IF_BIG_ENDIAN, /GET_LUN, _EXTRA=e
datafile = ASSOC( lun, !SNOE.f.L3 )
ERASE

IF ( KEYWORD_SET( ps ) ) THEN BEGIN
    disp = !d.name
    SET_PLOT, 'ps'
    DEVICE, /COLOR, BITS=8, _EXTRA=e
    ss = 4
ENDIF ELSE ss = 2
charsize = 1.5
charthick = ss & pth = ss & xth = ss & yth = ss

;;; IMAGE and CBAR positions
ipos=[ 0.18, 0.20, 0.90, 0.85 ]
cpos=[ 0.18+0.10, 0.77, 0.90-0.10, 0.79 ]

alt_lo = !SNOE.f.l3_alt[ 30 ]
alt_hi = !SNOE.f.l3_alt[ 0 ]

;;; CBAR labels
;;;
;;; NOTE: cut-and-paste this section into the "TOGGLE LOG" section
;;; below if any changes are made
;;;
IF ( KEYWORD_SET( log ) ) THEN BEGIN
    xtickv = [3e7,6e7,1e8,3e8,6e8] & xtickn = [' 3',' 6','10','30','60']
    title = 'Log Nitric Oxide Density!c(x10!u7!n molecules / cm!u3!n)'
ENDIF ELSE BEGIN ;;; LINEAR
    xtickv = MAKEX( CEIL(  sv/1.0e8 ) * 1e8, (FLOOR( lv/1.0e8 )>1) * 1e8, 1e8 )
    xtickn = STRTRIM( FIX(xtickv / 1e7), 2 )
    title = 'Nitric Oxide Density!c(x10!u7!n molecules / cm!u3!n)'
ENDELSE

xday = dom ;;; day currently being displayed (increments for movie)
xorb = 0   ;;; orb currently being displayed (increments for movie)
IF ( n_elements( orbit ) NE 0 ) THEN xorb = orbit
WHILE (1) DO BEGIN

    data = datafile[ *,*, xorb, xday ]
    data = data[ 7:43, 0:30 ] ;;; CHECK THIS FOR CORRECTNESS WITH ALT
    data[ *, [0,1,2,3] ] = 0 ;;; zero out top 4 columns
    data[ *, [27,28,29] ] = 0 ;;; zero out bot 3 columns
    IF ( KEYWORD_SET( mask ) ) THEN BEGIN
        ;    data[ [0,1,35,36], * ] = 0
        ;    data[ [1,35], 26 ] = 0
        ;    data[ [1,2,34,35], 27 ] = 0
        MESSAGE, "MASK not yet implemented", /CONT
    ENDIF

    IF ( KEYWORD_SET( log ) ) THEN BEGIN
        data = (ALOG10( (data/ (sv) )>1) )
        data = (255./ALOG10( lv/sv )) * data
    ENDIF ELSE data = ( data * 254 / lv) > 0 ;;; LINEAR

    ;;; CREATE IMAGE
    imdisp, data, ERASE=0, $
      /ORDER, /NOSCALE, $
      /AXIS, $
      xrange=[-92.5,92.5], xticks=6, xstyle=1, xminor=3, xticklen=-0.02, $
      xtickv=MAKEX(-90,90,30),xtickn=STRTRIM(FIX(MAKEX(-90,90,30)),2), $
      yrange=[alt_lo-(5/3.),alt_hi+(5/3.)], $
      yticks=5, ystyle=1, yminor=2, yticklen=-0.02, $
      ytickv=MAKEX( alt_lo, alt_hi, 20 ), $
      ytickn=STRTRIM( FIX( MAKEX( alt_lo, alt_hi, 20 ) ), 2 ), $
      title=title, ytitle='Altitude (km)', xtitle=xtitle, $
      charsize=charsize, charthick=charthick, $
      thick=pth, xthick=xth, ythick=yth, $
      POSITION=ipos, /USE, $
      _EXTRA=e
    
    ;;; CBAR
    CBAR, /HORIZONTAL, /TOP, XLOG=KEYWORD_SET( log ), $
      /XST, XRANGE=[ sv,lv ], $
      xtickv=xtickv, xtickn=xtickn, xticks=n_elements(xtickv)-1, $
      POSITION=cpos, color=!SNOE.ct.fg, $
      CHARSIZE=charsize, $
      charth=charthick
    
    ;;; YYYYDDD title
    XYOUTS, 0, 152.5, $
      STRTRIM( SNOE_DATE( xday,/from_dom,/to_yyyyddd), 2 ) + '.' + $
      STRTRIM( xorb, 2 ), $
      alignment=.5, charsize=charsize, charth=charthick, $
      COLOR=!SNOE.ct.fg

    IF ( KEYWORD_SET( manual ) ) THEN BEGIN
        k = GET_KBRD( 1 )
        IF ( k EQ string(10b) ) THEN k = 'n' ; enter
        CASE k OF
            ',': BEGIN
                IF ( N_ELEMENTS( orbit ) EQ 0 ) THEN BEGIN
                    xorb = xorb -1
                    IF ( xorb EQ -1 ) THEN BEGIN
                        xorb = 15
                        xday = xday - 1
                    ENDIF
                ENDIF ELSE xday = xday -1 ;;; same orbit, previous day
            END
            'q': GOTO, done
            'j': BEGIN
                READ, jump, PROMPT='New YYYYDDD: '
                xday = SNOE_DATE( jump, /from_yyyyddd, /to_dom )
            END
            'l': BEGIN ;;; TOGGLE LOG
                log = NOT KEYWORD_SET( log )+2 ;;; TOGGLE log
                ERASE
                IF ( KEYWORD_SET( log ) ) THEN BEGIN
                    xtickv = [3e7,6e7,1e8,3e8,6e8]
                    xtickn = [' 3',' 6','10','30','60']
                    title = 'Log Nitric Oxide Density!c(x10!u7!n moleclues / cm!u3!n)'
                ENDIF ELSE BEGIN ;;; LINEAR
                    xtickv = MAKEX( CEIL(  sv/1.0e8 ) * 1e8, $
                                    (FLOOR( lv/1.0e8 )>1) * 1e8, $
                                    1e8 )
                    xtickn = STRTRIM( FIX(xtickv / 1e7), 2 )
                    xtickn = STRTRIM( FIX(xtickv / 1e7), 2 )
                    title = 'Nitric Oxide Density!c(x10!u7!n molecules / cm!u3!n)'
                ENDELSE
            END
            ELSE: BEGIN
                IF ( N_ELEMENTS( orbit ) EQ 0 ) THEN BEGIN
                    IF ( xorb EQ 15 ) THEN xday = xday + 1
                    xorb = ( xorb + 1 ) MOD 16
                ENDIF ELSE xday = xday + 1
            END
        ENDCASE
    ENDIF ELSE BEGIN
        IF ( N_ELEMENTS( orbit ) EQ 0 ) THEN BEGIN
            IF ( xorb EQ 15 ) THEN xday = xday + 1
            xorb = ( xorb + 1 ) MOD 16
        ENDIF ELSE xday = xday + 1
    ENDELSE

    ;;; allow generation of postscript movies
    IF ( keyword_set( ps ) ) THEN BEGIN
        erase
        print, snoe_date( xday, /from_dom, /to_yyyyddd )
    ENDIF
    IF ( xday GE dom1 ) THEN GOTO, done
ENDWHILE
done:

IF ( KEYWORD_SET( ps ) ) THEN BEGIN
    DEVICE, /CLOSE
    SET_PLOT, disp
ENDIF

FREE_LUN, lun
END

;
; $Log: l3_lat_alt_day.pro,v $
; Revision 1.7  2002/09/20 23:41:41  mankoff
; L3 DB now has 50 lats (-55 to 55). Changed code to handle this
;
; Revision 1.6  2002/09/19 01:25:13  mankoff
; handles 16 orbits per day
;
; Revision 1.5  2002/09/10 07:08:53  mankoff
;  added _EXTRA=e to OPENR, so it can be used on old LASP data
;  (big_endian) without modification
;
; Revision 1.4  2002/09/01 22:53:53  mankoff
; /swap_if_big_endian
;
; Revision 1.3  2002/08/29 18:18:37  mankoff
; Fixed altitude axis error.
; Made tickv alignments exact
; changed title to 2-line title
; Fixed linear CBAR
;
; Revision 1.2  2002/08/22 03:56:35  mankoff
; Fixed orbit movie bug. Now orbit=0 is handled correctly
;
; Revision 1.1  2002/07/26 20:07:48  mankoff
; Initial revision
;
;
