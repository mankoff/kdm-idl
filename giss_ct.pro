;+
;
; $Id: GISS_ct.pro,v 1.1 2004/11/11 16:22:44 mankoff Exp mankoff $
;
; NAME: GISS_ct
;
; PURPOSE: Load the colortables for the EdGCM project. The colortables
; come from Panoply
;
; CATEGORY: Display, Graphics, Utility
;
; CALLING SEQUENCE: GISS_ct, FileName
;
; INPUTS:
;    FileName: The name of the file in the colorbars/ subdirectory to load
;
; OPTIONAL INPUTS:
;
; KEYWORD PARAMETERS:
;    FILP: Set to reverse the colortable
;    DISPLAY: Set to plot the RGB values on screen (debugging)
;
; OUTPUTS:
;
; OPTIONAL OUTPUTS:
;    A graphic display of the new colorbar if DISPLAY keyword is set
;
; SIDE EFFECTS:
;    Modifies the current color table 
;
; EXAMPLE:
;    GISS_ct, 'bluescale.pa2'
;    GISS_ct, 'gistemp_11nla.pal'
;
;    spawn, 'ls colorbars', files & i=0
;    GISS_ct, files[i] & i=i+1 ; (repeat)
;
; MODIFICATION HISTORY:
;    KDM, 2004-10-20, Inital write
;
;-


pro GISS_ct_flip, r,g,b
r = reverse(r)
g = reverse(g)
b = reverse(b)
end


pro GISS_ct, ct, r,g,b, flipC=flipC, display=display, $
             backcolor=backcolor, forecolor=forecolor, $
             invalid=invalid

;ON_ERROR, 3
openr, lun, ct, /get_lun
size = (fstat(lun)).size

if (size eq 768) then begin 
    file = assoc( lun, bytarr( 256 ) )
    r = file[0] & g = file[1] & b = file[2]
endif else if ( size eq 772 ) then begin
    file = assoc( lun, bytarr( 3, 256 ) )
    file = file[0]
    r = file[0,*] & g = file[1,*] & b = file[2,*]
endif else begin
    MESSAGE, "Error: Unknown colorbar size", /CONT
endelse

;catch, error_status, /cancel
;if error_status ne 0 then r = ( g = ( b = bindgen(256) ) )


;;; flip scale if requested
if ( keyword_set( flipC ) ) then GISS_ct_flip, r,g,b

; make the colorbar go from 1 to 253.
; make 254 invalid
; make 0 and 255 be bg and fg
r[1] = r[0] & g[1] = g[0] & b[1] = b[0] ; underflow
r[254] = r[255] & g[254] = g[255] & b[254] = b[255] ; overflow

;;; black on bottom, white on top
;;; should use: view=BYTSCL(data,top=252,_EXTRA=e)+1 ; 1-253
r[0] = ( g[0] = ( b[0] = 255 ) ) ; bg
r[255] = ( g[255] = ( b[255] = 0 ) ) ; fg

if not keyword_set(backcolor) then backcolor = '000000'
dummy = STRNUMBER( STRMID( backcolor, 0, 2 ), rb, /HEX )
dummy = STRNUMBER( STRMID( backcolor, 2, 2 ), gb, /HEX )
dummy = STRNUMBER( STRMID( backcolor, 4, 2 ), bb, /HEX )
r[0] = rb & g[0] = gb & b[0] = bb ; bg custom

if keyword_set( forecolor ) then begin
    dummy = STRNUMBER( STRMID( forecolor, 0, 2 ), rb, /HEX )
    dummy = STRNUMBER( STRMID( forecolor, 2, 2 ), gb, /HEX )
    dummy = STRNUMBER( STRMID( forecolor, 4, 2 ), bb, /HEX )
    r[255] = rb & g[255] = gb & b[255] = bb ; fg custom
endif
;;; invalid 1 below the top
if keyword_set(invalid) then begin
    dummy = STRNUMBER( STRMID( invalid, 0, 2 ), rb, /HEX )
    dummy = STRNUMBER( STRMID( invalid, 2, 2 ), gb, /HEX )
    dummy = STRNUMBER( STRMID( invalid, 4, 2 ), bb, /HEX )
endif else begin
    rb = ( gb = ( bb = 128 ) )
endelse
r[253] = r[254] & g[253] = g[254] & b[253] = b[254] ; move over down 1
r[252] = r[253] & g[252] = g[253] & b[252] = b[253] ; double it for #464
r[254] = rb & g[254] = gb & b[254] = bb             ; invalid

;; load scale
tvlct, r, g, b
free_lun, lun


;;; debug display to window
; IF ( keyword_set( display ) ) THEN BEGIN
;     x = indgen( 255 ) 
;     ; display the colortable with both a color-bar and
;     ; plots of the r, g, and b channels.
;     plot, x, r, /xst, position=[.1,.3,.9,.9], $
;           /yst, yrange=[0,256], $
;           xtickv=indgen(9)*32, xticks=10
;     oplot, x, r, color=253, thick=3;, psym=-6
;     oplot, x, g, color=110, thick=3;, psym=-6
;     oplot, x, b, color=40, thick=3;, psym=-6
;     cbar, position=[.1,.1,.9,.2], /xst, $
;           xtickv=indgen(9)*32, xticks=10, xr=[0,256]
; ENDIF

END

;
; $Log: GISS_ct.pro,v $
; Revision 1.1  2004/11/11 16:22:44  mankoff
; Initial revision
;
