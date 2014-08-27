;+
; CLASS_NAME:
;	kdm_kml
;
; PURPOSE:
;   Top level KML object for the kdm-idl kdm_kml group. A kdm_kml
;   object holds a kdm_kml_object. This object contains the generic
;   code that all other inherited KML objects might use
;
; CATEGORY:
;   KML
;
; SUPERCLASSES:
;   kdm, objtree
;
; SUBCLASSES:
;   kdm_kml_object
;
; CREATION:
;   kml = obj_new( 'kdm_kml', filename='output.kml' )
;
; METHODS:
;   saveKML: Write the KML to disk
;   KMLhead, KMLbody, KMLtail: Produce the head, body, and tail KML code
;
; MODIFICATION HISTORY:
; 	Written by:	Ken Mankoff, July 2009.
;
;-


;+
;
; METHODNAME:
;       kdm_kml::saveKML
;
; PURPOSE:
;       This method generats the KML code into a string and saves it
;       to disk. Optionally it converts the KML into a KMZ.
;
; CALLING SEQUENCE:
;   o->saveKML, /openGE, /KMZ, dirs=dirs, include=include, exclude=exclude
;
; OPTIONAL INPUTS:
;   /openGE: Open the resulting KML/KMZ file in Google Earth
;	
; KEYWORD PARAMETERS:
;   /KMZ: Convert the KML to KMZ. Optionally use the INCLUDE and
;         EXCLUDE keywords
;   INCLUDE=include: A string or array of strings listing files in
;           other folders (or entire folders) to include in the KMZ
;           file. This is because a KMZ contains images and various
;           other items that must be zipped into it.
;   EXCLUDE=exclude: A string or array of strings (wildcards allowed)
;           listing items that should be excluded from the KMZ.
;
;   Example of INCLUDE and EXCLUDE: Include a folder of images that
;   contains PS, PDF, and PNG images, but exclude the PS and PDF
;   images, as only the PNG images are used in the KMZ file.
;
; OUTPUTS:
;   This function writes a KML file to disk.
;
; EXAMPLE:
;   kml = obj_new('kdm_kml', filename='test.kml' )
;   doc = obj_new('kdm_kml_document')
;   placemark = obj_new('kdm_kml_placemark, $
;       name='Google Earth - New Placemark', $
;       description='Some Descriptive text.', $
;       lat=-90.86, lon=48.25 )
;   doc->add, placemark
;   kml->add, doc
;   kml->kmlSave, /kmz, /openGE
;
;-
pro kdm_kml::saveKML, recursive=recursive, $
                      kmz=kmz, openge=openge, $
                      hint=hint, $
                      _EXTRA=e

  ;; open the file, and store the LUN
  if not keyword_set(recursive) then begin
     if self->getProperty(/filename) ne '' then $
        openw, lun, self->getProperty(/filename), /get_lun else lun = -1
     self.lun = lun

     ;; hack to make the lun globally accessible. This should be
     ;; doable inside the object hierarchy but I'm having
     ;; trouble figuring it out... subclasses don't seem to see it...
     DEFSYSV, '!KDM_KML_LUN', lun
  endif

  ;; print the header
  if obj_class(self) eq 'KDM_KML' then self->KMLhead, hint=hint ELSE self->kmlHead ;; hack. 
  ;; Perhaps all KMLHEAD's should be redefined to support
  ;; _EXTRA=e so I can pass a hint to just this one?
  self->KMLbody

  ;; recursively print all children
  c=self.children
  if ptr_valid(c) then begin 
     for i=0L,n_elements(*c)-1 do begin
        ;;print, label + obj_class(self)
        ;;(*c)[i]->Hierarchy, label='    '+label, /recursive
        (*c)[i]->saveKML, /recursive
     endfor
     self->KMLtail
  endif else self->KMLtail

  ;; kml contains all the source code for the file
  if not keyword_set(recursive) then begin
     ;;printf, lun, str
     if lun ne -1 then free_lun, lun

     ;; format with xmllint
     spawn, 'xmllint', out, error
     if error[0] eq '' then begin ;; xmllint command works?
        spawn, 'xmllint --format ' + self.filename + '>' + self.filename+'.xml'
        spawn, 'mv ' + self.filename+'.xml ' + self.filename
     endif

     ;;self->prettyprint, kml     ; save to file
     if keyword_set( kmz ) then self->kml2kmz, _EXTRA=e
     if keyword_set( openge ) AND self.filename ne '' then begin
        file = keyword_set( kmz ) ? $
               STRMID(self.filename,0,STRLEN(self.filename)-3)+'kmz' : $
               self.filename
        MESSAGE, "Google Earth must already be running", /CONTINUE
        spawn, 'open ' + file
     endif
  endif
end


;;
;; Called by saveKML. Converts a KML to KMZ. Optional dirs, includ,
;; and exclude arguments can be used to incorporate images into the
;; KMZ to make it a self-contained bundle.
;;
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
     for i = 0L, n_elements(files)-1 do printf, lun, files[i]
     free_lun, lun
     cmd = cmd + ' -i@tmp.include'
  endif
  if keyword_set(exclude) then begin
     message, "not yet implemented"
  endif
  ;;if keyword_set(exclude) then cmd += ' -x' + '`ls -R *'+include+'*`'
  ;;print, cmd
  spawn, cmd, out
  ;;file_delete, kmlfile, tmp.include, 
end

pro kdm_kml::buildsource, kml
  printf, !KDM_KML_LUN, kml
end
pro kdm_kml::KMLhead, hint=hint
  self->buildsource, '<?xml version="1.0" encoding="UTF-8"?>'
  self->buildsource, '<kml xmlns="http://www.opengis.net/kml/2.2"'
  self->buildsource, ' xmlns:gx="http://www.google.com/kml/ext/2.2"'
  self->buildsource, ' xmlns:atom="http://www.w3.org/2005/Atom"'
  if keyword_set( hint ) then  self->buildsource, ' hint="target='+hint+'"'
  self->buildsource, '>'
end
pro kdm_kml::KMLbody
  ;;self->buildsource, "<!-- Top Level Body -->"
end
pro kdm_kml::KMLtail
  self->buildsource, '</kml>'
end

function kdm_kml_object::xmlTag, tag, val, _EXTRA=e
  return, '<'+tag+'>'+STRTRIM(STRING(val),2)+'</'+tag+'>'
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
            filename: '', $
            LUN: 0, $
            inherits objtree }
end

