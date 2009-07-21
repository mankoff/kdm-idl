; $Id: lontv.pro,v 1.2 2002/09/26 01:04:13 mankoff Exp mankoff $
;
; $Author: mankoff $
; $Revisions$
; $Date: 2002/09/26 01:04:13 $
;
;+
; NAME:
;	LONTV
;
; PURPOSE:
;       Fix a lat/lon grid that you want to map on a globe with
;       MAP_PATCH or MAP_IMAGE so it works with IDLs buggy routines
;
; CATEGORY:
;       SNOE, Imaging, Map
;
; CALLING SEQUENCE:
;       Result = LONTV( Array )
;
; INPUTS:
;       Array: An array of any size, where the X dimension is
;           longitude, and Y is data
;
; OUTPUTS:
;       The array is returned with the first column duplicated as the
;       last column.
;
; EXAMPLE:
;     test = REBIN( BYTSCL( BINDGEN(15) ), 15, 2 )
;     tv, map_image( test, bilinear=0 )
;     ;;; The max color is 1/2 as wide as all the rest!
;     tv, map_image( lontv(test), bilinear=0 )
;
; MODIFICATION HISTORY:
; 	Written by: Barth
;	2002-09-25: Added docs
;
;-

function lontv, input

s = size( input )

x = s[ 1 ] ; xsize
y = s[ 2 ] ; ysize
t = s[ 3 ] ; array type

output = make_array( x+1, y, /nozero, type=t )
output[ 0 : x-1, 0 : y-1 ] = input
output[ x, * ] = output[ 0, * ]

return, output
end

;
; $Log: lontv.pro,v $
; Revision 1.2  2002/09/26 01:04:13  mankoff
; added docs
;
; Revision 1.1  2002/08/01 23:31:54  mankoff
; Initial revision
;
;
