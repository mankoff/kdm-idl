
PRO plotg, xx_in, yy_in, $
           gval=gval, $
           _EXTRA=e

;+
; NAME:
;	PLOTG
;
; PURPOSE:
;   This procedure is a wrapper for the IDL plot command, that puts a
;   light gray grid behind the plot. It makes the plots much easier to
;   read
;
; CATEGORY:
;   plotting
;
; CALLING SEQUENCE:
;   PLOTG, y
;   PLOTG, x, y
;
; INPUTS:
;	y:	A vector of data
;
; OPTIONAL INPUTS:
;	x: The x value positions for the y data
;
; KEYWORD PARAMETERS:
;   GVAL: The value (0 to 255) for the gray color
;   
;   See PLOT procedure for all other keywords
;
; OUTPUTS:
;   A plot that should be identical to one produced with the PLOT
;   command but with gray lines where the tickmajor value exist.
;
; SIDE EFFECTS:
;	Creates a plot in the current device.
;
; PROCEDURE:
;   1) set up the Y or X and Y arrays
;   2) Save the existing color table
;   3) Load a new colortable with GRAY equal to GVAL as value 254
;   4) Plot with /NODATA, ticklen=1, and color equal 254 (GVAL)
;
; EXAMPLE:
;   PLOTG, indgen( 11 )
;   PLOTG, indgen(11), title='Foo', GVAL=10
;
; MODIFICATION HISTORY:
; 	Written by: KDM; 2002-07-28
;       2002-08-25; KDM; grid is now 'light' even for PS
;       2010-02-25; KDM; removed dependence on SNOEct
;
;-

xx = xx_in
IF ( n_elements( yy_in ) EQ 0 ) THEN BEGIN
    yy = xx
    xx = lindgen( n_elements( xx ) )
ENDIF ELSE yy = yy_in

tvlct,rsave,gsave,bsave,/get

;; set the gray value to element 254 of the colorscale
tvlct,r,g,b, /get
if not keyword_set(gval) then gval = 64
r[254] = ( g[254] = ( b[254] = gval ) )
if !d.name eq 'PS' then begin
   r[254] = 255-r[254]
   g[254] = 255-g[254]
   b[254] = 255-b[254]
endif
tvlct,r,g,b

;;; plot the background grid in gray.
plot, xx, yy, /NODATA, color=254, $
      xticklen=1, yticklen=1, yminor=1, xminor=1, _EXTRA=e

;;; re-plot the frame, ticks, and titles in the foreground color
plot, xx, yy, /NODATA, /NOERASE, _EXTRA=e
if not xiastrec( e, 'nodata' ) then oplot, xx, yy, _EXTRA=e

tvlct,rsave,gsave,bsave
END

