;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;; This object encapsulates the Link
;; http://code.google.com/apis/kml/documentation/kmlreference.html#link
;; 
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

pro kdm_kml_link::KMLhead
  self->buildsource, '<Link>'
end

pro kdm_kml_link::KMLbody
  if self.href eq '' then MESSAGE, "HREF undefined"
  self->buildsource, self->xmlTag( "href", self.href )
end
pro kdm_kml_link::KMLtail
  self->buildsource, '</Link>'
end

function kdm_kml_link::init, _EXTRA=e
  MESSAGE, "Only basic HREF feature implemented", /CONTINUE
  if self->kdm_kml_object::init(_EXTRA=e) ne 1 then return, 0
  self->setProperty, _EXTRA=e
  return, 1
end
pro kdm_kml_link::cleanup
  self->kdm_kml_object::cleanup
end 
pro kdm_kml_link__define, class
  class = { kdm_kml_link, $
            inherits kdm_kml_object, $
;; NOT IMPLEMENTED
;;             refreshMode: '', $
;;             refreshInterval: '', $
;;             viewRefreshMode: '', $
;;             viewRefreshTime: '', $
;;             viewFormatBBOX: ''
;;             viewFormatCAMERA: ''
;;             viewFormatVIEW: ''
            href: '' }
end

link = obj_new('kdm_kml_link', href="http://kenmankoff.com/maps/MM71/MM71_links.kml" )
link->saveKML
end
