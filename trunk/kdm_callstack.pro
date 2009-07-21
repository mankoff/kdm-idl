pro kdm_callstack
  help, /traceback, output=stack
  str = ''
  for i = n_elements(stack)-1,1,-1 do begin
     if STRMID( stack[i], 0, 1 ) ne '%' then continue
     data = STRSPLIT( stack[i], /EXTRACT )
     str = str + STRTRIM(data[1],2)
     if n_elements(data) gt 2 then $
        str = str + '('+STRTRIM(data[2],2)+')' + ' > ' $
     else str = str + '   '
  endfor
  str = STRMID( str, 0, STRLEN( str ) -3 ) ; trim off last ' > '
  print, str
end

;; pro test
;; ;  stop
;; kdm_callstack
;; end

;; kdm_callstack
;; test
;; end
