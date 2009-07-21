

function kdm_gchart_xy::type, _EXTRA=e
  return, 'lxy'
end

function kdm_gchart_xy::url, _EXTRA=e
  url = 't:'
  url = url + self.x0 + '|' + self.y0
  if self.x1 ne '' then url = url + '|' + self.x1 + '|' + self.y1
  return, url
end

pro kdm_gchart_xy::setProperty, x0=x0, y0=y0, x1=x1, y1=y1, _EXTRA=e
  if keyword_set(x0) then self.x0 = STRCOMPRESS(STRJOIN(STRING(x0),','),/REMOVE)
  if keyword_set(x1) then self.x1 = STRCOMPRESS(STRJOIN(STRING(x1),','),/REMOVE)
  if keyword_set(y0) then self.y0 = STRCOMPRESS(STRJOIN(STRING(y0),','),/REMOVE)
  if keyword_set(y1) then self.y1 = STRCOMPRESS(STRJOIN(STRING(y1),','),/REMOVE)
  self->kdm_gchart_data::setProperty, _EXTRA=e
end

function kdm_gchart_xy::init, _EXTRA=e
  if self->kdm_gchart_data::init() ne 1 then return, 0
  self->setProperty, _EXTRA=e
  return, 1
end
pro kdm_gchart_xy::cleanup
end 
pro kdm_gchart_xy__define, class
  class = { kdm_gchart_xy, $
            inherits kdm_gchart_data, $
            x0: '', $
            x1: '', $
            y0: '', $
            y1: '' }
end
