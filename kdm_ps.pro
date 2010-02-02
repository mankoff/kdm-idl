;+
;
; NAME:
;	KDM_PS
;
; PURPOSE:
;   Make producing PostScript images easier. And PDF, PNG, etc. The
;   primary benefit is that PS images take up a full page in Portrait
;   or Landscape mode. Also simplifies creation of PDF and PNG from
;   PS, so the PNG images can be high quality and anti-aliased.
;
; CATEGORY:
;   Imaging
;
; CALLING SEQUENCE:
;   KDM_PS
;
; KEYWORD PARAMETERS:
;   Anything that DEVICE accepts, plus...
;   LANDSCAPE: Set this keyword to produce images in Landscape mode
;   PORTRAIT: Set to produce images in portrait mode
;   CLOSE: Call with /CLOSE to finish producing the image
;   PDF: Call with /PDF to convert the postscript to PDF
;   CROP: Set this to crop the whitespace around any image
;   PNG: Set this to produce a PNG from the Postscript
;   SHOW: Set this to show the file (PDF or PNG) once produced
;   LOW: Set this to produce a low-quality (small size) PDF file
;   ROTATE: Set this to rotate the image by 90 degrees
;  
; OUTPUTS:
;   This procedure produces a PostScript file in the current directory
;   (unless the name encodes a different directory).
;
; OPTIONAL OUTPUTS:
;   A PDF and/or PNG may also be produced.
;
; SIDE EFFECTS:
;   Files are produced in the current folder
;
; RESTRICTIONS:
;   * Must have write access to the current folder.
;   * Many parts of this code are written specifically for an OS X
;     computer with the following programs installed: pstopdf,
;     pdfcrop, sips, gm (graphicsmagick). These are only used if /PDF,
;     /CROP, /LOW, /PNG, or /ROTATE are used. The basic PS production
;     should work on any computer.
;
; EXAMPLE:
;    kdm_ps, /landscape, filename='kdm_ps_test.ps'
;    plot, [0,0], [1,1], position=[0,0,1,1]
;    xyouts, 0.5, 0.5, 'Hello World', align=0.5, charsize=3, charth=3
;    kdm_ps, /close, /pdf, /png, /show, /crop, rotate=-90
;   
; MODIFICATION HISTORY:
; 	Written by:	Ken Mankoff, 2009-ish?
;   2010-02-02: KDM Added documentation. Changed from ImageMagick
;                   (convert) to GraphicsMagick (gm convert).
;-

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
   if !d.name ne 'PS' then begin
      MESSAGE, "Cannot close. Current device is " + !d.name, /CONTINUE
      return
   endif
   help, /device, out=ps_info
   device, /close, _EXTRA=e
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
         spawn, 'gm convert ' + rotcmd + pdfname + ' ' + pngname, output
      endif
      if keyword_set( show ) then begin
         if keyword_set(png) then spawn, 'open '+pngname+'&'
         if keyword_set(pdf) then spawn, 'open '+pdfname+'&'
      endif
   endif

endif
end

pro kdm_ps_test
  COMPILE_OPT hidden, IDL2
  kdm_ps, /landscape, filename='kdm_ps_test.ps'
  plot, [0,0], [1,1], position=[0,0,1,1]
  xyouts, 0.5, 0.5, 'Hello World', align=0.5, charsize=3, charth=3
  kdm_ps, /close, /pdf, /show, /crop, /PNG, ROTATE=-90
end


kdm_ps_test
end
