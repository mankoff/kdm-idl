
pro kinect, $
   file=file, $
   x=x, y=y, z=flat, $
   grid=grid, $
   ;;
   fillholes=fillholes, $
   ;; debug
   display=display, $
   ;;
   _EXTRA=e

  if not keyword_set(file) then file="/Users/mankoff/data/Kinect/test.pgm"

  ;; load the raw Kinect data
  DN = kinect_pgm(file)

  if keyword_set( fillholes ) then kdm_fillholes, dn, _EXTRA=e
  
  if keyword_set(display) then begin
     window, 0, title='Raw DN'
     imdisp, hist_equal(DN), /axis, /erase
  endif

  kinect_dn2xyz, DN,x,y,z
  kinect_plane, x,y,z, plane, flat

  gd = where( DN gt 300 AND DN lt 1000, complement=bad, ngd )
  if ngd gt 0 then $
     x=x[gd] & y=y[gd] & z=z[gd] & flat=flat[gd]

;;   pct = percentiles( flat, value=[0.01,0.99] )
;;   gd = where( flat gt pct[0] AND flat lt pct[1], ngd )
;;   if ngd gt 0 then $
;;      x=x[gd] & y=y[gd] & z=z[gd] & flat=flat[gd]
  print, 'minmax range: ', minmax(flat)

  if keyword_set(display) then begin
     color = kdm_range( flat, from=minmax(flat), to=[1,253] )
     window, 1, title='XY Scatter Plot (Flattened)'
     plot, [0,0], xr=minmax(x), yr=minmax(y), /xst, /yst, /nodata
     for i=0L, n_elements(flat)-1, 1 do begin
        plots, x[i], y[i], color=color[i], psym=3
     endfor
  endif

  openw, lun, file+'.xyz', /get_lun
  ;;printf, lun, 'x y z'
  for i=0L, n_elements(flat)-1 do begin
     printf, lun, $
             STRTRIM(x[i],2),',',$
             STRTRIM(y[i],2),',',$
             STRTRIM(flat[i],2)
  endfor
  free_lun, lun

  grid = points2grid( infile=file+'.xyz', resolution=1E-3, _EXTRA=e )
  if keyword_set(display) then begin
     window, 2, title='Gridded Point Density'
     imdisp, hist_equal(grid.den), /axis, /erase, /order
     print, 'max density: ' + FIX(max(grid.den))


     window, 3, title='Gridded Flattened Height Map'
     gd = where( grid.mean ne -9999, ngd, complement=bad )
     img = kdm_range( grid.mean, $
                      from=[min(grid.mean[gd]),max(grid.mean)], $
                      to=[1,253], under=254, over=254 )
     imdisp, img, /noscale, /axis, /erase, /order, $
             xtitle='mm',ytitle='mm'

     dat = grid.mean & dat[bad] = mean(dat[gd])
     write_tiff, file+'.tif', bytscl(dat)
     spawn, 'gdaldem hillshade -z 0.1 ' + file+'.tif ' + file+'.shade.tif', $
            stdout, stderr
  endif

end

kinect, /DISPLAY
end
