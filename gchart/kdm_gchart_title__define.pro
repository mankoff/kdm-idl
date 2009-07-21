
function kdm_gchart_title::url, _EXTRA=e
  chtt = self.title
  if self.subtitle ne '' then chtt = chtt + '|' + self.subtitle
  return, '&chtt='+chtt
end

;; pro kdm_gchart_title::setproperty, title=title, _EXTRA=e
;;   if keyword_set(title) then begin
;;      if n_elements(title) gt 1 then l = STRJOIN(title,"|") else l=title
;;   endif
;;   self->kdm_gchart::setProperty, title=l, _EXTRA=e
;; end

function kdm_gchart_title::init, _EXTRA=e
  if self->kdm::init() ne 1 then return, 0
  self->setProperty, _EXTRA=e
  return, 1
end
pro kdm_gchart_title::cleanup
  ;; obj_destroy, child_objects
  ;; ptr_free, ptrs
  ;; self->kdm::cleanup
end 
pro kdm_gchart_title__define, class
  class = { kdm_gchart_title, $
            title: '', $
            subtitle: '', $
            inherits kdm_gchart }
end
