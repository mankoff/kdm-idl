function blank_string, n
_n = keyword_set(n) ? n : 1
return, replicate(' ',n)
end
