function kinect_pgm, f

  
  openr, lun, f, /get_lun

  if STRCMP( STRMID(f,3,/REV), '.pgm' ) then begin
     ;; PGM from record
     header = { P5: BYTARR(2), width:BYTARR(4), height:BYTARR(4), x:BYTARR(7) }
     readu, lun, header
     ;;print, string( header.p5 ), string(header.width), string(header.height)
     ;;print, string(header.x)
     data = intarr( string(header.width), string(header.height) )
     readu, lun, data
  endif else if STRCMP( STRMID(f,3,/REV), '.raw' ) then begin
     ;; .raw from RGB-Demo
     header = LONARR(2)
     readu, lun, header
     print, header
     data = FLTARR( header[1], header[0] )
     readu, lun, data
  endif else begin
     MESSAGE, "Kinect depth image not recognized.", /CONT
     MESSAGE, "Should be .pgm (record) or .raw (RGB-Demo)"
  endelse

  free_lun, lun
  return, data

end
