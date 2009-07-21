pro xyoutsbg, x, y, text, $
                                ; xyouts keyword
              charthick=charthick, $ 
              color=color, $ 
                                ; my keywords below here
              fudge=fudge, $
              backcolor=backcolor, $
                                ; xyout keywords
              _EXTRA=e
  
  ;; xyouts needs these
  if not keyword_set(charthick) then charthick = 1
  if not keyword_set(color) then color = 0
  
  ;; we have to pick a background color if it wasn't
  ;; supplied. Try to do so intelligently.
  if not keyword_set(backcolor) then begin
     if color eq 255 then backcolor = 0 else backcolor = 255
  endif
  if not keyword_set(fugde) then fudge = 4

  ;; write the text VERY thick
  xyouts, x, y, text, $
          charthick=charthick*4, $
          color=backcolor, $
          _EXTRA=e

;;   xyouts, 999, 999, text, /norm, width=w, _EXTRA=e
;;   img = bytarr(2,2) + backcolor
;;   p = convert_coord( x, y, data=data, device=device, norm=norm, /to_norm )
;;   tv, img, p[0], p[1], xsize=w, ysize=!D.y_ch_size * 

  ;; write the text normally
  xyouts, x, y, text, $
          charthick=charthick, $
          color=color, $
          _EXTRA=e
  
end

pro xyoutsbg_test

  COMPILE_OPT hidden
  erase, 1
  xyoutsbg, 0.5, 0.5, 'Hello World', $
            align=0.5, charsize=3, $
            color=252, $
            /norm
end

xyoutsbg_test
end
