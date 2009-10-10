
function s87::init, file, _EXTRA=e
  if self->ctd::init() ne 1 then return, 0
  if keyword_set(file) then self->load, file
  self->setProperty, _EXTRA=e
  return, 1
end

pro s87::display, _EXTRA=e
  self->ctd::display, title=self->getProperty(/note)
end

pro s87::load, file
  openr, lun, file, /get_lun
  line = ''
  readf, lun, line & hdr0 = line
  readf, lun, line & hdr1 = line
  readf, lun, line & hdr2 = line
  readf, lun, line & hdr3 = line
  nl = STRING(BYTE(10))
  hdr = hdr0+nl+hdr1+nl+hdr2+nl+hdr3

  data = STRSPLIT( hdr0, /EXTRACT )
  lat = data[3] & lon = data[4]
  dates = STRSPLIT( data[5], "/", /EXTRACT )
  yr = dates[0] & mm = dates[1] & day=dates[2]
  doy = data[6]
  times = STRSPLIT( data[7], ":", /EXTRACT )
  hr = times[0] & min = times[1]

  self->setProperty, hdr=hdr, lat=lat, lon=lon
  dt = self->getProperty(/kdm_dt)
  dt->setProperty, year=yr, month=mm, day=day, doy=doy, hour=hr, minute=min

  while not eof( lun ) do begin
     readf, lun, line
     data = STRSPLIT( line, /EXTRACT )
     d = arrconcat( d, data[0] )
     t = arrconcat( t, data[1] )
     s = arrconcat( s, data[2] )
  endwhile
  free_lun, lun
  self->setProperty, depth=float(d), temp=float(t), salt=float(s)
  
  kdm_filepathext, file, root=root
  self->setProperty, note=root
end

pro s87__define, class
  class = { s87, inherits ctd }
end

;;o = obj_new('s87')
;;o->load, "/Users/mankoff/UCSC/ASEP/ODEN/kdm_s87/Cast11.s87"
;;o->display
;;help, (o->getProperty(/kdm_dt))->getProperty(/all), /st
;;end

;;o = obj_new('s87', "/Users/mankoff/UCSC/ASEP/ODEN/kdm_s87/Cast11.s87")
;;o->display
;;help, (o->getProperty(/kdm_dt))->getProperty(/all), /st
;;end
