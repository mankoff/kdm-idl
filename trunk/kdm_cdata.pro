;+
;
; NAME:
;	KDM_CDATA
;
; PURPOSE:
;       Wrap a string in CDATA tags: "<![CDATA[" + string + "]]>"
;
; CATEGORY:
;	Strings, KML
;
; CALLING SEQUENCE:
;   result = KDM_CDATA( string )
;
; INPUTS:
;	string: A string or string array
;
; OUTPUTS:
;   this version returns the input wrapped in the CDATA tag (for
;   embedding HTML in KML. If the input is an array of strings each
;   string is wrapped.
;
; RESTRICTIONS:
;	The function will not double-wrap, even if you want it to.
;
; EXAMPLE:
;   IDL> print, kdm_cdata('foo')
;   <![CDATA[foo]]>
;
;   IDL> print, kdm_cdata( [ 'foo', 'bar' ] )
;   <![CDATA[foo]]> <![CDATA[bar]]>
;
; MODIFICATION HISTORY:
; 	Written by:	Ken Mankoff. 2009
;	2009-09-22: Rewrote to check for double-wrapping with arrays.
;
;-


function kdm_cdata, _str
  str = _str

  ;; algorithm could be: return, '<![CDATA['+str+']]>'
  ;; but we don't want to double-wrap the tags...

  for i = 0, n_elements(str)-1 do begin
     if STRMID(str[i],0,9) NE '<![CDATA[' AND $
        STRMID(str[i],2,/REV) NE ']]>' then $
           str[i] = '<![CDATA['+str[i]+']]>'
  endfor
  return, str

end

;; testing kdm_cdata
a_string = 'a string'
an_array = ['an','array']
print, kdm_cdata( a_string )
print, kdm_cdata( kdm_cdata( a_string ) )
print, kdm_cdata( an_array )
print, kdm_cdata( kdm_cdata( an_array ) )

;; a_number = 42
;; print, kdm_cdata( a_number ) ;; crashes
end
