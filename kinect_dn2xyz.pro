
;;   img = kinect_record_depth( file )
;;   depth = DN2dist(img)
;;   DN2world, depth, x,y,z

pro kinect_dn2xyz, dn, x,y,z, file=file

  k1 = 1.1863d
  k2 = 2842.5d
  k3 = 0.1236d
  z = k3 * tan( double(dn) / k2 + k1)
  
  ;;http://graphics.stanford.edu/~mdfisher/Kinect.html
  sz = SIZE( dn, /dim )
  x  = dindgen(sz[0]) # (dblarr(sz[1]) + 1)
  y  = (dblarr(sz[0]) + 1) # (dindgen(sz[1]))
  
  ;; https://groups.google.com/group/openni-dev/browse_thread/thread/5ac8d1effec8048
  FovH=1.0144686707507438  ;; (rad)
  FovV=0.78980943449644714 ;; (rad)
  XtoZ=tan(FovH/2)*2
  YtoZ=tan(FovV/2)*2
  Xres = 640
  Yres = 480
  x_proj = x
  y_proj = y
  
  x=(X_proj/Xres-.5)*Z*XtoZ
  y=(0.5-Y_proj/Yres)*(-Z)*YtoZ
  
  if keyword_set(file) then begin
     save, x,y,z,dn, file=file+'.sav'
     openw, lun, file, /get
     for i=0L, n_elements(x)-1 do begin
        printf, lun, x[i],y[i],z[i]
     endfor
     free_lun, lun
  endif
end

