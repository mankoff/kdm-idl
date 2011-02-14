pro kdm_alert, message=msg, audio=audio, growl=growl, _EXTRA=e

  if not keyword_set(message) then begin
     help, calls=stack
     ;; get the name of the bottom (the one the USER called)
     tlc = stack[ n_elements( stack )-2 ] ; Top Level Call
     name = (STRSPLIT( tlc, /EXTRACT ))[0]
     msg = name
  endif

  if keyword_set(audio) then begin
     spawn, "say " + msg, _EXTRA=e
  endif
  if keyword_set(growl) then begin
     spawn, 'growlnotify -m' + msg, _EXTRA=e
  endif
end

kdm_alert, message="testing", /growl
end
