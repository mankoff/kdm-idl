;+
;
; NAME:
;	KDM_ISDEFINED
;
; PURPOSE:
;   This procedure checks if a variable is defined or not, and
;   optionally sets it to a default value, or prompts the user to
;   enter a value.
;
;   This is a fancy wrapper for N_ELEMENTS() EQ 0 and KEYWORD_SET()
;
; CATEGORY:
;	Genaral Programming
;
; CALLING SEQUENCE:
;   KDM_ISDEFINED, Variable
;
; INPUTS:
;   Variable: A variable that may or may not be defined.
;
; KEYWORD PARAMETERS:
;   DEFAULT: The value to set the variable to. This is ONLY if 
;            the variable is not defined.
;   PROMPT: The prompt to use to let the user set the value. The user
;           is only prompted to enter a value if the variable is
;           undefined.
;
; OUTPUTS:
;   Variable may be changed. If it was undefined, and one (or both) of
;   the DEFAULT and/or PROMPT keywords were set.
;
; RESTRICTIONS:
;   If the input variable is undefined, and no default value is
;   supplied, but a PROMPT value is supplied, then the returned
;   variable is of type STRING because that is the most general data
;   type. 
;
; EXAMPLE:
;
;   If a variable is defined, nothing happens:
;   x = 42
;   kdm_isdefined, x, default='foo', prompt='P'
;
;   Set an undefined variable to a default value:
;   kdm_isdefined, xx, default='bar'
;   kdm_isdefined, xx2, default=dist(42,24)
;   kdm_isdefined, ll, d=[0.,0], p="Enter lat,lon: "
;
;   Set an undefined variable to user inputs:
;   kdm_isdefined, xxx, prompt='Enter Something: '
;
;   Set an undefinde variable to a user input but control the type:
;   kdm_isdefined, xxxx, prompt='Enter Something: ', default=BYTE(42)
;
; MODIFICATION HISTORY:
; 	Written by:	Ken Mankoff, 2010-03
;               2010-04-18: Provide type hint. Allow empty strings to
;                           default to default input if supplied.
;
;-

pro kdm_isdefined, var, $
                   default=default, $
                   prompt=prompt, $
                   _EXTRA=e

  undefined = n_elements( var ) eq 0
  defined = n_elements( var ) ne 0
  
  ;; if default set then us it, if the variable was undefined
  if n_elements(default) ne 0 AND undefined then var = default
  
  if keyword_set(prompt) AND undefined then begin
     ;; In this case we want to prompt and read in a value. Of what
     ;; type? If default is defined, obviously of that type. If
     ;; default is not defined, we'll default to a string,
     ;; because that can hold most other types.

     if n_elements(default) eq 0 then default = ''
     var = ''
     default_type = size( default, /tname)

     ;; The input is always of type string, then
     ;; cast to the correct type. This allows you to enter nothing
     ;; (just hit return) and the default value will be
     ;; used. Doesn't work for strings if you *want* a string
     ;; to be null but the PROMPT is non-null...

     ;; give a hint of what type to expect
     pp = '['+default_type+':'+STRTRIM(default,2)+'] '+prompt
     read, var, prompt=pp, _EXTRA=e

     ;; var contains the data and is type string. Need to convert to
     ;; the correct type, which is the the default variable.
     default[0] = var
     var = default
  endif

end

;; testing code
;; x = 42
;; kdm_isdefined, x, default='foo'
;; help, x
;; kdm_isdefined, x, prompt='Enter something: '
;; help, x

;; undefine, x
;; kdm_isdefined, x, default='foo'
;; help, x

;; undefine, x
;; kdm_isdefined, x, prompt='Enter something: '
;; help, x

;; undefine, x
;; kdm_isdefined, x, prompt='Enter something: ', default=BYTE(42)
;; help, x
;end
