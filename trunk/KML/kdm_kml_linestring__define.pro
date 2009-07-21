pro kdm_kml_linestring::KMLhead, kml=kml
  self->kdm_kml_geometry::KMLhead, kml=kml
  self->buildsource, kml, '<LineString id="'+self.ID+'">'
end
pro kdm_kml_linestring::KMLbody, kml=kml
  self->kdm_kml_geometry::KMLbody, kml=kml
  self->buildsource, kml, self->xmlTag( 'extrude', self.extrude*1 )
  self->buildsource, kml, self->xmlTag( 'altitudeMode', self.x_altitudeMode )
  self->buildsource, kml, self->xmlTag( 'coordinates', self.coordinates )
end
pro kdm_kml_linestring::KMLtail, kml=kml
  self->buildsource, kml, '</LineString>'
  self->kdm_kml_geometry::KMLtail, kml=kml
end

pro kdm_kml_linestring::setproperty, lat=lat, lon=lon, alt=alt, _EXTRA=e
  if keyword_set( e ) then self->kdm_kml_geometry::setProperty, _EXTRA=e
  if keyword_set(lat) then begin
     self.coordinates = ''
     for i = 0, n_elements(lat)-1 do begin
        self.coordinates = self.coordinates + STRTRIM(lon[i],2) + ','+ STRTRIM(lat[i],2)
        if keyword_set(alt) then self.coordinates = self.coordinates + ',' + STRTRIM(LONG(alt[i]),2)
        self.coordinates = self.coordinates + ' '
     endfor
  endif
end

function kdm_kml_linestring::init, _EXTRA=e
  if self->kdm_kml_geometry::init(_EXTRA=e) ne 1 then return, 0
  self->setProperty, x_altitudeMode='relativeToGround', $
                     extrude=1, $
                     tesselate=1, $
                     _EXTRA=e
 return, 1
end
pro kdm_kml_linestring::cleanup
  self->kdm_kml_geometry::cleanup
end 
pro kdm_kml_linestring__define, class
  class = { kdm_kml_linestring, $
            inherits kdm_kml_geometry, $
            extrude: 0B, $
            tesselate: 0B, $
            x_altitudeMode: '', $ ; clampToGround, relativeToGround, or absolut OR clampToSeaFloor, relativeToSeaFloor
            coordinates: '' }
end

