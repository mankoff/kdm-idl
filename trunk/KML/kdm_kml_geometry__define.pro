pro kdm_kml_geometry::KMLhead
  ;;self->buildsource, '<!-- Geometry id="'+self.ID+'" -->'
  ;kdm_callstack
end
;; pro kdm_kml_geometry::KMLbody, kml=kml
;;   ;; 
;; end
pro kdm_kml_geometry::KMLtail
  ;;self->buildsource, '<!-- /Geometry -->'
end

function kdm_kml_geometry::init, _EXTRA=e
  if self->kdm_kml_object::init(_EXTRA=e) ne 1 then return, 0
  self->setProperty, _EXTRA=e
  return, 1
end
pro kdm_kml_geometry::cleanup
  self->kdm_kml_object::cleanup
end 
pro kdm_kml_geometry__define, class
  class = { kdm_kml_geometry, $
            inherits kdm_kml_object }
end

;; o = obj_new('kdm_kml_geometry', id='geomID', name='TheGeometry')
;; o->print
;; end
