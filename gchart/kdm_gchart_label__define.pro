
function kdm_gchart_label::url, _EXTRA=e
  return, '&chl=' + self.label
end

pro kdm_gchart_label::setproperty, label=label, _EXTRA=e
  if keyword_set(label) then begin
     if n_elements(label) gt 1 then l = STRJOIN(label,"|") else l=label
  endif
  self->kdm_gchart::setProperty, label=l, _EXTRA=e
end

function kdm_gchart_label::init, _EXTRA=e
  if self->kdm_gchart::init() ne 1 then return, 0
  self->setProperty, _EXTRA=e
  return, 1
end
pro kdm_gchart_label::cleanup
  ;; obj_destroy, child_objects
  ;; ptr_free, ptrs
  ;; self->kdm::cleanup
end 
pro kdm_gchart_label__define, class
  class = { kdm_gchart_label, $
            label: '', $
            inherits kdm_gchart }
end
