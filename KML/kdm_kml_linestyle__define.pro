;;
;; This object encapsulates the LineStyle
;; http://code.google.com/apis/kml/documentation/kmlreference.html#linestyle
;; 
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;; <LineStyle>
;; Syntax
;;
;; <LineStyle id="ID">
;;   <!-- inherited from ColorStyle -->
;;   <color>ffffffff</color>        <!-- kml:color -->
;;   <colorMode>normal</colorMode>  <!-- colorModeEnum: normal or random -->
;;
;;   <!-- specific to LineStyle -->
;;   <width>1</width>                   <!-- float -->
;; </LineStyle>
;;
;; Description
;;
;; Specifies the drawing style (color, color mode, and line width) for
;; all line geometry. Line geometry includes the outlines of outlined
;; polygons and the extruded "tether" of Placemark icons (if extrusion
;; is enabled). 
;;
;; Elements Specific to LineStyle
;;
;; <width>
;;     Width of the line, in pixels.
;;
;; Extends
;;     * <ColorStyle>
;;
;; Contained By
;;     * <Style>
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


pro kdm_kml_linestyle::KMLhead
  self->buildsource, '<LineStyle id="'+self.ID+'">'
end
pro kdm_kml_linestyle::KMLbody
  self->kdm_kml_colorstyle::KMLbody
  self->buildsource, self->xmlTag( 'width', self.width )
end
pro kdm_kml_linestyle::KMLtail
  self->buildsource, '</LineStyle>'
end

function kdm_kml_linestyle::init, _EXTRA=e
  if self->kdm_kml_colorstyle::init(_EXTRA=e) ne 1 then return, 0
  self->setProperty, width=1
  self->setProperty, _EXTRA=e
  return, 1
end
pro kdm_kml_linestyle::cleanup
  self->kdm_kml_colorstyle::cleanup
end 
pro kdm_kml_linestyle__define, class
  class = { kdm_kml_linestyle, $
            inherits kdm_kml_colorstyle, $
            width: 0.0 }
end

