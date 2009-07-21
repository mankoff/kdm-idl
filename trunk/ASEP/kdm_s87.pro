;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;72
;; this file contains a bunch of code to read and write s87 files

function kdm_s87_load, id
  if not keyword_set(id) then id = ''
  file = file_search( id+'*.s87', count=count )
  if count eq 0 then begin
     MESSAGE, "File not found: " + id, /CONTINUE
     MESSAGE, "Will search subfolders", /CONTINUE
     cmd = 'find . -name '+id+'*.s87'
     spawn, cmd, file
     count = n_elements(file)
     if count eq 1 AND file eq '' then MESSAGE, "File not found in subfolders"
  endif
  if count eq 1 then return, kdm_s87_load_one( file )
     
  ;; requested more than one, (maybe even all?)
  data = objarr( n_elements(file) )
  for i=0, n_elements(file)-1 do begin
     data[i] = kdm_s87_load_one( file[i] )
  endfor
  if n_elements(data) eq 0 then return, data[0]
  return, data
end


;; reads one s87 file and returns it in a structure
function kdm_s87_load_one, file
  line = ''
  openr, lun, file, /get_lun
  readf, lun, line & header0 = line
  readf, lun, line & header1 = line
  readf, lun, line & header2 = line
  readf, lun, line & header3 = line        
  while not EOF( lun ) do begin
     readf, lun, line
     data = STRSPLIT( line, /EXTRACT )
     d = arrconcat( d, float(data[0]) )
     t = arrconcat( t, float(data[1]) )
     s = arrconcat( s, float(data[2]) )
  endwhile   
  free_lun, lun
  nl = STRING(byte(10)) ; unix newline (?)
  hdr = header0+nl+header1+nl+header2+nl+header3
  o = obj_new('ctd')
  o->setProperty, depth=d, temp=t, salt=s, $
                  hdr=hdr, note=file
  return, o
end


pro kdm_s87
  aoeu
end
