
function template::init, _EXTRA=e
  ;; Require subclass of kdm ?
  if not obj_isa(self,'kdm') then begin 
     MESSAGE, "Must inherit KDM object", /CONTINUE
     return, 0
  endif
  ;; if self->parent::init(_EXTRA=e) ne 1 then return, 0
  self->setProperty, _EXTRA=e
  return, 1
end
pro template::cleanup
  ;; obj_destroy, child_objects
  ;; ptr_free, ptrs
end 
pro template__define, class
  class = { template, $
            delete_me: 0B }
end
