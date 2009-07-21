;; pro kdm_colorspheres
;;   for i = 0, 3 do begin
;;      istr = STRING(i,FORMAT='(I03)')
;;      kdm_ps, filename='circles/'+istr+'.ps'
;;      if !d.name eq 'PS' then f=72. else f=1. ; PS is 72 dpi
;;      tvcircle, 64*f, 64*f,64*f, i, /fill
;;      kdm_ps, /close, /crop, /png
;;   endfor
;; end


function kdm_colorspheres, pie=p, colors=c

  choco = ''
  for i = 0, n_elements(c[0,*])-1 do $
     choco += STRJOIN(to_hex(c[*,i],2))+','
  choco = KDM_STRTAIL( choco, 1 ) ; remove trailing ','

  chd = STRCOMPRESS(STRJOIN(p,','),/REM)

  transparent_bg = "chf=bg,s,ffffff00"
  str = 'http://chart.apis.google.com/chart?cht=p&chd=t:'+chd+'&chs=75x75&chco='+choco+'&'+transparent_bg
  str = STRJOIN( STRSPLIT( str, "&", /EXTRACT ), '&amp;' )
  return, str
end
