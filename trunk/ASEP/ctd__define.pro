
function ctd::init, _EXTRA=e
  self->setProperty, _EXTRA=e
  self.kdm_dt = obj_new('kdm_dt')
  return, 1
end

pro ctd::display, title=title, $
                  _EXTRA=e
  _title = keyword_set(title)? title : ""
  
  Psave = !P & Xsave = !x & Ysave = !y
  ;xticklen = -0.02 & yticklen = -0.02
  if !d.name eq 'PS' then begin
     pos = [0.30, 0.30, 0.75, 0.72 ]
     thick = 5 & xthick = 5 & ythick = 5
     linethick = 3
     charsize = 1.5 & charthick = 5
  endif else if !d.name eq 'X' then begin
     pos = [0.15, 0.15, 0.90, 0.85 ]
     thick = 1 & xthick = 1 & ythick = 1
     linethick = 1
     charsize = 1.2 & charthick = 2
  endif else message, "DISPLAY not recognize"
  tvlct,rSave,gSave,bSave,/get

  snoect, /gray

  temprange = [ -2.5, 2.0 ]

  ;; set up the plot
  plotg, self->getProperty(/temp), $
         -1*self->getProperty(/depth), $
         ytitle='Depth (m)', $
         xtitle='Temperature (C)', $
         yrange=[min([min(-1*self->getProperty(/depth)),-250]),0], $
         thick=thick, xstyle=9, $
         xthick=xthick, ythick=ythick, $
         linethick=linethick, $
         xrange=temprange, $
         /nodata, $
         position=pos, $
         charsize=charsize, charthick=charthick, $
         title=_title+"!C!C!C!C", $
         ;xticks=9, $
         xticklen=xticklen, yticklen=yticklen, $
         xminor=4, $
         _EXTRA=e

  ;; plot the temperature (blue, bottom)
  axis, xaxis=0, xrange=temprange, xtitle='Temperature (C)', $
        charsize=charsize, charthick=charthick, $
        ;xticklen=-0.02, $
        ;xticks=9, $
        xthick=xthick, ythick=ythick, color=10, $
        xst=9, xminor=4
  oplot, self->getProperty(/temp), -1*self->getProperty(/depth), $
         color=10, thick=thick, _EXTRA=e

  ;; plot the salinity (red, top)
  axis, /xaxis, xrange=[33.5,35.0], /save, xtitle='Salinity', $
        charsize=charsize, charthick=charthick, $
        xticklen=-0.02, $
        xthick=xthick, ythick=ythick, color=253
  oplot, self->getProperty(/salt), -1*self->getProperty(/depth), $
         color=253, thick=thick, _EXTRA=e

  ;; add oxygen, below the bottom, green
  ;; just set up the coordinates, don't show anything
  if ptr_valid( self.oxygen ) then begin
     axis, xaxis=0, xrange=[3,10], /save, xtitle='Oxygen', $
           charsize=1e-10, charthick=1e-10, ticklen=1e-10, $
           /xst, xthick=0, ythick=0
     ;; show the data. Still no axes
     oplot, self->getProperty(/oxygen), -1*self->getProperty(/depth), $
            color=100, thick=thick, _EXTRA=e
  endif

  ;; add flourescence, top, blue
  if ptr_valid( self.fluorescence ) then begin
     axis, xaxis=0, xrange=[-1,30], /save, xtitle='Fluorescence', $
           charsize=1e-10, charthick=1e-10, ticklen=1e-10, $
           /xst, xthick=0, ythick=0
     oplot, self->getProperty(/fluorescence), -1*self->getProperty(/depth), $
            color=48, thick=thick, _EXTRA=e
  endif

  ;; density
;;   axis, xaxis=0, xrange=[1020,1040], /save, xtitle='Density', $
;;         charsize=1e-10, charthick=1e-10, ticklen=1e-10, $
;;         /xst, xthick=0, ythick=0
;;   dens = self->getProperty(/density) & depth = -1*self->getProperty(/depth)
;;   oplot, dens, depth, $
;;         color=254, thick=thick, _EXTRA=e
;;   xyouts, max(dens), min(depth), 'Density', color=254, /data, $
;;           charthick=charthick/2., charsize=charsize/2.

  ;; remake the plot grid invisible (no axes) but lower for OXYGEN
  if ptr_valid( self.oxygen ) then begin
     plot, [0,1], /nodata, $
           position=[pos[0],pos[1]-0.08,pos[2],pos[3]], $
           xst=5, yst=5 , /noerase, $
           xrange=[3,10]
     axis, xaxis=0, xrange=[3,10], /save, xtitle='Oxygen', $
           charsize=charsize, charthick=charthick, ticklen=ticklen, $
           color=100, xminor=4, $
           /xst, xthick=xthick, ythick=ythick
  endif

  if ptr_valid( self.fluorescence ) then begin
     ;; remake the plot grid invisible (no axes) but taller for FLUORESCENCE
     plot, [0,1], /nodata, $
           position=[pos[0],pos[1],pos[2],pos[3]+0.07], $
           xst=5, yst=5 , /noerase, $
           xrange=[-1,30]
     axis, xaxis=1, xrange=[-1,30], /save, xtitle='Fluorescence', $
           charsize=charsize, charthick=charthick, ticklen=ticklen, $
           color=48, $
           /xst, xthick=xthick, ythick=ythick
  endif

  ;; reset the plot so that I can overplot outside this procedure
  plot, $
     ;[0,0], $
     self->getProperty(/temp), $
     -1*self->getProperty(/depth), $
     ytitle='', xtitle='', $
     thick=1e-10, xthick=1e-10, ythick=1e-10, $
     xstyle=5, ystyle=4, $
     xrange=temprange, $
     yrange=[min([min(-1*self->getProperty(/depth)),-250]),0], $
     ;/nodata, $
     color=10, $
     /noerase, $
     position=pos, $
     charsize=1e-10, charthick=1e-10, $
     _EXTRA=e
;;   axis, xaxis=0, xrange=temprange, /save, $
;;         yrange=[min([min(-1*self->getProperty(/depth)),-250]),0], $
;;         charsize=-1e10, charthick=-1e10, ticklen=-1e10, $
;;         xthick=-1e10, ythick=-1e10, $
;;         color=48, $
;;         yst=4, xst=4
  

  tvlct,rSave,gSave,bSave ;; restore
  !p = Psave ;& !x = Xsave & !y = ysave
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
              density: ptr_valid(all.density)? *(all).density: 0, $
              dense2: ptr_valid(all.dense2)? *(all).dense2: 0, $
              fluorescence: ptr_valid(fluorescence)? *(all).fluorescence: 0, $
              fluor2: ptr_valid(fluor2)? *(all).fluor2: 0, $
              oxygen: ptr_valid(oxygen)? *(all).oxygen: 0, $
              ox2: ptr_valid(ox2)? *(all).ox2: 0, $
              depth: *(all).depth }
     return, actd
  endif
end

pro ctd::cleanup
  obj_destroy, self.kdm_dt
  ptr_free, self.temp, self.salt, self.depth 
  ptr_free, self.t2, self.s2
  ptr_free, self.density, self.dense2
  ptr_free, self.fluorescence, self.fluor2
  ptr_free, self.oxygen, self.ox2
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
            density: ptr_new(), $
            dense2: ptr_new(), $
            fluorescence: ptr_new(), $
            fluor2: ptr_new(), $
            oxygen: ptr_new(), $
            ox2: ptr_new(), $
            note: '', $
            ;;
            inherits kdm, $
            debug_ctd: 0B }
end



;ascs = oden_ascs()
;display_iterator, ascs

;; ctd = oden_asc('68')
;; ctd->display
;ctd->getProperty, temp=temp, depth=depth
;plots, [-2,-1],[-800,-600]
;oplot, indgen(10)
;oplot, temp, -1*depth;, color=252

;; kdm_ps, /portrait
;; ctd->display
;; kdm_ps, /close, /png, /crop, /show
;end
