
;; Given x as a function of y_in, produce x_out binned onto scale
;; y_out

;; Concept: NBP0901 S and T data is on non-linear scale PrDm and we
;; want it averaged into 1 or 10 m depth bins

function kdm_binavg, x, y_in, y_out, $
                     bad=bad, $
                     _EXTRA=e
  ;; Maybe use value_locate?
  ;; http://www.dfanning.com/code_tips/valuelocate.html
  
  x_out = y_out*0
  for i_out = 0, n_elements(y_out)-1 do begin
     x0 = max( where( y_in le y_out[ i_out ] ) )
     x1 = min( where( y_in gt y_out[ i_out ] ) )
     if x0 eq -1 OR x1 eq -1 then MESSAGE, "Range out of bounds"
     
     if not keyword_set( bad ) then binavg = mean( x[ x0:x1 ] )
     
     if keyword_set( bad ) then begin
        subset = x[ x0:x1 ]
        gd = where( subset ne bad, ngd )
        if ngd eq 0 then binavg = bad else $
           binavg = total( subset[gd]  )/ n_elements(gd)
     endif
     x_out[ i_out ] = binavg
  endfor
  return, x_out
end
