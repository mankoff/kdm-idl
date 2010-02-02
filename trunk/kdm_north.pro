;+
;
; NAME:
;	KDM_NORTH
;
; PURPOSE:
;   This procedure puts a North arrow (and letter N) on a map
;   indicating which way is North.
;
; CATEGORY:
;   Map, Imaging
;
; CALLING SEQUENCE:
;   KDM_NORTH
;
; KEYWORD PARAMETERS:
;   LON: The desired longitude of the tail of the arrow
;   LAT: The desired latitude of the tail of the arrow
;
; SIDE EFFECTS:
;   Draws an arrow and the letter "N" on the current map display
;
; RESTRICTIONS:
;   Must have a map projection set up (for example, with MAP_SET)
;
; PROCEDURE:
;   1) Find the lat/lon bounds of the map
;   2) If no lat/lon for arrow tail specified, then use the point at
;     (0.2, 0.8) (where (0,0) is the bottom left and (1,1) is the top
;     right corner of the map)
;   3) Calculate an offset so the arrow is 10% of the map
;   4) Convert the head and tail to a great circle path (map_2points)
;   5) Plot it, add the arrow, and add the letter "N"
;
; EXAMPLE:
;   MAP_SET, /MOLLWEIDE, 40,-50, /GRID, SCALE=75e6,/CONTINENTS  
;   map_continents
;   map_grid, glinestyle=0, color=254
;   kdm_north, color=253, thick=4, charth=4 ; default location
;   KDM_NORTH, lon=0, lat=0                 ; at (0,0)
;
; MODIFICATION HISTORY:
; 	Written by:	Ken Mankoff, 2009-02.
;   2010-02-02: KDM Added documentation. Fixed bug where setting lat=0
;                   or lon=0 used default location instead.
;-

pro kdm_north, lon=lon, lat=lat, _EXTRA=e

  ns = [!map.ll_box[0],!map.ll_box[2]]
  ew = [!map.ll_box[1],!map.ll_box[3]]
  x0 = n_elements(lon) ? lon : kdm_range( 0.2, from=[0.0,1.0], to=minmax(ew))
  y0 = n_elements(lat) ? lat : kdm_range( 0.8, from=[0.0,1.0], to=minmax(ns))

  offset = (max(ns)-min(ns))*0.1
  line = map_2points( x0, y0, x0, y0+offset, dpath=1, _EXTRA=e )
  plots, line, _EXTRA=e
  arrow, x0, y0+offset-0.0000001, x0, y0+offset, /data, _EXTRA=e;, hsize=8, _EXTRA=e
  xyouts, x0, y0+offset, " N!c", charsize=2, align=0.0, color=255, _EXTRA=e
end

MAP_SET, /MOLLWEIDE, 40,-50, /GRID, SCALE=75e6,/CONTINENTS  
map_continents
map_grid, glinestyle=0, color=254
kdm_north, color=253, thick=4, charth=4
KDM_NORTH, lon=0, lat=0
end
