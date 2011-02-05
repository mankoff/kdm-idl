function kdm_onlydigits_convert1,  instr
  COMPILE_OPT HIDDEN
  instrB = byte(instr)
  digits = where( instrB ge 48 AND instrB le 57, $
                  num_digits, ncomplement=other_chars )

  if num_digits eq 0 then MESSAGE, "No digits in string"
  return, double(string(instrB[digits]))
end

function kdm_onlydigits, in

  sz = size( in, /dim )
  if sz eq 0 then return, kdm_onlydigits_convert1( in )

  out = DOUBLE( in*0 ) ; same size as in
  for i=0, n_elements(in)-1 do begin
     out[i] = kdm_onlydigits_convert1( in[i] )
  endfor
  return, out
end

print, kdm_onlydigits( '012abc 345x' )
print, ' '
tmp = kdm_onlydigits( ['2009-10-29T19:07:37Z', $
                       '2009-11-01T23:04:19Z', $
                       '2009-11-12T01:22:22Z' ] )
help, tmp & print, tmp

end
