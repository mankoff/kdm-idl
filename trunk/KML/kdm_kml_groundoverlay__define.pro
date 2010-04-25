pro kdm_kml_groundoverlay::KMLhead
  self->kdm_kml_overlay::KMLhead
  self->buildsource, '<GroundOverlay id="'+self.ID+'">'
end
pro kdm_kml_groundoverlay::KMLbody
  self->kdm_kml_overlay::KMLbody
  ;;self->buildsource, "<!-- Groundoverlay Body -->"
  
  self->buildsource, self->xmlTag( 'altitude', self.altitude )
  self->buildsource, self->xmlTag( 'altitudeMode', self.x_altitudemode )
  self->buildsource, '<LatLonBox>'
  self->buildsource, self->xmlTag( 'north', self.north )
  self->buildsource, self->xmlTag( 'south', self.south )
  self->buildsource, self->xmlTag( 'east', self.east )
  self->buildsource, self->xmlTag( 'west', self.west )
  self->buildsource, self->xmlTag( 'rotation', self.rotation )
  self->buildsource, '</LatLonBox>'
  
end
pro kdm_kml_groundoverlay::KMLtail
  self->buildsource, '</GroundOverlay>'
  self->kdm_kml_overlay::KMLtail
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

