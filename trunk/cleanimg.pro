function cleanimg, img0, bad_val=bad_val, rep_val=rep_val

img = img0
if n_elements(bad_val) eq 0 then bad_val = min(img)

bad_loc = where( img eq bad_val, n, complement=good_loc )
if n eq 0 then return, img

min_good = min(img[good_loc])
if n_elements(rep_val) eq 0 then rep_val = min_good - 2
img[ bad_loc ] = rep_val
return, img
end

