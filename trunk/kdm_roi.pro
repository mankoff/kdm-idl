function kdm_roi, x0, y0, x1, y1
  o = obj_new('idlanroi', x0, y0 )
  interior = o->containspoints( x1, y1 )
  gd = where( interior ne 0, ngd )
  if ngd eq 0 then MESSAGE, "No interior points found", /CONTINUE
  obj_destroy, o
  return, gd
end

;; test
data_x = randomu( seed, 10, 10 ) * 10
data_y = randomu( seed, 10, 10 ) * 10
plot, data_x, data_y, /nodata
plots, data_x, data_y, psym=2

;; circle in the center
x = findgen(100) * (!pi*(2/99.))
y = sin(x)+5
x = cos(x)+5
oplot, x, y

inside = kdm_roi( x, y, data_x, data_y )
plots, data_x[inside], data_y[inside], color=253, psym=2
end
