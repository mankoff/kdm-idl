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

pro kdm_ps, filename=filename, $
            landscape=landscape, $
            portrait=portrait, $
            close=close, $
            pdf=pdf, nocrop=nocrop, $
            png=png, $
            tiff=tiff, $
            show=show, $
            low=low, $
            high=high, $
            rotate=rotate, $
            _EXTRA=e

if not keyword_set(close) then begin
   set_plot,'ps'

   kdm_isdefined, filename, default=file_uniq()+'.ps'

   kdm_filepathext, filename, extstr=extstr
   if STRLOWCASE(strmid(extstr,1,1)) eq 'e' then encaps=1 else encaps=0

   if keyword_set(portrait) then begin
      device, /color, bits=8, $
              /portrait, $
              filename=filename, $
              encapsulated=encaps, $
              xoff=0.0, yoff=0, xsize=8.5, ysize=11, /inches, $
              _EXTRA=e
   endif else if keyword_set(landscape) then begin
      device, /color, bits=8, $
              /landscape, $
              filename=filename, $
              encapsulated=encaps, $
              xoff=0.0, yoff=11, xsize=11, ysize=8.5, /inches, $
              scale_factor=1, $
              _EXTRA=e
   endif else begin
      ;; print, 'here'
      device, /color, bits=8, $
              filename=filename, $
              encapsulated=encaps, $
              ;; these are default, from clean "help, /device"
              ;; xoff=0.75, yoff=5, xsize=7, ysize=5
              xoff=1, yoff=2, xsize=7, ysize=5, /inches, $
              _EXTRA=e
   endelse
endif

if keyword_set(close) then begin
   if !d.name ne 'PS' then begin
      MESSAGE, "Cannot close. Current device is " + !d.name, /CONTINUE
      return
   endif
   help, /device, out=ps_info
   device, /close ;, _EXTRA=e
   set_plot, 'x'
   if keyword_set(pdf) OR keyword_set(png) OR keyword_set(TIFF) then begin
      file_info = strsplit( ps_info[2], /extract )
      psname = file_info[1]

      ;;pdfname = STRMID(psname,0,STRLEN(psname)-3) + '.pdf'
      kdm_filepathext, psname, pathstr=pathstr, root=root
      pdfname = pathstr + root + '.pdf'
      pngname = pathstr + root + '.png'
      tifname = pathstr + root + '.tif'

      if keyword_set(pdf) then begin
         spawn, 'pstopdf ' + psname + ' -o ' + pdfname, stdout, stderr

         ;; crop NOT requested
         if not keyword_set(nocrop) then $
            spawn, 'pdfcrop --clip --hires --margins 15 ' + pdfname + ' ' + pdfname, stdout, stderr

         ;; rotate if requested
         if keyword_set(rotate) then begin
            cmd = 'sips --rotate '+STRTRIM(rotate,2) + ' '+pdfname
            print, cmd
            spawn, cmd, stdout, stderr
         endif
         
         ;; low quality (shrink size)?
;;          if keyword_set(low) then begin
;;             pdfnamelo = STRMID(psname,0,STRLEN(psname)-3) + '_low.pdf'
;;             cmd = 'sips -s format pdf -s formatOptions low '+pdfname+ $
;;                   ' -s dpiHeight 72.0 -s dpiWidth 72.0 --out '+pdfnamelo
;;             MESSAGE, "Producing low resolution PDF: "+pdfnamelo, /CONTINUE
;;             pdfname = pdfnamelo
;;             spawn, cmd, stdout, stderr
;;          endif
         if keyword_set(show) then spawn, 'open -a Preview '+pdfname+'&', $
                                          stdout, stderr
      endif ;; PDF 
      
      ;; Doesn't work for multi-page PDFs
      if keyword_set(png) then begin
         if keyword_set(low) then begin
            dense=' -density 72x72 ' 
            border=' -border 7x7 -bordercolor white '
         endif else if keyword_set(high) then begin
            dense=' -density 600x600 '
            border=' -border 14x14 -bordercolor white '
         endif else begin
            dense=' -density 300x300 '
            border=' -border 30x30 -bordercolor white '
         endelse
         spawn, 'gm convert -units PixelsPerInch ' + dense + psname + ' ' + pngname, stdout, stderr
         if not keyword_set(nocrop) then spawn, 'gm mogrify -trim ' + pngname, stdout, stderr
         if not keyword_set(nocrop) then spawn, 'gm mogrify ' + border + pngname, stdout, stderr
         if keyword_set(rotate) then spawn, 'gm mogrify -rotate '+STRTRIM(rotate,2)+ ' ' + pngname, stdout, stderr
         if keyword_set(show) then spawn, 'open '+pngname+'&', stdout, stderr
      endif

      ;; Doesn't work for multi-page PDFs
      if keyword_set(tiff) then begin
         if keyword_set(low) then dense=' -density 72x72 ' else dense=' -density 300x300 '
         spawn, 'gm convert -compress LZW ' + dense + psname + ' ' + tifname, stdout, stderr
         if not keyword_set(nocrop) then spawn, 'gm mogrify -trim ' + tifname, stdout, stderr
         if not keyword_set(nocrop) then spawn, 'gm mogrify ' + border + tifname, stdout, stderr
         if keyword_set(rotate) then spawn, 'gm mogrify -rotate '+STRTRIM(rotate,2)+ ' ' + tifname, stdout, stderr
         if keyword_set(show) then spawn, 'open '+tifname+'&', stdout, stderr
      endif

   endif
endif
end

pro kdm_ps_test
  COMPILE_OPT hidden, IDL2
  kdm_ps, /landscape, filename='kdm_ps_test.eps'
  plot, [0,0], [1,1], position=[0.3,.5,.8,.9], title='Foo'
  xyouts, 0.5, 0.5, 'Hello World', align=0.5, charsize=3, charth=3
  kdm_ps, /close, /show, /crop, /PNG, /PDF, /TIF, ROTATE=-90
  ;;kdm_ps, /close, /show, /TIF, ROTATE=-90, filename='kdm_ps_test.ps', /LOW, /CROP
  ;kdm_ps, /close, /show, /crop, /PNG, ROTATE=-90
end


kdm_ps_test
end
