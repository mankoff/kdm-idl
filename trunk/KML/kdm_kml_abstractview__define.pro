
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


pro kdm_kml_object::addRandomLookAt, $
   longitude=longitude, latitude=latitude, $
   altitude=altitude, x_altitudeMode=x_altitudeMode, $
   heading=heading, tilt=tilt, range=range, $
   ;; above are KML tags. Below are user-level hints
   near=near, mid=mid, far=far, $
   ;;
   _EXTRA=e
  
  CASE OBJ_CLASS( self ) OF
     'KDM_KML_PLACEMARK': BEGIN
        pointObj = (self->getProperty(/children))
        pointObj->getProperty, latitude=latitude, $
                               longitude=longitude, $
                               altitude=altitude, $
                               x_altitudeMode=x_altitudeMode
        message, 'PLACEMARK', /CONTINUE
     END
     default: BEGIN
        MESSAGE, "addRandomLookAt not yet implemented for this object"
     END
  ENDCASE

  ;; mid is default
  rangehint = [1e3,1e6]
  IF keyword_set( near ) then rangehint = [1e2,1e3]
  if keyword_set( far ) then rangehint = [1e5,1e7]
     
  kdm_isdefined, longitude, default=longitude
  kdm_isdefined, latitude, default=latitude
  kdm_isdefined, altitude, default=altitude
  kdm_isdefined, x_altitudeMode, default=x_altitudeMode
  kdm_isdefined, heading, default=RANDOMU(seed,1) * 360
  kdm_isdefined, tilt, default=KDM_RANGE( RANDOMU(seed,1), from=[0,1], to=[30, 75] )
  kdm_isdefined, range, default=KDM_RANGE( RANDOMU(seed,1), from=[0,1], to=rangehint )
  
  la = obj_new( 'kdm_kml_lookat', $
                longitude=longitude, latitude=latitude, $
                altitude=altitude, altitudeMode=x_altitudeMode, $
                heading=heading, tilt=tilt, range=range, $
                _EXTRA=e )
  self->add, la
end


pro kdm_kml_abstractview__define, class
  class = { kdm_kml_abstractview, $
            inherits kdm_kml_object }
end



;; testing code
pro test_arla ; addRandomLookAt
  k = obj_new('kdm_kml', file='test.kml')
  p = obj_new('kdm_kml_placemark', lat=42, lon=42)
  p->addRandomLookAt, /near
  k->add, p
  k->saveKML, /openGE
end


test_arla
end
