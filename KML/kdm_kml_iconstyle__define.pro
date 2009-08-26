;; <Style>
;;   <IconStyle>
;;     <color>ff0078ff</color>
;;     <scale>1.55</scale>
;;     <Icon>
;;       <href>circle.png</href>
;;     </Icon>
;;   </IconStyle>
;; </Style>
pro kdm_kml_iconstyle::KMLhead
  ;;self->kdm_kml_::KMLhead
  ;;self->buildsource, '<Style id="'+self.ID+'">'
  self->buildsource, '<IconStyle>'
  if self.scale ne 0 then self->buildsource, self->xmlTag( 'scale', self.scale )
  if self.color ne '' then self->buildsource, self->xmlTag( 'color', self.color )
  self->buildsource, '<Icon id="'+self.ID+'">'
end
pro kdm_kml_iconstyle::KMLbody
  self->buildsource,  self->xmlTag( 'href', self.href )
end
pro kdm_kml_iconstyle::KMLtail
  self->buildsource, '</Icon>'
  self->buildsource, '</IconStyle>'
end

pro kdm_kml_iconstyle::setProperty, color=color, _EXTRA=e
  if keyword_set(color) then c = 'FF'+STRJOIN(to_hex( color, 2 ))
  self->kdm_kml_colorstyle::setProperty, color=c, _EXTRA=e
end
function kdm_kml_iconstyle::init, _EXTRA=e
  if self->kdm_kml_colorstyle::init(_EXTRA=e) ne 1 then return, 0
  self->setProperty, _EXTRA=e
  return, 1
end
pro kdm_kml_iconstyle::cleanup
  ;;self->kdm_kml_colorstyle::cleanup
end 

pro kdm_kml_iconstyle__define, class
  class = { kdm_kml_iconstyle, $
            inherits kdm_kml_colorstyle, $
            scale: 0.0, $
            href: '' }
end

