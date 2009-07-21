function kdm_strtail, s, n
  return, strmid( s, 0, strlen(s)-n )
end
