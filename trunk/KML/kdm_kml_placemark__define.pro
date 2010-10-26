;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;; This object encapsulates the Placemark
;; http://code.google.com/apis/kml/documentation/kmlreference.html#placemark
;; 
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;; <Placemark>
;; Syntax
;;
;; <Placemark id="ID">
;;   <!-- inherited from Feature element -->
;;   <name>...</name>                      <!-- string -->
;;   <visibility>1</visibility>            <!-- boolean -->
;;   <open>0</open>                        <!-- boolean -->
;;   <atom:author>...<atom:author>         <!-- xmlns:atom -->
;;   <atom:link>...</atom:link>            <!-- xmlns:atom -->
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
;;   <!-- specific to Placemark element -->
;;   <Geometry>...</Geometry>
;; </Placemark>
;;
;; Description
;; A Placemark is a Feature with associated Geometry. In Google Earth,
;; a Placemark appears as a list item in the Places panel. A Placemark
;; with a Point has an icon associated with it that marks a point on
;; the Earth in the 3D viewer. (In the Google Earth 3D viewer, a Point
;; Placemark is the only object you can click or roll over. Other
;; Geometry objects do not have an icon in the 3D viewer. To give the
;; user something to click in the 3D viewer, you would need to create
;; a MultiGeometry object that contains both a Point and the other
;; Geometry object.) 
;;
;; Elements Specific to Placemark
;;     * 0 or one <Geometry> elements
;;
;; Extends
;;     * <Feature>
;;
;; Contained By
;;     * <Document>
;;     * <Folder>
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


pro kdm_kml_placemark::KMLhead
  self->kdm_kml_feature::KMLhead
  self->buildsource, '<Placemark id="'+self.ID+'">'
end
;; pro kdm_kml_placemark::KMLbody, kml=kml
;;   self->kdm_kml_feature::KMLbody, kml=kml
;; end
pro kdm_kml_placemark::KMLtail
  self->buildsource, '</Placemark>'
  self->kdm_kml_feature::KMLtail
end

pro kdm_kml_placemark::setproperty, lat=lat, lon=lon, _EXTRA=e
  if keyword_set(e) then self->kdm_kml_feature::setproperty, _EXTRA=e
  if not ptr_valid( self.children ) AND keyword_set(lat) then begin
  ;;if keyword_set(lat) then begin
     if n_elements(lat) eq 1 then begin
        self->add, obj_new('kdm_kml_point', lat=lat, lon=lon, _EXTRA=e )
     endif else if n_elements(lat) gt 1 then begin
        self->add, obj_new('kdm_kml_linestring', lat=lat, lon=lon, _EXTRA=e )
     endif
  endif
end

function kdm_kml_placemark::init, _EXTRA=e
  if self->kdm_kml_feature::init(_EXTRA=e) ne 1 then return, 0
  ;;self.geometry = obj_new('kdm_kml_geometry', _EXTRA=e)
  self->setProperty, _EXTRA=e
  ;;self.geometry = obj_new('kdm_kml_linestring', _EXTRA=e )
  return, 1
end
pro kdm_kml_placemark::cleanup
  ;;OBJ_DESTROY, self.geometry
  self->kdm_kml_feature::cleanup
end 
pro kdm_kml_placemark__define, class
  class = { kdm_kml_placemark, $
            inherits kdm_kml_feature }
end



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;; test
;;
pro kdm_kml_placemark_test
  kml = obj_new('kdm_kml', file='placemarks.kml')
  d = obj_new( 'kdm_kml_document', visibility=1 )
  f = obj_new( 'kdm_kml_folder', id='folder', name='aFolder' )

  for i = 0, 42 do begin
     istr = STRING(i,FORMAT='(I03)')
     p = obj_new('kdm_kml_placemark', $
                 id='Pid'+istr, $
                 lat=randomn(seed,1)*90, $
                 lon=randomu(seed,1)*360, $
                 x_altitudemode='relativeToGround', $
                 altitude=randomu(seed,1)*1e7, $
                 extrude=randomu(seed,1) gt 0.5, $
                 description=istr, $
                 name='Pid'+istr, $
                 visibility=1 )
     f->add, p
  endfor
  d->add, f
  kml->add, d
  kml->saveKML, /openGE, hint='mars'
end

kdm_kml_placemark_test
end
