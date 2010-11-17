
;; I use GraphicsMagick (better ImageMagick) often via the SPAWN
;; command. This is a wrapper to make my code more portable for other
;; users. 

pro kdm_convert, opts=opts, infile=infile, outfile=outfile, $
                 show=show, $
                 delete_original=delete_original, $
                 _EXTRA=e

  if (keyword_set(opts) + keyword_set(infile) + keyword_set(outfile)) $
     ne 3 then begin
     print, " "
     print, "kdm_convert, opts=opts, infile=infile, outfile=outfile"
     print, "  opts: command line argument to 'gm convert' or 'convert'"
     return
  endif

  ON_ERROR, 2 ;; return to caller

  ;; check if GraphicsMagick and/or ImageMagick is installed
  spawn, 'which gm', stdoutgm, stderrgm
  spawn, 'which convert', stdoutim, stderrim
  if stdoutgm eq '' AND stdoutim eq '' then begin
     MESSAGE, "GraphicsMagick and ImageMagick not found."
  endif

  ;; Use whatever is found. If both found, use GraphicsMagick
  if stdoutim ne '' then cmd = 'convert '
  if stdoutgm ne '' then cmd = 'gm convert '

  spawn, cmd + ' ' + opts + ' ' + infile + ' ' + outfile, stdout, stderr
  if stderr ne '' then MESSAGE, stderr, /CONTINUE

  if keyword_set(show) then spawn, 'open ' + outfile
  if keyword_set(delete_original) then file_delete, infile

end


;; testing
;; gm convert -transparent "#ffffff" MM71_legend.ps MM71_legend.png
img = congrid( bindgen(16,16), 512, 512 )
write_jpeg, 'test.jpeg', img
kdm_convert, opts='-transparent "#ffffff"', $
             infile='test.jpeg', outfile='test.png', $
             /show, /delete
wait, 0.1
file_delete, 'test.png'
end
