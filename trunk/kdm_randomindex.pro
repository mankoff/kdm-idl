;;http://www.dfanning.com/code_tips/randomindex.html

function kdm_randomindex, len, n_in
  swap = n_in gt len/2
  IF swap THEN n = len-n_in ELSE n = n_in
  inds = LonArr(n, /NOZERO)
  M = n
  WHILE n GT 0 DO BEGIN
     inds[M-n] = Long( RandomU(seed, n)*len )
     inds = inds[Sort(inds)]
     u = Uniq(inds)
     n = M-n_elements(u)
     inds[0] = inds[u]
  ENDWHILE
  
  IF swap THEN inds = Where(Histogram(inds,MIN=0,MAX=len-1) EQ 0)
  RETURN, inds
end

;; testing
print, " "
print, "Three Random Indices in a 5 element array, 5x"
for i = 0, 4 do print, kdm_randomindex( 5, 3 )

;; stats
;; undefine, idx
;; for i = 0, 500 do idx = arrconcat( idx, kdm_randomindex( 10, 3 ) )

end
