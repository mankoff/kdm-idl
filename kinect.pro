
pro kinect, $
   file=file, $
   x=x, y=y, z=flat, $
   grid=grid, $
   ;;
   fillholes=fillholes, $
   trim_pct=trim_pct, $
   z_scale=z_scale, $
   smooth=smooth, $
   ;; debug
   display=display, $
   ;;
   _EXTRA=e

  if not keyword_set(file) then file="/Users/mankoff/data/Kinect/test.pgm"

  ;; load the raw Kinect data
  DN = kinect_pgm(file)

  if keyword_set( fillholes ) then kdm_fillholes, dn, _EXTRA=e
  if not keyword_set(z_scale) then z_scale = 0.33

  ;;kdm_ps, file='test.ps'
  
  if keyword_set(display) then begin
     window, 0, title='Raw DN'
     imdisp, hist_equal(DN), /axis, /erase
  endif

  kinect_dn2xyz, DN,x,y,z
  kinect_plane, x,y,z, plane, flat

  gd = where( DN gt 300 AND DN lt 1000, complement=bad, ngd )
  if ngd gt 0 then $
     x=x[gd] & y=y[gd] & z=z[gd] & flat=flat[gd]

  if keyword_set(trim_pct) then begin
     pct = percentiles( flat, value=[0.01,0.99], _EXTRA=e )
     gd = where( flat gt pct[0] AND flat lt pct[1], ngd )
     if ngd gt 0 then $
        x=x[gd] & y=y[gd] & z=z[gd] & flat=flat[gd]
  endif
  print, 'minmax range: ', minmax(flat)

  if keyword_set(display) then begin
     color = kdm_range( flat, from=minmax(flat), to=[1,253] )
     window, 1, title='XY Sctater Plot (Flattened)'
     plot, [0,0], xr=minmax(x), yr=minmax(y), /xst, /yst, /nodata, $
           position=[0.1,0.1,0.8,0.9]
     for i=0L, n_elements(flat)-1, 1 do begin
        plots, x[i], y[i], color=color[i], psym=3
     endfor
     cbar, /vert, cmin=1,cmax=253,vmin=0,vmax=max(flat)-min(flat),$
           position=[0.82,0.1,0.84,0.9], ytitle='m'
  endif

  openw, lun, file+'.xyz', /get_lun
  ;;printf, lun, 'x y z'
  
  ;; tmp subset
;;   for i=0L, n_elements(flat)-1 do begin
;;      if x[i] le -0.21 OR x[i] ge 0.2 OR y[i] le -0.20 OR y[i] ge 0.21 then continue
;;      printf, lun, $
;;              STRTRIM(x[i],2),',',$
;;              STRTRIM(y[i],2),',',$
;;              STRTRIM(flat[i],2)
;;   endfor
;;   free_lun, lun
  ;;stop

  grid = points2grid( infile=file+'.xyz', resolution=1E-3, _EXTRA=e )
  if keyword_set(display) then begin
     window, 2, title='Gridded Point Density'
     imdisp, grid.den>0, /axis, /erase, /order, $
             position=[0.1,0.1,0.8,0.9], /use_pos
     cbar, /vert, cmin=1,cmax=253,vmin=0, vmax=max(grid.den), $
           position=[0.82,0.1,0.84,0.9], ytitle='point density'
     print, 'max density: ' + FIX(max(grid.den))

     window, 3, title='Gridded Flattened Height Map'
     gd = where( grid.mean ne -9999, ngd, complement=bad )
     img = kdm_range( grid.mean, $
                      from=[min(grid.mean[gd]),max(grid.mean)], $
                      to=[1,253], under=254, over=254 )
     imdisp, img, /noscale, /axis, /erase, /order, $
             ;;xtitle='mm',ytitle='mm', $
             position=[0.1,0.1,0.8,0.9], /use_pos, $
             _EXTRA=e
     cbar, /vert, cmin=1,cmax=253,$
           ;;vmin=min(grid.mean[gd]),$
           ;;vmax=max(grid.mean[gd]), $
           vmin=0, vmax=max(grid.mean[gd])-min(grid.mean[gd]),$
           position=[0.82,0.1,0.84,0.9], $
           ytitle='m'

     dat = grid.mean 
     if bad[0] ne -1 then dat[bad] = mean(dat[gd])
     if keyword_set(smooth) then dat = median(dat,15)
     write_tiff, file+'.tif', bytscl(dat)
     spawn, 'gdaldem hillshade ' + $
            '-z ' + STRTRIM(z_scale,2) +' ' + $
            file+'.tif ' + file+'.shade.tif', $
            stdout, stderr
     spawn, 'open '+file+'.tif '+file+'.shade.tif'
  endif

end

kinect, /DISPLAY, /trim_pct
end
