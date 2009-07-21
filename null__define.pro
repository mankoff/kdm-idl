function null::init, _EXTRA=e
  self->setProperty, _EXTRA=e
  if self->GetProperty(/null_debug) then MESSAGE, "Init", /CONTINUE
  if self->kdm::init(_EXTRA=e) ne 1 then message, "Parent init fail", /CONTINUE
  return, 1
end
pro null::cleanup
  if self->GetProperty(/debug) then MESSAGE, "Cleanup", /CONTINUE
end 
pro null__define, class
  class = { null, $
            null_debug: 1B, $ $
            null_value: 0B, $
            null_ptr: ptr_new(), $
            inherits kdm }
end
