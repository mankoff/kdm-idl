

function kdm_gchart_venn::type, _EXTRA=e
  return, 'v'
end

function kdm_gchart_venn::url, _EXTRA=e
  url = 't:'
  url = url + STRCOMPRESS(STRJOIN(STRING(self.area),','),/REMOVE) + ','
  url = url + STRTRIM(self.ab,2)+ ','
  url = url + STRTRIM(self.ac,2)+ ','
  url = url + STRTRIM(self.bc,2)+ ','
  url = url + STRTRIM(self.all,2)
  return, url
end

function kdm_gchart_venn::init, _EXTRA=e
  if self->kdm_gchart_data::init() ne 1 then return, 0
  self->setProperty, _EXTRA=e
  return, 1
end
pro kdm_gchart_venn__define, class
  class = { kdm_gchart_venn, $
            inherits kdm_gchart_data, $
            area: [0,0,0], $
            ab: 0, $
            ac: 0, $
            bc: 0, $
            all: 0 }
end
