;+
;
; NAME:
;	PPPRINT
;
; PURPOSE:
;   Pretty print arrays.
;
; CATEGORY:
;	Misc, Arrays, Console
;
; CALLING SEQUENCE:
;   PPPRINT, array
; INPUTS:
;	Array: An array. Should work with any basic type. Not sure (yet)
;          how to handler arrays of pointers or objects or structures.
;
; KEYWORD PARAMETERS:
;   FORMAT: Provide some control over the formatting of the output
;   POWER: Set this keyword to print floats like "3.5E-02"
;          rather than "0.035"
;
; OUTPUTS:
;   The array is printed to the screen, perhaps in a nicer way than
;   the default IDL print command.
;
; RESTRICTIONS:
;   Doesn't work with types such as pointers, objects, or structures.
;
; PROCEDURE:
;   Procedure taken from
;   http://groups.google.com/group/comp.lang.idl-pvwave/msg/013a8314ce6dcef5
;
; EXAMPLE:
;   ppprint, [2e3,3.5e-3]
;   ppprint, [2e3,3.5e-3], /power
;   ppprint, indgen(10)
;   ppprint, indgen(10)+998
;   ppprint, ['a','b','c']
;   ppprint, ['goodbye','cruel','world']
;
; MODIFICATION HISTORY:
; 	Written by:	Ken Mankoff, 2010-04-13
;
;-

pro ppprint, arr, format=format, power=power
  
  if not keyword_set(format) then begin
     type = size(arr,/tname)
     if type eq 'STRING' then begin
        n = max(strlen(arr))
        format = 'A'+STRTRIM(n,2)
     endif else if type eq 'INT' then begin
        format = 'I10'
     endif else if type eq 'FLOAT' then begin
        if keyword_set(power) then format = 'E12.2' else $
           format = 'F8.3'
     endif else begin
        MESSAGE, "Array type not expected. Using default format", /CONTINUE
        format = 'F8.5'
     endelse
  endif

  n = STRTRIM( n_elements( arr ), 2 )
  arrstr = STRING( arr, format='("[ ",'+n+'('+format+',:,", "),$)' ) + ' ]'
  print, STRCOMPRESS(arrstr)

end

;; testing code
ppprint, [2e3,3.5e-3]
ppprint, [2e3,3.5e-3], /power
ppprint, indgen(10)
ppprint, indgen(10)+998
ppprint, ['a','b','c']
ppprint, ['goodbye','cruel','world']
end
