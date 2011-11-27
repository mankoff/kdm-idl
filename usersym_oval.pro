pro usersym_oval, xs=xs, ys=ys
  if not keyword_set(xs) then xs=1
  if not keyword_set(ys) then ys=1
  i = 10
  x = [ cos( FINDGEN(i) * ((!PI)/(i-1.0)) ), $ ;; top half
        reverse(cos( FINDGEN(i) * ((!pi)/(i-1.0)) )) ]
  y = [ sin( FINDGEN(i) * ((!PI)/(i-1.0)) )+2, $ ;; top half
        reverse(sin( -FINDGEN(i) * ((!pi)/(i-1.0)) )-2) ]
  x = [x,x[0]]*xs
  y = [y,y[0]]*ys
  USERSYM, x,y
;;   plot, [-3,3], [-3,3], /nodata
;;   plots, 0, 0, psym=8, symsize=5
end
