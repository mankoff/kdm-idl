;
;This function plots up to 7 lines on the same plot x axis in seven different
;colors with a legend.
;
;Syntax:   c_plot, {x vector}, {y vector #1}, {'y lable #1'}, {y vector #2},...
;
PRO c_plot, xaxis, y1axis, y1lable, y2axis, y2lable, y3axis, y3lable, $
            y4axis, y4lable, y5axis, y5lable, y6axis, y6lable, y7axis, y7lable, $
            _EXTRA=e

    IF n_elements(y7axis) NE 0 THEN lines = 6 $
    ELSE IF n_elements(y6axis) NE 0 THEN lines = 5 $
    ELSE IF n_elements(y5axis) NE 0 THEN lines = 4 $
    ELSE IF n_elements(y4axis) NE 0 THEN lines = 3 $
    ELSE IF n_elements(y3axis) NE 0 THEN lines = 2 $
    ELSE IF n_elements(y2axis) NE 0 THEN lines = 1 $
    ELSE IF n_elements(y1axis) NE 0 THEN lines = 0 $
    ELSE BEGIN
        print,'I need at least one "y" vector to graph!'
        return
    ENDELSE

    ybig = fltarr(lines + 1)
    ysmall = fltarr(lines + 1)

    IF lines GE 0 THEN BEGIN 
        ybig[0] = max(y1axis)
        ysmall[0] = min(y1axis)
    ENDIF
    IF lines GE 1 THEN BEGIN 
        ybig[1] = max(y2axis)
        ysmall[1] = min(y2axis)
    ENDIF
    IF lines GE 2 THEN BEGIN 
        ybig[2] = max(y3axis)
        ysmall[2] = min(y3axis)
    ENDIF
    IF lines GE 3 THEN BEGIN 
        ybig[3] = max(y4axis)
        ysmall[3] = min(y4axis)
    ENDIF
    IF lines GE 4 THEN BEGIN 
        ybig[4] = max(y5axis)
        ysmall[4] = min(y5axis)
    ENDIF
    IF lines GE 5 THEN BEGIN 
        ybig[5] = max(y6axis)
        ysmall[5] = min(y6axis)
    ENDIF
    IF lines GE 6 THEN BEGIN 
        ybig[6] = max(y7axis)
        ysmall[6] = min(y7axis)
    ENDIF

    gbig = (ybig(where(ybig EQ max(ybig))))[0]
    gsmall = (ysmall(where(ysmall EQ min(ysmall))))[0]

    xbig = max(xaxis)
    xsmall = min(xaxis)

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
