
pro kdm_kml_feature::KMLhead
  self->buildsource, '<!-- Feature id="'+self.ID+'" -->'
end
pro kdm_kml_feature::KMLbody
  if self.name ne '' then self->buildsource, self->xmlTag("name",self.name)
  self->buildsource, self->xmlTag( "visibility", self.visibility*1 )
  self->buildsource, self->xmlTag( "open", self.open*1 )
  if self.description ne '' then self->buildsource, self->xmlTag( "description",self.description )
  if self.styleURL ne '' then self->buildsource, self->xmlTag( "styleUrl",self.styleURL )
  if self.snippet ne '' then self->buildsource, '<Snippet maxLines="'+STRTRIM(self.snipmaxlines,2)+'">'+self.snippet+'</Snippet>'
end
pro kdm_kml_feature::KMLtail
  self->buildsource, '<!-- /Feature -->'
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
            description: '', $
            ;; abstractview
            ;; timeprimitive, $
            styleURL: '' $
            ;;styleSelector, $
            ;; region
            ;; extendeddata
            
          }
end

;; o = obj_new('kdm_kml_feature', id='featID', name='TheFeature', description='My Description')
;; o->saveKML
;; end
