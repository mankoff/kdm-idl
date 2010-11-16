pro kdm_kml_polygon::KMLhead
  self->kdm_kml_geometry::KMLhead
  self->buildsource, '<Polygon id="'+self.ID+'">'
end
pro kdm_kml_polygon::KMLbody
  self->kdm_kml_geometry::KMLbody
  self->buildsource, self->xmlTag( 'extrude', self.extrude*1 )
  self->buildsource, self->xmlTag( 'tessellate', self.tessellate*1 )
  self->buildsource, self->xmlTag( 'altitudeMode', self.x_altitudeMode )
end
pro kdm_kml_polygon::KMLtail
  self->buildsource, '</Polygon>'
  self->kdm_kml_geometry::KMLtail
end

pro kdm_kml_polygon::setproperty , _EXTRA=e
  if keyword_set( e ) then self->kdm_kml_geometry::setProperty, _EXTRA=e
end

function kdm_kml_polygon::init, _EXTRA=e
  if self->kdm_kml_geometry::init(_EXTRA=e) ne 1 then return, 0
  self->setProperty, x_altitudeMode='relativeToGround', $
                     extrude=1, $
                     tessellate=1, $
                     _EXTRA=e
 return, 1
end
pro kdm_kml_polygon::cleanup
  self->kdm_kml_geometry::cleanup
end 
pro kdm_kml_polygon__define, class
  class = { kdm_kml_polygon, $
            inherits kdm_kml_geometry, $
            x_altitudeMode: '', $ ; clampToGround, relativeToGround, or absolut OR clampToSeaFloor, relativeToSeaFloor
            extrude: 0, $
            tessellate: 0 }
end

