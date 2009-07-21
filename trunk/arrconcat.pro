;+
;
; NAME:
;	ARRCONCAT
;
; PURPOSE:
;       Concatenate onto an array. This utility makes it easier to build an N+1
;       dimensional array from a bunch of n-dimensional arrays. For example, the common
;       case of X=[X,42] can be done with this function, but it becomes more useful
;       when concatenating 2D or 3D arrays together into 3D or 4D arrays.
;
; CATEGORY:
;	Utility, Arrays
;
; CALLING SEQUENCE:
;	Result = ARRCONCAT( ARR, ADD )
;
; INPUTS:
;   ARR: A scalar or array of 1,2, or 3 dimensions
;   ADD: A scalar or array of 1,2, or 3 dimensions
;
; KEYWORDS:
;   KEEP1D: Set (when appending two 1D arrays) to keep it 1D, and
;           simply grow the length ([a,b] rather than [[[a],[b]]])
;
; OUTPUTS:
;   An array that is based on ARR but has ADD concatenated to it.
;
; RESTRICTIONS:
;   Little error checking is done. ARR and ADD must be logically concatenatable.
;   Doesn't work for 5D or higher arrays
;
; EXAMPLE:
;   r = arrconcat( x, 43 )   ; returns [43]
;   r = arrconcat( 42, 43 )  ; returns [42,43]
;
;   x = [40,41] & y = [42,43]
;   r = arrconcat( x, y ) ; r is 2x2
;   print, r
;      40      41
;      42      43
;   r = arrconcat( r, [44,45] ) ; r is 2x3
;   print, r
;      40      41
;      42      43
;      44      45
;
;   x = [40,41] & y = [42,43]
;   r = arrconcat( x, y, /KEEP1D ) ; r is 1x4
;   print, r
;      40      41      42     43
;
; MODIFICATION HISTORY:
; 	Written by:	Ken Mankoff. 2007-07-10
;
;-

function arrconcat, arr, new, $
                    KEEP1D=KEEP1D, $
                    debug=debug

dbg = keyword_set(debug)
ON_ERROR, 2

if n_elements(arr) eq 0 then begin
    if dbg then MESSAGE, "ARR non existent. Returning NEW", /CONTINUE
    return, [new]
endif

sz = size( arr, /dimensions )
szz = size( new, /dimensions )
if szz[0] eq 0 then begin
    if dbg then MESSAGE, "NEW is SCALAR. Returning [ARR,NEW]", /CONTINUE
    return, [arr,new]
endif

if n_elements(szz) eq 1 then begin
    if dbg then MESSAGE, "NEW is VECTOR. Returning [[[arr],[new]]]", /CONTINUE
    if keyword_set(keep1D) then return, [arr,new]
    return, [[[arr],[new]]]
endif

if n_elements(szz) eq 2 then begin
    if dbg then MESSAGE, "NEW is 2D. Returning [[[arr]],[[new]]]", /CONTINUE
    return, [[[arr]],[[new]]]
endif

if n_elements(szz) eq 3 then begin
    if dbg then MESSAGE, "NEW is 3D. Concatenting onto ARR", /CONTINUE
    if n_elements(sz) eq 3 then sz = [sz,1]
    newarr = fltarr( [ sz[0:2], sz[3]+1 ], /NOZERO )
    newarr[0,0,0,0]=arr
    newarr[0,0,0,sz[3]]=new
    return, newarr
endif


if n_elements(szz) eq 4 then begin
    if dbg then MESSAGE, "NEW is 4D. Concatenting onto ARR", /CONTINUE
    if n_elements(sz) eq 4 then sz = [sz,1]
    newarr = fltarr( [ sz[0:3], sz[4]+1 ], /NOZERO )
    newarr[0,0,0,0,0]=arr
    newarr[0,0,0,0,sz[4]]=new
    return, newarr
endif



if n_elements(szz) GE 5 then begin
    MESSAGE, "NEW is 5D+. Not yet handled by algorithm", /CONTINUE
    return, -1
endif 
end


