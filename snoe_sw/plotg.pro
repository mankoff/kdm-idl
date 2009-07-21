; $Id: plotg.pro,v 1.5 2002/08/27 00:39:31 mankoff Exp $
;
; $Author: mankoff $
; $Revision: 1.5 $
; $Date: 2002/08/27 00:39:31 $
;

PRO plotg, xx_in, yy_in, _EXTRA=e

;+
; NAME:
;	PLOTG
;
; PURPOSE:
;   This procedure is a wrapper for the IDL plot command, that puts a
;   light gray grid behind the plot. It makes the plots much easier to
;   read :)
;
; CATEGORY:
;   SNOE, plot
;
; PROCEDURE:
;   See PLOT and SNOECT for any and all documentation
;
; EXAMPLE:
;   PLOTG, indgen( 11 )
;   PLOTG, indgen(11), title='Foo', GVAL=10
;
; MODIFICATION HISTORY:
; 	Written by: KDM; 2002-07-28
;       2002-08-25; KDM; grid is now 'light' even for PS
;
;-

xx = xx_in
IF ( n_elements( yy_in ) EQ 0 ) THEN BEGIN
    yy = xx
    xx = indgen( n_elements( xx ) )
ENDIF ELSE yy = yy_in

snoect, /gray, _EXTRA=e
IF ( !d.name EQ 'PS' ) THEN BEGIN
    ;;; the gray value defaults to a low number for X-windows, where
    ;;; 0->255 is black->white. But on PS the background is reversed,
    ;;; so you want a mostly white background grid, not mostly black.
    tvlct, r,g,b, /GET
    snoect, /gray, gval=255-r[254], _EXTRA=e
ENDIF

;;; plot the background grid in gray.
plot, xx, yy, /NODATA, color=254, $
  xticklen=1, yticklen=1, yminor=1, xminor=1, _EXTRA=e

;;; re-plot the frame, ticks, and titles in the foreground color
plot, xx, yy, /NODATA, /NOERASE, _EXTRA=e
;;; plot the data
oplot, xx, yy, _EXTRA=e

END

;
; $Log: plotg.pro,v $
; Revision 1.5  2002/08/27 00:39:31  mankoff
; fixed bug with tvlct call
;
; Revision 1.4  2002/08/26 02:16:12  mankoff
; fixed so grid is light-colored even in PS when there is a different background
;
; Revision 1.3  2002/08/19 22:33:01  mankoff
; didn't work when both X and Y were passed in.
;
; Revision 1.2  2002/07/31 19:49:34  mankoff
; fixed x/y bug
;
; Revision 1.1  2002/07/29 18:07:13  mankoff
; Initial revision
;
;
;
