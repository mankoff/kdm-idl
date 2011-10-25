function kdm_where2d, test, n, _EXTRA=e

  sz = size( test, /dim )
  ncol = sz[0]
  if n_elements(sz) ne 2 then begin
     MESSAGE, "Only works with 2D data"
  endif

  idx = where( test eq 1, n, _EXTRA=e )
  col = idx mod ncol
  row = idx / ncol

  return, transpose([[col],[row]])
end

;;; testing
;; x = indgen(3,3)
;; print, x
;; r = kdm_where2d( x eq 5, num )
;; help, r, num
;; print, r
data = indgen(4,5)
data[ 3,3 ] = 0
data[ 3,* ] = 0
print, data
print, kdm_where2d( data eq 0 )
end
