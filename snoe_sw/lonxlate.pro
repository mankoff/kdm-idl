; $Id: lonxlate.pro,v 1.1 2002/08/01 21:25:37 mankoff Exp $
;
; $Author: mankoff $
; $Revision: 1.1 $
; $Date: 2002/08/01 21:25:37 $
;
;+
; NAME:
;	LONXLATE
;
; PURPOSE:
;   This function translates an array (or atomic element) of
;   longitudes from one grid to another. A grid is either Eastern or
;   Western longitude, and from 0 to 360 or -180 to 180
;
; CATEGORY:
;   Mapping
;
; CALLING SEQUENCE:
;   Result = LONXLATE( Longitudes, /from_xxx, /to_xxx )
;
; INPUTS:
;   Longitudes: An array (or a atomic element (scalar)) of
;   longitudes. These must be valid regarding the /FROM_xxx grid
;   system. 
;
; KEYWORD PARAMETERS:
;   FROM_180E: A keyword specifying that the longitude(s) range
;   between -180 and 180, and increase to the East.
;
;   FROM_180W: A keyword specifying that the longitude(s) range
;   between -180 and 180, and increase to the West.
;
;   FROM_360E: A keyword specifying that the longitude(s) range
;   between 0 and 360, and increase to the East.
;
;   FROM_360W: A keyword specifying that the longitude(s) range
;   between 0 and 360, and increase to the West.
;
;   TO_180E: A keyword specifying that the output longitude(s) range
;   should be between -180 and 180, and increase to the East.
;
;   TO_180W: A keyword specifying that the output longitude(s) range
;   should be between -180 and 180, and increase to the West.
;
;   TO_360E: A keyword specifying that the output longitude(s) range
;   should be between 0 and 360, and increase to the East.
;
;   TO_360W: A keyword specifying that the output longitude(s) range
;   should be between 0 and 360, and increase to the West.
;
; OUTPUTS:
;   This function returns the input longitude array, translated from
;   the grid specified by the /FROM_xxx keyword, onto the grid
;   specified by the /TO_xxx keyword.
;
; SIDE EFFECTS:
;   None that I know of yet... Email me if you find any.
;
; RESTRICTIONS:
;   The input array must be valid on the grid specified by the
;   /FROM_xxx keyword. No error checking is done. Use CIRRANGE and/or
;   RANGECIR before calling this to fix your lons for you (they are in
;   the astronomy library)
;
; PROCEDURE:
;   * read the code
;   * Most of the work is done in the /to_180e section. All other
;   /TO_xxx keywords use that chunk of code, pass in the /FROM_xxx
;   keyword, and then do only a little bit of work to translate from
;   /to_180e to the actual requested /TO_xxx.
;
; EXAMPLE:
;   lon_0 = [ -135, -45, 45, 135 ]
;   lon_1 = lonxlate( lon_0, /from_180e, /to_180w )
;   lon_2 = lonxlate( lon_1, /from_180w, /to_360e )
;
; MODIFICATION HISTORY:
; 	Written by:	Ken Mankoff (mankoff@lasp.colorado.edu), 2002-04-03
;	2002-05-22; KDM; Added documentation.
;-

FUNCTION lonxlate, inLon, $
                  from_180e=from_180e, $
                  from_180w=from_180w, $
                  from_360e=from_360e, $
                  from_360w=from_360w, $
                  to_180e=to_180e, $
                  to_180w=to_180w, $
                  to_360e=to_360e, $
                  to_360w=to_360w

lon = inLon
IF ( keyword_set( to_180e ) ) THEN BEGIN
    IF ( KEYWORD_SET( FROM_180E ) ) THEN RETURN, LON
    IF ( KEYWORD_SET( FROM_180W ) ) THEN RETURN, -LON
    IF ( KEYWORD_SET( FROM_360W ) ) THEN RETURN, $
      lonxlate( 360-LON, /from_360E, /to_180e )
    IF ( KEYWORD_SET( FROM_360E ) ) THEN BEGIN
        BIG = WHERE( LON GT 180, N )
        IF ( N NE 0 ) THEN LON[ BIG ] = LON[ BIG ] - 360
        RETURN, LON
    ENDIF
ENDIF

IF ( keyword_set( to_180w ) ) THEN BEGIN
    lon = lonxlate( lon, from_180e=from_180e, from_180w=from_180w, $
                    from_360e=from_360e, from_360w=from_360w, $
                    /to_180e )
    return, -lon
ENDIF

IF ( keyword_set( to_360e ) ) THEN BEGIN
    lon = lonxlate( lon, from_180e=from_180e, from_180w=from_180w, $
                    from_360e=from_360e, from_360w=from_360w, $
                    /to_180e )
    NEG = WHERE( LON LT 0, N )
    IF ( N NE 0 ) THEN LON[ neg ] = LON[ neg ] + 360
    RETURN, lon
ENDIF

IF ( keyword_set( to_360w ) ) THEN BEGIN
    lon = lonxlate( lon, from_180e=from_180e, from_180w=from_180w, $
                    from_360e=from_360e, from_360w=from_360w, $
                    /to_360e )
    return, 360-lon
ENDIF

MESSAGE, "Error. Should no be here", /CONTINUE
return, "ERROR"
END

;
; $Log: lonxlate.pro,v $
; Revision 1.1  2002/08/01 21:25:37  mankoff
; Initial revision
;
;
