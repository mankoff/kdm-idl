pro kdm_kml_folder::KMLhead
  self->kdm_kml_container::KMLhead
  self->buildsource, '<!-- Folder -->'
  self->buildsource, '<Folder id="'+self.ID+'">'
end
pro kdm_kml_folder::KMLbody
  self->kdm_kml_container::KMLbody
  ;;self->buildsource, 'folder body'
end
pro kdm_kml_folder::KMLtail
  self->buildsource, '</Folder>'
  self->buildsource, '<!-- /Folder -->'
  self->kdm_kml_container::KMLtail
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

