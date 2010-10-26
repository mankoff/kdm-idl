;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;; This object encapsulates the Region
;; http://code.google.com/apis/kml/documentation/kmlreference.html#region
;; 
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;; <Region>
;; Syntax
;;
;; <Region id="ID"> 
;;   <LatLonAltBox> 
;;     <north></north>                            <!-- required; kml:angle90 -->
;;     <south></south>                            <!-- required; kml:angle90 --> 
;;     <east></east>                              <!-- required; kml:angle180 -->
;;     <west></west>                              <!-- required; kml:angle180 -->
;;     <minAltitude>0</minAltitude>               <!-- float -->
;;     <maxAltitude>0</maxAltitude>               <!-- float -->
;;     <altitudeMode>clampToGround</altitudeMode> 
;;         <!-- kml:altitudeModeEnum: clampToGround, relativeToGround, or absolute -->
;;         <!-- or, substitute gx:altitudeMode: clampToSeaFloor, relativeToSeaFloor --> 
;;   </LatLonAltBox> 
;;   <Lod>
;;     <minLodPixels>0</minLodPixels>             <!-- float -->
;;     <maxLodPixels>-1</maxLodPixels>            <!-- float -->
;;     <minFadeExtent>0</minFadeExtent>           <!-- float --> 
;;     <maxFadeExtent>0</maxFadeExtent>           <!-- float -->
;;   </Lod>
;; </Region> 
;;
;; Description
;;
;; A region contains a bounding box (<LatLonAltBox>) that
;; describes an area of interest defined by geographic
;; coordinates and altitudes. In addition, a Region contains an
;; LOD (level of detail) extent (<Lod>) that defines a validity
;; range of the associated Region in terms of projected screen
;; size. A Region is said to be "active" when the bounding box
;; is within the user's view and the LOD requirements are
;; met. Objects associated with a Region are drawn only when
;; the Region is active. When the <viewRefreshMode> is
;; onRegion, the Link or Icon is loaded only when the Region is
;; active. See the "Topics in KML" page on Regions for more
;; details. In a Container or NetworkLink hierarchy, this
;; calculation uses the Region that is the closest ancestor in
;; the hierarchy. 
;;
;; Elements Specific to Region
;; <LatLonAltBox>(required)
;;     A bounding box that describes an area of interest defined by
;;     geographic coordinates and altitudes. Default values and
;;     required fields are as follows:  
;;     <altitudeMode> or <gx:altitudeMode>
;;         Possible values for <altitudeMode> are clampToGround,
;;         relativeToGround, and absolute. Possible values for
;;         <gx:altitudeMode> are clampToSeaFloor and
;;         relativeToSeaFloor. Also see <LatLonBox>.  
;;     <minAltitude>
;;         Specified in meters (and is affected by the altitude mode
;;         specification).  
;;     <maxAltitude>
;;         Specified in meters (and is affected by the altitude mode
;;         specification).  
;;     <north> (required)
;;         Specifies the latitude of the north edge of the bounding
;;         box, in decimal degrees from 0 to ±90.  
;;     <south> (required)
;;         Specifies the latitude of the south edge of the bounding
;;         box, in decimal degrees from 0 to ±90.  
;;     <east> (required)
;;         Specifies the longitude of the east edge of the bounding
;;         box, in decimal degrees from 0 to ±180.  
;;     <west> (required)
;;         Specifies the longitude of the west edge of the bounding
;;         box, in decimal degrees from 0 to ±180.  
;;
;; <Lod>
;;     Lod is an abbreviation for Level of Detail. <Lod> describes the
;;     size of the projected region on the screen that is required in
;;     order for the region to be considered "active." Also specifies
;;     the size of the pixel ramp used for fading in (from transparent
;;     to opaque) and fading out (from opaque to transparent). See
;;     diagram below for a visual representation of these parameters. 
;;
;;     <minLodPixels> (required)
;;         Measurement in screen pixels that represents the minimum
;;         limit of the visibility range for a given Region. Google
;;         Earth calculates the size of the Region when projected onto
;;         screen space. Then it computes the square root of the
;;         Region's area (if, for example, the Region is square and
;;         the viewpoint is directly above the Region, and the Region
;;         is not tilted, this measurement is equal to the width of
;;         the projected Region). If this measurement falls within the
;;         limits defined by <minLodPixels> and <maxLodPixels> (and if
;;         the <LatLonAltBox> is in view), the Region is active. If
;;         this limit is not reached, the associated geometry is
;;         considered to be too far from the user's viewpoint to be
;;         drawn.  
;;     <maxLodPixels>
;;         Measurement in screen pixels that represents the maximum
;;         limit of the visibility range for a given Region. A value
;;         of −1, the default, indicates "active to infinite size."  
;;     <minFadeExtent>
;;         Distance over which the geometry fades, from fully opaque
;;         to fully transparent. This ramp value, expressed in screen
;;         pixels, is applied at the minimum end of the LOD
;;         (visibility) limits.  
;;     <maxFadeExtent>
;;         Distance over which the geometry fades, from fully
;;         transparent to fully opaque. This ramp value, expressed in
;;         screen pixels, is applied at the maximum end of the LOD
;;         (visibility) limits.  
;;
;; Extends
;;     * <Object>
;;
;; Contained By
;;     * any element derived from <Feature>
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;



pro kdm_kml_region::KMLhead
  ;;self->kdm_kml_object::KMLhead
  self->buildsource, '<Region id="'+self.ID+'">'
  self->buildSource, '<LatLonAltBox>'
  self->buildsource, self->xmlTag( 'north', self.north )
  self->buildsource, self->xmlTag( 'south', self.south )
  self->buildsource, self->xmlTag( 'east', self.east )
  self->buildsource, self->xmlTag( 'west', self.west )
  self->buildsource, self->xmlTag( 'minAltitude', self.minAltitude )
  self->buildsource, self->xmlTag( 'maxAltitude', self.maxAltitude )
  self->buildSource, '</LatLonAltBox>'
  self->buildSource, '<Lod>'
  self->buildsource, self->xmlTag( 'minLodPixels', self.minLodPixels )
  self->buildsource, self->xmlTag( 'maxLodPixels', self.maxLodPixels )
  self->buildsource, self->xmlTag( 'minFadeExtent', self.minFadeExtent )
  self->buildsource, self->xmlTag( 'maxFadeExtent', self.maxFadeExtent )
  self->buildSource, '</Lod>'
end
pro kdm_kml_region::KMLtail
  self->buildsource, '</Region>'
  ;;self->kdm_kml_object::KMLtail
end

function kdm_kml_region::init, maxLodPixels=maxLodPixels, _EXTRA=e
  if self->kdm_kml_object::init(_EXTRA=e) ne 1 then return, 0
  self->setProperty, maxLodPixels=-1, _EXTRA=e
  return, 1
end
pro kdm_kml_region::cleanup
  self->kdm_kml_object::cleanup
end 
pro kdm_kml_region__define, class
  class = { kdm_kml_region, $
            north:0.0, $
            south:0.0, $
            east:0.0, $
            west:0.0, $
            minAltitude:0.0d, $
            maxAltitude:0.0d, $
            x_altitudeMode:'', $
            minLodPixels:0.0d, $
            maxLodPixels:0.0d, $
            minFadeExtent:0.0d, $
            maxFadeExtent:0.0d, $
            inherits kdm_kml_object }
end


kml = obj_new('kdm_kml', file='test.kml')
d = obj_new('kdm_kml_document' )

;; p = obj_new('kdm_kml_placemark', $
;;             ;;0,5 -5,0 5,0 5,5 0,5
;;             lat=[0,0,5,5,0], $
;;             lon=[5,0,0,5,5], $
;;             alt=0, $;1e5, $
;;             x_altitudeMode='relativeToGround', visibility=1,
;;             tesselate=0 )

pl = obj_new( 'kdm_kml_placemark', name='PlaceMark', id='placeID', $
              description=kdm_cdata('Balloon contents...') )
d->add, pl
p = obj_new( 'kdm_kml_polygon', extrude=1, tessellate=1, $
             x_altitudeMode='clampToGround', id='polyID' )
pl->add, p
p->add, obj_new( 'kdm_kml_linearring', lat=[0,1,1,0,0]-0.5, $
                 lon=[0,0,1,1,0]-0.5, id='ringID' )

st = obj_new('kdm_kml_style')
st->add, obj_new('kdm_kml_polystyle', /fill, color=[128, 255,0,0] )
pl->add, st
;; p = obj_new('kdm_kml_placemark', $
;;             lat=47, lon=26)
r = obj_new('kdm_kml_region', $
            north=20, south=-20, east=20, west=-20, $
            minAlt=10, maxAlt=50, $
            minLod=128, maxLod=1024, minFade=32, maxFade=32 )
;pl->add, r
;d->add, p
kml->add, d
kml->saveKML, /openGE
end

