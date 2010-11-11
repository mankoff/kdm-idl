;
;+
; NAME:
;	KDM_RANGE
;
; PURPOSE:
;   This function converts a variable or array from one scale to
;   another. The input data is assumed to be on the scale
;   [min(data),max(data)] although this can be customized. It is
;   converted to a new scale of the range
;   [rangemin,rangemax]. Overflow and underflow can be customized.
;
; CATEGORY:
;	Data massaging
;
; CALLING SEQUENCE:
;	result = KDM_RANGE( data, from, to )
;
; INPUTS:
;	DATA This is your input data set, either a single number or
;	multi-dimensional array
;
;   FROM: A 2 element array specifying the [min,max] input range of DATA
;   TO: A 2 element array specifying the desired output range of DATA
;
; KEYWORD PARAMETERS:
;   UNDERFLOW: This is value to set data points that convert to less
;              than RANGEMIN
;   OVERFLOW: This is value to set data points that convert to more
;             than RANGEMAX
;
; OUTPUTS:
;   This function returns the input array (data) scaled from FROM to TO
;
; RESTRICTIONS:
;   Output is always float.
;
; PROCEDURE:
;   Scale the input data to [0,1], then multiply by the desired
;   [minrange,maxrange] 
;
; EXAMPLE:
;   data = [-1, 0, 0.1, 1]
;
;   ; scale data to [0,100]
;   print, kdm_range( data, from=minmax(data), to=[0,100] )
;   ; -1 goes to 0, 1 goes to 100, and everything else betwixt...
;
;   ; scale data to [-1,0] output, but force the data input range to
;   ; [0,1]. Underflow (the -1 input value) should be set to -999
;   print, kdm_range( data,from=[-1,1],to=[-1, 0], datamin=0, underflow=-999 )
;
;
; MODIFICATION HISTORY:
; 	Written by:	Ken Mankoff, 2007-05.
;	2007-07-17: KDM. Re-wrote to use from and to arrays
;
;-


function kdm_range, data, $
                    from=from, to=to, $
                    byte=byte, $
                    overflow=overflow,underflow=underflow

r = CHECK_MATH(/PRINT)

if n_elements(from) ne 2 OR $
   n_elements(to) ne 2 then begin
   message, "ERR: FROM and TO not specified correctly", /CONTINUE
   return, -999.99
endif

range = ( (float(data)-from[0]) / (from[1]-from[0]) ) * (to[1]-to[0])+to[0]

if CHECK_MATH(/PRINT) ne 0 then MESSAGE, "Math Error. Results Invalid."

if n_elements(underflow) ne 0 then begin
    un = where(data lt from[0], c)
    if c ne 0 then range[un] = underflow
endif
if n_elements(overflow) ne 0 then begin
    ov = where(data gt from[1], c)
    if c ne 0 then range[ov] = overflow
endif

if keyword_set(byte) then range=byte(round(temporary(range)))
return, range
end

