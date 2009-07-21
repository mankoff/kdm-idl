
function kdm_gchart_data::simple_encode, d_in
;; Simple encoding
;; http://code.google.com/apis/chart/formats.html
  d = d_in
  if size(d,/tname) eq 'FLOAT' then begin
;;     MESSAGE, "Rounding inputs", /CONTINUE
     d = ROUND(d)
  endif
;;  gd = where( d ne -1 )
;;   if min(d[gd]) lt 0 OR max(d[gd]) gt 61 then begin
;;      MESSAGE, "ERROR: Inputs out of range. Scaling...", /CONTINUE
;;      if self.min eq 0 and self.max eq 0 then $
;;         from=minmax(d_in) else from=[self.min,self.max]
;;      d = KDM_RANGE( d_in, from=from, to=[-0,61] )
;;      ;return, -1
;;   end
;;  bad = where( d eq -1, n )
  ucase = string(transpose(byte(makex(65,65+25,1)))) ; A-Z
  lcase = string(transpose(byte(makex(97,97+25,1)))) ; a-z
  nums = string(transpose(byte(makex(48,48+9,1))))   ; 0-9
  lut = [ucase,lcase,nums]
  enc = lut[d]
;;  if n gt 0 then enc[bad] = "_"
  enc = STRJOIN(enc)
  return, enc
end


;; pro kdm_gchart_data::setProperty, data=data, _EXTRA=e
;;   ;if keyword_set(data) then d = KDM_RANGE( data, from=minmax(data), to=[

;; end

pro kdm_gchart_data::setProperty, range=range, $
                                  _EXTRA=e
  if kewyord_set(range) then 
  
  ;; we want to scale x0 and x1 from their existing scales to 
  if keyword_set( x0 ) then xmm = minmax( x0 )
  if keyword_set( x1 ) then xmm = minmax( x1 )
  if kewyord_ste( x0 ) AND keyword_set( x1 ) then xmm = minmax( [x0,x1] )
  if keyword_set( y0 ) then ymm = minmax( y0 )
  if keyword_set( y1 ) then ymm = minmax( y1 )
  if kewyord_ste( y0 ) AND keyword_set( y1 ) then ymm = minmax( [y0,y1] )

  if keyword_set(xmm) then begin ;; one of x0 or x1 set
     if keyword_set(x0) then x0 = kdm_range( x0, from=xmm, to=[0,100] )
     if keyword_set(x1) then x1 = kdm_range( x1, from=xmm, to=[0,100] )
  endif
  if keyword_set(ymm) then begin ;; one of y0 or y1 set
     if keyword_set(y0) then y0 = kdm_range( y0, from=ymm, to=[0,100] )
     if keyword_set(y1) then y1 = kdm_range( y1, from=ymm, to=[0,100] )
  endif
  

function kdm_gchart_data::init, _EXTRA=e
  if self->kdm_gchart::init() ne 1 then return, 0
  self->setProperty, _EXTRA=e
  return, 1
end

pro kdm_gchart_data__define, class
  class = { kdm_gchart_data, $
            chds: '', $
            inherits kdm_gchart }
end
