
;;http://groups.google.com/group/comp.lang.idl-pvwave/browse_thread/thread/86ac5035179c0487/ec1e8945ec76fe23?lnk=gst&q=shuffle+array#ec1e8945ec76fe23

;; Knuth Shuffle
function kdm_arrayshuffle, array 
  na = n_elements(array) 
  rarray = array 
  b = randomu(seed,na-1) * (na - lindgen(na-1) - 1) + lindgen(na-1) 
  for i=0L,na-2 do begin 
    tmp = rarray[i] 
    rarray[i] = rarray[b[i]] 
    rarray[b[i]] = tmp 
 endfor 
  return, rarray 
END 
