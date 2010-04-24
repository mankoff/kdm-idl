
function kdm_flightpath, $
   lat0=lat0, lon0=lon0, lat1=lat1, lon1=lon1, $
   _EXTRA=e
  
  ;; maximum possible distance between two points
  ;; maxD = distance_sphere( 90,0,-90,0 )*1e3 ; [m] 

  n = 100

  ;; Distance between two endpoints
  dist = distance_sphere( lat0,lon0,lat1,lon1 )*1e3
  maxAlt = dist / 10 ;; a reasonable value for the top of the arch.

  ;; path between start and end
  result = map_2points( lon0, lat0, lon1, lat1, npath=100, _EXTRA=e)

  lats = result[1,*]
  lons = result[0,*]
  rangecir, lons
  ;; alt is half a sine curve
  alt =  findgen(n)/n * !pi
  alts = maxAlt * sin( alt ) 

  ;; return a structure for the hop
  path = { alts:alts, lats:lats, lons:lons }
  return, path
end

pro kdm_flightpath_test
;; testing code
lat1 = randomu( seed, 200 ) * 180-90
lon1 = randomu( seed, 200 ) * 360;-180
lat0 = randomu( seed, 200 ) * 180-90
lon0 = randomu( seed, 200 ) * 360;-180

k = obj_new('kdm_kml', file='flight.kml')
d = obj_new('kdm_kml_document')
f = obj_new('kdm_kml_folder')

for i = 0, n_elements( lat1 )-1 do begin
   path = kdm_flightpath( lat0=lat0[i], lon0=lon0[i], lat1=lat1[i],lon1=lon1[i] )
   ;;path = kdm_flightpath( lat0=37, lon0=-120, lat1=37,lon1=-122 )
   line = obj_new('kdm_kml_placemark', lat=path.lats, lon=path.lons, $
                  alt=path.alts, extrude=0, $
                  x_altitudeMode='absolute', visibility=1, tesselate=1 )
   f->add, line
endfor
d->add, f
k->add, d
k->saveKML, /openGE
end

kdm_flightpath_test
end
