;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;; This is NOT part of the KML API. This is a custom implementation
;; of vertical data curtains based on the MODEL element
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
;;       <x>1</x>
;;       <y>1</y>
;;       <z>1</z>
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




;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;; This helper function just returns a basic DAE (3D Google SketchUp
;; Model) file as an array of strings. The points that need to be
;; changed for vertical curtain data in GE are highlighted as BLBL for
;; the bottom left corner, BRBR, TLTL, TRTR, and HHHL,HHHR (for the
;; height of the left and right edge. This string array is then passed
;; through 'kdm_kml_vertical_repstr' to replace those keywords with the
;; desired values.
;;
;; Users should not call this function directly.
;;
function kdm_kml_vertical_dae
  dae = [ ['<?xml version="1.0" encoding="utf-8"?>'], $
          [ '<COLLADA xmlns="http://www.collada.org/2005/11/COLLADASchema" version="1.4.1">'], $
          [ '		  <asset>'], $
          [ '      <contributor>'], $
          [ '         <authoring_tool>Google SketchUp 6.0.312</authoring_tool>'], $
          [ '      </contributor>'], $
          [ '      <unit name="meters" meter="1.0"/>'], $
          [ '      <up_axis>Z_UP</up_axis>'], $
          [ '   </asset>'], $
          [ '	   <library_images>'], $
          [ '      <image id="kdm-kml_vertical-image" name="kdm-kml_vertical-image">'], $
          [ '	         <init_from>../images/IMAGE.PNG</init_from>'], $
          [ '      </image>'], $
          [ '   </library_images>'], $
          [ '      <library_materials>'], $
          [ '      <material id="kdm-kml_verticalID" name="kdm-kml_vertical">'], $
          [ '         <instance_effect url="#kdm-kml_vertical-effect"/>'], $
          [ '      </material>'], $
          [ '   </library_materials>'], $
          [ '   <library_effects>'], $
          [ '      <effect id="kdm-kml_vertical-effect" name="kdm-kml_vertical-effect">'], $
          [ '         <profile_COMMON>'], $
          [ '            <newparam sid="kdm-kml_vertical-image-surface">'], $
          [ '               <surface type="2D">'], $
          [ '                  <init_from>kdm-kml_vertical-image</init_from>'], $
          [ '               </surface>'], $
          [ '            </newparam>'], $
          [ '            <newparam sid="kdm-kml_vertical-image-sampler">'], $
          [ '               <sampler2D>'], $
          [ '                  <source>kdm-kml_vertical-image-surface</source>'], $
          [ '               </sampler2D>'], $
          [ '            </newparam>'], $
          [ '            <technique sid="COMMON"> '], $
          [ '               <phong>'], $
          [ '                  <emission>'], $
          [ '                     <color>0.000000 0.000000 0.000000 1</color>'], $
          [ '                  </emission>'], $
          [ '                  <ambient>'], $
          [ '                     <color>0.000000 0.000000 0.000000 1</color>'], $
          [ '                  </ambient>'], $
          [ '                  <diffuse>'], $
          [ '                     <texture texture="kdm-kml_vertical-image-sampler" texcoord="UVSET0"/>'], $
          [ '                  </diffuse>'], $
          [ '                  <specular>'], $
          [ '                     <color>0.000000 0.000000 0.000000 1</color>'], $
          [ '                  </specular>'], $
          [ '                  <shininess>'], $
          [ '                     <float>20.000000</float>'], $
          [ '                  </shininess>'], $
          [ '                  <reflectivity>'], $
          [ '                     <float>0.100000</float>'], $
          [ '                  </reflectivity>'], $
          [ '                  <transparent>'], $
          [ '                     <color>1 1 1 1</color>'], $
          [ '                  </transparent>'], $
          [ '                  <transparency>'], $
          [ '                     <float>0.000000</float>'], $
          [ '                  </transparency>'], $
          [ '               </phong>'], $
          [ '            </technique>'], $
          [ '         </profile_COMMON>'], $
          [ '              </effect>'], $
          [ '   </library_effects>'], $
          [ '      <library_geometries>'], $
          [ '      <geometry id="mesh1-geometry" name="mesh1-geometry">'], $
          [ '         <mesh>'], $
          [ '            <source id="mesh1-geometry-position">'], $
          [ '				   <!-- 1: -Width,Left,Bottom. 3: Width,Right,Bottom. 6:Width,Top,Left 8/11: Height. 9:Width,Top,Left -->'], $
          [ '			       <!--                                                       0 1 2 3     4 5 6     7 8   9   10 11         -->'], $
          [ '				   <!--'], $
          [ '	               <float_array id="mesh1-geometry-position-array" count="12">0 0 0 109.5 0 0 -20.5 0 300 112 0 300</float_array>'], $
          [ '	               <float_array id="mesh1-geometry-position-array" count="12">0 0 0 100 0 0 0 0 100 100 0 100</float_array>'], $
          [ '	               <float_array id="mesh1-geometry-position-array" count="12">-50 0 0 50  0 0 -50 0 100 50 0 100</float_array>'], $
          [ '	               <float_array id="mesh1-geometry-position-array" count="12">-50 0 0 50  0 0 -50 0 100 50 0 100</float_array>'], $
          [ '	               <float_array id="mesh1-geometry-position-array" count="12">-0.5 0 0 0.5  0 0 -0.5 0 1 0.5 0  1</float_array>'], $
          [ '				   -->'], $
          [ '			       <!--                                                       0    1 2 3     4 5 6    7 8    9    10 11         -->'], $
          [ '	               <float_array id="mesh1-geometry-position-array" count="12">BLBL 0 0 BRBR  0 0 TLTL 0 HHHL TRTR 0  HHHR</float_array>'], $
          [ '			   <technique_common>'], $
          [ '                  <accessor source="#mesh1-geometry-position-array" count="4" stride="3">'], $
          [ '                     <param name="X" type="float"/>'], $
          [ '                     <param name="Y" type="float"/>'], $
          [ '                     <param name="Z" type="float"/>'], $
          [ '                  </accessor>'], $
          [ '               </technique_common>'], $
          [ '            </source>'], $
          [ '            <source id="mesh1-geometry-normal">'], $
          [ '               <float_array id="mesh1-geometry-normal-array" count="6">0 -0.0254 0 0 0.0254 0</float_array>'], $
          [ '               <technique_common>'], $
          [ '                  <accessor source="#mesh1-geometry-normal-array" count="2" stride="3">'], $
          [ '                     <param name="X" type="float"/>'], $
          [ '                     <param name="Y" type="float"/>'], $
          [ '                     <param name="Z" type="float"/>'], $
          [ '                  </accessor>'], $
          [ '               </technique_common>'], $
          [ '            </source>'], $
          [ '            <source id="mesh1-geometry-uv">'], $
          [ '               <float_array id="mesh1-geometry-uv-array" count="8">0 0 1 0 0 1 1 1</float_array>'], $
          [ '               <technique_common>'], $
          [ '                  <accessor source="#mesh1-geometry-uv-array" count="4" stride="2">'], $
          [ '                     <param name="S" type="float"/>'], $
          [ '                     <param name="T" type="float"/>'], $
          [ '                  </accessor>'], $
          [ '               </technique_common>'], $
          [ '            </source>'], $
          [ '            <vertices id="mesh1-geometry-vertex">'], $
          [ '               <input semantic="POSITION" source="#mesh1-geometry-position"/>'], $
          [ '            </vertices>'], $
          [ '            <triangles material="kdm-kml_vertical" count="4">'], $
          [ '               <input semantic="VERTEX" source="#mesh1-geometry-vertex" offset="0"/>'], $
          [ '               <input semantic="NORMAL" source="#mesh1-geometry-normal" offset="1"/>'], $
          [ '               <input semantic="TEXCOORD" source="#mesh1-geometry-uv" offset="2" set="0"/>'], $
          [ '               <p>0 0 0 1 0 1 2 0 2 0 1 0 2 1 2 1 1 1 3 0 3 2 0 2 1 0 1 3 1 3 1 1 1 2 1 2 </p>'], $
          [ '            </triangles>'], $
          [ '         </mesh>'], $
          [ '      </geometry>'], $
          [ '   </library_geometries>'], $
          [ '		   <library_visual_scenes>'], $
          [ '      <visual_scene id="SketchUpScene" name="SketchUpScene">'], $
          [ '         <node id="Model" name="Model">'], $
          [ '            <node id="mesh1" name="mesh1">'], $
          [ '               <instance_geometry url="#mesh1-geometry">'], $
          [ '                  <bind_material>'], $
          [ '                     <technique_common>'], $
          [ '                        <instance_material symbol="kdm-kml_vertical" target="#kdm-kml_verticalID">'], $
          [ '                           <bind_vertex_input semantic="UVSET0" input_semantic="TEXCOORD" input_set="0"/>'], $
          [ '                        </instance_material>'], $
          [ '                     </technique_common>'], $
          [ '                  </bind_material>'], $
          [ '               </instance_geometry>'], $
          [ '            </node>'], $
          [ '         </node>'], $
          [ '      </visual_scene>'], $
          [ '   </library_visual_scenes>'], $
          [ '   <scene>'], $
          [ '      <instance_visual_scene url="#SketchUpScene"/>'], $
          [ '   </scene>'], $
          [ '</COLLADA>'] ]
return, reform( dae )
end
	


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;; helper function: Given a string (str), a search term (str0) and a
;; replacement term (str1), find the search term and relpace it with
;; the replacement term. Used to stretch the corners and top of the
;; DAE file.
;;
pro kdm_kml_vertical_repstr, str, str0,str1
  for i = 0, n_elements(str)-1 do begin
     stri = str[i]
     result = STRPOS( stri, str0 )
     if result eq -1 then continue
     stri = strmid( stri, 0, result ) + str1 + strmid( stri, result+strlen(str0), 99999 )
     str[i] = stri
  endfor
end




pro kdm_kml_vertical::KMLhead
  self->kdm_kml_geometry::KMLhead
  self->buildsource, '<Model>'
end
pro kdm_kml_vertical::KMLbody
  self->kdm_kml_geometry::KMLbody

  ;; Given two lat and lon pairs for the grounded points of the data
  ;; curtain, find out the distance between the two points. Also
  ;; determine the distance at the top of the curtain, a slightly
  ;; longer arclen due to the curvature of the earth.

  ll2rb, self.lon0,self.lat0,self.lon1,self.lat1,dist,azi,/DEGREES
  bot_dist = (dist*!dtor)*6378.1 * 1e3                   ; distance in meters on surface
  top_dist = (dist*!dtor)*(6378.1 * 1e3 + self.top_altitude ) ; distance in meters at top
  top_alt_str = STRTRIM(LONG(self.top_altitude),2)

  ;; Calculate the center point which is where the model is placed,
  ;; and the direction (azimuth).

  lat_center = (self.lat0+self.lat1)/2.
  lon_center = (self.lon0+self.lon1)/2.

  azi = azi+90
  cirrange, azi
  azi = STRTRIM((azi),2)

  ps = path_sep()
  folder0 = file_uniq()
  folder1 = folder0 + ps + "files"
  file_mkdir, folder0 & file_mkdir, folder1

  ;; adjust the DAE file to the new coordinates. Set the width at the
  ;; base, the width at the top, and the height
  str = kdm_kml_vertical_dae()
  ;; <float_array id="mesh1-geometry-position-array" count="12">BLBL 0 0 BRBR  0 0 TLTL 0 HHHL TRTR 0  HHHR</float_array>
  kdm_kml_vertical_repstr, str, "BLBL", STRTRIM( -bot_dist/2.0, 2 )
  kdm_kml_vertical_repstr, str, "BRBR", STRTRIM( bot_dist/2.0, 2 )
  kdm_kml_vertical_repstr, str, "TLTL", STRTRIM( -top_dist/2.0, 2 )
  kdm_kml_vertical_repstr, str, "TRTR", STRTRIM( top_dist/2.0, 2 )
  kdm_kml_vertical_repstr, str, "HHHL", top_alt_str
  kdm_kml_vertical_repstr, str, "HHHR", top_alt_str

  kdm_filepathext, self.vertical_image, file=vertical_image_file
  kdm_kml_vertical_repstr, str, "IMAGE.PNG", vertical_image_file

  openw, lun, folder0+ps+'files'+ps+vertical_image_file+'.dae', /get
  printf, lun, str
  free_lun, lun


  self->buildsource, self->xmlTag( 'altitudeMode', self.x_altitudeMode )
  ;; Location
  self->buildsource, "<Location>"
  self->buildsource, self->xmlTag( 'longitude', STRTRIM(lon_center,2) )
  self->buildsource, self->xmlTag( 'latitude', STRTRIM(lat_center,2) )
  self->buildsource, self->xmlTag( 'altitude', STRTRIM(0,2) )
  self->buildsource, "</Location>"
  ;; Orientation
  self->buildsource, "<Orientation>"
  self->buildsource, self->xmlTag( 'heading', STRTRIM(azi,2) )
  self->buildsource, self->xmlTag( 'tilt', self.tilt )
  self->buildsource, self->xmlTag( 'roll', self.roll )
  self->buildsource, "</Orientation>"
  ;; Scale
  ;; Keep the scale of the data curtain at 1, and set the actual
  ;; distances to real values (above with TLTL, BRBR, etc.)
  self->buildsource, "<Scale>"
  self->buildsource, self->xmlTag( 'x', '1' );self.x_scale )
  self->buildsource, self->xmlTag( 'y', '1' );self.y_scale )
  self->buildsource, self->xmlTag( 'z', '1' );self.z_scale )
  self->buildsource, "</Scale>"
  ;; Model URL
  self->buildsource, "<Link>"
  ;;self->buildsource, self->xmlTag( 'href', self.link_href )
  self->buildsource, self->xmlTag( 'href', folder0+ps+'files'+ps+vertical_image_file+'.dae' )
  self->buildsource, "</Link>"

  ;; image for wall
  kdm_filepathext, self.vertical_image, file=vertical_image_file
  file_copy, self.vertical_image, folder0+ps+'files', /OVERWRITE
  self->buildsource, "<ResourceMap><Alias>"
  self->buildsource, self->xmlTag( 'targetHref', self.vertical_image )
  self->buildsource, self->xmlTag( 'sourceHref', '../images/'+vertical_image_file )
  self->buildsource, "</Alias></ResourceMap>"
end
pro kdm_kml_vertical::KMLtail
  self->buildsource, '</Model>'
  self->kdm_kml_geometry::KMLtail
end


function kdm_kml_vertical::init, _EXTRA=e
  if self->kdm_kml_geometry::init(_EXTRA=e) ne 1 then return, 0
  self.x_scale = 1 & self.y_scale = 1 & self.z_scale = 1
  self.top_altitude = 1e3 * 100 ; 100 km 
  self.x_altitudeMode='absolute'
  self.id = "modelID"
  self->setProperty, _EXTRA=e
 return, 1
end
pro kdm_kml_vertical::cleanup
  self->kdm_kml_geometry::cleanup
end 

pro kdm_kml_vertical__define, class
  class = { kdm_kml_vertical, $
            inherits kdm_kml_geometry, $
            x_altitudeMode: '', $
            lat0: 0.0, $
            lon0: 0.0, $
            lat1: 0.0, $
            lon1: 0.0, $
            top_altitude: 0.0, $
            vertical_image: '', $
            altitude: 0.0, $
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



pro kdm_kml_vertical_test
  
  ;; A slightly complex example. Generates ~21 vertical curtains in
  ;; random locations and orientations each with their own unique
  ;; image (data) painted on the face. Each curtain also contains a
  ;; KML TimeSpan() so that the time slider can be used to show and
  ;; hide them.

  file_mkdir, 'kdm_kml_vertical_example'
  cd, 'kdm_kml_vertical_example'
  folder = obj_new('kdm_kml_folder')

  for img = 0, 20 do begin
     
     loadct, img, /silent ; colortables 0 through 10
     tvlct,r,g,b,/get
     fname = 'vert_img_'+STRTRIM(img,2)+'.png'
     write_png, fname, bytscl( dist(2, 200) ), r,g,b

     range = 20
     lat0 = randomu(seed)*range & lat1 = randomu(seed)*range
     lon0 = randomu(seed)*range & lon1 = randomu(seed)*range

     p = obj_new( 'kdm_kml_placemark' ) ; lat and lon not used

     vert = obj_new( 'kdm_kml_vertical', $
                     lat0=lat0, lat1=lat1, $
                     lon0=lon0, lon1=lon1, $
                     top_alt=3e5, $
                     vertical_image=fname )

     ;; random date and time
     yr = round(randomn(seed)*10)+2000
     dt0 = obj_new('kdm_dt', year=yr, month=1, day=1 )
     dt1 = obj_new('kdm_dt', year=yr+1, month=12, day=31 )
     t = obj_new( 'kdm_kml_timespan', timebegin=dt0->TimeStamp(), timeend=dt1->TimeStamp() )
     p->add, t->Clone()

     p->add, vert
     folder->add, p
  endfor

  lookAt = obj_new('kdm_kml_lookat', lon=6, lat=5, alt=0, range=2000000, tilt=45, head=45 )
  dt0 = obj_new('kdm_dt', year=1980, month=1, day=1 )
  dt1 = obj_new('kdm_dt', year=2020, month=12, day=31 )
  t = obj_new( 'kdm_kml_timespan', timebegin=dt0->TimeStamp(), timeend=dt1->TimeStamp() )
  lookAt->add, t
  folder->add, lookAt

  doc = obj_new('kdm_kml_document')
  doc->add, folder
  kml = obj_new('kdm_kml', file='test_vert.kml')
  kml->add, doc
  kml->saveKML, /openGE
  cd, '../'
end

kdm_kml_vertical_test
end
