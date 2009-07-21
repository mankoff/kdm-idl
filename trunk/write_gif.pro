PRO write_gif, name, data, r, g, b

tvlct, r, g, b, /get
unique_name = strtrim( long( systime( 1 ) ), 2 ) + '.bmp'
write_bmp, unique_name, data, r, g, b

cmd = '/usr/X11R6/bin/convert ' + unique_name + ' ' + name
spawn, cmd, /sh

cmd = '/bin/rm ' + unique_name
spawn, cmd, /sh

;;; to read gifs:
; convert img.gif img.bmp
; read_bmp, img.bmp
; delete img.bmp
; return image

END

