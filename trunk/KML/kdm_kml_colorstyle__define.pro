;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;; This object encapsulates the ColorStyle
;; http://code.google.com/apis/kml/documentation/kmlreference.html#colorstyle
;; 
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;; <ColorStyle>
;; Syntax
;;
;; <!-- abstract element; do not create -->
;; <!-- ColorStyle id="ID" --><!-- IconStyle,LabelStyle,LineStyle,PolyStyle -->
;;   <color>ffffffff</color>   <!-- kml:color -->
;;   <colorMode>normal</colorMode><!-- kml:colorModeEnum: normal or random -->
;; <!-- /ColorStyle -->
;;
;; Description
;;
;; This is an abstract element and cannot be used directly in a KML
;; file. It provides elements for specifying the color and color mode
;; of extended style types. 
;;
;; Elements Specific to ColorStyle
;;
;; <color>
;;     Color and opacity (alpha) values are expressed in hexadecimal
;;     notation. The range of values for any one color is 0 to 255 (00
;;     to ff). For alpha, 00 is fully transparent and ff is fully
;;     opaque. The order of expression is aabbggrr, where aa=alpha (00
;;     to ff); bb=blue (00 to ff); gg=green (00 to ff); rr=red (00 to
;;     ff). For example, if you want to apply a blue color with 50
;;     percent opacity to an overlay, you would specify the following:
;;     <color>7fff0000</color>, where alpha=0x7f, blue=0xff,
;;     green=0x00, and red=0x00. 
;; <colorMode>
;;     Values for <colorMode> are normal (no effect) and random. A
;;     value of random applies a random linear scale to the base
;;     <color> as follows.  
;;
;;     * To achieve a truly random selection of colors, specify a base
;;     <color> of white (00ffffff). 
;;     * If you specify a single color component (for example, a value
;;     of ff0000ff for red), random color values for that one
;;     component (red) will be selected. In this case, the values
;;     would range from 00 (black) to ff (full red). 
;;     * If you specify values for two or for all three color
;;     components, a random linear scale is applied to each color
;;     component, with results ranging from black to the maximum
;;     values specified for each component. 
;;     * The opacity of a color comes from the alpha component of
;;     <color> and is never randomized. 
;;
;; Extends
;;     * <Object>
;;
;; Extended By
;;     * <IconStyle>
;;     * <LabelStyle>
;;     * <LineStyle>
;;     * <PolyStyle>
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;



pro kdm_kml_colorstyle::KMLhead
end
pro kdm_kml_colorstyle::KMLbody
  if self.color ne '' then $
     self->buildsource, self->xmlTag( 'color', self.color )
  if self.x_colormode ne '' then $
     self->buildsource, self->xmlTag( 'colormode', self.x_colormode )
end
pro kdm_kml_colorstyle::KMLtail
end

function kdm_kml_colorstyle::init, _EXTRA=e
  if self->kdm_kml_object::init(_EXTRA=e) ne 1 then return, 0
  self->setProperty, _EXTRA=e
  return, 1
end
pro kdm_kml_colorstyle::cleanup
  self->kdm_kml_object::cleanup
end 
pro kdm_kml_colorstyle__define, class
  class = { kdm_kml_colorstyle, $
            inherits kdm_kml_substyle, $
            color: '', $
            x_colorMode: '' }
end

