
;;
;; NOTE: First draft. Seeking feedback or use cases.
;;

;+
;
; NAME:
;	PLOTBREAK
;
; PURPOSE:
;   Plot a data set with a break as per:
;   http://groups.google.com/group/comp.lang.idl-pvwave/browse_frm/thread/ce29c1ba4693c373
;   Should be a drop-in replacement for PLOT.
;
; CATEGORY:
;   Plotting
;
; CALLING SEQUENCE:
;   PLOTBREAK, X, Y
;
; INPUTS:
;   X: an array, similar to what you might pass to PLOT
;   Y: an array, similar to what you might pass to PLOT
;
; KEYWORD PARAMETERS:
;   BREAKPCT: The percentage horizontally across the plot where the
;             break should occur. Defaults to 50%
;   GAP: The break size.
;   VERTBAR: If a vertical bar should be drawn instead of "/" marks.
;   XRANGE0: The xrange of the left part
;   XRANGE1: The xrange of the right part
;
;   Etc... more complete documentation to come as code matures.
;
; EXAMPLE:
;   For now see testing code at bottom.
;
; MODIFICATION HISTORY:
; 	Written by:	Ken Mankoff, 2010-04-03.
;
;-

pro plotbreak, x,y, $
               breakpct=breakpct, $
               gap=gap, $
               vertbar=vertbar, $
               xrange0=xrange0, xrange1=xrange1, $
;;                xticks0=xticks0, xticks1=xticks1, $
;;                xtickv0=xtickv0, xtickv1=xtickv1, $
;;                xtickn0=xtickn0, xtickn1=xtickn1, $
               key0=key0, key1=key1, $
               position=position, $
               _EXTRA=e

  if not keyword_set(position) then position=[0.1,0.1,0.9,0.9]
  if not keyword_set(breakpct) then breakpct=50
  breakloc = (position[2]-position[0]) * (breakpct/100.)+position[0]
  if n_elements(gap) eq 0 then gap = 0.01 ;kdm_isdefined, gap, default=0.01

  if not keyword_set(xrange0) then xrange0=[0,max(x)/2.]
  if not keyword_set(xrange1) then xrange1=[max(x)/2.,max(x)]

  pos0 = [position[0],position[1],breakloc-gap,position[3]]
  pos1 = [breakloc+gap,position[1],position[2],position[3]]

  yrange = minmax(y)
  yrange += 0.1*yrange

  plot, x, y, $
        position=pos0, $
        xrange=xrange0, $
        /xst, $
        yst=9, $
        yrange=yrange, $
        _EXTRA=key0

  if keyword_set(vertbar) then begin
     plots, [breakloc,breakloc], [pos0[1],pos0[3]], /norm, color=254, linestyle=2, _EXTRA=e
  endif

  if not keyword_set( slashScaleV ) then slashScaleV = 2.5
  if not keyword_set( slashScaleH ) then slashScaleH = 0.5

  ;; bottom left
  slashL = convert_coord( pos0[2]-gap*slashScaleH, pos0[1]-gap*slashScaleV, /norm, /to_data )
  slashR = convert_coord( pos0[2]+gap*slashScaleH, pos0[1]+gap*slashScaleV, /norm, /to_data )
  plots, [slashL[0],slashR[0]], [slashL[1],slashR[1]]
  ;; bottom right
  slashL = convert_coord( pos0[2]-gap*slashScaleH+(2*gap), pos0[1]-gap*slashScaleV, /norm, /to_data )
  slashR = convert_coord( pos0[2]+gap*slashScaleH+(2*gap), pos0[1]+gap*slashScaleV, /norm, /to_data )
  plots, [slashL[0],slashR[0]], [slashL[1],slashR[1]]
  ;; top left
  slashL = convert_coord( pos0[2]-gap*slashScaleH, pos0[3]-gap*slashScaleV, /norm, /to_data )
  slashR = convert_coord( pos0[2]+gap*slashScaleH, pos0[3]+gap*slashScaleV, /norm, /to_data )
  plots, [slashL[0],slashR[0]], [slashL[1],slashR[1]]
  ;; top right
  slashL = convert_coord( pos0[2]-gap*slashScaleH+(2*gap), pos0[3]-gap*slashScaleV, /norm, /to_data )
  slashR = convert_coord( pos0[2]+gap*slashScaleH+(2*gap), pos0[3]+gap*slashScaleV, /norm, /to_data )
  plots, [slashL[0],slashR[0]], [slashL[1],slashR[1]]

  
  plot, x,y, $
        /NOERASE, $
        /xst, $
        position=pos1, $
        xrange=xrange1, $
        yrange=yrange, $
        yst=5, $
        _EXTRA=key1
  
  axis, /yaxis, /yst, _EXTRA=key1

  

end

x = indgen(100)/100.*2*!pi
y = sin(x)

;plotbreak, x,y, breakpct=66, xrange0=[0,!pi], xrange1=[!pi,2*!pi], gap=0, /vertbar

plotbreak, x,y, breakpct=66,$; xrange0=[0,!pi], xrange1=[!pi,2*!pi],$
           key0={xtitle:'X', ytitle:'Y',title:'A Plot'}, $
           key1={ytitle:'Also Y',color:253}

;; x = indgen(1000)
;; y = randomu(seed,1000)+x/250.
;; plotbreak, x, y

end
