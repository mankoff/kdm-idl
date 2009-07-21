pro kdm_map_vect, lat,lon,u,v, $
                  scale=scale, $
                  _EXTRA=e

  _scale = keyword_set(scale) ? scale : 1.0

;; problem: Have lat/lon and u/v (m/s) data set. Want on map
;; Map should be of any scale, dimension, and/or rotation.
;;
;; Option: True to map or true to eye
;;
;; True to map:
;; * Set lat,lon to tail (x0,y0)
;; * Convert to device units (pixels, cm)
;; * Find head(lat,lon) = tail+[ (u*scale),+(v*scale) ]
;; * Plot
;;
;; True to eye:
;; * True to map = unit circle warped no map. True to eye = true unit circle

x0 = lon
y0 = lat
tail = convert_coord( x0, y0, /data, /to_device )
x0 = tail[0,*]
y0 = tail[1,*]

mag = ( u^2 + v^2 )^0.5
dir = atan( v/u )

x1 = x0 + u*_scale ;; cosv scales, and these are not scaled
y1 = y0 + v*_scale
;head = convert_coord( x1, y1, /a, /to_device )
;x1 = head[0,*]
;y1 = head[1,*]

;; mag = sqrt( u^2 + v^2 )
;; dir = atan( v/u )
;; print, mag
;; scale=90
;scale = scale * kdm_range(mag,from=minmax(mag),to=[0.001,1])
;; x1 = u*scale
;; y1 = v*scale

;;     ll0 = convert_coord( sadcp.lon, sadcp.lat, /data, /to_norm ) 
     ;;ll1 = convert_coord( x1, y1, /data, /to_norm )
;;     x1 = cos(dir*!dtor) * mag * scale
;;     y1 = sin(dir*!dtor) * mag * scale


arrow, x0,y0,x1,y1, $
       ;color=100, $
       _EXTRA=e

end ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


;; A = FINDGEN(17) * (!PI*2/16.)  
;; u = cos(a)
;; v = sin(a)
;; lon = u*0
;; lat = v*0+40
;; scale = 90

;; map_set, 0,0, /ortho, /iso
;; map_continents
;; map_grid, glinestyle=0

;; kdm_map_vect, lat,lon,u,v, $
;;               color=253, $
;;               thick=3, $
;;               scale = scale, $
;;               _EXTRA=e
;;end
