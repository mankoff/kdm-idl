
;; currently only 1D

;; adjusts an array arr to size len either by truncating, or expanding
;; and filling with zeroes
function kdm_arrsetsize, arr, len
  if len eq n_elements(arr) then return, arr
  if len lt n_elements(arr) then return, arr[0:len-1]
  arr2 = fltarr( len )
  arr2[ 0: n_elements( arr )-1 ] = arr
  return, arr2
end
