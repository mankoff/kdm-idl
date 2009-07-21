; $Id: l4_lat_alt_day.pro,v 1.12 2002/09/13 18:56:04 mankoff Exp $
;
; $Author: mankoff $
; $Revision: 1.12 $
; $Date: 2002/09/13 18:56:04 $
;

PRO L4_lat_alt_day, coords, yyyyddd, yyyyddd1, manual=manual, $
                    ch=ch, ps=ps, log=log, $
                    _EXTRA=e

;+
; NAME:
;	L4_LAT_ALT_DAY
;
; PURPOSE:
;   This routine displays one day of L4 data at a time. A movie can be
;   generated (manual or passive mode), or a single day, or a PS file.
;
; CATEGORY:
;   SNOE, image, movie
;
; CALLING SEQUENCE:
;   L4_LAT_ALT_DAY, Coord, YYYYDDD [YYYYDDD1]
;
; INPUTS:
;   COORD: The coordinate system of the data, either 'geo' or 'mag'
;   YYYYDDD: The day to display.
;
; OPTIONAL INPUTS:
;   YYYYDDD1: The last day to display in a MOVIE sequence
;	
; KEYWORD PARAMETERS:
;   MANUAL: Set this to control the movie manually
;           ,: prev day (<)
;           q: Quit movie
;           j: Jump to day
;           l: Toggle LOG mode
;           any other key: next day
;   PS: Set this keyword to produce a POSTSCRIPT image
;   CH: Set this to the desired channel to view [ 2 ]
;   LOG: Set this to view the data on a Logarithmic scale
;
;   EXTRA=e is used for:
;       L4_LAT_ALT_DISP (lv, sv, mask, log, subtitle, interp, xtitle, etc.)
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
; PROCEDURE:
;   This routine just opens files and handles the movie part
;   (i.e. moving through the file in a loop or based upon your
;   keystrokes). The display program is called each time through the
;   loop, with all necessary variables and keywords (and _EXTRA=e)
;   passed in.
;
; EXAMPLE:
;   To generate an image:
;   L4_lat_alt_day, 'geo', 1998079
;   L4_lat_alt_day, 'mag', 2002150, /LOG, /PS, /INTERP, FILENAME='foo.ps'
;
;   To watch a movie:
;   L4_lat_alt_day, 'geo', 1998079, 1999079, /LOG
;   
;   To step through:
;   L4_lat_alt_day, 'geo', 1998079, /MANUAL, /INTERP
;
; MODIFICATION HISTORY:
;   Written by: KDM; 2002-07-25
;   2002-07-26: KDM; Added TOGGLE LOG mode
;   2002-08-27; KDM; Improved AXIS accuracies
;   2002-08-29; KDM; cm-3 should be cm^3
;   2002-08-29; KDM; Now uses generic L4_LAT_ALT_DISP subroutine for
;                    graphics. Uses FILE_UNIQ() 
;   2002-09-01; KDM; /swap_if_big_endian
;   2002-09-09; KDM; added _EXTRA=e to OPEN (can now be used with BIG ENDIAN)
;-

IF ( N_PARAMS() LT 2 ) THEN BEGIN
    MESSAGE, "Usage: L4_LAT_ALT_DAY, COORDS, YYYYDDD", /CONT
    MESSAGE, "Use DOC_LIBRARY for help"
    RETURN
END

ERASE
IF ( NOT KEYWORD_SET( ch ) ) THEN ch = 2
file = STRCOMPRESS('NO_' + STRING(ch) + '_day_' + coords + '.dat', /REMOVE_ALL)
IF ( coords EQ 'geo' ) THEN xtitle = 'Geographic ' ELSE xtitle = 'Geomagnetic '
xtitle = xtitle + 'Latitude'

dom = SNOE_DATE( yyyyddd, /from_yyyyddd, /to_dom )
IF ( KEYWORD_SET( manual ) OR KEYWORD_SET( yyyyddd1 ) ) THEN BEGIN
    IF ( KEYWORD_SET( yyyyddd1 ) ) THEN $
      dom1 = SNOE_DATE( yyyyddd1, /from_yyyyddd, /to_dom )
    IF ( KEYWORD_SET( manual ) ) THEN dom1 = !SNOE.d.now_dom
ENDIF ELSE dom1 = dom

OPENR, lun, file, /SWAP_IF_BIG_ENDIAN, /GET_LUN, _EXTRA=e
datafile = ASSOC( lun, !SNOE.f.l4 )

charsize = 1.5
charthick = 2
IF ( KEYWORD_SET( ps ) ) THEN BEGIN
    disp = !d.name
    SET_PLOT, 'ps'
    DEVICE, /COLOR, BITS=8, FILENAME=file_uniq()+'.ps', _EXTRA=e
    charthick = 4
    charsize = 1.5
ENDIF

today = dom ;;; will increment through movie
WHILE (1) DO BEGIN
    
    data = datafile[ today ] & data = data[ 0:36, 0:27 ]

    ;;; THIS IS THE PROGRAM THAT DOES ALL THE DISPLAY WORK
    L4_LAT_ALT_DISP, data, $
      xtitle=xtitle, $
      subtitle=STRTRIM( SNOE_DATE( today, /from_dom, /to_yyyyddd), 2 ), $
      log=log, $
      charsize=charsize, $
      charthick=charthick, $
      _EXTRA=e
    
    IF ( KEYWORD_SET( manual ) ) THEN BEGIN
        k = GET_KBRD( 1 )
        IF ( k EQ string(10b) ) THEN k = 'n' ; enter
        CASE k OF
            ',': today = today-1
            'q': GOTO, done
            'j': BEGIN
                READ, jump, PROMPT='New YYYYDDD: '
                today = SNOE_DATE( jump, /from_yyyyddd, /to_dom )
            END
            'l': BEGIN ;;; TOGGLE LOG
                log = NOT KEYWORD_SET( log )+2 ;;; TOGGLE log
                ERASE
            END
            ELSE: today = today + 1
        ENDCASE
    ENDIF ELSE today = today + 1 ; if NOT manual then auto-update
    
    ;;; allow generation of postscript movies
    IF ( keyword_set( ps ) ) THEN BEGIN
        erase
        print, snoe_date( today-1, /from_dom, /to_yyyyddd )
    ENDIF
    IF ( today GT dom1 ) THEN GOTO, done
ENDWHILE
done:

IF ( KEYWORD_SET( ps ) ) THEN BEGIN
    DEVICE, /CLOSE
    SET_PLOT, disp
ENDIF

FREE_LUN, lun
END

;
; $Log: l4_lat_alt_day.pro,v $
; Revision 1.12  2002/09/13 18:56:04  mankoff
; fixed PS printout of date bug
;
; Revision 1.11  2002/09/10 07:09:50  mankoff
; added _EXTRA=e to OPEN (can now be used with BIG ENDIAN)
;
; Revision 1.10  2002/09/01 22:28:27  mankoff
; /swap_if_big_endian
;
; Revision 1.9  2002/08/29 23:21:21  mankoff
; uses FILE_UNIQ() for PS output
;
; Revision 1.8  2002/08/29 20:27:53  mankoff
; Now uses generic L4 display program L4_LAT_ALT_DISP
;
; Revision 1.7  2002/08/29 18:19:30  mankoff
; foo>1 * 1e8 is now correctly (foo>1)*1e8
;
; Revision 1.6  2002/08/29 17:59:18  mankoff
; title was wrong: molecules/cm-3 should be molecules/cm^3
;
; Revision 1.5  2002/08/28 03:19:45  mankoff
; AXIS now correct to the pixel. Changed log title when toggling log/linear
;
; Revision 1.4  2002/08/01 23:34:28  mankoff
; changed titles for LOG / LINEAR
;
; Revision 1.3  2002/07/26 17:26:48  mankoff
; Fixed bug in movie mode (infinite loop unless /MANUAL set)
; Added toggle-log (L) in movie mode
;
; Revision 1.2  2002/07/26 04:35:27  mankoff
; added movie capabilities
;
; Revision 1.1  2002/07/26 02:36:28  mankoff
; Initial revision
;

