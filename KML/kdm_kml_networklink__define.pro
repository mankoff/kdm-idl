;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;; This object encapsulates the NetworkLink
;; http://code.google.com/apis/kml/documentation/kmlreference.html#networklink
;; 
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

pro kdm_kml_NetworkLink::KMLhead
  self->buildsource, '<NetworkLink>'
end

pro kdm_kml_NetworkLink::KMLbody
  if self.name ne '' then self->buildsource, self->xmlTag("name",self.name)
  sml = STRTRIM( self.SnipMaxLines, 2 )
  self->buildsource, self->xmlTag( "visibility", STRTRIM(self.visibility,2) )
  self->buildSource, self->xmlTag( "open", STRTRIM(self.open,2) )
  self->buildsource, '<Snippet maxLines="'+STRTRIM(sml,2)+'"></Snippet>'
  self->buildSource, self->xmlTag( "description", self.description )
end
pro kdm_kml_NetworkLink::KMLtail
  self->buildsource, '</NetworkLink>'
end

function kdm_kml_NetworkLink::init, _EXTRA=e
  if self->kdm_kml_object::init(_EXTRA=e) ne 1 then return, 0
  self->setProperty, visibility=1, open=0
  self->setProperty, _EXTRA=e
  return, 1
end
pro kdm_kml_NetworkLink::cleanup
  self->kdm_kml_object::cleanup
end 
pro kdm_kml_NetworkLink__define, class
  class = { kdm_kml_NetworkLink, $
            inherits kdm_kml_object, $
            visibility: 0, $
            open: 0, $
            name: '', $
            SnipMaxLines: 0, $
            description: '' }
end

kml = obj_new('kdm_kml', file='test.kml')
nl = obj_new('kdm_kml_NetworkLink', open=0, vis=0 )
nl->add, obj_new('kdm_kml_link', href="http://kenmankoff.com/maps/MM71/MM71_links.kml" )
kml->add, nl
kml->saveKML
end
