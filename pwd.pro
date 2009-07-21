pro pwd, cur, silent=silent
  cd, '.', cur=cur
  if not keyword_set(silent) then print, cur
end
