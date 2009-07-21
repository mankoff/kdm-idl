;;; this is a little utility (short for PLOT BIG) that lets you look
;;; at long vectors with a scroll window, rather than mushing all the
;;; pixels into a little area:

;;; EXAMPLE:
;;; a = randomn(s,1e4) + sin(indgen(1e4))
;;; plot, a  ; can't see anything
;;; plotb, a ; now I can see...

PRO plotb, v0, v1, _EXTRA=e

xs = ( n_elements( v0 ) * 5 ) < 5000

set_plot,'z'
device, set_resolution=[ xs, 300 ]

plotg, v0, v1, $
  /xst, $
  _EXTRA=e

img = tvrd()

set_plot,'x'

slide_image, img, show_full=0, $
  xsize=xs, xvisible=800<xs, $
  ysize=300, yvisible=300, $
  _EXTRA=e

END
