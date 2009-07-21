pro kdm_kml_groundoverlay::KMLhead, kml=kml
  self->kdm_kml_overlay::KMLhead, kml=kml
  self->buildsource, kml, '<GroundOverlay id="'+self.ID+'">'
end
pro kdm_kml_groundoverlay::KMLbody, kml=kml
  self->kdm_kml_overlay::KMLbody, kml=kml
  self->buildsource, kml, "<!-- Groundoverlay Body -->"
  
  self->buildsource, kml, self->xmlTag( 'altitude', self.altitude )
  self->buildsource, kml, self->xmlTag( 'altitudeMode', self.x_altitudemode )
  self->buildsource, kml, '<LatLonBox>'
  self->buildsource, kml, self->xmlTag( 'north', self.north )
  self->buildsource, kml, self->xmlTag( 'south', self.south )
  self->buildsource, kml, self->xmlTag( 'east', self.east )
  self->buildsource, kml, self->xmlTag( 'west', self.west )
  self->buildsource, kml, self->xmlTag( 'rotation', self.rotation )
  self->buildsource, kml, '</LatLonBox>'
  
end
pro kdm_kml_groundoverlay::KMLtail, kml=kml
  self->buildsource, kml, '</GroundOverlay>'
  self->kdm_kml_overlay::KMLtail, kml=kml
end

function kdm_kml_groundoverlay::init, _EXTRA=e
  if self->kdm_kml_overlay::init(_EXTRA=e) ne 1 then return, 0
  self->setProperty, _EXTRA=e
  return, 1
end
pro kdm_kml_groundoverlay::cleanup
  self->kdm_kml_overlay::cleanup
end 
pro kdm_kml_groundoverlay__define, class
  class = { kdm_kml_groundoverlay, $
            inherits kdm_kml_overlay, $
            altitude: 0, $
            x_altitudemode: '', $
            ;; boundaries nested in LatLonBox
            north: 0, south: 0, east: 0, west: 0, rotation: 0 }
end

