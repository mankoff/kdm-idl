
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;; This object encapsulates the SubStyle
;; http://code.google.com/apis/kml/documentation/kmlreference.html#substyle
;; 
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

pro kdm_kml_substyle__define, class
  class = { kdm_kml_substyle, $
            inherits kdm_kml_object }
end

