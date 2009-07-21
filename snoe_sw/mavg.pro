; $Id: mavg.pro,v 1.2 2002/09/05 18:42:24 mankoff Exp $
;
; $Author: mankoff $
; $Revision: 1.2 $
; $Date: 2002/09/05 18:42:24 $
;


FUNCTION mavg, data_c, $
               dimension=dimension, value=value, $ ; INPUT
               mask=mask, sum=sum ; OUTPUT

;+
; NAME:
;   MAVG
;
; PURPOSE:
;	This procedure does a "smart average", where array elements less
;	than a certain value are NOT included in the average (they are
;	masked out)
;
; CATEGORY: 
;   Array, Math
;
; CALLING SEQUENCE:
;   Result = MAVG( Data, DIMENSION=d, VALUE=v, SUM=s, MASK=m )
;
; INPUTS:
;   Data: This is an array of any dimensions that you want averaged
;      across *ONE* of the dimensions
;
; OPTIONAL INPUTS:
;   None
;	
; INPUT KEYWORD PARAMETERS:
;   DIMENSION: Set this to the dimension across which to sum. The
;       first dimension is 1 not 0. The default value is the LAST
;       dimension of the input array.
;
;   VALUE: Set this such that any elements LE this value are not
;       included in the average. Default is 0.
;
; OUTPUT KEYWORD PARAMETERS:
;   MASK: The mask array used to throw out 'bad' values
;   SUM: The sum of the data across the dimension being averaged
; 
; OUTPUTS:
;   Result: The average of the DATA input array, with any values less
;   than VALUE not being included in the average. The DIMENSION of the
;   RESULT is one less than the input DATA
;
; PROCEDURE:
;   Yes.
;
; EXAMPLE:
;   data = [ [ 1, 3, 0 ], $   ; 1+3 / 2 = 2
;            [ 3, 0, 3 ], $   ; 3+3 / 2 = 3
;            [ 0, 0, 10 ] ]   ; 10  / 1  = 10
;   ;;; to sum over columns
;   avg = MAVG( data, dimension=1 )
;   print, avg
;        2.00000      3.00000      10.0000
;
; MODIFICATION HISTORY:
;   Written by:	KDM; 2002-07-31
;   2002-08-12: KDM; Fixed bug when value gt 0. Made MASK and SUM
;	             keyword parameters
;   2002-09-05; KDM; made faster when getting rid of elements lt value
;
;-

data=data_c      ; now we can change without affecting calling program


IF ( n_elements( value ) EQ 0 ) THEN value = 0

;;; sum the last dimension by default
IF ( n_elements( dimension ) EQ 0 ) THEN dimension = (SIZE(data))[0]

;;; don't include elements less than value in the sum
data = ( data GT value ) * TEMPORARY( data )

;;; Here is the heart of the code to do a MASKED AVERAGE
sum = total( data, dimension )
mask = total( data GT value, dimension )
avg = sum / ( mask > 1.0 )

return, avg

END

;
; $Log: mavg.pro,v $
; Revision 1.2  2002/09/05 18:42:24  mankoff
; made faster
;
; Revision 1.1  2002/08/01 21:06:16  mankoff
; Initial revision
;
