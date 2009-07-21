
;; given a string, insert it into the current KML file
pro kdm_kml::inject

;; inject this into the top level folder, setting the date to today:  
;; Effect: Time sliders are expanded by default
;;     <gx:Tour>
;;       <name>Play me</name>
;;       <gx:Playlist>
;;         <gx:FlyTo>
;;           <gx:duration>8.0</gx:duration>
;;           <gx:flyToMode>bounce</gx:flyToMode>
;;           <LookAt>
;;             <longitude>-119.748584</longitudne>
;;             <latitude>33.736266</latitude>
;;             <altitude>0</altitude>
;;             <heading>-9.295926</heading>
;;             <tilt>84.0957450</tilt>
;;             <range>4469.850414</range>
;;             <gx:altitudeMode>relativeToSeaFloor</gx:altitudeMode>
;;           </LookAt>
;;         </gx:FlyTo>

end

pro kdm_kml::saveKML, kml=kml, recursive=recursive, kmz=kmz, openge=openge, _EXTRA=e
  self->KMLhead, kml=kml
  self->KMLbody, kml=kml

  c=self.children
  if ptr_valid(c) then begin 
     for i=0,n_elements(*c)-1 do begin
        ;;print, label + obj_class(self)
        ;;(*c)[i]->Hierarchy, label='    '+label, /recursive
        (*c)[i]->saveKML, kml=kml, /recursive
     endfor
     self->KMLtail, kml=kml
  endif else self->KMLtail, kml=kml

  ;; kml contains all the source code for the file
  if not keyword_set(recursive) then begin
     self->prettyprint, kml     ; save to file
     if keyword_set( kmz ) then self->kml2kmz, _EXTRA=e
     if keyword_set( openge ) AND self.filename ne '' then begin
        file = keyword_set( kmz ) ? STRMID(self.filename,0,STRLEN(self.filename)-3)+'kmz' : self.filename
        spawn, 'open -a "Google Earth" ' + file
     endif
  endif
end

pro kdm_kml::kml2kmz, dirs=dirs, include=include, exclude=exclude
  if keyword_set(include) AND keyword_set(exclude) then $
     MESSAGE, "Include and exclude are mutually exclusive"
  kmlfile = self.filename
  kdm_filepathext, kmlfile, pathstr=path, root=root
  kmzfile = path + root + '.kmz'

  ;; zip -r zipfile foo.kml dirs -i include_list -x exclude_list
  cmd = 'zip -r ' + kmzfile + ' ' + kmlfile
  if keyword_set(dirs) then cmd += ' ' + STRJOIN( dirs, ' ' )
  if keyword_set(include) then begin
     files = file_search( dirs, '*'+include+'*' )
     openw, lun, 'tmp.include', /get_lun
     printf, lun, kmlfile
     for i = 0, n_elements(files)-1 do printf, lun, files[i]
     free_lun, lun
     cmd = cmd + ' -i@tmp.include'
  endif
  if keyword_set(exclude) then begin
     message, "not yet implemented"
  endif
  ;;if keyword_set(exclude) then cmd += ' -x' + '`ls -R *'+include+'*`'
  print, cmd
  spawn, cmd, out
  ;;file_delete, kmlfile, tmp.include, 
end

pro kdm_kml::buildsource, kml, str
  kml = kml + str + STRING(10B)
end
pro kdm_kml::KMLhead, kml=kml
  kml = ''
  self->buildsource, kml, '<?xml version="1.0" encoding="UTF-8"?>'
  self->buildsource, kml, '<kml xmlns="http://www.opengis.net/kml/2.2"'
  self->buildsource, kml, ' xmlns:gx="http://www.google.com/kml/ext/2.2">'
end
pro kdm_kml::KMLbody, kml=kml
  self->buildsource, kml, "<!-- Top Level Body -->"
end
pro kdm_kml::KMLtail, kml=kml
  self->buildsource, kml, '</kml>'
end
pro kdm_kml::prettyprint, str
  message, "Printing...", /CONTINUE
  if self->getProperty(/filename) ne '' then $
     openw, lun, self->getProperty(/filename), /get_lun else lun = -1
  printf, lun, str
  if lun ne -1 then free_lun, lun
end

function kdm_kml_object::xmlTag, tag, str, _EXTRA=e
  return, '<'+tag+'>'+STRTRIM(str,2)+'</'+tag+'>'
end




function kdm_kml::init, _EXTRA=e
  kdm_requiresubclass, self, 'kdm'
  if self->kdm::init(_EXTRA=e) ne 1 then return, 0
  self->setProperty, visibility=1, extrude=1, _EXTRA=e
  return, 1
end
pro kdm_kml::cleanup
  self->objtree::cleanup
end 
pro kdm_kml__define, class
  class = { kdm_kml, $
            inherits kdm, $
            kml_source: '', $
            filename: '', $
            inherits objtree }
end

