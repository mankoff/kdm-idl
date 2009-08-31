pro kdm_kml_timestamp::KMLhead
  self->kdm_kml_timeprimitive::KMLhead
  ;;self->buildsource, '<!-- Timestamp -->'
  self->buildsource, '<TimeStamp id="'+self.ID+'">'
end
pro kdm_kml_timestamp::KMLbody
  self->kdm_kml_timeprimitive::KMLbody
  if self.when ne '' then $
     self->buildsource, self->xmlTag( 'when', self.when )
end
pro kdm_kml_timestamp::KMLtail
  self->buildsource, '</TimeStamp>'
  self->kdm_kml_timeprimitive::KMLtail
end


function kdm_kml_timestamp::init, _EXTRA=e
  if self->kdm_kml_timeprimitive::init(_EXTRA=e) ne 1 then return, 0
  self->setProperty, _EXTRA=e
 return, 1
end
pro kdm_kml_timestamp::cleanup
  self->kdm_kml_timeprimitive::cleanup
end 
pro kdm_kml_timestamp__define, class
  class = { kdm_kml_timestamp, $
            inherits kdm_kml_timeprimitive, $
            when: '' }
end

