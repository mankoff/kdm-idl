

function kdm_gchart_pie::type, _EXTRA=e
  return, 'p'
end

function kdm_gchart_pie::url, _EXTRA=e
  url = 't:'
  url = url + self.slices
  return, url
end

pro kdm_gchart_pie::setProperty, data=data, _EXTRA=e
  if keyword_set(data) then slices = STRCOMPRESS(STRJOIN(STRING(data),','),/REMOVE)
  self->kdm_gchart_data::setProperty, slices=slices, _EXTRA=e
end

function kdm_gchart_pie::init, _EXTRA=e
  if self->kdm_gchart_data::init() ne 1 then return, 0
  self->setProperty, _EXTRA=e
  return, 1
end
pro kdm_gchart_pie::cleanup
end 
pro kdm_gchart_pie__define, class
  class = { kdm_gchart_pie, $
            inherits kdm_gchart_data, $
            slices: '' }
end

