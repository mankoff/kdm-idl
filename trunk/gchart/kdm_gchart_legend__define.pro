
function kdm_gchart_legend::url, _EXTRA=e
  return, '&chdl=' + self.legend
end

pro kdm_gchart_legend::setproperty, legend=legend, _EXTRA=e
  if keyword_set(legend) then begin
     if n_elements(legend) gt 1 then l = STRJOIN(legend,"|") else l=legend
  endif
  self->kdm_gchart::setProperty, legend=l, _EXTRA=e
end

function kdm_gchart_legend::init, _EXTRA=e
  if self->kdm::init() ne 1 then return, 0
  self->setProperty, _EXTRA=e
  return, 1
end
pro kdm_gchart_legend__define, class
  class = { kdm_gchart_legend, $
            legend: '', $
            inherits kdm_gchart }
end
