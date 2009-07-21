;
; $Id: shiftzero.pro,v 1.2 2002/08/30 08:47:06 mankoff Exp $
;
; $Author: mankoff $
; $Revision: 1.2 $
; $Date: 2002/08/30 08:47:06 $
;


;;; This procedure is based upon the IDL SHIFT Function.
;;; But... This function zeroes out the data that gets "wrapped"
;;;
;;; See IDL documentation on SHIFT, and see code below
;;;
;;; It is designed for VECTORS, not multi-dimensionaly arrays.

FUNCTION shiftzero, array, sh
d = array
s = N_ELEMENTS( d ) - 1
d = SHIFT( d, sh )
IF ( sh GT 0 ) THEN d[ 0 : ( sh - 1 ) ] = 0 ELSE $
IF ( sh LT 0 ) THEN d[ ( s + sh + 1 ) : s ] = 0
RETURN, d
END

;
; $Log: shiftzero.pro,v $
; Revision 1.2  2002/08/30 08:47:06  mankoff
; shortened variable names
;
;
