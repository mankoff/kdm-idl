; $Id$
;
; $Author$
; $Revision$
; $Date$
;
;+
; NAME:
;	FIX_GAPS
;
; PURPOSE:
;       This function fills in gaps in a 2D array with the average
;       value of its neighbors
;
; CALLING SEQUENCE:
;       Result = FIX_GAPS( Data )
;
; INPUTS:
;       Data:   A 2D array of any numeric type
;
; OPTIONAL INPUTS:
;      Gapsize: Set this value to 1 or 2 to specify the size of the
;               gaps to fill in. A value of 1 means the gap must have
;               2 adjacent neighbors with non Gv values. The Default
;               value is 1. A value of 2 means 2 adjacent gaps will
;               both get the average values of their neighbors. NOTE
;               that if gapsize=2, gaps of size 1 will still be filled
;               in.
;
;      Compare: Set this to the compare function used to find the
;               gaps. That is, compare should equal 'LT', 'LE', 'EQ',
;               'GE', or 'GT'. The default comparitor is 'EQ'
;
; KEYWORD PARAMETERS:
;       X:      Set this keyword to fill in gaps in the X direction
;
;       Y:      Set this keyword to fill in gaps in the Y direction
;
;       Gv:     Set this keyword to the value of the gaps. This value
;               defaults to zero if the keyword is not set.
;
;       Edge:   Set this keyword to have the algorithm wrap around the
;               edge of the array, and fill in gaps on the edge.
;
; OUTPUTS:
;       This procedure returns the original array, but the gaps have
;       been filled in by the average of its two neighbors.
;
; PROCEDURE:
;       A gap is defined as a value in the array that is 0 (zero) or
;       equal to the value 'Gv'. Furthermore, the gap must have two
;       neighbors that are *NOT* equal to Gv.
;
;       A Neighbor is defined as the array cells to the left and right
;       of a gap if the X keyword is set, or above and below if the Y
;       keyword is set. 
;
;       If the Edge keyword is set, then a cell on the edge might
;       still have two valid neighbors.
;
; EXAMPLE:
;       a = indgen( 4,4 )
;       a[ [ 0,2,6,7,8,11,15 ] ] = 99
;       print, fix_gaps( data, /x, /edge, gv=99 )
;       print, fix_gaps( data, /y, gv=99 )
;
;       NOTE:
;       (fix_gaps(fix_gaps(d,/y),/x)) NE (fix_gaps(fix_gaps(d,/x),/y))
;
; MODIFICATION HISTORY:
; 	Written by:	Ken Mankoff, June, 2001
;       Oct, 2001       Added documentation and most keywords
;-

FUNCTION fix_gaps, data0, x=x, y=y, gv=gv, edge=edge, $
                   gapsize=gapsize, compare=compare, debug=debug

data = data0
IF ( ( NOT keyword_set( x ) ) AND ( NOT keyword_set( y ) ) ) THEN BEGIN
    print, "Error. Must use X or Y keyword."
    print, "Check documentation for usage instructions"
    print, "returning..."
    return, 0
ENDIF
IF ( keyword_set( y ) ) THEN data = transpose( data ) 
IF ( n_elements( gv ) EQ 0 ) THEN gv = 0
IF ( n_elements( compare ) EQ 0 ) THEN compare = 'EQ'
IF ( n_elements( gapsize ) EQ 0 ) THEN gapsize = 1

;;; input is a 2D array
size = size( data, /dimensions )
xs = size[ 0 ]       ; x dimension to decode 2D where queries
ys = size[ 1 ]       ; y dimension for number of columns

;;; set up the comparison
cmd = 'comp = ( data[col,row] ' + compare + ' gv )'
IF ( keyword_set ( debug ) ) THEN print, 'CMD: ' + cmd

;;; now move down every row and fix the holes...
;;; special cases are the first and last elements
FOR row = 0, ys-1 DO BEGIN
    FOR col = 0, xs-1 DO BEGIN 
        dummy = execute( cmd )
        IF ( comp EQ 1 ) THEN BEGIN  ;;; found a hole
            IF ( keyword_set ( debug ) ) THEN print, 'GAP @: ', col, row
            
            ;;; CASE: column 0, /edge, gs=1
            IF ( ( col EQ 0 ) AND ( keyword_set( edge ) ) ) THEN $
              IF ( ( data[ xs-1, row ] NE gv ) AND $
                   ( data[ 1, row ] NE gv ) ) THEN BEGIN
                data[0,row] = (data[xs-1,row]+data[1,row])/2.
                GOTO, filled
            ENDIF
            
            ;;; CASE (generic): middle cells, gs=1
            IF ( ( col NE 0 ) AND ( col NE xs-1 ) ) THEN $
              IF ( ( data[ col-1, row ] NE gv ) AND $
                   ( data[ col+1, row ] NE gv ) ) THEN BEGIN
                data[col,row] = (data[col-1,row]+data[col+1,row])/2.
                GOTO, filled
            ENDIF
            
            ;;; CASE: column xs-1, gs=1, /edge
            IF ( ( col EQ xs-1 ) AND ( keyword_set( edge ) ) ) THEN $
              IF ( ( data[ xs-2, row ] NE gv ) AND $
                   ( data[ 0, row ] NE gv ) ) THEN BEGIN
                data[xs-1,row] = (data[xs-2,row]+data[0,row])/2.
                GOTO, filled
            ENDIF

            IF ( gapsize EQ 2 ) THEN BEGIN

                ;;; CASE: column 0, /edge
                IF ( ( col EQ 0 ) AND ( keyword_set( edge ) ) ) THEN BEGIN
                    IF ( ( data[ xs-1, row ] NE gv) AND $
                         ( data[ 2, row ] NE gv ) ) THEN BEGIN 
                        ;;; [ X, gv, good, ... , good ]
                        data[0,row] = (data[xs-1,row]+data[2,row])/2.
                        data[1,row] = (data[xs-1,row]+data[2,row])/2.
                        GOTO, filled
                    ENDIF ELSE IF ( ( data[ xs-2, row ] NE gv ) AND $
                                    ( data[ 1, row ] NE gv ) ) THEN BEGIN
                        ;;; [ X, good, ... , good, gv ]
                        data[0,row] = (data[xs-2,row]+data[1,row])/2.
                        data[xs-1,row] = (data[xs-2,row]+data[1,row])/2.
                        GOTO, filled
                    ENDIF
                ENDIF
                
                ;;; CASE: column 1, /edge
                IF ( ( col EQ 1 ) AND ( keyword_set( edge ) ) ) THEN BEGIN
;                    IF ( ( data[ xs-1, row ] NE gv) AND $
;                         ( data[ 2, row ] NE gv ) ) THEN BEGIN 
;                        ;;; [ gv, X, good, ... , good ]
;                        data[1,row] = (data[xs-1,row]+data[2,row])/2.
;                        goto, filled
;                    ENDIF ELSE IF ( ( data[ 0, row ] NE gv ) AND $
                    IF ( ( data[ 0, row ] NE gv ) AND $
                         ( data[ 3, row ] NE gv ) ) THEN BEGIN
                        ;;; [ good, X, gv, good, ...]
                        data[1,row] = (data[0,row]+data[3,row])/2.
                        data[2,row] = (data[0,row]+data[3,row])/2.
                        GOTO, filled
                    ENDIF
                ENDIF

                IF ( ( col NE 0 ) AND ( col NE 1 ) AND $
                     ( col NE xs-2 ) AND  ( col NE xs-1 ) ) THEN BEGIN
                    ;;; CASE (generic) middle cells, gs=2
                    IF ( ( data[ col-1, row ] NE gv ) AND $
                         ( data[ col+2, row ] NE gv ) ) THEN BEGIN
                        data[col,row] = (data[col-1,row]+data[col+2,row])/2.
                        data[col+1,row] = (data[col-1,row]+data[col+2,row])/2.
                        GOTO, filled
;                    ENDIF ELSE IF ( ( data[ col-1, row ] NE gv ) AND $
;                                    ( data[ col+2, row ] NE gv ) ) THEN BEGIN
;                        data[col,row] = (data[col-1,row]+data[col+2,row])/2.
;                        data[col+1,row] = (data[col-1,row]+data[col+2,row])/2.
;                        GOTO, filled
                    ENDIF
                ENDIF
                
                ;;; CASE: column xs-2, /edge
                IF ( col EQ xs-2 AND keyword_set( edge ) ) THEN BEGIN
                    IF ( ( data[ xs-3, row ] NE gv) AND $
                         ( data[ 0, row ] NE gv ) ) THEN BEGIN 
                        ;;; [ good, ..., good, X, gv ]
                        data[xs-2,row] = (data[xs-3,row]+data[0,row])/2.
                        data[xs-1,row] = (data[xs-3,row]+data[0,row])/2.
                        GOTO, filled
;                    ENDIF ELSE IF ( ( data[ xs-4, row ] NE gv ) AND $
;                                    ( data[ xs-1, row ] NE gv ) ) THEN BEGIN
;                        ;;; [ ... , good, gv, X, good ]
;                        data[xs-2,row] = (data[xs-4,row]+data[xs-1,row])/2.
;                        data[xs-2,row] = (data[xs-4,row]+data[xs-1,row])/2.
;                        GOTO, filled
                    ENDIF
                ENDIF
                
                ;;; CASE: column xs-1, /edge
                IF ( col EQ xs-1 AND keyword_set( edge ) ) THEN BEGIN
                    IF ( ( data[ xs-2, row ] NE gv) AND $
                         ( data[ 1, row ] NE gv ) ) THEN BEGIN 
                            ;;; [ gv, good, ... good, X ]
                        data[xs-1,row] = (data[xs-2,row]+data[0,row])/2.
                        data[0,row] = (data[xs-2,row]+data[0,row])/2.
                        goto, filled
;                    ENDIF ELSE IF ( ( data[ xs-3, row ] NE gv ) AND $
;                                    ( data[ 0, row ] NE gv ) ) THEN BEGIN
;                            ;;; [ good, .., good, gv, X ]
;                        data[xs-1,row] = (data[0,row]+data[xs-3,row])/2.
;                        data[xs-2,row] = (data[0,row]+data[xs-3,row])/2.
;                        GOTO, filled
                    ENDIF
                ENDIF
            ENDIF
        ENDIF
        filled:
        IF ( keyword_set( debug ) ) THEN $
          IF ( data[col,row] NE gv ) THEN $
          print, '*FILLED*'
    ENDFOR
ENDFOR
IF ( KEYWORD_SET( Y ) ) THEN DATA = TRANSPOSE( DATA ) 
RETURN, DATA
END


;
; $Log$
;
