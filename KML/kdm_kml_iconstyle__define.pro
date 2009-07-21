;; <Style>
;;   <IconStyle>
;;     <color>ff0078ff</color>
;;     <scale>1.55</scale>
;;     <Icon>
;;       <href>circle.png</href>
;;     </Icon>
;;   </IconStyle>
;; </Style>
pro kdm_kml_iconstyle::KMLhead, kml=kml
  ;;self->kdm_kml_::KMLhead, kml=kml
  self->buildsource, kml, '<Style id="'+self.ID+'">'
  self->buildsource, kml, '<IconStyle>'
  if self.scale ne 0 then self->buildsource, kml,  self->xmlTag( 'scale', self.scale )
  if self.color ne '' then self->buildsource, kml,  self->xmlTag( 'color', self.color )
  self->buildsource, kml, '<Icon id="'+self.ID+'">'
end
pro kdm_kml_iconstyle::KMLbody, kml=kml
  ;;self->kdm_kml_container::KMLbody, kml=kml
  self->buildsource, kml,  self->xmlTag( 'href', self.href )
end
pro kdm_kml_iconstyle::KMLtail, kml=kml
  self->buildsource, kml, '</Icon>'
  self->buildsource, kml, '</IconStyle>'
  self->buildsource, kml, '</Style>'
  ;;self->kdm_kml_container::KMLtail, kml=kml
end

pro kdm_kml_iconstyle::setProperty, color=color, _EXTRA=e
  if keyword_set(color) then c = 'FF'+STRJOIN(to_hex( color, 2 ))
  self->kdm_kml_object::setProperty, color=c, _EXTRA=e
end
function kdm_kml_iconstyle::init, _EXTRA=e
  if self->kdm_kml_object::init(_EXTRA=e) ne 1 then return, 0
  self->setProperty, _EXTRA=e
  return, 1
end
pro kdm_kml_iconstyle::cleanup
  ;;self->kdm_kml_object::cleanup
end 

pro kdm_kml_iconstyle__define, class
  class = { kdm_kml_iconstyle, $
            color: '', $
            scale: 0.0, $
            href: '', $
            inherits kdm_kml_object }
end

