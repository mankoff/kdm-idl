
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;; This object encapsulates the BalloonStyle
;; http://code.google.com/apis/kml/documentation/kmlreference.html#balloonstyle
;; 
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;; <BalloonStyle>
;; Syntax
;;
;; <BalloonStyle id="ID">
;;   <!-- specific to BalloonStyle -->
;;   <bgColor>ffffffff</bgColor>            <!-- kml:color -->
;;   <textColor>ff000000</textColor>        <!-- kml:color --> 
;;   <text>...</text>                       <!-- string -->
;;   <displayMode>default</displayMode>     <!-- kml:displayModeEnum -->
;; </BalloonStyle>
;;
;; Description
;; Specifies how the description balloon for placemarks is drawn. The
;; <bgColor>, if specified, is used as the background color of the
;; balloon. See <Feature> for a diagram illustrating how the default
;; description balloon appears in Google Earth. 
;; Elements Specific to BalloonStyle
;;
;; <bgColor>
;;     Background color of the balloon (optional). Color and opacity
;;     (alpha) values are expressed in hexadecimal notation. The range
;;     of values for any one color is 0 to 255 (00 to ff). The order
;;     of expression is aabbggrr, where aa=alpha (00 to ff); bb=blue
;;     (00 to ff); gg=green (00 to ff); rr=red (00 to ff). For alpha,
;;     00 is fully transparent and ff is fully opaque. For example, if
;;     you want to apply a blue color with 50 percent opacity to an
;;     overlay, you would specify the following:
;;     <bgColor>7fff0000</bgColor>, where alpha=0x7f, blue=0xff,
;;     green=0x00, and red=0x00. The default is opaque white
;;     (ffffffff).  
;; 
;; Note: The use of the <color> element within <BalloonStyle> has been
;; deprecated. Use <bgColor> instead. 
;; <textColor>
;;     Foreground color for text. The default is black (ff000000). 
;; <text>
;;     Text displayed in the balloon. If no text is specified, Google
;;     Earth draws the default balloon (with the Feature <name> in
;;     boldface, the Feature <description>, links for driving
;;     directions, a white background, and a tail that is attached to
;;     the point coordinates of the Feature, if specified). 
;;
;;     You can add entities to the <text> tag using the following
;;     format to refer to a child element of Feature: $[name],
;;     $[description], $[address], $[id], $[Snippet]. Google Earth
;;     looks in the current Feature for the corresponding string
;;     entity and substitutes that information in the balloon. To
;;     include To here - From here driving directions in the balloon,
;;     use the $[geDirections] tag. To prevent the driving directions
;;     links from appearing in a balloon, include the <text> element
;;     with some content, or with $[description] to substitute the
;;     basic Feature <description>.  
;; 
;;     For example, in the following KML excerpt, $[name] and
;;     $[description] fields will be replaced by the <name> and
;;     <description> fields found in the Feature elements that use
;;     this BalloonStyle:
;;
;; <text>This is $[name], whose description is:<br/>$[description]</text>
;; <displayMode>
;;     If <displayMode> is default, Google Earth uses the
;;     information supplied in <text> to create a balloon . If
;;     <displayMode> is hide, Google Earth does not display the
;;     balloon. In Google Earth, clicking the List View icon
;;     for a Placemark whose balloon's <displayMode> is hide
;;     causes Google Earth to fly to the Placemark.  
;;
;; Extends
;;     * <ColorStyle>
;;
;; Contained By
;;     * <Style>
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


pro kdm_kml_balloonstyle::KMLhead
  self->buildsource, '<BalloonStyle id="'+self.ID+'">'
end
pro kdm_kml_balloonstyle::KMLbody
  if self.bgcolor ne '' then self->buildsource, self->xmlTag( 'bgColor', self.bgColor )
  if self.x_textcolor ne '' then self->buildsource, self->xmlTag( 'textColor', self.x_textcolor )
  if self.text ne '' then self->buildsource, self->xmlTag( 'text', self.text )
  if self.displayMode ne '' then self->buildsource, self->xmlTag( 'displayMode', self.displayMode )
end
pro kdm_kml_balloonstyle::KMLtail
  self->buildsource, '</BalloonStyle>'
end

function kdm_kml_balloonstyle::init, _EXTRA=e
  if self->kdm_kml_colorstyle::init(_EXTRA=e) ne 1 then return, 0
  self->setProperty, _EXTRA=e
  return, 1
end
pro kdm_kml_balloonstyle::cleanup
  self->kdm_kml_colorstyle::cleanup
end 
pro kdm_kml_balloonstyle__define, class
  class = { kdm_kml_balloonstyle, $
            inherits kdm_kml_colorstyle, $
            bgcolor: '', $
            x_textcolor: '', $
            text: '', $
            displayMode: '' }
end

