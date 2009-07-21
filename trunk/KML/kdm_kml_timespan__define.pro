pro kdm_kml_timespan::KMLhead, kml=kml
  self->kdm_kml_timeprimitive::KMLhead, kml=kml
  ;;self->buildsource, kml, '<!-- Timespan -->'
  self->buildsource, kml, '<TimeSpan id="'+self.ID+'">'
end
pro kdm_kml_timespan::KMLbody, kml=kml
  self->kdm_kml_timeprimitive::KMLbody, kml=kml
  if self.timebegin ne '' then $
     self->buildsource, kml, self->xmlTag( 'begin', self.timebegin )
  if self.timeend ne '' then $
     self->buildsource, kml, self->xmlTag( 'end', self.timeend )
end
pro kdm_kml_timespan::KMLtail, kml=kml
  self->buildsource, kml, '</TimeSpan>'
  ;;self->buildsource, kml, '<!-- /TimeSpan -->'
  self->kdm_kml_timeprimitive::KMLtail, kml=kml
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

