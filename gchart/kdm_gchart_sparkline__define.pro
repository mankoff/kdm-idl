
function kdm_gchart_sparkline::type, _EXTRA=e
  return, 'ls'
end
pro kdm_gchart_sparkline__define, class
  class = { kdm_gchart_sparkline, $
            inherits kdm_gchart_lineplot }
end
