pro kdm_kml_overlay::KMLhead
  self->kdm_kml_feature::KMLhead
  ;;self->buildsource, '<!-- Overlay -->'
end
pro kdm_kml_overlay::KMLbody
  self->kdm_kml_feature::KMLbody
  ;;self->buildsource, "<!-- Overlay Body -->"
  self->buildsource, self->xmlTag( 'color', self.color )
  self->buildsource, self->xmlTag( 'drawOrder', self.draworder )
  self->buildsource, $ ;; nested href inside icon tags
     self->xmlTag( 'Icon', self->xmlTag( 'href', self.href ) )
end
pro kdm_kml_overlay::KMLtail
  ;;self->buildsource, '<!-- /Overlay -->'
  self->kdm_kml_feature::KMLtail
end

function kdm_kml_overlay::init, _EXTRA=e
  if self->kdm_kml_feature::init(_EXTRA=e) ne 1 then return, 0
  self->setProperty, _EXTRA=e
  return, 1
end
pro kdm_kml_overlay::cleanup
  self->kdm_kml_feature::cleanup
end 
pro kdm_kml_overlay__define, class
  class = { kdm_kml_overlay, $
            inherits kdm_kml_feature, $
            color: '', $
            draworder: 0, $
            href: '' $ ;; nested in <Icon>
          }
end

