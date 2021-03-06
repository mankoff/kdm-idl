
; $Id: l3_globe.pro,v 1.3 2002/09/12 21:27:53 mankoff Exp $
;
; $Author: mankoff $
; $Revision: 1.3 $
; $Date: 2002/09/12 21:27:53 $
;

PRO L3_globe, coords, yyyyddd, yyyyddd1, manual=manual, $
              fill=fill, mask=mask, _EXTRA=e

;+
; NAME:
;	L3_GLOBE
;
; PURPOSE:
;   Display a globe of 1 day of SNOE data
;
; CATEGORY:
;   SNOE, image, map, display
;
; CALLING SEQUENCE:
;   L3_GLOBE, Coords, Yyyyddd, Yyyyddd1
;
; INPUTS:
;   COORDS: The coordinate system of dataset to use ('geo' or 'mag')
;   YYYYDDD: The date of the data to display
;   
; OPTIONAL INPUTS:
;   YYYYDDD1: The end date if in automatic movie mode
;	
; KEYWORD PARAMETERS:
;   FILL: Set this keyword to fill in some holes using FIX_GAPS
;   MASK: Set this keyword to mask out the polar regions (80 to the pole)
;   MANUAL: Set this to control the movie manually.
;           ',': previous day (<)
;           'l': toggle Log mode
;           'j': Jump to YYYYDDD
;           'q': Quit movie mode
;           any other key: next day
; 
;   _EXTRA is used by:
;       L3_LON_LAT: altitude, verbose
;       GRID_GLOBE, lots (see documentation)
;       MAP_SET, MAP_GRID, MAG_GRID, LOAD_CGM, etc.
;
; OUTPUTS:
;   An image
;
; SIDE EFFECTS:
;   Uses current WINDOW. May change PS device.
;
; RESTRICTIONS:
;   Must be in directory with L3 files (NO_?_den_???.dat)
;
; EXAMPLE:
;   Simple view of a day:
;   L3_GLOBE, 'geo', 1998124
;
;   Nice hard-copy output
;   L3_globe,'geo',1998124,/ortho,lat=81.5,long=277.5,/mask,/cont,/gg,
;             /mg,/bil,lv=!SNOE.f.l3_lv,/ps,filename='test'
;
; MODIFICATION HISTORY:
; 	Written by:	KDM; 2002-07-26
;   2002-09-12; KDM; Fixed bug when /MANUAL set. Added STATUSLINE output
;
;-


dom = SNOE_DATE( yyyyddd, /from_yyyyddd, /to_dom )
IF ( KEYWORD_SET( yyyyddd1 ) OR ( keyword_SET( manual ) ) ) THEN BEGIN
    IF ( keyword_set( yyyyddd1 ) ) then $
      dom1 = SNOE_DATE( yyyyddd1, /from_yyyyddd, /to_dom )
    IF ( KEYWORD_SET( manual ) ) THEN dom1 = !SNOE.d.now_dom
ENDIF ELSE dom1 = dom

today = dom ;;; will incement through movie
WHILE (1) DO BEGIN

    ;;;
    ;;; GRID GLOBE CODE BEGIN
    ;;;
    L3_lon_lat, coords, SNOE_DATE( today, /from_dom, /to_yyyyddd ), d, $
      _EXTRA=e ;;; LOAD the data

    IF ( keyword_set( fill ) ) THEN BEGIN
        d = fix_gaps( d, /x, gap=2, /edge )
        d = fix_gaps( d, /y, gap=2, /edge )
        d = fix_gaps( d, /x, gap=2, /edge )
    ENDIF	

    IF ( keyword_set( mask ) ) THEN BEGIN
    ;    d[*,[0,1,35,36]] = 0
        grid_globe, d[*,2:34], latmin=-80,latmax=80, log=log, _EXTRA=e
    ENDIF ELSE grid_globe, d, log=log, _EXTRA=e
    ;;;
    ;;; GRID GLOBE CODE END
    ;;;

    ;;; Tell the user (in the xterm) what day they are looking at.
    statusline, /clear
    STATUSLINE, STRTRIM(SNOE_DATE( today, /from_dom, /to_yyyyddd ),2), 42

    ;;; below here is just MOVIE code
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
            'l': log = NOT KEYWORD_SET( log )+2 ;;; TOGGLE log
            ELSE: today = today + 1
        ENDCASE
    ENDIF ELSE today = today + 1 ; if NOT manual then auto-update
    IF ( today GT dom1 ) THEN GOTO, done
ENDWHILE
done:
END


;
; $Log: l3_globe.pro,v $
; Revision 1.3  2002/09/12 21:27:53  mankoff
; Fixed movie bug (didn't work when /MANUAL set). Added STATUSLINE output
;
; Revision 1.2  2002/07/30 03:17:41  mankoff
; added movie option
;
; Revision 1.1  2002/07/26 20:08:27  mankoff
; Initial revision
;
