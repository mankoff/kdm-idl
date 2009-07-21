
function kdm_gchart_axis::url, _EXTRA=e
  axisidx = 0
  chxturl = ''                  ; axes on/off
  chxrurl = ''                  ; axis ranges
  chxlurl = ''                  ; axis labels
  chxpurl = ''                  ; label alignment
  
  if keyword_set( self.xrange ) then begin
     chxturl = chxturl + 'x,'
     chxrurl = chxrurl + STRTRIM(axisidx,2)+","+self.xrange+'|'
     axisidx = axisidx+1
  endif
  if keyword_set( self.xlabel ) then begin
     chxturl = chxturl + 'x,'
     chxpurl = chxpurl + STRTRIM(axisidx,2)+',50|'
     chxlurl = chxlurl + STRTRIM(axisidx,2)+":|"+self.xlabel+'|'
     axisidx = axisidx+1
  endif

  if keyword_set( self.yrange ) then begin
     chxturl = chxturl + 'y,'
     chxrurl = chxrurl + STRTRIM(axisidx,2)+","+self.yrange+'|'
     axisidx = axisidx+1
  endif
  if keyword_set( self.ylabel ) then begin
     chxturl = chxturl + 'y,'
     chxpurl = chxpurl + STRTRIM(axisidx,2)+',50|'
     chxlurl = chxlurl + STRTRIM(axisidx,2)+":|"+self.ylabel+'|'
     axisidx = axisidx+1
  endif

  if keyword_set( self.trange ) then begin
     chxturl = chxturl + 't,'
     chxrurl = chxrurl + STRTRIM(axisidx,2)+","+self.trange+'|'
     axisidx = axisidx+1
  endif
  if keyword_set( self.tlabel ) then begin
     chxturl = chxturl + 't,'
     chxpurl = chxpurl + STRTRIM(axisidx,2)+',50|'
     chxlurl = chxlurl + STRTRIM(axisidx,2)+":|"+self.tlabel+'|'
     axisidx = axisidx+1
  endif

  if keyword_set( self.rrange ) then begin
     chxturl = chxturl + 'r,'
     chxrurl = chxrurl + STRTRIM(axisidx,2)+","+self.rrange+'|'
     axisidx = axisidx+1
  endif
  if keyword_set( self.rlabel ) then begin
     chxturl = chxturl + 'r,'
     chxpurl = chxpurl + STRTRIM(axisidx,2)+',50|'
     chxlurl = chxlurl + STRTRIM(axisidx,2)+":|"+self.rlabel+'|'
     axisidx = axisidx+1
  endif

  chxturl = STRMID( chxturl, 0, STRLEN(chxturl)-1 ) ;; remove last ','
  ;;chxlurl = STRMID( chxlurl, 0, STRLEN(chxlurl)-1 ) ;; remove last '|'
  chxrurl = STRMID( chxrurl, 0, STRLEN(chxrurl)-1 ) ;; remove last '|'
  chxpurl = STRMID( chxpurl, 0, STRLEN(chxpurl)-1 ) ;; remove last '|'
  
  url = ''
  if chxturl ne '' then url = url + '&chxt='+chxturl
  if chxlurl ne '' then url = url + '&chxl='+chxlurl
  if chxrurl ne '' then url = url + '&chxr='+chxrurl
  if chxpurl ne '' then url = url + '&chxp='+chxpurl
  return, STRCOMPRESS(url,/REMOVE_ALL)
end

pro kdm_gchart_axis::setProperty, xrange=xrange, yrange=yrange, $
                                  rrange=rrange, trange=trange, $
                                  xlabel=xlabel, ylabel=ylabel, $
                                  rlabel=rlabel, tlabel=tlabel, $
                                  _EXTRA=e
  if keyword_set( xrange ) then xr = STRJOIN(xrange,',')
  if keyword_set( yrange ) then yr = STRJOIN(yrange,',')
  if keyword_set( trange ) then tr = STRJOIN(trange,',')
  if keyword_set( rrange ) then rr = STRJOIN(rrange,',')
  if keyword_set( xlabel ) then xl = STRJOIN(xlabel,'|')
  if keyword_set( ylabel ) then yl = STRJOIN(ylabel,'|')
  if keyword_set( tlabel ) then tl = STRJOIN(tlabel,'|')
  if keyword_set( rlabel ) then rl = STRJOIN(rlabel,'|')
  self->kdm_gchart::setProperty, xrange=xr, yrange=yr, trange=tr, rrange=rr, $
                                 xlabel=xl, ylabel=yl, tlabel=tl, rlabel=rl, _EXTRA=e
end

function kdm_gchart_axis::init, _EXTRA=e
  if self->kdm_gchart::init() ne 1 then return, 0
  self->setProperty, _EXTRA=e
  return, 1
end
;; pro kdm_gchart_axis::cleanup
;; end 
pro kdm_gchart_axis__define, class
  class = { kdm_gchart_axis, $
            ;;x: 0, y:0, t: 0, r:0, $
            xlabel: '', ylabel: '', $
            rlabel: '', tlabel: '', $
            xrange: '', yrange: '', $
            rrange: '', trange: '', $
            inherits kdm_gchart }
end

o->add, obj_new('kdm_gchart_axis', ylabel='Y Axis', yrange=[0,100] )
end
