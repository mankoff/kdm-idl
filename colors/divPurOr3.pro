pro divpuror3

;;     Orange, White, Purple
;; rgb = [ [0,0,0], $
;;         [ 241, 247, 153 ], $ ; r
;;         [ 163, 247, 142 ], $ ; g
;;         [ 064, 247, 195 ], $ ; b
;;         [ 255, 255, 255 ]

; divs = [1,84,85,84,1]
;
; rgb  = transpose(rgb)

;; lower = CONGRID( [241,163,064], 84 ) ;; lower purple
;; middle = CONGRID( [247,247,247], 84 ) ;; middle white-ish
;; upper = CONGRID( [ 064, 247, 195 ], 84 ) ;; upper orange

r = [0,CONGRID([241],84),CONGRID([247],85),CONGRID([153],84),128,255]
g = [0,CONGRID([163],84),CONGRID([247],85),CONGRID([142],84),128,255]
b = [0,CONGRID([064],84),CONGRID([247],85),CONGRID([195],84),128,255]

tvlct,r,g,b

;imdisp, indgen(16,16)


end

imdisp, indgen(16,16)
divpuror3
end
