pro kdm_kml_linestring::KMLhead
  self->kdm_kml_geometry::KMLhead
  self->buildsource, '<LineString id="'+self.ID+'">'
end
pro kdm_kml_linestring::KMLbody
  self->kdm_kml_geometry::KMLbody
  self->buildsource, self->xmlTag( 'extrude', self.extrude*1 )
  self->buildsource, self->xmlTag( 'tessellate', self.tessellate*1 )
  self->buildsource, self->xmlTag( 'altitudeMode', self.x_altitudeMode )
  self->buildsource, self->xmlTag( 'coordinates', self.coordinates )
end
pro kdm_kml_linestring::KMLtail
  self->buildsource, '</LineString>'
  self->kdm_kml_geometry::KMLtail
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
                     tessellate=1, $
                     _EXTRA=e
 return, 1
end
pro kdm_kml_linestring::cleanup
  self->kdm_kml_geometry::cleanup
end 
pro kdm_kml_linestring__define, class
  class = { kdm_kml_linestring, $
            inherits kdm_kml_geometry, $
            extrude: 0, $
            tessellate: 0, $
            x_altitudeMode: '', $ ; clampToGround, relativeToGround, or absolut OR clampToSeaFloor, relativeToSeaFloor
            coordinates: '' }
end



;; testing code
kml = obj_new('kdm_kml', file='kdm_kml_linestring.kml')
d = obj_new( 'kdm_kml_document', visibility=1 )
f = obj_new( 'kdm_kml_folder', id='folder1', name='aFolder', visib=1 )
ls1 = obj_new('kdm_kml_placemark', lat=indgen(10)*(-2), lon=indgen(10)*2, $
              alt=indgen(10)*1e5, $
              x_altitudeMode='relativeToGround', visibility=1, tesselate=0 )
ls1->add, obj_new( 'kdm_kml_timespan', timebegin=1950 )
f->add, ls1
d->add, f
kml->add, d
kml->saveKML, /openGE
end

