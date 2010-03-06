;+
;
; NAME:
;	KDM_ARRSETSIZE
;
; PURPOSE:
;       This function resizes a 1D array. It can truncate or expand
;       the array. When expanding it can optionally fill the new
;       elements with a default value.
;
; CATEGORY:
;	Array
;
; CALLING SEQUENCE:
;   Result = KDM_ARRSETSIZE( Array, newSize )
;
; INPUTS:
;   Array: An array of any type up to 8 dimensions
;   NewSize: The new length of the array. Each dimension can be
;            shorter, longer, or equal to the original length.
;
; KEYWORD PARAMETERS:
;   _EXTRA=e is passed to MAKE_ARRAY (VALUE might be useful)
;
; OUTPUTS:
;   A new array, based on the input array. For each dimension of the
;   array, if newSize[dim] is shorter then the result contains the
;   values in the original array dimension up to the truncation
;   point. If newSize is equal to the original array dimension length
;   then the new array is the same as the input array. If newSize is
;   larger than the length of the original array then the new array is
;   longer, filled with zero by default, or the value specified by the
;   VALUE keyword passed to MAKE_ARRAY. 
;
; RESTRICTIONS:
;   I haven't tested it with arrays of structures or pointers yet.
;
; PROCEDURE:
;   For 1D array, the algorithm is the following. 
;
;   n = n_elements(arr)
;   if len eq n then return, arr          ; new size eq current size
;   if len lt n then return, arr[0:len-1] ; new size lt current size
;   arr2 = MAKE_ARRAY( len, TYPE=SIZE(arr,/TYPE), _EXTRA=e )
;   arr2[ 0:n-1 ] = arr
;   return, arr2
;
;   The code works for arrays up to 8 dimensions due to IDL allowing
;   you to subscript non-existent dimensions with [0] or [0:0], such
;   as: 
;
;   x = indgen(3)
;   print, x[ 0:2, 0:0, 0:0 ]
;
; EXAMPLE:
;
;   x = indgen(3)
;   ;; shorten X to 2 elements
;   print, kdm_arrsetsize( x, 2 )
;   ;; grow X to 5 elements
;   print, kdm_arrsetsize( x, 5 )
;   ;; grow X to 5 elements and use a default value
;   print, kdm_arrsetsize( x, 5, VALUE=42 )
;
;   ;; Trim a 5x5 array to a 3x2 array
;   print, kdm_arrsetsize( bindgen(5,5), [3,2] )
;
;   ;; Works with strings too. Take an array of 2 and expand it to 4,
;   ;; filling with a default value of 'Goodbye'
;   print, kdm_arrsetsize( ['hello','world'], 4, value='Goodbye' )
;   
; MODIFICATION HISTORY:
; 	Written by:	Ken Mankoff
;	2010-03-05: KDM. Added documentation. Expanded to support 8 dimensions.
;
;-

function kdm_arrsetsize, arr, $
                         len, $
                         _EXTRA=e

  arr_dims = size( arr, /dim )        ; dimensions of existing array
  new_ndims = n_elements( len )       ; desired dimensions of new array
  if n_elements(arr_dims) ne new_ndims then MESSAGE, "Length of each dimension must be specified"
  if min(len) le 0 then MESSAGE, "Length of each dimension must be greater than zero"
  
  arr2 = MAKE_ARRAY( DIMENSION=len, $
                     TYPE=SIZE(arr,/TYPE), $
                     _EXTRA=e )

  ;; the dimensions of the new array
  len8 = intarr(8)+1
  len8[0] = len
  ;; the dimensions of the existing array
  arr_dims8 = intarr(8)+1
  arr_dims8[0] = arr_dims
  ;; the subscript range of the existing array
  idx = len8 < arr_dims8
  idx = idx-1
  
  arr2[ 0,0,0,0,0,0,0] = arr[ 0:idx[0], $
                              0:idx[1], $
                              0:idx[2], $
                              0:idx[3], $
                              0:idx[4], $
                              0:idx[5], $
                              0:idx[6], $
                              0:idx[7] ]
  return, arr2
end


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;; testing code
;;

;; 1D
print, kdm_arrsetsize( indgen(5), 3 )
print, kdm_arrsetsize( indgen(5), 5 )
print, kdm_arrsetsize( findgen(3), 5, value=42 )

;; strings
print, kdm_arrsetsize( ['Goodbye','Cruel'], 4, value='World' )

;; 2D
;; print, kdm_arrsetsize( findgen(3,3), [2,2] )
;; print, kdm_arrsetsize( findgen(3,3), [5,5] )


;; 3D
;; print, "== 3D Test =="
;; print, kdm_arrsetsize( indgen(3,3,3), [3,3,2] )
;; print, kdm_arrsetsize( indgen(3,3,3), [5,5,5] )
end
