pro kdm_kml_folder::KMLhead
  self->kdm_kml_container::KMLhead
  ;;self->buildsource, '<!-- Folder -->'
  self->buildsource, '<Folder id="'+self.ID+'">'
end
pro kdm_kml_folder::KMLbody
  self->kdm_kml_container::KMLbody
  ;;self->buildsource, 'folder body'
end
pro kdm_kml_folder::KMLtail
  self->buildsource, '</Folder>'
  ;;self->buildsource, '<!-- /Folder -->'
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


;;; testing code
kml = obj_new('kdm_kml', file='kdm_kml_folder_test.kml' )
doc = obj_new('kdm_kml_document')
kml->add, doc

f0 = obj_new('kdm_kml_folder', name='F0', visi=1, open=1 ) ; vis ignored. Set by children
f01 = obj_new('kdm_kml_folder', name='F01', visi=0 )
f02 = obj_new('kdm_kml_folder', name='F02', visi=1 )
f0->add, f01
f0->add, f02

f1 = obj_new('kdm_kml_folder', name='F1', visi=1 ) ; vis ignored. Set by children
f11 = obj_new('kdm_kml_folder', name='F11', vis=0 )
f12 = obj_new('kdm_kml_folder', name='F12', vis=0 )
f1->add, f11
f1->add, f12

doc->add, f0
doc->add, f1
kml->saveKML, /openGE
end
