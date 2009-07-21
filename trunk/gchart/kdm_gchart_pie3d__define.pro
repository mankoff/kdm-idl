

function kdm_gchart_pie3d::type, _EXTRA=e
  return, 'p3'
end
pro kdm_gchart_pie3d__define, class
  class = { kdm_gchart_pie3d, $
            inherits kdm_gchart_pie }
end

