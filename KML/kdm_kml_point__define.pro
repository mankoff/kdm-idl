pro kdm_kml_point::KMLhead, kml=kml
  self->kdm_kml_geometry::KMLhead, kml=kml
  ;;self->buildsource, kml, '<!-- Point -->'
  self->buildsource, kml, '<Point id="'+self.ID+'">'
end
pro kdm_kml_point::KMLbody, kml=kml
  self->kdm_kml_geometry::KMLbody, kml=kml
  self->buildsource, kml, self->xmlTag( 'extrude', self.extrude*1 )
  self->buildsource, kml, self->xmlTag( 'altitudeMode', self.x_altitudeMode )
  coordinates = STRTRIM(self.longitude,2) + ',' + $
                STRTRIM(self.latitude,2) + ',' + $
                STRTRIM(self.altitude,2)
  self->buildsource, kml, self->xmlTag( 'coordinates', coordinates )
end
pro kdm_kml_point::KMLtail, kml=kml
  self->buildsource, kml, '</Point>'
  ;;self->buildsource, kml, '<!-- /Point -->'
  self->kdm_kml_geometry::KMLtail, kml=kml
end


function kdm_kml_point::init, _EXTRA=e
  if self->kdm_kml_geometry::init(_EXTRA=e) ne 1 then return, 0
  self.x_altitudeMode='relativeToGround'
  self->setProperty, _EXTRA=e
 return, 1
end
pro kdm_kml_point::cleanup
  self->kdm_kml_geometry::cleanup
end 
pro kdm_kml_point__define, class
  class = { kdm_kml_point, $
            inherits kdm_kml_geometry, $
            extrude: 0B, $
            x_altitudeMode: '', $ ; clampToGround, relativeToGround, or absolut OR clampToSeaFloor, relativeToSeaFloor
            altitude: 0.0, $
            longitude: 0.0, $
            latitude: 0.0 }
end

;; o = obj_new('kdm_kml_point', id='pointID', $
;;             latitude=42, lon=-30, $
;;             altitude=3758.4, $
;;             x_altitudeMode='relativeToGround', $
;;             filename='foo.kml' )
;; o->buildKML
;; end
