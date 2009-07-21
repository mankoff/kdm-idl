function kdm_smooth_w_invalid, img, $
                               invalid=inv, $
                               scale_in=scale_in, $
                               _EXTRA=e

  if not keyword_set(scale_in) then scale_in = 25
  if not keyword_set(inv) then inv = min(img)
  
  scale = float(scale_in)
  sz = size( img, /dim )
  mask = CONGRID( img, sz[0]*scale, sz[1]*scale )
  inv_loc = WHERE( mask EQ inv, num_inv_loc )
  if num_inv_loc eq 0 then return, img

  gd_loc = WHERE( img NE inv)
  ix = gd_loc mod sz[0]
  iy = gd_loc / sz[0]
  TRIANGULATE, ix, iy, tr
  out = TRIGRID( ix, iy, img[ gd_loc ], tr, nx=sz[0]*scale, ny=sz[1]*scale )
  IF num_inv_loc GT 0 THEN out[ inv_loc ] = inv

  return, out
end
