
function ctd::init, _EXTRA=e
  self->setProperty, _EXTRA=e
  self.kdm_dt = obj_new('kdm_dt')
  return, 1
end

pro ctd::display, title=title, $
                  _EXTRA=e
  _title = keyword_set(title)? title : ""
  pos = [0.30, 0.30, 0.75, 0.80 ]
  tvlct,r,g,b,/get
  snoect, /gray
  plotg, self->getProperty(/temp), $
        -1*self->getProperty(/depth), $
        ytitle='Depth (m)', $
        xtitle='Temperature (C)', $
        yrange=[min([min(-1*self->getProperty(/depth)),-250]),0], $
        thick=3, xstyle=9, $
         xthick=5, ythick=5, $
         linethick=3, $
        xrange=[-2.5,2], /nodata, $
        position=pos, $
        charsize=1.5, charthick=5, $
        title=_title+"!C!C", $
         xminor=4, $
        _EXTRA=e
  axis, xaxis=0, xrange=[-2.5,2], xtitle='Temperature (C)', $
        charsize=1.5, charthick=5, xthick=5, ythick=5, color=10, $
        xst=9, xminor=4
  oplot, self->getProperty(/temp), -1*self->getProperty(/depth), $
         color=10, thick=5, _EXTRA=e
  axis, /xaxis, xrange=[33.5,35.0], /save, xtitle='Salinity', $
         charsize=1.5, charthick=5, xthick=5, ythick=5, color=253
  oplot, self->getProperty(/salt), -1*self->getProperty(/depth), $
         color=253, thick=5, _EXTRA=e
  tvlct,r,g,b ;; restore
end


;; special getProperty... Calls parent for default actions,
;; but if /struct is requested then it removes all the pointers
;; and returns just data. We can do this since this is a *single*
;; CTD object and it should not be used in an array of structs
;; with properties (depths) of variable length.
function ctd::getProperty, struct=struct, $
                           _EXTRA=e
  parent = self->kdm::getProperty(_EXTRA=e)
  if not kdm_is_null_string(parent) then return, parent
  if keyword_set(struct) then begin
     all = self->getProperty(/all)
     actd = { id: all.id, $
              kdm_dt: all.kdm_dt, $
              lat: all.lat, lon:all.lon, $
              temp: *(all).temp, $
              t2: ptr_valid(all.t2)? *(all).t2 : 0, $
              salt: *(all).salt, $
              s2: ptr_valid(all.s2)? *(all).s2 : 0, $
              depth: *(all).depth }
     return, actd
  endif
end

pro ctd::cleanup
  obj_destroy, self.kdm_dt
  ptr_free, self.temp, self.salt, self.depth 
  ptr_free, self.t2, self.s2
end

pro ctd__define, class
  class = { ctd, $
            hdr: '', $
            id: '', $
            kdm_dt: obj_new(), $
            lat: 0.0, $
            lon: 0.0, $
            depth: ptr_new(), $
            temp: ptr_new(), $
            t2: ptr_new(), $
            salt: ptr_new(), $
            s2: ptr_new(), $
            note: '', $
            ;;
            inherits kdm, $
            debug_ctd: 0B }
end


;; o = kdm_s87_load("/Users/mankoff/UCSC/ASEP/SIMBA/kdm_s87/*066")
;; kdm_ps, /portrait
;; o->display, title='foo'
;; kdm_ps, /close, /pdf, /crop, /show
;; end
