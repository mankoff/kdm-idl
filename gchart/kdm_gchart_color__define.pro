
function kdm_gchart_color::url, _EXTRA=e
  return, '&chco=' + self.color
end

pro kdm_gchart_color::setproperty, color=color, _EXTRA=e
  if keyword_set(color) then begin
     if n_elements(color) gt 1 then l = STRJOIN(color,",") else l=color
  endif
  self->kdm_gchart::setProperty, color=l, _EXTRA=e
end

function kdm_gchart_color::init, _EXTRA=e
  if self->kdm_gchart::init() ne 1 then return, 0
  self->setProperty, _EXTRA=e
  return, 1
end
pro kdm_gchart_color::cleanup
  ;; obj_destroy, child_objects
  ;; ptr_free, ptrs
  ;; self->kdm::cleanup
end 
pro kdm_gchart_color__define, class
  class = { kdm_gchart_color, $
            color: '', $
            inherits kdm_gchart }
end
