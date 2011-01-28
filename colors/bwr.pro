
;; convert BlueWhiteRed.pa1 to BlueWRed, where there is only 1 white
;; pixel in the middle
pro bwr
  openr, lun, 'BlueWhiteRed.pa1', /get_lun
  r = ( g = ( b = bindgen(256) ) )
  data = assoc( lun, r )
  r = data[0] & g = data[1] & b = data[2]
  free_lun, lun

  ;; bottom color is black or user-specified
  if not keyword_set(c0) then c0 = 0
  r[0] = ( g[0] = (b[0] = c0 ) )
  r[1] = ( g[1] = (b[1] = c0 ) )

  if not keyword_set(c255) then c255 = 255
  r[255] = ( g[255] = ( b[255] = c255 ) )

  if not keyword_set(c254) then c254 = 128 ;; gray, invalid
  r[254] = ( g[254] = ( b[254] = c254 ) )

  ;; 256 colors total. 0 is black, 255 is white, 254 is gray, and one
  ;; in the middle should be white. That leaves 252, or 2x126.

;;   ss = STRTRIM(FIX(r),2) + STRTRIM(fix(g),2) + strtrim(fix(b),2)
;;   IDL> print, ss(uniq(ss))
;;   000 515217 3280255 66151255 109193255 134218255 157239255 175246255 
;;   207255255 255255255 255255102 2552360 2551960 2551530 2551020 25500 
;;   21300 15900 128128128 255255255
  ;;
  ;; Other than black, gray, and white there are 16 colors, 8 in the
  ;; lower segment, 8 in the upper

  print, where( r eq 255 AND g eq 255 AND b eq 255 )
;;   121         122         123         124         125         126
;;   127         128         129         130         131         132
;;   133         134         255

  ;;lower
  old = makex( 1, 120, 1 )
  new = makex( 1, 127, 1 )
  r[ new ] = congrid( r[old], n_elements(new) );
  g[ new ] = congrid( g[old], n_elements(new) ) ;
  b[ new ] = congrid( b[old], n_elements(new) );
  ;; upper
  old = makex( 135, 253, 1 )
  new = makex( 129, 254, 1 )
  r[ new ] = congrid( r[old], n_elements(new) );
  g[ new ] = congrid( g[old], n_elements(new) ) ;
  b[ new ] = congrid( b[old], n_elements(new) );

  tvlct,r,g,b
  imdisp, indgen(16,16)

  openw, lun, 'BlueWRed.pa1', /get_lun
  data = assoc( lun, r )
  data[0] = r & data[1] = g & data[2] = b
  free_lun, lun
  
  loadct, 0, /silent
  kdm_loadct, 'BlueWRed'
  erase
  imdisp, indgen(16,16)

return


  ;; restart, and this time no white.

  openr, lun, 'BlueWhiteRed.pa1', /get_lun
  r = ( g = ( b = bindgen(256) ) )
  data = assoc( lun, r )
  r = data[0] & g = data[1] & b = data[2]
  free_lun, lun

  ;; bottom color is black or user-specified
  if not keyword_set(c0) then c0 = 0
  r[0] = ( g[0] = (b[0] = c0 ) )

  if not keyword_set(c255) then c255 = 255
  r[255] = ( g[255] = ( b[255] = c255 ) )

  if not keyword_set(c254) then c254 = 128 ;; gray, invalid
  r[254] = ( g[254] = ( b[254] = c254 ) )


  ;;lower
  old = makex( 1, 120, 1 )
  new = makex( 1, 128, 1 )
  r[ new ] = congrid( r[old], n_elements(new) );
  g[ new ] = congrid( g[old], n_elements(new) ) ;
  b[ new ] = congrid( b[old], n_elements(new) );
  ;; upper
  old = makex( 135, 253, 1 )
  new = makex( 128, 254, 1 )
  r[ new ] = congrid( r[old], n_elements(new) );
  g[ new ] = congrid( g[old], n_elements(new) ) ;
  b[ new ] = congrid( b[old], n_elements(new) );

  tvlct,r,g,b
  imdisp, indgen(16,16)

  openw, lun, 'BlueRed.pa1', /get_lun
  data = assoc( lun, r )
  data[0] = r & data[1] = g & data[2] = b
  free_lun, lun
  
  loadct, 0, /silent
  kdm_loadct, 'BlueRed'
  erase
  imdisp, indgen(16,16)

end
bwr
end
