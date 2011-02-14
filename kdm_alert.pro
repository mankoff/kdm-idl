pro kdm_alert, message=msg, audio=audio, growl=growl, _EXTRA=e

  if keyword_set(audio) then begin
     spawn, "say " + msg, _EXTRA=e
  endif
  if keyword_set(growl) then begin
     spawn, 'growlnotify -m' + msg, _EXTRA=e
  endif
end

kdm_alert, message="testing", /growl
end
