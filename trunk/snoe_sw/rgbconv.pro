;This procedure converts color in RGB format to 16.7 mil decimal format
function rgbconv, red, green, blue
;converting colors to longs
red=long(red)
green=long(green)
blue=long(blue)
;adding individual components to color
color = red + 256*green + 65536*blue
return, color
end
