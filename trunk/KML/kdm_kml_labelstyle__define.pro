;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;; This object encapsulates the LabelStyle
;; http://code.google.com/apis/kml/documentation/kmlreference.html#labelstyle
;; 
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

pro kdm_kml_labelstyle::KMLhead
  self->buildsource, '<LabelStyle>'
end
pro kdm_kml_labelstyle::KMLbody
  ;;if self.scale eq 0 then MESSAGE, "Setting label scale to 0", /CONTINUE
  self->buildsource, self->xmlTag( 'scale', self.scale )
end
pro kdm_kml_labelstyle::KMLtail
  self->buildsource, '</LabelStyle>'
end

function kdm_kml_labelstyle::init, _EXTRA=e
  if self->kdm_kml_object::init(_EXTRA=e) ne 1 then return, 0
  self->setProperty, _EXTRA=e
  return, 1
end
pro kdm_kml_labelstyle::cleanup
  self->kdm_kml_object::cleanup
end 
pro kdm_kml_labelstyle__define, class
  class = { kdm_kml_labelstyle, $
            inherits kdm_kml_colorstyle, $
            scale: 0.0 }
end

