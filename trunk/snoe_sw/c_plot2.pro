;
;This function plots up to 7 lines on the same plot x axis in seven different
;colors with a legend.
;
;Syntax:   c_plot, {x vector}, {y vector #1}, {'y lable #1'}, {y vector #2},...
;
PRO c_plot2, xaxis, y1axis, y1lable, y2axis, y2lable, y3axis, y3lable, $
            y4axis, y4lable, y5axis, y5lable, y6axis, y6lable, y7axis, y7lable, $
            _EXTRA=e

lines = n_elements( y7axis ) ne 0 + $
        n_elements( y6axis ) ne 0 + $
        n_elements( y5axis ) ne 0 + $
        n_elements( y4axis ) ne 0 + $
        n_elements( y3axis ) ne 0 + $
        n_elements( y2axis ) ne 0 + $
        n_elements( y1axis ) ne 0 + $
        n_elements( y0axis ) ne 0 
if ( lines eq 0 ) then begin
   print, 'I need at least on "y" vector to graph!'
   return
endif
gbig = -9999999L                ; start with a really small number
gsmall = 1e9                    ; start with a really big number
for i = 1, n_elements( lines ) do begin
   var = 'y' + STRTRIM(i,2) + 'axis'
   cmd = 'mm = minmax( ' + var + ' ) '
   ;print, "executing: " + cmd
   dummy = execute( cmd )
   if ( gsmall gt mm[0] ) then gsmall = mm[0] ; shrink
   if ( gbig lt mm[1] ) then gbig = mm[1] ; grow
endfor

xsmall = min( xaxis )
xbig = max( xaxis )


    snoect, /gray, _EXTRA=e

    plotg, xaxis, y1axis, xrange=[xsmall,xbig], $
      yrange=[gsmall, gbig + .2 * (gbig - gsmall)],$
      xstyle=1, ystyle=1, /nodata, _EXTRA=e

    IF lines GE 0 THEN BEGIN
        oplot, xaxis, y1axis, color=1,_EXTRA=e
        plots, [ .05 * (xbig - xsmall)+xsmall, .15 * (xbig - xsmall)+xsmall], $
          [ 1.15 * (gbig - gsmall) + gsmall, 1.15 * (gbig - gsmall) + gsmall], $
          color=1, thick=2, _EXTRA=e
        xyouts,.175 * (xbig - xsmall) +xsmall, 1.15 * (gbig - gsmall) +gsmall, $
          y1lable, charsize=1.5
    ENDIF 
    IF lines GE 1 THEN BEGIN
        oplot, xaxis, y2axis, color=100,_EXTRA=e
        plots, [ .35 * (xbig - xsmall)+xsmall, .45 * (xbig - xsmall)+xsmall], $
          [ 1.15 * (gbig - gsmall) + gsmall, 1.15 * (gbig - gsmall) + gsmall], $
          color=100, thick=2, _EXTRA=e
        xyouts,.475 * (xbig - xsmall) +xsmall , 1.15 * (gbig - gsmall) +gsmall, $
          y2lable, charsize=1.5
    ENDIF     
    IF lines GE 2 THEN BEGIN
        oplot, xaxis, y3axis, color=253,_EXTRA=e
        plots, [ .65 * (xbig - xsmall)+xsmall, .75 * (xbig - xsmall)+xsmall], $
          [ 1.15 * (gbig - gsmall)+gsmall, 1.15 * (gbig - gsmall)+gsmall], $
          color=253, thick=2, _EXTRA=e
        xyouts,.775 * (xbig - xsmall) +xsmall , 1.15 * (gbig - gsmall) +gsmall, $
          y3lable, charsize=1.5
    ENDIF 
    IF lines GE 3 THEN BEGIN
        oplot, xaxis, y4axis, color=50,_EXTRA=e
        plots, [ .05 * (xbig - xsmall)+xsmall, .15 * (xbig - xsmall)+xsmall], $
          [ 1.1 * (gbig - gsmall)+gsmall, 1.1 * (gbig - gsmall)+gsmall], $
          color=50, thick=2, _EXTRA=e
        xyouts,.175 * (xbig - xsmall) +xsmall , 1.1 * (gbig - gsmall) +gsmall, $
          y4lable, charsize=1.5
    ENDIF 
    IF lines GE 4 THEN BEGIN
        oplot, xaxis, y5axis, color=150,_EXTRA=e
        plots, [ .35 * (xbig - xsmall)+xsmall, .45 * (xbig - xsmall)+xsmall], $
          [ 1.1 * (gbig - gsmall)+gsmall, 1.1 * (gbig - gsmall)+gsmall], $
          color=150, thick=2, _EXTRA=e
        xyouts,.475 * (xbig - xsmall) +xsmall , 1.1 * (gbig - gsmall) +gsmall, $
          y5lable, charsize=1.5
    ENDIF 
    IF lines GE 5 THEN BEGIN
        oplot, xaxis, y6axis, color=224,_EXTRA=e
        plots, [ .65 * (xbig - xsmall)+xsmall, .75 * (xbig - xsmall)+xsmall], $
          [ 1.1 * (gbig - gsmall)+gsmall, 1.1 * (gbig - gsmall)+gsmall], $
          color=224, thick=2, _EXTRA=e
        xyouts,.775 * (xbig - xsmall) +xsmall , 1.1 * (gbig - gsmall) +gsmall, $
          y6lable, charsize=1.5
    ENDIF 
    IF lines GE 6 THEN BEGIN
        oplot, xaxis, y7axis, color=255,_EXTRA=e
        plots, [ .05 * (xbig - xsmall)+xsmall, .15 * (xbig - xsmall)+xsmall], $
          [ 1.05 * (gbig - gsmall)+gsmall, 1.05 * (gbig - gsmall)+gsmall], $
          color=255, thick=2, _EXTRA=e
        xyouts,.175 * (xbig - xsmall) +xsmall , 1.05 * (gbig - gsmall) +gsmall,$
          y7lable, charsize=1.5
    ENDIF 

END
