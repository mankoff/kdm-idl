; $Id: snoect.pro,v 1.2 2002/08/01 21:07:06 mankoff Exp $
;
; $Author: mankoff $
; $Revision: 1.2 $
; $Date: 2002/08/01 21:07:06 $
;
;+
; NAME:
;	SNOECT
;
; PURPOSE:
;	This procedure loads the SNOE color table. It allows different
;	variants of the color table based upon keywords, and optionally
;	saves the current (about-to-be-destroyed) table.
;
; CATEGORY:
;	SNOE, color, image
;
; CALLING SEQUENCE:
;	SNOECT            ; no *required* args (but plenty o' options)
;
; INPUTS:
;   none
;
; KEYWORD PARAMETERS:
;   GRAY:    Set this keyword to have a gray pixel at index 254
;   GVAL:    Set this to the value of the gray pixel [ default: 120 ]
;   BW:      Set this keword to swap the Black and White (Top and
;            Bottom, Foreground and Backround) 
;   DISPLAY: Set this keyword to have the SNOE color table loaded and
;            displayed on screen with a color bar and plots of the RGB
;            vectors. 
;
; OPTIONAL OUTPUTS:
;   R: The current Red channel vector
;   G: The current Green channel vector
;   B: The current Blue channel vector
;
; SIDE EFFECTS:
;   The current color table is changed to the SNOE color table.
;
; RESTRICTIONS:
;   You must be able to access the display to call this procedure
;
; PROCEDURE:
;   Generate R,G,B vectors for an 8-bit colortable. Vectors should be
;   0 to 255 in length (2^8 = 256). Index 0 should be [0,0,0] which is
;   black (background). Index 255 is [255,255,255] which is white
;   (foreground) color. Indices between 1 and 254 are the color table
;   itself, with the top 2 indices here (253 and 254) repeated as the
;   same color. This allows the user to optionally change 254 to any
;   shade of gray. 
;
; EXAMPLE:
;   SNOECT  ; load the default SNOE color table
;   SNOECT, oldR, oldG, oldB, /gray ; load with gray, save old ct
;   SNOECT, /bw ; use for a white background, black text
;   SNOECT, /display ; What is the SNOE ct?
;
;   ;;; This is an example how to use gray in you plots
;   ;;; I use it to add a subtle grid behind the data
;   SNOECT, /gray
;   data = indgen(11)
;   plot, data, color=254, xticklen=1, yticklen=1
;   plot, data, /noerase
;
; MODIFICATION HISTORY:
;   Written by: Ken Mankoff
;   05/21/2002; KDM; Added rr,gg,bb, vectors to save current CT. Added
;                    /gray, gval, and /bw keywords. Added documentation.
;-
PRO snoect, rr, gg, bb, $       ; old vectors to save
            gray=gray, $        ; add a gray pixel at [254]
            gval=gval, $        ; value of gray pixel (default: 120)
            bw=bw, $            ; swap B&W [0] and [255] (fore/back ground)
            display=display     ; plot the colortable

;;; Define the color table by specifying the R,G,B values at each
;;; desired location. Next, interpolate to get vectors 256 in length
;         RED  GRN  BLU  LOC
rgb = [ [ 000, 000, 000, 000 ], $ ; first pixel (0) is black
        [ 000, 000, 255, 001 ], $ ; blue (true)
        [ 000, 150, 255, 032 ], $ ; mid blue
        [ 000, 220, 220, 060 ], $ ; blue/green
        [ 000, 255, 000, 110 ], $ ; green (true)
        [ 150, 255, 000, 120 ], $ ; lime green
        [ 255, 255, 000, 150 ], $ ; yellow
        [ 255, 220, 000, 180 ], $ ; gold
        [ 255, 150, 000, 225 ], $ ; orange
        [ 255, 000, 000, 253 ], $ ; red (true)
        [ 255, 000, 000, 254 ], $ ; red (true) (x2, in case of /gray)
        [ 255, 255, 255, 255 ] ] ; last pixel (255) is white

r = interpol( rgb[ 0, * ], rgb[3,*], indgen(256) ) >0<255
g = interpol( rgb[ 1, * ], rgb[3,*], indgen(256) ) >0<255
b = interpol( rgb[ 2, * ], rgb[3,*], indgen(256) ) >0<255

IF ( keyword_set( gray ) OR n_elements( gval ) NE 0 ) THEN BEGIN
    ; make index 253 the requested (or default) gray value
    IF ( n_elements( gval ) EQ 0 ) THEN gval = 120 
    r[ 254 ] = ( g[ 254 ] = ( b[ 254 ] = gval ) )
ENDIF

IF ( keyword_set( bw ) ) THEN BEGIN
    ; make index 0 (background) white
    ; make index 255 (foreground, text) black
    r[ 0 ] = ( g[ 0 ] = ( b[ 0 ] = 255 ) )
    r[255] = ( g[255] = ( b[255] = 000 ) )
ENDIF

;;; save the old table and pass out if requested (does nothing if the
;;; caller did not want the old one saved. Then, load the new table)
tvlct, rr, gg, bb, /get
tvlct, r, g, b

IF ( keyword_set( display ) ) THEN BEGIN
    ; display the colortable with both a color-bar and
    ; plots of the r, g, and b channels.
    plot, rgb[3,*], rgb[0,*], /xst, position=[.1,.3,.9,.9], $
          /yst, yrange=[0,256], $
          xtickv=indgen(9)*32, xticks=10
    oplot, rgb[3,*], rgb[0,*], color=253, thick=3, psym=-6
    oplot, rgb[3,*], rgb[1,*], color=110, thick=3, psym=-6
    oplot, rgb[3,*], rgb[2,*], color=40, thick=3, psym=-6
    cbar, position=[.1,.1,.9,.2], /xst, $
          xtickv=indgen(9)*32, xticks=10, xr=[0,256]
ENDIF
END

;
; $Log: snoect.pro,v $
; Revision 1.2  2002/08/01 21:07:06  mankoff
; Added RCS variables
;
;
