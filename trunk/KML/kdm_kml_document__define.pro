
pro kdm_kml_document::KMLhead
  self->kdm_kml_container::KMLhead
  self->buildsource, '<Document id="'+self.ID+'">'
end
pro kdm_kml_document::KMLbody
  self->kdm_kml_container::KMLbody
end
pro kdm_kml_document::KMLtail
  self->buildsource, '</Document>'
  self->kdm_kml_container::KMLtail
end

function kdm_kml_document::init, _EXTRA=e
  if self->kdm_kml_container::init(_EXTRA=e) ne 1 then return, 0
  self->setProperty, _EXTRA=e
  return, 1
end
pro kdm_kml_document::cleanup
  self->kdm_kml_container::cleanup
end 

;; A Document IsA Container and contains one or more feature elements
pro kdm_kml_document__define, class
  class = { kdm_kml_document, $
            inherits kdm_kml_container }
end

;;o = obj_new('kdm_kml_document', id='doc0' )
;; o->add, obj_new('kdm_kml_container', id='c0', name='CC')
;;o->saveKML
;;end
