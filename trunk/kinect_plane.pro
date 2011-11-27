pro kinect_plane, $
   x_in,y_in,z_in, $            ; 2D arrays
   plane, flat, $
   _EXTRA=e

  x = x_in & y=y_in & z=z_in

  gd = where( z gt 0, complement=bad )
  x = x[gd] & y=y[gd] & z=z[gd]

  Xcolv = transpose(x)          ; % Make X a column vector
  Ycolv = transpose(y)          ; % Make Y a column vector
  Zcolv = transpose(z)          ; % Make Z a column vector
  Const = Xcolv*0+1             ; % Vector of ones for constant term
  
  a = [ Xcolv, Ycolv, Const ]
  b = Zcolv
  coefficients = la_least_squares(a,b)
  
  XCoeff = Coefficients(0)      ; % X coefficient
  YCoeff = Coefficients(1)      ; % X coefficient
  CCoeff = Coefficients(2)      ; % constant term

  sz = size( z_in, /dim )
  xr = kdm_range( makex( 0, sz[0]-1, 1 ), from=[0,sz[0]-1], to=minmax(x) )
  yc = kdm_range( makex( 0, sz[1]-1, 1 ), from=[0,sz[1]-1], to=minmax(y) )
  XX = XR # (YC*0 + 1)          ;         eqn. 1
  YY = (XR*0 + 1) # YC          ;         eqn. 2
  zz = xCoeff*xx + Ycoeff*yy + CCoeff

  zzz = xCoeff*x_in + Ycoeff*y_in 
  plane = zzz ;;-mean(zz)
  flat = z_in-plane
end

