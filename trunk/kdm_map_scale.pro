;+
;
; NAME:
;	KDM_MAP_SCALE
;
; PURPOSE:
;   Provide a scale (legend) for a map
;
; CATEGORY:
;   Map, Imaging
;
; CALLING SEQUENCE:
;   KDM_MAP_SCALE
;
; KEYWORD PARAMETERS:
;   X: location (in units [0,1]) of X position of scale
;
;   Y: location (in units [0,1]) of Y position of scale
;
;   HIGHLIGHT: Set this keyword to try to make the text stand out
;              against the background of the map
;
; RESTRICTIONS:
;   Map coordinates must be defined (with, for example, MAP_SET)
;
; PROCEDURE:
;   1) pick a point at (0.1, 0.1) from south west corner of map
;   2) convert /norm coordinates to lat/lon
;   3) pick a point at (0.3, 0.1) due east of first point
;   4) convert /norm to lat/lon
;   5) get distance between points in m
;   6) find nearest round number of format [1-9][0*]
;   7) find error between measured distance rounded goal number
;   8) adjust second point by error
;   9) repeat untill err < err_limit
;   10) draw line from (x0,y0) to newly determined (x1,y0) location
;     equal to nice round distance
;   11) add legend
;
; EXAMPLE:
;   map_set, 41, -74.5, /ortho, scale=3e6         ; near NY
;   map_continents, /hi, /states, /US, color=254
;   kdm_map_scale, x=0.1 ; explicitely set the X location
;
;   OR
;
;   map_set, /ortho, /iso ; the whole globe!
;   map_continents
;   kdm_map_scale, x=0.1, y=0.4 ; select X and Y locations
;
; MODIFICATION HISTORY:
; 	Written by:	Ken Mankoff, 2009.
;   2010-02-02: KDM Added documentation.
;-

pro kdm_map_scale, x=x, y=y, $
                   highlight=highlight, $
                   _EXTRA=e

  ;; range of existing map
  ns = [!map.ll_box[0],!map.ll_box[2]]
  ew = [!map.ll_box[1],!map.ll_box[3]]

  ;; height and width of map
  height_lat = max(ns)-min(ns)
  width_lon = max(ew)-min(ew)
  ;; find the percentage location of 10% in from bottom left of map
  lat0 = convert_coord( min(ew)+width_lon*0.1, $
                        min(ns)+height_lat*0.1, $
                        /data, /to_norm )
  ;; convert location to data coordinates
  x0 = ( keyword_set(x) ? x : lat0[0] )
  y0 = ( keyword_set(y) ? y : lat0[1] )
  c0 = convert_coord( x0, y0, /norm, /to_data )
  
  x1 = x0 + 0.20 ;; scale should cover around 20% of the map
  
  err_pct = 0
  err_limit = 0.001d
  idx = 0
  while abs(1-err_pct) ge err_limit do begin
     c = convert_coord( x1, y0, /norm, /to_data )
     m = map_2points( c0[0], c0[1], c[0], c[1], /meters )
     if not finite(m) then begin
        message, "Points not found on map", /CONTINUE
        return
     endif
     mm = STRTRIM( STRING(ROUND(m), FORMAT='(I100)'), 2)

     l = STRLEN( mm )
     goal = round(mm/(10d^(l-1)))*10d^(l-1)

     err_m = goal - m
     err_pct = goal / m

     ;if _debug then print, m, ' ', mm, goal, err_m, err_pct
     ;; distance from c0[0] to c[0] is m meters
     ;; we want it to be km/10^3 meters
     ;; error is err_m, which is also err_pct
     ;; => distance from x0 to x1 is off by err_pct
     ;; => adjust x1 by err_pct
     old = x1
     x1 = ( x1 - x0 ) * err_pct + x0
     idx++
     if idx ge 15 then stop

  endwhile
  
  c0 = convert_coord( x0, y0, /norm, /to_data )
  c1 = convert_coord( x1, y0, /norm, /to_data )
  line = map_2points( c0[0], c0[1], c1[0], c1[1], dpath=1, _EXTRA=e )
  plots, line, $
         ;;color=253, $
         thick=2, $
         _EXTRA=e

  m = map_2points( c0[0], c0[1], c[0], c[1], /meters )
  mm = STRTRIM( STRING(ROUND(m), FORMAT='(I10)'), 2)
  l = STRLEN( mm )
  goal = round(mm/(10d^(l-1)))*10d^(l-1)
  ;if _debug then print, mm, goal

  suffix = ([ 'm', 'km' ])[goal ge 1e3]
  scale =  ([  1., 1.e3  ])[goal ge 1e3]
  ;if _debug then print, goal, suffix, scale, goal/scale
  goal_str = STRTRIM( round( goal/scale), 2 ) + ' ' + suffix
  

  if keyword_set(highlight) then begin
     xyoutsbg, (x0+x1)/2., y0+0.005, $
               goal_str, $
               align=0.5, $
               /norm, $
               _EXTRA=e
  ENDIF else begin
     xyouts, (x0+x1)/2., y0+0.005, $
               goal_str, $
               align=0.5, $
               /norm, $
               _EXTRA=e
  endelse

end
