
; Take a /path/to/file.ext0.ext1 and return the components, either as
; strings or arrays.
pro kdm_filepathext, string, $
                     pathstr=pathstr, $ ; /path/to/
                     patharr=patharr, $ ; [path,to]
                     file=file, $       ; file.ext0.ext1
                     root=root, $       ; file
                     extstr=extstr, $   ; ext0.ext1
                     extarr=extarr, $   ; [ext0,ex1]
                     _EXTRA=e

  if n_elements(string) eq 0 then begin
     test = "/Users/mankoff/Desktop/foo.tar.gz"
     kdm_filepathext, test, pathstr=pathstr, patharr=patharr, $
                      file=file, root=root, $
                      extstr=extstr, extarr=extarr
     help, test, pathstr, patharr, file, root, extstr, extarr
     return
  endif

  pathstr = file_dirname(string, /mark)
  patharr = STRSPLIT( pathstr, path_sep(), /EXTRACT )

  file = file_basename(string)
  IF STRPOS( file, '.' ) eq -1 then begin
     root = file 
     extstr = ''
     extarr = ['']
  endif else begin
     root = STRMID( file, 0, STRPOS(file,'.') )
     extstr = STRMID( file, STRPOS(file,'.') )
     extarr = STRSPLIT( extstr, '.', /EXTRACT )
  endelse
end

test = "/Users/mankoff/Desktop/foo.tar.gz"
kdm_filepathext, test, pathstr=pathstr, patharr=patharr, $
                 file=file, root=root, $
                 extstr=extstr, extarr=extarr
help, test, pathstr, patharr, file, root, extstr, extarr
end
