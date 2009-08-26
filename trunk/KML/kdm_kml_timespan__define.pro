pro kdm_kml_timespan::KMLhead
  self->kdm_kml_timeprimitive::KMLhead
  ;;self->buildsource, '<!-- Timespan -->'
  self->buildsource, '<TimeSpan id="'+self.ID+'">'
end
pro kdm_kml_timespan::KMLbody
  self->kdm_kml_timeprimitive::KMLbody
  if self.timebegin ne '' then $
     self->buildsource, self->xmlTag( 'begin', self.timebegin )
  if self.timeend ne '' then $
     self->buildsource, self->xmlTag( 'end', self.timeend )
end
pro kdm_kml_timespan::KMLtail
  self->buildsource, '</TimeSpan>'
  self->kdm_kml_timeprimitive::KMLtail
end


function kdm_kml_timespan::init, _EXTRA=e
  if self->kdm_kml_timeprimitive::init(_EXTRA=e) ne 1 then return, 0
  self->setProperty, _EXTRA=e
 return, 1
end
pro kdm_kml_timespan::cleanup
  self->kdm_kml_timeprimitive::cleanup
end 
pro kdm_kml_timespan__define, class
  class = { kdm_kml_timespan, $
            inherits kdm_kml_timeprimitive, $
            timebegin: '', $
            timeend: '' }
end

