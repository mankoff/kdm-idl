pro kdm_gd_subset, gd, $
                   x0,x1,x2,x3,x4,x5,x6,x7,x8,x9,x10,x11,x12

  ;; if n_tags(x0) ne 0 then begin ;; struct
  ;;    stop
  ;;    for i = 0, n_tags(x0)-1 do begin
  ;;       x0.(i) = (x0.(i))[gd]
  ;;    endfor
  ;; endif

  if n_elements(x0) ne 0 then x0 = x0[gd]
  if n_elements(x1) ne 0 then x1 = x1[gd]
  if n_elements(x2) ne 0 then x2 = x2[gd]
  if n_elements(x3) ne 0 then x3 = x3[gd]
  if n_elements(x4) ne 0 then x4 = x4[gd]
  if n_elements(x5) ne 0 then x5 = x5[gd]
  if n_elements(x6) ne 0 then x6 = x6[gd]
  if n_elements(x7) ne 0 then x7 = x7[gd]
  if n_elements(x8) ne 0 then x8 = x8[gd]
  if n_elements(x9) ne 0 then x9 = x9[gd]
  if n_elements(x10) ne 0 then x10 = x10[gd]
  if n_elements(x11) ne 0 then x11 = x11[gd]
  if n_elements(x12) ne 0 then x12 = x12[gd]
end
