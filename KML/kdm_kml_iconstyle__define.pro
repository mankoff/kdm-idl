
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;; http://code.google.com/apis/kml/documentation/kmlreference.html#iconstyle
;;

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
  if self.xunits ne '' and $
     self.yunits ne '' then begin
     self->buildSource, '<hotSpot ' + $
                        'x="' + STRTRIM(self.hotSpotX,2) + '" ' + $
                        'y="' + STRTRIM(self.hotSpotY,2) + '" ' + $
                        'xunits="' + self.xunits + '" ' + $
                        'yunits="' + self.yunits + '"/>'
  endif
  self->buildsource, '</IconStyle>'
end

pro kdm_kml_iconstyle::setProperty, color=color, _EXTRA=e
  if keyword_set(color) then begin
     if n_elements(color) eq 3 then cc = [255,color] else cc=color
     c = STRJOIN(to_hex( cc, 2 ))
  endif
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
            hotSpotX: 0.0, $
            hotSpotY: 0.0, $
            xunits: '', $
            yunits: '', $
            href: '' }
end

