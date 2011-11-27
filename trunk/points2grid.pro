

function points2grid, $
   infile=infile, $
   resolution=resolution, $ ;; 1 meter = 3.2808399 feet
   _EXTRA=e

  m2f = 3.2808399d              ; meter to foot conversion
  
  if not keyword_set(resolution) then resolution = 1E-2
  res = STRTRIM(resolution*m2f)
  MESSAGE, "Grid resolution: " + $
           STRTRIM(resolution,2) + " (m); " + $
           res + " (ft)", /CONTINUE

  cmd = 'points2grid ' + $
        '--resolution ' + res + ' ' + $
        '--output_format grid ' + $
        '-i ' + infile + ' ' +  $
        '-o ' + infile
  spawn, cmd, stdout, stderr

  outfiles = infile + '.'+['mean','min','max','den','idw']+'.grid'
  mean = points2grid_load( infile + '.mean.grid' )
  min = points2grid_load( infile + '.min.grid' )
  max = points2grid_load( infile + '.max.grid' )
  den = points2grid_load( infile + '.den.grid' )
  idw = points2grid_load( infile + '.idw.grid', $
        north=north, south=south, $
        east=east, west=west, $
        cols=cols, rows=rows )
  

  data = { mean:mean, den:den, min:min, max:max, idw:idw, $
           north:north, south:south, east:east, west:west, $
           cols:cols, rows:rows }
  return, data

end
