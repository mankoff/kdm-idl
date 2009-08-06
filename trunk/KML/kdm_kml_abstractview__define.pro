
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;; This object encapsulates the AbstractView
;; http://code.google.com/apis/kml/documentation/kmlreference.html#abstractview
;; 
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; 
;; <AbstractView>
;; Syntax
;;;
;; <!-- abstract element; do not create -->
;; <!-- AbstractView -->                   <!-- Camera, LookAt --> 
;;   <!-- extends Object -->
;;   <TimePrimitive>...</TimePrimitive> <!-- gx:TimeSpan or gx:TimeStamp -->
;; <-- /AbstractView -->
;;
;; Description
;;
;; This is an abstract element and cannot be used directly in a KML
;; file. This element is extended by the <Camera> and <LookAt>
;; elements. 
;;
;; Extends
;;     * <Object>
;;
;; Extended By
;;     * <Camera>
;;     * <LookAt>
;; 
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

pro kdm_kml_abstractview__define, class
  class = { kdm_kml_abstractview, $
            inherits kdm_kml_object }
end

