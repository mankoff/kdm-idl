;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;; This object encapsulates the Object
;; http://code.google.com/apis/kml/documentation/kmlreference.html#object
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; 
;; <Object>
;; Syntax
;; <!-- abstract element; do not create -->
;; <!-- Object id="ID" targetId="NCName" -->
;; <!-- /Object> -->
;;
;; Description
;;
;; This is an abstract base class and cannot be used directly in a KML
;; file. It provides the id attribute, which allows unique
;; identification of a KML element, and the targetId attribute, which
;; is used to reference objects that have already been loaded into
;; Google Earth. The id attribute must be assigned if the <Update>
;; mechanism is to be used.
;;
;; <Overlay>
;; Syntax
;;
;; <!-- abstract element; do not create -->
;; <!-- Overlay id="ID" -->                    <!-- GroundOverlay,ScreenOverlay -->
;;   <!-- inherited from Feature element -->
;;   <name>...</name>                      <!-- string -->
;;   <visibility>1</visibility>            <!-- boolean -->
;;   <open>0</open>                        <!-- boolean -->
;;   <atom:author>...<atom:author>         <!-- xmlns:atom -->
;;   <atom:link href=" "/>            <!-- xmlns:atom -->
;;   <address>...</address>                <!-- string -->
;;   <xal:AddressDetails>...</xal:AddressDetails>  <!-- xmlns:xal -->
;;   <phoneNumber>...</phoneNumber>        <!-- string -->
;;   <Snippet maxLines="2">...</Snippet>   <!-- string -->
;;   <description>...</description>        <!-- string -->
;;   <AbstractView>...</AbstractView>      <!-- Camera or LookAt -->
;;   <TimePrimitive>...</TimePrimitive>
;;   <styleUrl>...</styleUrl>              <!-- anyURI -->
;;   <StyleSelector>...</StyleSelector>
;;   <Region>...</Region>
;;   <Metadata>...</Metadata>              <!-- deprecated in KML 2.2 -->
;;   <ExtendedData>...</ExtendedData>      <!-- new in KML 2.2 -->
;;
;;   <!-- specific to Overlay -->
;;   <color>ffffffff</color>                   <!-- kml:color -->
;;   <drawOrder>0</drawOrder>                  <!-- int -->
;;   <Icon>
;;     <href>...</href>
;;   </Icon>
;; <!-- /Overlay -->
;;
;; Description
;;
;; This is an abstract element and cannot be used directly in a KML
;; file. <Overlay> is the base type for image overlays drawn on the
;; planet surface or on the screen. <Icon> specifies the image to use
;; and can be configured to reload images based on a timer or by
;; camera changes. This element also includes specifications for
;; stacking order of multiple overlays and for adding color and
;; transparency values to the base image. 
;;
;; Elements Specific to Overlay
;;
;; <color>
;;     Color values are expressed in hexadecimal notation, including
;;     opacity (alpha) values. The order of expression is alpha, blue,
;;     green, red (aabbggrr). The range of values for any one color is
;;     0 to 255 (00 to ff). For opacity, 00 is fully transparent and
;;     ff is fully opaque. For example, if you want to apply a blue
;;     color with 50 percent opacity to an overlay, you would specify
;;     the following: <color>7fff0000</color> 
;;
;; Note: The <geomColor> element has been deprecated. Use <color> instead.
;; <drawOrder>
;;     This element defines the stacking order for the images in
;;     overlapping overlays. Overlays with higher <drawOrder> values
;;     are drawn on top of overlays with lower <drawOrder> values. 
;; <Icon> See also <Icon>.
;;     Defines the image associated with the Overlay. The <href>
;;     element defines the location of the image to be used as the
;;     Overlay. This location can be either on a local file system or
;;     on a web server. If this element is omitted or contains no
;;     <href>, a rectangle is drawn using the color and size defined
;;     by the ground or screen overlay. 
;;
;;     <Icon>
;;        <href>icon.jpg</href>
;;     </Icon>
;;
;; Extends
;;     <Feature>
;;
;; Extended By
;;     <GroundOverlay>
;;     <PhotoOverlay>
;;     <ScreenOverlay>
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


function kdm_kml_object::init, id=id, _EXTRA=e
  if self->kdm_kml::init() ne 1 then return, 0
  if not keyword_set(id) then id = 'ID'
  id = STRJOIN(STRSPLIT(id,/extract))
  self->setProperty, id=id, _EXTRA=e
  return, 1
end
pro kdm_kml_object::cleanup
  ;; obj_destroy, child_objects
  ;; ptr_free, ptrs
  self->kdm_kml::cleanup
end 
pro kdm_kml_object__define, class
  class = { kdm_kml_object, $
            id: '', $
            inherits kdm_kml }
end

