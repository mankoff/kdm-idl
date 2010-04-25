pro kdm_kml_container::KMLhead
  self->kdm_kml_feature::KMLhead
  ;;self->buildsource, '<!-- Container -->'
end
pro kdm_kml_container::KMLbody
  self->kdm_kml_feature::KMLbody
  ;;self->buildsource, "<!-- Container Body -->"
end
pro kdm_kml_container::KMLtail
  ;;self->buildsource, '<!-- /Container -->'
  self->kdm_kml_feature::KMLtail
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
