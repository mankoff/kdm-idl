pro kdm_kml_timeprimitive::KMLhead
  ;;self->buildsource, '<!-- Timeprimitive id="'+self.ID+'" -->'
end
pro kdm_kml_timeprimitive::KMLbody
end
pro kdm_kml_timeprimitive::KMLtail
  ;;self->buildsource, '<!-- /Timeprimitive -->'
end

function kdm_kml_timeprimitive::init, _EXTRA=e
  if self->kdm_kml_object::init(_EXTRA=e) ne 1 then return, 0
  self->setProperty, _EXTRA=e
  return, 1
end
pro kdm_kml_timeprimitive::cleanup
  self->kdm_kml_object::cleanup
end 
pro kdm_kml_timeprimitive__define, class
  class = { kdm_kml_timeprimitive, $
            inherits kdm_kml_object }
end
