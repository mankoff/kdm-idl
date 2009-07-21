;+
; NAME: KDM_KML_IMG
;
; PURPOSE: Produce KML/KMZ files of images
;
; CATEGORY: Visualization
;
; CALLING SEQUENCE: KDM_KML_IMG, path_to_img
;
; INPUTS: The path to an image or array of image paths
;
; OPTIONAL INPUTS:
;     FILENAME: The name of the output file
;     FILEBASE: The base for each file (can be HTTP URL or "./")
;     BOUNDARY: The boundary of each image
;
;     NAME: Name of each layer (shown in sidebar)
;     OPACITY: The opacity of the layer (0 to 100)
;     STARTTIME: The start time of each image 
;                Format: 2009-01-15T01:00:00Z or just 2009
;     STOPTIME: The stop time of each image
;     DESCRIPTION: Text for the info balloon for each image
;
;     LEGEND: path to an image legend. Uses FILEBASE if supplied
;     
; KEYWORD PARAMETERS:
;     KMZ: Produce a KMZ rather than KML file
;     OPEN: Issue the 'open' command (on OS X) to ease debugging
;
; OUTPUTS:
;     A KML or KMZ file
;
; SIDE EFFECTS:
;     1. Produces a KML or KMZ file on disk
;     2. Produces a temporary unique folder if creating a KMZ
;
; EXAMPLE:
;     KDM_KML_IMG, 'foo.png'
;     KDM_KML_IMG, ['1977.png','2007.png'], BOUNDARY=[45,-180,86,180], $
;              OPACITY=0.5, FILEBASE="http://somewhere.com/subdir/", $
;              STARTTIME=['1977','2007'], STOPTIME=['1998','2008'], /OPEN
;
; MODIFICATION HISTORY:
;     KDM: 2008-05: Rough 1st draft.
;     KDM: 2009-02: Improved, mostly to use arrays for multiple images
;
;-

pro kdm_kml_img, image, $                       ; input graphic
             filename=filename, $         ; output KML
             legend=legend, $
             filebase=filebase, $
             boundary = boundary, $       ; [lat0,lon0,lat1,lon1]
             name=name, $                 ; in the sidebar
             description = description, $ ; in the bubble
             opacity = opacity, $
             starttime = starttime, $
             stoptime = stoptime, $
             hidechildren = hidechildren, $
             radio = radio, $
             kmz = kmz, $
             open = open, $     ; launch the KML when done?
;;           ;;   lookat fields
             looklon = looklon, $
             looklat = looklat, $
             lookalt = lookalt, $
             lookrange = lookrange, $
             looktilt = looktilt, $
             lookhead = lookhead, $
             lookmode = lookmode, $
             _EXTRA=e

  ;; logical keywords set?
  if keyword_set( filebase ) and keyword_set( kmz ) then begin
     if STRLOWCASE(STRMID( filebase, 0, 4 )) eq 'http' then begin
        MESSAGE, "Both KMZ and FILEBASE were specificed", /CONTINUE
        MESSAGE, "KMZ for remote files is valid KML but not supported"
     endif
  endif
  
  ;; default values if not set
  if not keyword_set(boundary) then boundary = [-90,-180,90,180]
  if not keyword_set(name) then name = image
  if not keyword_set(description) then description = name
  if not keyword_set(opacity) then opacity = 75
  if not keyword_set(filebase) then filebase = './'
  if not keyword_set(filename) then $
     filename = 'idlkml.'+ (keyword_set(kmz)?'kmz':'kml')
  
  ;; look defaults
  if not keyword_set(looklon) then $
     looklon = (boundary[1]+boundary[3])/2.0
  if not keyword_set(looklat) then $
     looklat = (boundary[0]+boundary[2])/2.0
  if not keyword_set(lookalt) then lookalt = 0.0
  if not keyword_set(lookrange) then lookrange = 1.3e7
  if not keyword_set(looktilt) then looktilt = 0.0
  if not keyword_set(lookhead) then lookhead = 0.0
  if not keyword_set(lookmode) then lookmode = 'relativeToGround'

  ;; everything correct array size?
  nel = n_elements( image )
  imagepath = filebase + image  ; filebase should be 1 or n_elements(image)
  if keyword_set(legend) then legendpath = filebase + legend
  if n_elements(name) ne nel then name = replicate(name, nel)
  if n_elements(description) ne nel then description = replicate( description, nel )
  if n_elements(boundary) ne 4 then begin
     MESSAGE, "ERROR: All images must have same boundary for now", /CONTINUE
     MESSAGE, "Contact Ken (or implement and send changes)"
  endif

  ;; convert everything to strings
  color = STRTRIM(STRING( (opacity/100.)*255, FORMAT='(Z)') + 'FFFFFF', 2 )
  if keyword_set( starttime) then starttime = STRTRIM(starttime,2)
  if keyword_set( stoptime) then stoptime = STRTRIM(stoptime,2)
  boundary = STRTRIM(boundary,2)
  lookrange = STRTRIM(DOUBLE(lookrange),2)
  looklon = STRTRIM(looklon, 2)
  looklat = STRTRIM(looklat, 2)
  lookalt = STRTRIM(lookalt, 2)
  lokkrange = STRTRIM(lookrange,2)
  looktilt = STRTRIM(looktilt,2)
  lookhead = STRTRIM(lookhead,2)
  
  ;; create temporary folder and copy ALL files there if creating KMZ
  if keyword_set(kmz) then begin
     MESSAGE, "Copying all files for KMZ", /CONTINUE
     KML_dir = '/tmp/kdm_kml_img.tmp/'
     img_dir = kml_dir + "/files"
     file_delete, KML_dir, /allow_nonexistent, /recursive
     file_mkdir, KML_dir
     file_mkdir, img_dir
     file_copy, imagepath, img_dir
     file_copy, legendpath, img_dir
     docname = 'doc.kml'
  endif else begin
     kml_dir = './'
     docname = filename
  endelse

  ;; write the KML
  openw, lun, KML_dir+docname, /get
  printf, lun, '<?xml version="1.0" encoding="UTF-8"?>'
  printf, lun, '<kml xmlns="http://earth.google.com/kml/2.2">'

  if keyword_set( legend ) then begin
     ;; Only 1 root folder allowed, so if there is a legend then we
     ;; need to wrap EVERYTHING in yet another folder
     printf, lun, '<Folder>'
     ;;printf, lun, '<Folder>'
     ;;printf, lun, '  <name>Legend</name>'
     printf, lun, '<ScreenOverlay>'
     printf, lun, '  <name>Legend</name>'
     printf, lun, '  <Icon><href>'+legendpath+'</href></Icon>'
     printf, lun, '  <overlayXY x="0" y="1" xunits="fraction" yunits="fraction"/>'
     printf, lun, '  <screenXY x="0" y="1" xunits="fraction" yunits="fraction"/>'
     printf, lun, '  <rotationXY x="0.5" y="0.5" xunits="fraction" yunits="fraction"/>'
     printf, lun, '  <size x="-1" y="-1" xunits="pixels" yunits="pixels"/>'
     printf, lun, '</ScreenOverlay>'
     ;;printf, lun, '</Folder>'
  endif

  if nel ne 1 then printf, lun, '<Folder>'
  printf, lun, '  <name>'+strmid(docname,0,strlen(docname)-4)+'</name>'

  printf, lun, '  <LookAt>'     ; where to look
  printf, lun, '    <longitude>'+looklon+'</longitude>'
  printf, lun, '    <latitude>'+looklat+'</latitude>'
  printf, lun, '    <altitude>'+lookalt+'</altitude>'
  printf, lun, '    <range>'+lookrange+'</range>'
  printf, lun, '    <tilt>'+looktilt+'</tilt>'
  printf, lun, '    <heading>'+lookhead+'</heading>'
  printf, lun, '    <altitudeMode>'+lookmode+'</altitudeMode>'
  printf, lun, '  </LookAt>'

  if keyword_set(radio) then $
     printf, lun, "<Style><ListStyle><listItemType>" + $
             "radioFolder" + $
             "</listItemType></ListStyle></Style>"
  
  if keyword_set(hidechildren) then $
     printf, lun, "<Style><ListStyle><listItemType>" + $
             "checkHideChildren" + $
             "</listItemType></ListStyle></Style>"

  for i = 0, nel-1 do begin
     printf, lun, '<GroundOverlay>'
  
     printf, lun, '  <name>'+name[i]+'</name>'
     printf, lun, '  <description>'+description[i]+'</description>'
     printf, lun, '  <color>'+color+'</color>' ; opacity
     printf, lun, '  <Snippet maxLines="0"></Snippet>'

     printf, lun, '  <Icon>'    ; image
     printf, lun, '     <href>'+imagepath[i]+'</href>'
     printf, lun, '  </Icon>'
     
     if keyword_set( starttime ) OR keyword_set( stoptime ) then $
        printf, lun, '<TimeSpan>'
     if keyword_set( starttime ) then $
        printf, lun, '<begin>'+starttime[i]+'</begin>'
     if keyword_set( stoptime ) then $
        printf, lun, '<end>'+stoptime[i]+'</end>'
     if keyword_set( starttime ) OR keyword_set( stoptime) then $
        printf, lun, '</TimeSpan>'

     printf, lun, '  <LatLonBox>'
     printf, lun, '    <north>'+boundary[2]+'</north>'
     printf, lun, '    <south>'+boundary[0]+'</south>'
     printf, lun, '    <east>'+boundary[3]+'</east>'
     printf, lun, '	   <west>'+boundary[1]+'</west>'
     printf, lun, '  </LatLonBox>'
     
     printf, lun, '  <LookAt>'  ; where to look
     printf, lun, '    <longitude>'+looklon+'</longitude>'
     printf, lun, '    <latitude>'+looklat+'</latitude>'
     printf, lun, '    <altitude>'+lookalt+'</altitude>'
     printf, lun, '    <range>'+lookrange+'</range>'
     printf, lun, '    <tilt>'+looktilt+'</tilt>'
     printf, lun, '    <heading>'+lookhead+'</heading>'
     printf, lun, '    <altitudeMode>'+lookmode+'</altitudeMode>'
     printf, lun, '  </LookAt>'

     printf, lun, '</GroundOverlay>'
  endfor
  if nel ne 1 then printf, lun, '</Folder>'
  if keyword_set(legend) then printf, lun, '</Folder>'

  printf, lun, '</kml>'
  free_lun, lun
  
  ;; create a local KMZ from the working folder
  if keyword_set(kmz) then begin
     cmd = '/usr/bin/zip -r ' + filename + ' ' + KML_dir
     spawn, cmd, output
  endif
  
  if keyword_set(open) then spawn, '/usr/bin/open ' + filename
end


;; kdm_kml_img,['pic1.png','pic1.png'],filebase='/Users/mankoff/Desktop/',
;; /open, legend='pic1.png', name=['foo','bar'], filename='Testing.kml'

;;kdm_kml_img,'pic1.png',filebase='/Users/mankoff/Desktop/', /open
;;kdm_kml_img,['pic1.png','pic2.png'],filebase='/Users/mankoff/Desktop/', /open, boundary=[-80,-70,-60,-50], starttime=[1997,2007], stoptime=[1999,2010], opacity=75, /kmz
;end
