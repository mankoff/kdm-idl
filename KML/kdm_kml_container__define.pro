pro kdm_kml_container::KMLhead, kml=kml
  self->kdm_kml_feature::KMLhead, kml=kml
  self->buildsource, kml, '<!-- Container -->'
end
pro kdm_kml_container::KMLbody, kml=kml
  self->kdm_kml_feature::KMLbody, kml=kml
  self->buildsource, kml, "<!-- Container Body -->"
end
pro kdm_kml_container::KMLtail, kml=kml
  self->buildsource, kml, '<!-- /Container -->'
  self->kdm_kml_feature::KMLtail, kml=kml
end

function kdm_kml_container::init, _EXTRA=e
  if self->kdm_kml_feature::init(_EXTRA=e) ne 1 then return, 0
  self->setProperty, _EXTRA=e
  return, 1
end
pro kdm_kml_container::cleanup
  self->kdm_kml_feature::cleanup
end 
pro kdm_kml_container__define, class
  class = { kdm_kml_container, $
            inherits kdm_kml_feature }
  ;; a container isa feature and contains 0 or more features
end

o = obj_new('kdm_kml_container', id='cont0ID', name='Container One')
o->add, obj_new('kdm_kml_feature', id='cont1ID', name='Container Two' )
;o->print
end
