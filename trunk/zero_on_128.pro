function zero_on_128, data, _EXTRA=e
  mm = minmax(data)
  mm = max(abs(mm))
  d = kdm_range( data, from=[-mm,mm], to=[2,253], _EXTRA=e, /BYTE )
  return, d

end

;; testing
print, zero_on_128( [-10,10] )
print, zero_on_128( [-1,0,2] )
print, zero_on_128( [0,253] )
end
