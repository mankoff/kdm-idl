;;
;; This object encapsulates the PolyStyle
;; http://code.google.com/apis/kml/documentation/kmlreference.html#polystyle
;; 
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;; <PolyStyle>
;; Syntax
;;
;; <PolyStyle id="ID">
;;   <!-- inherited from ColorStyle -->
;;   <color>ffffffff</color>            <!-- kml:color -->
;;   <colorMode>normal</colorMode>      <!-- kml:colorModeEnum: normal or random -->
;;   <!-- specific to PolyStyle -->
;;   <fill>1</fill>                     <!-- boolean -->
;;   <outline>1</outline>               <!-- boolean -->
;; </PolyStyle>
;;
;; Description
;;
;; Specifies the drawing style for all polygons, including polygon
;; extrusions (which look like the walls of buildings) and line
;; extrusions (which look like solid fences). 
;;
;; Elements Specific to PolyStyle
;; <fill>
;;     Boolean value. Specifies whether to fill the polygon. 
;; <outline>
;;     Boolean value. Specifies whether to outline the
;;     polygon. Polygon outlines use the current LineStyle.  
;;
;; Extends
;;     * <ColorStyle>
;;
;; Contained By
;;     * <Style>
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


pro kdm_kml_polystyle::KMLhead
  self->buildsource, '<PolyStyle id="'+self.ID+'">'
end
pro kdm_kml_polystyle::KMLbody
  self->kdm_kml_colorstyle::KMLbody
  self->buildsource, self->xmlTag( 'fill', self.fill )
  self->buildsource, self->xmlTag( 'outline', self.outline )
end
pro kdm_kml_polystyle::KMLtail
  self->buildsource, '</PolyStyle>'
end

function kdm_kml_polystyle::init, _EXTRA=e
  if self->kdm_kml_colorstyle::init(_EXTRA=e) ne 1 then return, 0
  self->setProperty, fill=1, outline=1
  self->setProperty, _EXTRA=e
  return, 1
end
pro kdm_kml_polystyle::cleanup
  self->kdm_kml_colorstyle::cleanup
end 
pro kdm_kml_polystyle__define, class
  class = { kdm_kml_polystyle, $
            inherits kdm_kml_colorstyle, $
            fill: 0, $
            outline: 0 }
end
