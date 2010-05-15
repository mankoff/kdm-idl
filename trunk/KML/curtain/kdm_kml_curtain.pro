
;; http://disc.sci.gsfc.nasa.gov/googleearth/
;;
;; Algorithm:
;; Given a lat0,lon0,lat1,lon1, height, and image, make a curtain.
;; v Compute distance on ground from lat0,lon0 to lat1,lon1 (Use: LL2RB.PRO)
;; v Compute distance at height h from lat0,lon0,h to lat1,lon1,h
;; v Compute center point (pivot) of curtain, and direction
;; v Scale the base across the base points
;; v Scale the height to height h
;; v Scale the top across the points at height h
;; v Place at center and in correct direction
;; v Paste on image

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

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;  
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;  
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;  
;;
;; Describe me...
;;
pro kdm_kml_curtain, $
   lat0=lat0, lon0=lon0, lat1=lat1, lon1=lon1, $ ; position
   top_altitude=top_altitude, $                  ; height
   image=image, $
   file=file, $                 ; output KML file
   openGE=openGE, $             ; launch file in GE once created?
   _EXTRA=e

  ;; require inputs
  kdm_isdefined, lat0
  kdm_isdefined, lon0
  kdm_isdefined, lat1
  kdm_isdefined, lon1
  kdm_isdefined, top_altitude, default=1e3 * 100 ; 100 km
  kdm_isdefined, image, prompt='Enter path to image: ', default=''
  kdm_isdefined, file, default='curtain.kmz'

  ps = path_sep()

  folder0 = file+'.zipme'
  folder1 = folder0 + ps + "files"
  file_mkdir, folder0 & file_mkdir, folder1

  lat0_str = STRTRIM(lat0,2)
  lon0_str = STRTRIM(lon0,2)
  top_alt_str = STRTRIM(LONG(top_altitude),2)

  ll2rb, lon0,lat0,lon1,lat1,dist,azi,/DEGREES
  bot_dist = (dist*!dtor)*6378.1 * 1e3                   ; distance in meters on surface
  top_dist = (dist*!dtor)*(6378.1 * 1e3 + top_altitude ) ; distance in meters at top

  lat_center = (lat0+lat1)/2.
  lon_center = (lon0+lon1)/2.
  
  azi = STRTRIM((azi+90),2)

  findpro, 'kdm_kml_curtain', dirlist=d ; find self
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
  openw, lun, folder0+ps+'files'+ps+'curtain.dae', /get
  printf, lun, str
  free_lun, lun

  ;; adjust the KML file with the location and heading of the curtain
  str = kdm_kml_curtain_readfile( template+ps+'doc.kml' )

  kdm_kml_curtain_repstr, str, "LON", STRTRIM( lon_center, 2 )
  kdm_kml_curtain_repstr, str, "LAT", STRTRIM( lat_center, 2 )
  kdm_kml_curtain_repstr, str, "ALT", STRTRIM( 0, 2 )
  kdm_kml_curtain_repstr, str, "HEAD", STRTRIM( azi, 2 )
  openw, lun, folder0+ps+'doc.kml', /get
  printf, lun, str
  free_lun, lun

  ;file_copy, template+ps+'files'+ps+'curtain.dae', folder1
  file_copy, image, folder1+ps+'curtain.png', /OVERWRITE

  cd, folder0, cur=cwd
  spawn, 'zip -r ../' + file + ' .', capture_output
  cd, cwd
  if keyword_set(openGE) then spawn, 'open '+file

  ;; Clean Up
  if folder0 eq '' OR folder0 eq "/" then stop ;; A bit of safety?
  file_delete, folder0+ps+'doc.kml'
  file_delete, folder0+ps+'files'+ps+'*'
  file_delete, folder0+ps+'files'+ps+'*'
  file_delete, folder0+ps+'files'
  file_delete, folder0

end


pro kdm_kml_curtain_test
  kdm_kml_curtain, $
     lat0=0, lon0=0, $
     lat1=10, lon1=0, $
     top=1e6, $
     file=f, $
     image='/Users/mankoff/local/IDL_lib/kdm-idl/trunk/KML/curtain/files/curtain.png', $
     _EXTRA=e

;;   for ll = 0, 80, 5 do begin
;;      f = STRTRIM(ll,2)+'.kmz'
;;      kdm_kml_curtain, $
;;         lat0=ll, lon0=0, $
;;         lat1=ll+5, lon1=0, $
;;         top=1e6, $
;;         file=f, $
;;         image='/Users/mankoff/local/IDL_lib/kdm-idl/trunk/KML/curtain/files/curtain.png', $
;;         _EXTRA=e
;;      wait, 0.1
;;   endfor
end

kdm_kml_curtain_test
end
