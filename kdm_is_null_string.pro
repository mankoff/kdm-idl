function kdm_is_null_string, s
  
  false = 0B
  true = 1B
  if size(s,/tname) ne 'STRING' then return, false
  if STRLEN(s) ne 0 then return, false

  return, true
  
end
