; $Id: nearest_element.pro,v 1.5 2002/09/25 23:22:19 mankoff Exp $
;
; $Author: mankoff $
; $Date: 2002/09/25 23:22:19 $
; $Revision: 1.5 $
;
;+
; NAME:
;    NEAREST_ELEMENT.PRO
;
; PURPOSE: 
;    This function return the nearest element in a LIST to a provided VALUE
;
; WARNING/NOTE:
;    Look at the IDL provided procedure VALUE_LOCATE, as it performs
;    a similar function, and works with arrays, and is MUCH
;    faster. However, it uses interpolation, so it provides the wrong
;    answer sometimes, depending on the type of array passed to it
;    IDL> a = [ 0, 1, 1.1, 1.2, 10, 11, 12 ]
;    IDL> print, value_locate( a, 1.16 )      ; WRONG
;    IDL> print, vaule_locate( a, 9.00 )      ; WRONG
;    
;    The input array must be fairly linear for VALUE_LOCATE to
;    work. If it is not, or has data gaps, use this procedure  
;    (NEAREST_ELEMENT)
;
; CATEGORY: 
;    Vector
;
; CALLING SEQUENCE: 
;    result = NEAREST_ELEMENTS( value, list, position )
;
; INPUTS:
;    value: This is a scalar value.
;    list:  This is a vector of any type but 'string'
;
; OUTPUTS: This function returns the element from list that is
;     closest to value
;
; OPTIONAL OUTPUTS: The position into list of the nearest value
;     can optionally be returned
;
; SIDE EFFECTS: hopefully none
;
; RESTRICTIONS: 
;     value cannot be an array
;     list must be sequentially increasing
;
; PROCEDURE: Perform a min(where()) and a max(where()). If multiple
;     entries in das_list are equally close, the first entry is returned.
;
; EXAMPLE:
;     val = 42
;     list = [ 40, 41, 44, 48 ] ; list = list[sort(list)]
;     print, nearest_element( val, list, p ), p
;        41    1
;
; MODIFICATION HISTORY:
;    KDM; 2002-04-09; wrote procedure
;    KDM; 2002-05-16; documented
;    KDM; 2002-07-31; Changed name and code from Mariner 9 DAS
;        specific to vector general
;    KDM; 2002-08-16; Removed all but 1 where() statement for speed
;
;-


FUNCTION nearest_element, val, list, position

;;; the code does this, but faster
;return, list[ min( abs(list-val), position )  ]

 n = n_elements( list ) - 1

 p = ( where( list GE val, count ) )[0]
 IF ( count EQ 0 ) THEN IF ( val GT max( list ) ) THEN p=n ELSE p=0
 top = list[ p ]
 bot = list[ p-1 >0 ]

 dif = abs( val - [ bot, top ] )
 IF ( dif[0] LE dif[1] ) THEN BEGIN
     ;;; lower value is closest
     position = p-1>0
     return, bot
 ENDIF ELSE BEGIN
     position = p
     return, top
 ENDELSE

 MESSAGE, "Error: should not be here...", /CONT
 return, -1
 END

;
; $Log: nearest_element.pro,v $
; Revision 1.5  2002/09/25 23:22:19  mankoff
; fixed NAME: comment header
;
; Revision 1.4  2002/09/14 22:32:11  mankoff
; Added comments/warnings re value_locate
;
; Revision 1.3  2002/08/18 01:59:59  mankoff
; added RCS vars
;
