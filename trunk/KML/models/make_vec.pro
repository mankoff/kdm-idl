
;; load your desired color table prior to calling this
pro make_vec
  tvlct,r,g,b, /get
  for c = 0, 255 do begin
    c01 =[ r[c]/255., g[c]/255., b[c]/255. ]
;;     c255 = [ STRING(r[c],FORMAT='(I03)'), $
;;              STRING(g[c],FORMAT='(I03)'), $
;;              STRING(b[c],FORMAT='(I03)') ]
;;    fname = 'vec_'+c255[0]+'_'+c255[1]+'_'+c255[2]+'.dae'
    fname = 'vec_'+STRING(c,FORMAT='(I03)')+'.dae'
    cmd = 'sed s' + $
          '/.*KDM.*--\>' + $
          ;;'/foo/ vec.dae > '+fname
          '/\<color\>'+STRJOIN(STRTRIM(c01,2),'\ ')+'\ 1\<\\/color\>/' + $
;;          ''+STRJOIN(STRTRIM(c01,2),'\ ')+'\<\/color\>/' + $
          ' vec.dae > '+fname
    print, cmd
    spawn, cmd
  endfor
end



;; load your desired color table prior to calling this
pro make_vectail
  tvlct,r,g,b, /get
  for c = 0, 255 do begin
    c01 =[ r[c]/255., g[c]/255., b[c]/255. ]
    fname = 'vectail_'+STRING(c,FORMAT='(I03)')+'.dae'
    cmd = 'sed s' + $
          '/.*KDM.*--\>' + $
          '/\<color\>'+STRJOIN(STRTRIM(c01,2),'\ ')+'\ 1\<\\/color\>/g' + $
          ' vectail.dae > '+fname
    print, cmd
    spawn, cmd
  endfor
end

make_vec
make_vectail
end
