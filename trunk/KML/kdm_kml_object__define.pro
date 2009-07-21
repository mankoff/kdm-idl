
function kdm_kml_object::init, id=id, _EXTRA=e
  if self->kdm_kml::init() ne 1 then return, 0
  if not keyword_set(id) then id = 'ID'
  id = STRJOIN(STRSPLIT(id,/extract))
  ;self->setProperty, filename='kdm_kml.kml', newline=10B
  self->setProperty, id=id, _EXTRA=e
  return, 1
end
pro kdm_kml_object::cleanup
  ;; obj_destroy, child_objects
  ;; ptr_free, ptrs
  self->kdm_kml::cleanup
end 
pro kdm_kml_object__define, class
  class = { kdm_kml_object, $
            id: '', $
            inherits kdm_kml }
end

o = obj_new('kdm_kml_object', id='objID')
o->saveKML
end
