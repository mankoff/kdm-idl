;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;; This is NOT part of the KML API. This is a custom implementation
;; of vertical data curtains based on the MODEL element
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;; Extends
;;     * <Geometry>
;;
;; Contained By
;;     * <MultiGeometry>
;;     * <Placemark>
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; helper function to read in a complete file to one long string
function kdm_kml_curtain_readfile, file
  lines=FILE_LINES(file)
  rr=STRARR(lines)
  OPENR, lun, file, /GET_LUN
  READF, lun, rr
  FREE_LUN, lun
  return, rr
end

;; helper function: Given a string (str), a search term (str0) and a
;; replacement term (str1), find the search term and relpace it with
;; the replacement term.
pro kdm_kml_curtain_repstr, str, str0,str1
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


  ll2rb, self.lon0,self.lat0,self.lon1,self.lat1,dist,azi,/DEGREES
  bot_dist = (dist*!dtor)*6378.1 * 1e3                   ; distance in meters on surface
  top_dist = (dist*!dtor)*(6378.1 * 1e3 + self.top_altitude ) ; distance in meters at top
  top_alt_str = STRTRIM(LONG(self.top_altitude),2)

  lat_center = (self.lat0+self.lat1)/2.
  lon_center = (self.lon0+self.lon1)/2.
  azi = STRTRIM((azi+90),2)

  ps = path_sep()
  folder0 = file_uniq()
  folder1 = folder0 + ps + "files"
  file_mkdir, folder0 & file_mkdir, folder1

  findpro, 'kdm_kml_vertical__define', dirlist=d ; find self
  template = d ;+'/curtain_template'
  ;; adjust the DAE file to the new coordinates. Set the width at the
  ;; base, the width at the top, and the height
  str = kdm_kml_curtain_readfile( template+ps+'files'+ps+'curtain.dae' )
  ;; <float_array id="mesh1-geometry-position-array" count="12">BLBL 0 0 BRBR  0 0 TLTL 0 HHHL TRTR 0  HHHR</float_array>
  kdm_kml_curtain_repstr, str, "BLBL", STRTRIM( -bot_dist/2.0, 2 )
  kdm_kml_curtain_repstr, str, "BRBR", STRTRIM( bot_dist/2.0, 2 )
  kdm_kml_curtain_repstr, str, "TLTL", STRTRIM( -top_dist/2.0, 2 )
  kdm_kml_curtain_repstr, str, "TRTR", STRTRIM( top_dist/2.0, 2 )
  kdm_kml_curtain_repstr, str, "HHHL", top_alt_str
  kdm_kml_curtain_repstr, str, "HHHR", top_alt_str

  kdm_filepathext, self.vertical_image, file=vertical_image_file
  kdm_kml_curtain_repstr, str, "curtain.png", vertical_image_file

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
  file_mkdir, 'kdm_kml_vertical_example'
  cd, 'kdm_kml_vertical_example'
  folder = obj_new('kdm_kml_folder')

  ;; generate 20 images and place them around the globe as vertical
  ;; curtains of data     
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
