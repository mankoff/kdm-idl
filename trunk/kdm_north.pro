
pro kdm_north, lon=lon, lat=lat, _EXTRA=e

  ns = [!map.ll_box[0],!map.ll_box[2]]
  ew = [!map.ll_box[1],!map.ll_box[3]]
  x0 = keyword_set(lon) ? lon : kdm_range( 0.2, from=[0.0,1.0], to=minmax(ew))
  y0 = keyword_set(lat) ? lat : kdm_range( 0.8, from=[0.0,1.0], to=minmax(ns))

  offset = (max(ns)-min(ns))*0.1
  line = map_2points( x0, y0, x0, y0+offset, dpath=1, _EXTRA=e )
  plots, line, _EXTRA=e
  arrow, x0, y0+offset-0.0000001, x0, y0+offset, /data, _EXTRA=e;, hsize=8, _EXTRA=e
  xyouts, x0, y0+offset, " N!c", charsize=2, align=0.0, color=255, _EXTRA=e
end

aoeu
nbp_map_set, /amundsen
;MAP_SET, /MOLLWEIDE, 40,-50, /GRID, SCALE=75e6,/CONTINENTS  
;kdm_north, lat=-74.9, lon=-101.75
kdm_north, color=253, thick=2, charth=2
load_pig_front, lat, lon
plots, lon, lat
map_continents
map_grid, /box_axes, glinestyle=0
end
