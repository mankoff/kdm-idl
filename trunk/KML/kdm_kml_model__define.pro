pro kdm_kml_model::KMLhead, kml=kml
  self->kdm_kml_geometry::KMLhead, kml=kml
  self->buildsource, kml, '<Model>'
end
pro kdm_kml_model::KMLbody, kml=kml
  self->kdm_kml_geometry::KMLbody, kml=kml
  self->buildsource, kml, self->xmlTag( 'altitudeMode', self.x_altitudeMode )
  ;; Location
  self->buildsource, kml, "<Location>"
  self->buildsource, kml, self->xmlTag( 'longitude', self.longitude )
  self->buildsource, kml, self->xmlTag( 'latitude', self.latitude )
  self->buildsource, kml, self->xmlTag( 'altitude', self.altitude )
  self->buildsource, kml, "</Location>"
  ;; Orientation
  self->buildsource, kml, "<Orientation>"
  self->buildsource, kml, self->xmlTag( 'heading', self.heading )
  self->buildsource, kml, self->xmlTag( 'tilt', self.tilt )
  self->buildsource, kml, self->xmlTag( 'roll', self.roll )
  self->buildsource, kml, "</Orientation>"
  ;; Scale
  self->buildsource, kml, "<Scale>"
  self->buildsource, kml, self->xmlTag( 'x', self.x_scale )
  self->buildsource, kml, self->xmlTag( 'y', self.y_scale )
  self->buildsource, kml, self->xmlTag( 'z', self.z_scale )
  self->buildsource, kml, "</Scale>"
  ;; Model URL
  self->buildsource, kml, "<Link>"
  self->buildsource, kml, self->xmlTag( 'href', self.link_href )
  self->buildsource, kml, "</Link>"
  ;; other stuff
  self->buildsource, kml, "<ResourceMap><Alias>"
  self->buildsource, kml, self->xmlTag( 'targetHref', self.targetHref )
  self->buildsource, kml, self->xmlTag( 'sourceHref', self.sourceHref )
  self->buildsource, kml, "</Alias></ResourceMap>"
end
pro kdm_kml_model::KMLtail, kml=kml
  self->buildsource, kml, '</Model>'
  self->kdm_kml_geometry::KMLtail, kml=kml
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
