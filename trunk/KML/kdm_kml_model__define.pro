pro kdm_kml_model::KMLhead
  self->kdm_kml_geometry::KMLhead
  self->buildsource, '<Model>'
end
pro kdm_kml_model::KMLbody
  self->kdm_kml_geometry::KMLbody
  self->buildsource, self->xmlTag( 'altitudeMode', self.x_altitudeMode )
  ;; Location
  self->buildsource, "<Location>"
  self->buildsource, self->xmlTag( 'longitude', self.longitude )
  self->buildsource, self->xmlTag( 'latitude', self.latitude )
  self->buildsource, self->xmlTag( 'altitude', self.altitude )
  self->buildsource, "</Location>"
  ;; Orientation
  self->buildsource, "<Orientation>"
  self->buildsource, self->xmlTag( 'heading', self.heading )
  self->buildsource, self->xmlTag( 'tilt', self.tilt )
  self->buildsource, self->xmlTag( 'roll', self.roll )
  self->buildsource, "</Orientation>"
  ;; Scale
  self->buildsource, "<Scale>"
  self->buildsource, self->xmlTag( 'x', self.x_scale )
  self->buildsource, self->xmlTag( 'y', self.y_scale )
  self->buildsource, self->xmlTag( 'z', self.z_scale )
  self->buildsource, "</Scale>"
  ;; Model URL
  self->buildsource, "<Link>"
  self->buildsource, self->xmlTag( 'href', self.link_href )
  self->buildsource, "</Link>"
  ;; other stuff
  self->buildsource, "<ResourceMap><Alias>"
  self->buildsource, self->xmlTag( 'targetHref', self.targetHref )
  self->buildsource, self->xmlTag( 'sourceHref', self.sourceHref )
  self->buildsource, "</Alias></ResourceMap>"
end
pro kdm_kml_model::KMLtail
  self->buildsource, '</Model>'
  self->kdm_kml_geometry::KMLtail
end


function kdm_kml_model::init, _EXTRA=e
  if self->kdm_kml_geometry::init(_EXTRA=e) ne 1 then return, 0
  self.x_scale = 1 & self.y_scale = 1 & self.z_scale = 1
  self.x_altitudeMode='absolute'
  self.id = "modelID"
  self->setProperty, _EXTRA=e
 return, 1
end
pro kdm_kml_model::cleanup
  self->kdm_kml_geometry::cleanup
end 
pro kdm_kml_model__define, class
  class = { kdm_kml_model, $
            inherits kdm_kml_geometry, $
            x_altitudeMode: '', $
            latitude: 0.0, $
            longitude: 0.0, $
            altitude: 0.0, $
            heading: 0.0, $
            tilt: 0.0, $
            roll: 0.0, $
            x_scale: 0.0, $
            y_scale: 0.0, $
            z_scale: 0.0, $
            link_href: '', $
            targetHref: '', $
            sourceHref: '' }
end

folder = obj_new('kdm_kml_folder')
alt = 0
for alt = 0, 4 do begin
   for ii = 0, 4 do begin
      for jj = 0, 4 do begin
         scale = 1e4*randomu(seed)*3
         heading = randomu(seed)*45-22.5
         p = obj_new( 'kdm_kml_placemark', $
                      x_altitude='relativeToGround', $
                      lat=ii, lon=jj )
         m = obj_new( 'kdm_kml_model', $
                      lat=ii, lon=jj, alt=alt*3e4, $
                      heading=heading, $
                      x_altitude='relativeToGround', $
                      x_scale=1e4, y=scale, z=1e4, $
                      link_href='./vec.dae' )
         p->add, m
         folder->add, p
      endfor
   endfor
endfor
doc = obj_new('kdm_kml_document')
doc->add, folder
kml = obj_new('kdm_kml', file='test.kml')
kml->add, doc
kml->saveKML, /openGE
end
