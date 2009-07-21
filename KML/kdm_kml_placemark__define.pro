pro kdm_kml_placemark::KMLhead, kml=kml
  self->kdm_kml_feature::KMLhead, kml=kml
  self->buildsource, kml, '<Placemark id="'+self.ID+'">'
end
;; pro kdm_kml_placemark::KMLbody, kml=kml
;;   self->kdm_kml_feature::KMLbody, kml=kml
;; end
pro kdm_kml_placemark::KMLtail, kml=kml
  self->buildsource, kml, '</Placemark>'
  self->kdm_kml_feature::KMLtail, kml=kml
end

pro kdm_kml_placemark::setproperty, lat=lat, lon=lon, _EXTRA=e
  if keyword_set(e) then self->kdm_kml_feature::setproperty, _EXTRA=e
  if not ptr_valid( self.children ) AND keyword_set(lat) then begin
  ;;if keyword_set(lat) then begin
     if n_elements(lat) eq 1 then begin
        self->add, obj_new('kdm_kml_point', lat=lat, lon=lon, _EXTRA=e )
     endif else if n_elements(lat) gt 1 then begin
        self->add, obj_new('kdm_kml_linestring', lat=lat, lon=lon, _EXTRA=e )
     endif
  endif
end

function kdm_kml_placemark::init, _EXTRA=e
  if self->kdm_kml_feature::init(_EXTRA=e) ne 1 then return, 0
  ;;self.geometry = obj_new('kdm_kml_geometry', _EXTRA=e)
  self->setProperty, _EXTRA=e
  ;;self.geometry = obj_new('kdm_kml_linestring', _EXTRA=e )
  return, 1
end
pro kdm_kml_placemark::cleanup
  ;;OBJ_DESTROY, self.geometry
  self->kdm_kml_feature::cleanup
end 
pro kdm_kml_placemark__define, class
  class = { kdm_kml_placemark, $
            inherits kdm_kml_feature }
            ;;geometry: obj_new() }
end

