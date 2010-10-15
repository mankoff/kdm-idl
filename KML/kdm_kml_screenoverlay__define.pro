;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;; http://code.google.com/apis/kml/documentation/kmlreference.html#screenoverlay
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;; Notes:
;; * ICON is in HREF in the kdm_kml_overlay object
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

pro kdm_kml_ScreenOverlay::KMLhead
  self->kdm_kml_feature::KMLhead
  self->buildsource, '<ScreenOverlay>'
end
pro kdm_kml_ScreenOverlay::KMLbody
  self->kdm_kml_feature::KMLbody

  self->buildsource, $ ;; nested href inside icon tags
     self->xmlTag( 'Icon', $
                   self->xmlTag( 'href', self->kdm_kml_overlay::getProperty(/href) ) )


  self->buildsource, '<overlayXY ' + $
                     ' x="'+STRTRIM(self.overlayXYx,2)+'"' + $
                     ' y="'+STRTRIM(self.overlayXYy,2)+'"' + $
                     ' xunits="'+self.overlayXY_xunits+'"' + $
                     ' yunits="'+self.overlayXY_yunits+'" />'

  self->buildsource, '<screenXY ' + $
                     ' x="'+STRTRIM(self.screenXYx,2)+'"' + $
                     ' y="'+STRTRIM(self.screenXYy,2)+'"' + $
                     ' xunits="'+self.screenXY_xunits+'"' + $
                     ' yunits="'+self.screenXY_yunits+'" />'

  self->buildsource, '<size ' + $
                     ' x="'+STRTRIM(self.sizex,2)+'"' + $
                     ' y="'+STRTRIM(self.sizey,2)+'"' + $
                     ' xunits="'+self.size_xunits+'"' + $
                     ' yunits="'+self.size_yunits+'" />'

  self->buildsource, '<rotationXY ' + $
                     ' x="'+STRTRIM(self.rotationXYx,2)+'"' + $
                     ' y="'+STRTRIM(self.rotationXYy,2)+'"' + $
                     ' xunits="'+self.rotationXY_xunits+'"' + $
                     ' yunits="'+self.rotationXY_yunits+'" />'
  self->buildsource, self->xmlTag( 'rotation', self.x_rotation )
end
pro kdm_kml_ScreenOverlay::KMLtail
  self->buildsource, '</ScreenOverlay>'
  self->kdm_kml_feature::KMLtail
end

function kdm_kml_ScreenOverlay::init, _EXTRA=e
  if self->kdm_kml_feature::init(_EXTRA=e) ne 1 then return, 0
  self->setProperty, overlayXY_xunits='fraction', $
                     overlayXY_yunits='fraction', $
                     screenXY_xunits='fraction', $
                     screenXY_yunits='fraction', $
                     size_xunits='fraction', $
                     size_yunits='fraction', $
                     rotationXY_xunits='fraction', $
                     rotationXY_yunits='fraction'
  self->setProperty, _EXTRA=e
  return, 1
end
pro kdm_kml_ScreenOverlay::cleanup
  self->kdm_kml_feature::cleanup
end 
pro kdm_kml_ScreenOverlay__define, class
  ;; ICON is in HREF in the kdm_kml_overlay object
  class = { kdm_kml_screenoverlay, $
            inherits kdm_kml_overlay, $
            overlayXYx: 0.0, $
            overlayXYy: 0.0, $
            overlayXY_xunits: '', $
            overlayXY_yunits: '', $

            screenXYx: 0.0, $
            screenXYy: 0.0, $
            screenXY_xunits: '', $
            screenXY_yunits: '', $

            sizex: 0.0, $
            sizey: 0.0, $
            size_xunits: '', $
            size_yunits: '', $

            rotationXYx: 0.0, $
            rotationXYy: 0.0, $
            rotationXY_xunits: '', $
            rotationXY_yunits: '', $

            x_rotation: 0.0 $
          }
end


;; TESTING CODE
icon = 'http://kml-samples.googlecode.com/svn/trunk/resources/top_left.jpg'
o = obj_new('kdm_kml_screenoverlay', $
            overlayXYx=1, overlayXYy=0, overlayxy_xunits='fraction', $
            ;;sizex=500, size_xunits='pixels', $
            screenxyx=1, screenxyy=0, $
            href=icon )
kml = obj_new('kdm_kml', file='test.kml')
kml->add, o
kml->saveKML, /openGE, hint='mars'
end
