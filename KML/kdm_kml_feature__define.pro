
pro kdm_kml_feature::KMLhead, kml=kml
  self->buildsource, kml, '<!-- Feature id="'+self.ID+'" -->'
end
pro kdm_kml_feature::KMLbody, kml=kml
  ;;self->kdm_kml_object::printbody, _EXTRA=e
  if self.name ne '' then self->buildsource, kml, self->xmlTag("name",self.name)
  self->buildsource, kml, self->xmlTag( "visibility", self.visibility*1 )
  self->buildsource, kml, self->xmlTag( "open", self.open*1 )
  if self.description ne '' then self->buildsource, kml, self->xmlTag( "description",self.description )
  if self.snippet ne '' then self->buildsource, kml, '<Snippet maxLines="'+STRTRIM(self.snipmaxlines,2)+'">'+self.snippet+'</Snippet>'
  ;;self->buildsource, kml, self->xmlTag( "Snippet", self.Snippet )
  ;;self->buildsource, kml, '<Snippet maxlines="0"></Snippet>'
end
pro kdm_kml_feature::KMLtail, kml=kml
  self->buildsource, kml, '<!-- /Feature -->'
end

function kdm_kml_feature::init, _EXTRA=e
  if self->kdm_kml_object::init(_EXTRA=e) ne 1 then return, 0
  self->setProperty, _EXTRA=e
  return, 1
end
pro kdm_kml_feature::cleanup
  self->kdm_kml_object::cleanup
end 
pro kdm_kml_feature__define, class
  class = { kdm_kml_feature, $
            inherits kdm_kml_object, $
            name: '', $
            visibility: 0B, $
            open: 0B, $
            Snippet: '', $
            snipmaxlines: 0, $
            description: '' $
            ;; abstractview
            ;; timeprimitive, $
            ;;styleURL: '', $
            ;;styleSelector, $
            ;; region
            ;; extendeddata
            
          }
end

;; o = obj_new('kdm_kml_feature', id='featID', name='TheFeature', description='My Description')
;; o->saveKML
;; end
