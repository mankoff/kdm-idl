
function points2grid_load, file, $
                           north=north, south=south, $
                           east=east, west=west, $
                           cols=cols, rows=rows, $
                           _EXTRA=e
  
  line = ''
  openr, lun, file, /get_lun
  readf,lun,line&north=line&north=kdm_onlydigits(north)
  readf,lun,line&south=line&south=kdm_onlydigits(south)
  readf,lun,line&east=line&east=kdm_onlydigits(east)
  readf,lun,line&west=line&west=kdm_onlydigits(west)
  readf,lun,line&rows=line&rows=FIX(kdm_onlydigits(rows))
  readf,lun,line&cols=line&cols=FIX(kdm_onlydigits(cols))
  
  dat = fltarr( cols, rows )
  readf, lun, dat
  free_lun, lun
  return, dat
end

