
function kdm_gchart_lineplot::type, _EXTRA=e
  return, 'lc'
end

function kdm_gchart_lineplot::url, _EXTRA=e
  url = 't:'
  url = url + self.data
  return, url
end

pro kdm_gchart_lineplot::setProperty, data=data, _EXTRA=e
  if keyword_set(data) then begin
     data = kdm_range( data, from=minmax(data), to=[0,100] )
     data = fix(round(data))
     sz = size( data, /dim )
     if n_elements(sz) eq 1 then begin
        datastr = STRCOMPRESS(STRJOIN(STRING(data),','),/REMOVE)
     endif else begin
        datastr = ''
        for i = 0, sz[1]-1 do $
           datastr = datastr + STRCOMPRESS(STRJOIN(STRING(data[*,i]),','),/REMOVE)+"|"
        datastr = STRMID( datastr, 0, strlen(datastr)-1 )
     endelse
  endif
  self->kdm_gchart::setProperty, data=datastr, _EXTRA=e
end

function kdm_gchart_lineplot::init, _EXTRA=e
  if self->kdm_gchart_data::init() ne 1 then return, 0
  self->setProperty, _EXTRA=e
  return, 1
end
pro kdm_gchart_lineplot::cleanup
end 
pro kdm_gchart_lineplot__define, class
  class = { kdm_gchart_lineplot, $
            inherits kdm_gchart_data, $
            data: '' }
end
