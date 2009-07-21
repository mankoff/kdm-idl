function kdm_arraycontains, arr, item, idx, count
  idx = where( arr eq item, count )
  return, count ge 1
end
