pro kdm_ps, landscape=landscape, $
            portrait=portrait, $
            close=close, $
            pdf=pdf, crop=crop, $
            png=png, $
            show=show, $
            low=low, $
            rotate=rotate, $
            _EXTRA=e

if not keyword_set(close) then begin
   set_plot,'ps'
   if keyword_set(portrait) then begin
      device, /color, bits=8, $
              /portrait, $
              xoff=0.0, yoff=0, xsize=8.5, ysize=11, /inches, $
              _EXTRA=e
   endif else if keyword_set(landscape) then begin
      device, /color, bits=8, $
              /landscape, $
              xoff=0.0, yoff=11, xsize=11, ysize=8.5, /inches, $
              scale_factor=1, $
              _EXTRA=e
   endif else begin
      ;; print, 'here'
      device, /color, bits=8, $
              /portrait, $
              ;; these are default, from clean "help, /device"
              ;; xoff=0.75, yoff=5, xsize=7, ysize=5
              _EXTRA=e
   endelse
endif

if keyword_set(close) then begin
   help, /device, out=ps_info
   device, /close
   set_plot, 'x'
   if keyword_set(pdf) OR keyword_set(png) then begin
      file_info = strsplit( ps_info[2], /extract )
      psname = file_info[1]
      pdfname = STRMID(psname,0,STRLEN(psname)-3) + '.pdf'
      spawn, 'pstopdf ' + psname + ' -o ' + pdfname, output
      if keyword_set(crop) then $
         spawn, 'pdfcrop --clip --hires --margins 15 ' + pdfname + ' ' + pdfname, out
      if keyword_set(low) then begin
         pdfnamelo = STRMID(psname,0,STRLEN(psname)-3) + '_low.pdf'
         cmd = 'sips -s format pdf -s formatOptions low '+pdfname+ $
               ' -s dpiHeight 72.0 -s dpiWidth 72.0 --out '+pdfnamelo
         MESSAGE, "Producing low resolution PDF: "+pdfnamelo, /CONTINUE
         pdfname = pdfnamelo
         spawn, cmd, out
      endif
      if keyword_set(png) then begin
         pngname = STRMID(psname,0,STRLEN(psname)-3) + '.png'
         if keyword_set(rotate) then rotcmd = '-rotate ' + STRTRIM(rotate,2) + ' ' ELSE rotcmd=''
         spawn, 'convert ' + rotcmd + pdfname + ' ' + pngname, output
      endif
      if keyword_set( show ) then begin
         if keyword_set(png) then spawn, 'open '+pngname+'&'
         if keyword_set(pdf) then spawn, 'open '+pdfname+'&'
      endif
   endif
;;    if keyword_set(png) then begin
;;       file_info = strsplit( ps_info[2], /extract )
;;       psname = file_info[1]
;;       pngname = STRMID(psname,0,STRLEN(psname)-3) + '.png'
;;       if keyword_set(rotate) then rotcmd = '-rotate ' + STRTRIM(rotate,2) + ' ' ELSE rotcmd=''
;;       spawn, 'convert ' + rotcmd + psname + ' ' + pngname, output
;;       if keyword_set(crop) then message, "CROP not supported for PNG yet", /CONTINUE
;;       if keyword_set(show) then spawn, 'open '+pngname+'&'
;;    endif

endif
end

pro kdm_ps_test
  COMPILE_OPT hidden, IDL2
  kdm_ps, /landscape, filename='kdm_ps_test.ps'
  plot, [0,0], [1,1], position=[0,0,1,1]
  xyouts, 0.5, 0.5, 'Hello World', align=0.5, charsize=3
  kdm_ps, /close, /pdf
end


kdm_ps_test
end
