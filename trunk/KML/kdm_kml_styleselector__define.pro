
;; This object encapsulates the StyleSelector
;; http://code.google.com/apis/kml/documentation/kmlreference.html#styleselector
;; 
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;; <StyleSelector>
;; Syntax
;;
;; <!-- abstract element; do not create -->
;; <!-- StyleSelector id="ID" -->                 <!-- Style,StyleMap -->
;; <!-- /StyleSelector -->
;;
;; Description
;;
;; This is an abstract element and cannot be used directly in a KML
;; file. It is the base type for the <Style> and <StyleMap>
;; elements. The StyleMap element selects a style based on the current
;; mode of the Placemark. An element derived from StyleSelector is
;; uniquely identified by its id and its url. 
;;
;; Elements Specific to StyleSelector
;;
;; This abstract element does not contain any child elements.
;; Extends
;;
;;     * <Object>
;;
;; Extended By
;;
;;     * <Style>
;;     * <StyleMap>
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

pro kdm_kml_styleselector__define, class
  class = { kdm_kml_styleselector, $
            inherits kdm_kml_object }
end

