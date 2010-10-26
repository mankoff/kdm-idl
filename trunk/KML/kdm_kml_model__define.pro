;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;; This object encapsulates the Style
;; http://code.google.com/apis/kml/documentation/kmlreference.html#model
;; 
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;; <Model>
;; Syntax
;;
;; <Model id="ID">
;;   <!-- specific to Model -->
;;   <altitudeMode>clampToGround</altitudeMode> 
;;       <!-- kml:altitudeModeEnum: clampToGround,relativeToGround,or absolute -->
;;       <!-- or, substitute gx:altitudeMode: clampToSeaFloor, relativeToSeaFloor -->
;;   <Location> 
;;     <longitude></longitude> <!-- kml:angle180 -->
;;     <latitude></latitude>   <!-- kml:angle90 -->  
;;     <altitude>0</altitude>  <!-- double --> 
;;   </Location> 
;;   <Orientation>               
;;     <heading>0</heading>    <!-- kml:angle360 -->
;;     <tilt>0</tilt>          <!-- kml:angle360 -->
;;     <roll>0</roll>          <!-- kml:angle360 -->
;;   </Orientation> 
;;   <Scale> 
;;     <x>1</x>                <!-- double -->
;;     <y>1</y>                <!-- double -->
;;     <z>1</z>                <!-- double -->
;;   </Scale> 
;;   <Link>...</Link>
;;   <ResourceMap>
;;     <Alias>
;;       <targetHref>...</targetHref>   <!-- anyURI -->
;;       <sourceHref>...</sourceHref>   <!-- anyURI -->
;;     </Alias>
;;   </ResourceMap>
;; </Model>
;;
;; Description
;; A 3D object described in a COLLADA file (referenced in the <Link>
;; tag). COLLADA files have a .dae file extension. Models are created
;; in their own coordinate space and then located, positioned, and
;; scaled in Google Earth. See the "Topics in KML" page on Regions for
;; more detail. 
;;
;; Google Earth supports the COLLADA common profile, with the
;; following exceptions: 
;;     * Google Earth supports only triangles and lines as primitive
;;       types. The maximum number of triangles allowed is 21845. 
;;     * Google Earth does not support animation or skinning.
;;     * Google Earth does not support external geometry references.
;;
;; Elements Specific to Model
;; <altitudeMode>
;;     Specifies how the <altitude> specified in <Location> is
;;     interpreted. Possible values are as follows: 
;;         * clampToGround - (default) Indicates to ignore the
;;           <altitude> specification and place the Model on the
;;           ground. 
;;         * relativeToGround - Interprets the <altitude> as a value
;;                              in meters above the ground. 
;;         * absolute - Interprets the <altitude> as a value in meters
;;                      above sea level. 
;; <gx:altitudeMode>
;;     A KML extension in the Google extension namespace, allowing
;;     altitudes relative to the sea floor. Values are: 
;;         * relativeToSeaFloor - Interprets the <altitude> as a value
;;         in meters above the sea floor. If the point is above land
;;         rather than sea, the <altitude> will be interpreted as
;;         being above the ground. 
;;         * clampToSeaFloor - The <altitude> specification is
;;         ignored, and the Model will be positioned on the sea
;;         floor. If the point is on land rather than at sea, the
;;         Model will be positioned on the ground. 
;; <Location>
;;     Specifies the exact coordinates of the Model's origin in
;;     latitude, longitude, and altitude. Latitude and longitude
;;     measurements are standard lat-lon projection with WGS84
;;     datum. Altitude is distance above the earth's surface, in
;;     meters, and is interpreted according to <altitudeMode> or
;;     <gx:altitudeMode>. 
;;     <Location>
;;       <longitude>39.55375305703105</longitude>  
;;       <latitude>-118.9813220168456</latitude> 
;;       <altitude>1223</altitude> 
;;     </Location> 
;;
;; <Orientation>
;;     Describes rotation of a 3D model's coordinate system to
;;     position the object in Google Earth. See diagrams below. 
;;     <Orientation> 
;;       <heading>45.0</heading> 
;;       <tilt>10.0</tilt> 
;;       <roll>0.0</roll> 
;;     </Orientation> 
;;
;;     Rotations are applied to a Model in the following order:
;;        1. <roll>
;;        2. <tilt>
;;        3. <heading>
;;
;;     <heading>
;;         Rotation about the z axis (normal to the Earth's
;;         surface). A value of 0 (the default) equals North. A
;;         positive rotation is clockwise around the z axis and
;;         specified in degrees from 0 to 360. 
;;     <tilt>
;;         Rotation about the x axis. A positive rotation is clockwise
;;         around the x axis and specified in degrees from 0 to 360. 
;;     <roll>
;;         Rotation about the y axis. A positive rotation is clockwise
;;         around the y axis and specified in degrees from 0 to 360. 
;;         heading, tilt, and roll are specified in a clockwise
;;         direction when looking down the axis toward the origin 
;; <Scale>
;;     Scales a model along the x, y, and z axes in the model's coordinate space.
;;     <Scale>
;;       <x>2.5</x>
;;       <y>2.5</y>
;;       <z>3.5</z>
;;     </Scale>
;;
;; <Link>
;;     Specifies the file to load and optional refresh parameters. See
;;     <Link>. 
;; <ResourceMap>
;;     Specifies 0 or more <Alias> elements, each of which is a
;;     mapping for the texture file path from the original Collada
;;     file to the KML or KMZ file that contains the Model. This
;;     element allows you to move and rename texture files without
;;     having to update the original Collada file that references
;;     those textures. One <ResourceMap> element can contain multiple
;;     mappings from different (source) Collada files into the same
;;     (target) KMZ file. 
;;
;; <Alias> contains a mapping from a <sourceHref> to a <targetHref>:
;;     <targetHref>
;;         Specifies the texture file to be fetched by Google
;;         Earth. This reference can be a relative reference to an
;;         image file within the .kmz archive, or it can be an
;;         absolute reference to the file (for example, a URL).  
;;     <sourceHref>
;;         Is the path specified for the texture file in the Collada
;;         .dae file. 
;;
;;     In Google Earth, if this mapping is not supplied, the following
;;     rules are used to locate the textures referenced in the Collada
;;     (.dae) file: 
;;
;;         * No path: If the texture name does not include a path,
;;         Google Earth looks for the texture in the same directory as
;;         the .dae file that references it. 
;;         * Relative path: If the texture name includes a relative
;;         path (for example, ../images/mytexture.jpg), Google Earth
;;         interprets the path as being relative to the .dae file that
;;         references it. 
;;         * Absolute path: If the texture name is an absolute path
;;         (c:\mytexture.jpg) or a network path (for example,
;;         http://myserver.com/mytexture.jpg), Google Earth looks for
;;         the file in the specified location, regardless of where the
;;         .dae file is located. 
;;
;; Extends
;;     * <Geometry>
;;
;; Contained By
;;     * <MultiGeometry>
;;     * <Placemark>
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


pro kdm_kml_model::KMLhead
  self->kdm_kml_geometry::KMLhead
  self->buildsource, '<Model>'
end
pro kdm_kml_model::KMLbody
  self->kdm_kml_geometry::KMLbody
  self->buildsource, self->xmlTag( 'altitudeMode', self.x_altitudeMode )
  ;; Location
  self->buildsource, "<Location>"
  self->buildsource, self->xmlTag( 'longitude', self.longitude )
  self->buildsource, self->xmlTag( 'latitude', self.latitude )
  self->buildsource, self->xmlTag( 'altitude', self.altitude )
  self->buildsource, "</Location>"
  ;; Orientation
  self->buildsource, "<Orientation>"
  self->buildsource, self->xmlTag( 'heading', self.heading )
  self->buildsource, self->xmlTag( 'tilt', self.tilt )
  self->buildsource, self->xmlTag( 'roll', self.roll )
  self->buildsource, "</Orientation>"
  ;; Scale
  self->buildsource, "<Scale>"
  self->buildsource, self->xmlTag( 'x', self.x_scale )
  self->buildsource, self->xmlTag( 'y', self.y_scale )
  self->buildsource, self->xmlTag( 'z', self.z_scale )
  self->buildsource, "</Scale>"
  ;; Model URL
  self->buildsource, "<Link>"
  self->buildsource, self->xmlTag( 'href', self.link_href )
  self->buildsource, "</Link>"
  ;; other stuff
  self->buildsource, "<ResourceMap><Alias>"
  self->buildsource, self->xmlTag( 'targetHref', self.targetHref )
  self->buildsource, self->xmlTag( 'sourceHref', self.sourceHref )
  self->buildsource, "</Alias></ResourceMap>"
end
pro kdm_kml_model::KMLtail
  self->buildsource, '</Model>'
  self->kdm_kml_geometry::KMLtail
end


function kdm_kml_model::init, _EXTRA=e
  if self->kdm_kml_geometry::init(_EXTRA=e) ne 1 then return, 0
  self.x_scale = 1 & self.y_scale = 1 & self.z_scale = 1
  self.x_altitudeMode='absolute'
  self.id = "modelID"
  self->setProperty, _EXTRA=e
 return, 1
end
pro kdm_kml_model::cleanup
  self->kdm_kml_geometry::cleanup
end 
pro kdm_kml_model__define, class
  class = { kdm_kml_model, $
            inherits kdm_kml_geometry, $
            x_altitudeMode: '', $
            latitude: 0.0, $
            longitude: 0.0, $
            altitude: 0.0d, $
            heading: 0.0, $
            tilt: 0.0, $
            roll: 0.0, $
            x_scale: 0.0, $
            y_scale: 0.0, $
            z_scale: 0.0, $
            link_href: '', $
            targetHref: '', $
            sourceHref: '' }
end

folder = obj_new('kdm_kml_folder')
alt = 0
for y = 2000, 2010 do begin
   for alt = 0, 4 do begin
      for ii = 0, 4 do begin
         for jj = 0, 4 do begin
            scale = 1e4*randomu(seed)*3 ;; 0 to 3e4 (for color scale)
            color = STRING( KDM_RANGE( scale, from=[0,3e4], to=[0,255] ), FORMAT='(I03)' )
            scale = 3e4
            heading = randomu(seed)*45-22.5
            p = obj_new( 'kdm_kml_placemark', $
                         x_altitude='relativeToGround', $
                         lat=ii, lon=jj )
            m = obj_new( 'kdm_kml_model', $
                         lat=ii, lon=jj, alt=alt*3e4, $
                         heading=heading, $
                         x_altitude='relativeToGround', $
                         x_scale=scale, y=scale, z=scale, $
                         link_href='./models/vec_'+color+'.dae' )
            dt0 = obj_new('kdm_dt', year=y, month=1, day=1 )
            dt1 = obj_new('kdm_dt', year=y, month=12, day=31 )
            t = obj_new( 'kdm_kml_timespan', timebegin=dt0->TimeStamp(), timeend=dt1->TimeStamp() )
            p->add, m
            p->add, t
            folder->add, p
         endfor
      endfor
   endfor
endfor
doc = obj_new('kdm_kml_document')
doc->add, folder
kml = obj_new('kdm_kml', file='test.kml')
kml->add, doc
kml->saveKML, /openGE
end
