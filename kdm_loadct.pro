
pro KDM_loadct_reverse, r,g,b
COMPILE_OPT hidden, IDL2
r = reverse(r)
g = reverse(g)
b = reverse(b)
end


pro KDM_loadct, ctname, r,g,b, $
                reverse=reverse, $
                segments=segments, $
                c0=c0, c1=c1, c2=c2, $
                c255=c255, c254=c254, c253=c253, c252=c252, $
                debug=debug

debug = keyword_set(debug)
            
dir = programrootdir() + 'colors'
fname = dir + '/' + ctname
if debug then message, fname, /continue
list = file_search( fname + '*' )
fname = list[0]
if debug then message, fname, /continue

openr, lun, fname, /get_lun
size = (fstat(lun)).size
if (size eq 768) then begin 
    file = assoc( lun, bytarr( 256 ) )
    r = file[0] & g = file[1] & b = file[2]
endif else if ( size eq 772 ) then begin
    file = assoc( lun, bytarr( 3, 256 ) )
    file = file[0]
    r = file[0,*] & g = file[1,*] & b = file[2,*]
endif else begin
    MESSAGE, "Error: Unknown colorbar size", /CONT
endelse
free_lun, lun

catch, error_status, /cancel
if error_status ne 0 then r = ( g = ( b = bindgen(256) ) )


;;; flip scale if requested
if ( keyword_set( reverse ) ) then KDM_loadct_reverse, r,g,b

;; bottom color is black or user-specified
if not keyword_set(c0) then c0 = 0
r[0] = ( g[0] = (b[0] = c0 ) )

if not keyword_set(c255) then c255 = 255
r[255] = ( g[255] = ( b[255] = c255 ) )

if not keyword_set(c254) then c254 = 128 ;; gray, invalid
r[254] = ( g[254] = ( b[254] = c254 ) )

if keyword_set(segments) then begin
   r[1:253] = congrid( congrid(r[1:253],segments), 253 )
   g[1:253] = congrid( congrid(g[1:253],segments), 253 )
   b[1:253] = congrid( congrid(b[1:253],segments), 253 )
endif

;c1=c1, c2=c2
;c253=c253, c252=c252

;; load scale
tvlct, r, g, b

END



;; pro kdm_loadct_test, $
;;    show=show, $         ;; show a grid with colors and numbers
;;    colorbar=colorbar, $ ;; make a colorbar
;;    cbar=cbar            ;; make a different colorbar
;;   COMPILE_OPT hidden, IDL2
  
;;   ;; debug display to window
;;   if keyword_set(show) then begin
;;      cindex
;;   ENDIF
;;   if keyword_set( colorbar ) then begin
;;      erase
;;      colorbar
;;   endif
;;   if keyword_set( cbar ) then begin
;;      kdm_loadct, 'BlueWhiteRed'
;;      erase
;;      data = findgen( 10, 10 ) ;; 0 to 100
;;      data = data - 30        ;; -30 to 70, 0 is not in the middle
     
;;      imgneg = KDM_RANGE( data, from=[1, 128], to=[-1*max(abs(minmax(data))), 0] )
;;      imgpos = KDM_RANGE( data, from=[128, 253], to=[0, max(abs(minmax(data)))] )
;;      neg = where( data le 0 )
;;      pos = where( data gt 0 )
;;      img = imgneg*0
;;      img[ neg ] = imgneg[ neg ]
;;      img[ pos ] = imgpos[ pos ]
;;      imdisp, img, /axis, /noscale, out_pos=out_pos
;;      for i=0,99 do $
;;         xyouts, (i mod 10)+0.5, (i / 10)+0.5, $
;;                 STRTRIM(i,2), ALIGN=0.5
;;      cbar, /vert, $
;;            position=[ out_pos[0]-0.2, out_pos[1], out_pos[0]-0.15, out_pos[3] ], $
;;            cmin=1, cmax=253, $
;;            vmin=-1*max(abs(minmax(data))), $
;;            vmax=max(abs(minmax(data))), $
;;            ;; yticks=2, ytickv=[0,128,255], ytickn=['-30','0','70']
;;            _EXTRA=e
;;   endif
;; end


