

function kdm_dt::TimeStamp
  ;;http://code.google.com/apis/kml/documentation/kmlreference.html#timestamp
  ;; dateTime (YYYY-MM-DDThh:mm:ssZ) UTC time implemented
  ;; dateTime (YYYY-MM-DDThh:mm:sszzzzzz) local time not yet implemented

  if self.year eq -1 then MESSAGE, "Year not yet set"
  ts = STRING( self.year, FORMAT='(I04)' )

  if self.month eq -1 then return, ts
  ts = ts + '-' + STRING( self.month, FORMAT='(I02)' )
  if self.day eq -1 then return, ts
  ts = ts + '-' + STRING( self.day, FORMAT='(I02)' )
  if self.hour eq -1 then return, ts
  ts = ts + 'T' + STRING( self.hour, FORMAT='(I02)' )
  min = ( self.minute eq -1 ) ? 0 : self.minute
  sec = ( self.second eq -1 ) ? 0 : self.second
  ts = ts + ':' + STRING( min, FORMAT='(I02)' )
  ts = ts + ':' + STRING( sec, FORMAT='(I02)' )
  ts = ts + 'Z'
  
  return, ts
end

;; some error checking
pro kdm_dt::errcheck
;;   if ( self.day ne 0 AND self.doy ne 0 ) then $
;;      if ( floor(self.day) NE floor(self.doy) ) then begin
;;         MESSAGE, "Day and DOY fractions do not agree", /CONTINUE
;;         ;stop
;;      endif
  ;; add others...
end

pro kdm_dt::autofill_alert
  ;;MESSAGE, "Do Not Trust AutoFilled Fields", /CONTINUE
  MSG=''
  if self.year eq -1 then MSG=MSG+"Year, "
  if self.month eq 1 then MSG=MSG+"Month, "
  if self.strmonth eq '' then MSG=MSG+"Strmonth, "
  if self.day eq -1 then MSG=MSG+"Day, "
  if self.doy eq -1 then MSG=MSG+"DOY, "
  if self.hour eq -1 then MSG=MSG+"Hour, "
  if self.minute eq -1 then MSG=MSG+"Minute, "
  if self.second eq -1 then MSG=MSG+"Second, "
  IF MSG eq '' then return
  MSG = 'Empty Field: '+MSG
  MSG = STRMID( msg, 0, STRLEN(msg)-2 )
  ;;MESSAGE, MSG, /CONTINUE
end

pro kdm_dt::autofill
  self->errcheck
  
  ;; fill doy from year fraction?
  if self.doy eq -1 and ( self.year mod 1 NE 0 ) then $
     self.doy = (self.year mod 1) * TOTAL(MONTHDAYS(self.year,0))

  ;; fill doy from year, month, and day
  if self.doy eq -1 AND self.day ne -1 AND self.month ne -1 then begin
     if self.year ne -1 then y=self.year else begin 
        y = (bin_date(systime(0)))[0]
        ;;MESSAGE, "Using current year for leap-year calculations", /CONTINUE
     endelse
     self.doy = ymd2dn( y, self.month, self.day )
  endif

  ;; fill month and/or day from DOY
  if self.doy ne -1 AND (self.day eq -1 OR self.month eq -1) then begin
     if self.year ne -1 then y=self.year else begin 
        y = (bin_date(systime(0)))[0]
        ;;MESSAGE, "Using current year for leap-year calculations", /CONTINUE
     endelse
     ;;caldat, julday(1,1,y)+doy, month, day
     ydn2md, y, ceil(self.doy), month, day
     if self.day eq -1 then self.day = day-1+(self.doy mod 1)
     if self.month eq -1 then self.month = month
     ;; OR fill in doy from month and/or day
  endif

  ;; fill strmonth from month?
  if self.month ne -1 AND self.strmonth eq '' THEN $
     self.strmonth = (TheMonths())[self.month-1]
  
  ;; fill hour from day or doy fraction
  if self.hour eq -1 AND ( (self.doy mod 1 ne 0) OR (self.day mod 1 ne 0) ) then $
     self.hour = 24.0 * ( max( [ self.day, self.doy ] ) mod 1 )

  ;; fill minute from hour fraction
  if self.minute eq -1 AND self.hour ne -1 then $
     self.minute = 60.0 * ( self.hour - FLOOR(self.hour) )

  ;; fill second from minute fraction
  if self.second eq -1 AND self.minute ne -1 then $
     self.second = 60.0 * ( self.minute - FLOOR(self.minute) )

  self->autofill_alert
end

pro kdm_dt::reSetProperty, _EXTRA=e
  ;; should not need to be called manually.
  ;; SetProperty logic should handle this
  ;;MESSAGE, "Resetting fields", /CONTINUE
  self->kdm::setProperty, year=-1, month=-1, strmonth='', $
                     day=-1, doy=-1, $
                     hour=-1, minute=-1, second=-1
  self->kdm::setProperty, _EXTRA=e
end
pro kdm_dt::setProperty, kdm_dt_init=kdm_dt_init, _EXTRA=e
  kdm_requiresubclass, self, 'kdm'
  if keyword_set( kdm_dt_init ) then self->kdm::setProperty, kdm_dt_init=kdm_dt_init
  ;; If we are being called with a paramater, check if it is already
  ;; set. If it is already set, then reset all paramaters. Bit of
  ;; extra work because kdm::setProperty can only take one keyword at
  ;; a time.
  if self->getProperty(/kdm_dt_init) AND keyword_set(e) then begin
     et = tag_names(e)
     for i = 0, n_elements(et)-1 do begin
        st = create_struct( et[i], e.(i) )
        curval = self->kdm::getProperty(_EXTRA=st)
        ;;if self->getProperty(/kdm_dt_init) AND curval ne -1 then self->reSetProperty
        if curval ne -1 then self->reSetProperty
     endfor
     self->kdm::setProperty, _EXTRA=e
     self->autofill
  endif
  ;;if self->getProperty(/kdm_dt_init) then 
end

function kdm_dt::init, _EXTRA=e
  if (self->kdm::init(_EXTRA=e) ne 1) then return, 0
  self->reSetProperty
  self->setProperty, kdm_dt_init=1B
  self->setProperty, _EXTRA=e
  return, 1
end
pro kdm_dt::cleanup
  ;;if self->GetProperty(/debug) then MESSAGE, "Cleanup", /CONTINUE
end 

pro kdm_dt__define, class, _EXTRA=e
  class = { kdm_dt, $
            year: 0.0d, $
            month: 0.0d, $
            strmonth: '', $
            day: 0.0d, $
            doy: 0.0d, $
            hour: 0.0, $
            minute: 0.0, $
            second: 0.0d, $
            kdm_dt_init: 0B, $
            inherits kdm }
end

;;help, (obj_new('kdm_dt', doy=42))->getProperty(/all), /st
;print, (obj_new('kdm_dt'))->getProperty(/all)
;; o = obj_new('kdm_dt', year=2009.555)
;; print, "After Init: ", o->getProperty(/all)
;o->setProperty, year=2009.1d
;o->setProperty, year=2009+(1/365d)
;; dt = o->getProperty(/all)
;; ;print, "All: ", dt
;; help, dt, /st
;;end

;; dt = {kdm_dt}
;; dt.year = 2009.5555555
;; dt = kdm_dt_autofill(dt)
;; end
