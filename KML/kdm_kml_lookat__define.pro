
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;; This object encapsulates LookAt
;; http://code.google.com/apis/kml/documentation/kmlreference.html#lookat
;; 
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;; <LookAt>
;; Syntax
;;
;; <LookAt id="ID">
;;   <!-- inherited from AbstractView element -->
;;   <TimePrimitive>...</TimePrimitive>  <!-- gx:TimeSpan or gx:TimeStamp --> 
;;   <!-- specific to LookAt -->
;;   <longitude>0</longitude>            <!-- kml:angle180 -->
;;   <latitude>0</latitude>              <!-- kml:angle90 -->
;;   <altitude>0</altitude>              <!-- double --> 
;;   <heading>0</heading>                <!-- kml:angle360 -->
;;   <tilt>0</tilt>                      <!-- kml:anglepos90 -->
;;   <range></range>                     <!-- double -->
;;   <altitudeMode>clampToGround</altitudeMode> 
;;  <!--kml:altitudeModeEnum:clampToGround, relativeToGround, absolute -->
;;  <!-- or, gx:altitudeMode can be substituted: clampToSeaFloor, relativeToSeaFloor -->
;;
;; </LookAt>
;;
;; Description
;; Defines a virtual camera that is associated with any element
;; derived from Feature. The LookAt element positions the "camera" in
;; relation to the object that is being viewed. In Google Earth, the
;; view "flies to" this LookAt viewpoint when the user double-clicks
;; an item in the Places panel or double-clicks an icon in the 3D
;; viewer. 
;;
;; Elements Specific to LookAt
;; <longitude>
;;     Longitude of the point the camera is looking at. Angular
;;     distance in degrees, relative to the Prime Meridian. Values
;;     west of the Meridian range from −180 to 0 degrees. Values east
;;     of the Meridian range from 0 to 180 degrees. 
;; <latitude>
;;     Latitude of the point the camera is looking at. Degrees north
;;     or south of the Equator (0 degrees). Values range from −90
;;     degrees to 90 degrees. 
;; <altitude> 
;;     Distance from the earth's surface, in meters. Interpreted
;;     according to the LookAt's altitude mode. 
;; <heading>
;;     Direction (that is, North, South, East, West), in
;;     degrees. Default=0 (North). (See diagram below.) Values range
;;     from 0 to 360 degrees.  
;; <tilt>
;;     Angle between the direction of the LookAt position and the
;;     normal to the surface of the earth. (See diagram below.) Values
;;     range from 0 to 90 degrees. Values for <tilt> cannot be
;;     negative. A <tilt> value of 0 degrees indicates viewing from
;;     directly above. A <tilt> value of 90 degrees indicates viewing
;;     along the horizon.  
;; <range> (required)
;;     Distance in meters from the point specified by <longitude>,
;;     <latitude>, and <altitude> to the LookAt position. (See diagram
;;     below.)  
;; <altitudeMode>
;;     Specifies how the <altitude> specified for the LookAt point is
;;     interpreted. Possible values are as follows: 
;;
;;         * clampToGround - (default) Indicates to ignore the
;;         <altitude> specification and place the LookAt position on
;;         the ground. 
;;         * relativeToGround - Interprets the <altitude> as a value
;;         in meters above the ground. 
;;         * absolute - Interprets the <altitude> as a value in meters
;;         above sea level. 
;;
;; <gx:altitudeMode>
;;     A KML extension in the Google extension namespace, allowing
;;     altitudes relative to the sea floor. Values are: 
;;         * relativeToSeaFloor - Interprets the <altitude> as a value
;;         in meters above the sea floor. If the point is above land
;;         rather than sea, the <altitude> will be interpreted as
;;         being above the ground. 
;;         * clampToSeaFloor - The <altitude> specification is
;;         ignored, and the LookAt will be positioned on the sea
;;         floor. If the point is on land rather than at sea, the
;;         LookAt will be positioned on the ground. 
;;
;; Extends
;;     * <AbstractView>
;;
;; Contained By
;;     * Any element derived from <Feature>
;;     * <NetworkLinkControl>
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


pro kdm_kml_lookat::KMLhead
  self->buildsource, '<LookAt id="'+self.ID+'">'
end

pro kdm_kml_lookat::KMLbody
  if self.longitude ne 0 then self->buildsource, self->xmlTag( 'longitude', self.longitude )
  if self.latitude ne 0 then self->buildsource, self->xmlTag( 'latitude', self.latitude )
  if self.altitude ne 0 then self->buildsource, self->xmlTag( 'altitude', STRTRIM(LONG(self.altitude),2) )
  if self.heading ne 0 then self->buildsource, self->xmlTag( 'heading', self.heading )
  if self.tilt ne 0 then self->buildsource, self->xmlTag( 'tilt', self.tilt )
  if self.range ne 0 then self->buildsource, self->xmlTag( 'range', self.range )
  if self.x_altitudeMode ne '' then self->buildsource, self->xmlTag( 'x_altitudeMode', self.x_altitudeMode )
end

pro kdm_kml_lookat::KMLtail
  self->buildsource, '</LookAt>'
end

function kdm_kml_lookat::init, _EXTRA=e
  if self->kdm_kml_abstractview::init(_EXTRA=e) ne 1 then return, 0
  self->setProperty, _EXTRA=e
  return, 1
end
pro kdm_kml_lookat::cleanup
  self->kdm_kml_abstractview::cleanup
end 
pro kdm_kml_lookat__define, class
  class = { kdm_kml_lookat, $
            inherits kdm_kml_abstractview, $
            longitude: 0.0, $
            latitude: 0.0, $
            altitude: 0.0d, $
            heading: 0.0, $
            tilt: 0.0, $
            range: 0.0d, $
            x_altitudeMode: '' }
end

