pro kdm_kml_folder::KMLhead, kml=kml
  self->kdm_kml_container::KMLhead, kml=kml
  self->buildsource, kml, '<!-- Folder -->'
  self->buildsource, kml, '<Folder id="'+self.ID+'">'
end
pro kdm_kml_folder::KMLbody, kml=kml
  self->kdm_kml_container::KMLbody, kml=kml
  ;;self->buildsource, kml, 'folder body'
end
pro kdm_kml_folder::KMLtail, kml=kml
  self->buildsource, kml, '</Folder>'
  self->buildsource, kml, '<!-- /Folder -->'
  self->kdm_kml_container::KMLtail, kml=kml
end

function kdm_kml_folder::init, _EXTRA=e
  if self->kdm_kml_container::init(_EXTRA=e) ne 1 then return, 0
  self->setProperty, _EXTRA=e
  return, 1
end
pro kdm_kml_folder::cleanup
  self->kdm_kml_container::cleanup
end 

;; A Folder IsA Container and contains one or more feature elements
pro kdm_kml_folder__define, class
  class = { kdm_kml_folder, $
            inherits kdm_kml_container }
end

