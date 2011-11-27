;
;+
; CLASS_NAME:
;	KDM_DT
;
; PURPOSE:
;   A datetime object stores a date and/or time
;
; CATEGORY:
;   Date, Time, Object
;
; SUPERCLASSES:
;   Inherits the KDM object
;
; SUBCLASSES:
;   None
;
; CREATION:
;   Result = OBJ_NEW( 'kdm_dt' )
;
; METHODS:
;   TimeStamp, setProperty, Init, Cleanup
;
; RESTRICTIONS:
;   * Does not pay attention to leap year
;   * Accepts conflicting keywords and defaults (dt->setProperty, month=2, doy=2)
;   * Does not understand timezones. Defaults to UTC for /NOW keyword
;     and TimeStamp() function
;   * ...
;
; MODIFICATION HISTORY:
; 	Written by:	Ken Mankoff, 2009.
;	2009-09-22: Added documentation
;	2009-09-22: Added /NOW
;       2009-10-03: DOY is set when /NOW is used
;
; =============================================================
;
; METHODNAME:
;   KDM_DT::TimeStamp
;
; PURPOSE:
;   Return a timestamp based on the current date and time of this
;   object. Format is: YYYY-MM-DDThh:mm:ssZ
;
; CALLING SEQUENCE:
;   Result = KDM_DT -> TimeStamp()
;
; OUTPUTS:
;   A string based on the current date and time of this object. 
;   Format is: YYYY-MM-DDThh:mm:ssZ
;
; EXAMPLE:
;   To get the current date and time:
;
;   dt = obj_new( 'kdm_dt', /now )
;   print, dt->TimeStamp()
;
; =============================================================
;
; METHODNAME:
;   KDM_DT::SetProperty
;
; PURPOSE:
;   Set the properties of this date/time object
;
; CALLING SEQUENCE:
;   Obj -> SetProperty
;
; KEYWORD PARAMETERS:
;	YEAR, MONTH, STRMONTH, DAY, DOY, HOUR, MINUTE, SECOND
;
;   STRMONTH: The month in string format ("Sep", or "September")
;   DAY: The day of the month.
;   DOY: The day of year. Can be fractional
;
; PROCEDURE:
;   If a keyword overwrites an existing value then all values are set
;   to null and the object is essentially re-initialized. If an
;   existing does not already exist then the object is modified (ex:
;   Call once and set year to X, then call a second time and set hour
;   to Y)
;
;   If any other properties can be determined from an input they are
;   set. For example, if DOY is set to a fraction, month, day, hour,
;   minute, and second will all be filled in.
;  
; EXAMPLE:
;   To set the year of a KDM_DT object:
;
;   IDL> dt = obj_new( 'kdm_dt' )
;   IDL> dt->setProperty, year=2012
;   IDL> print, dt->TimeStamp()
;   2012

;   To set the day-of-year (fractional)
;   IDL> dt->setProperty, doy=42.24
;   IDL> print, dt->TimeStamp()
;   2012-02-11T05:45:36Z
;
; =============================================================
;
; METHODNAME:
;   KDM_DT::Init
;
; PURPOSE:
;   Create and initialize a KDM_DT object
;
; CALLING SEQUENCE:
;   dt = OBJ_NEW( 'kdm_dt' )
;	
; KEYWORD PARAMETERS:
;	NOW: Initialize with the current date and time
;   See SetProperty for other optional inputs
;
; OUTPUTS:
;   A KDM_DT object is returned. It is initialized with default values
;   passed in.
;
; PROCEDURE:
;   Create the object. Pass _EXTRA to SetProperty.
;
; EXAMPLE:
;   dt = OBJ_NEW( 'kdm_dt' )
;   dt = OBJ_NEW( 'kdm_dt', /NOW )
;   dt = OBJ_NEW( 'kdm_dt', YEAR=2012, monthStr='Feb', day=10, hour=13.3 )
;
;-


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


function kdm_dt::js
  sod = self.hour*3600+self.minute*60+self.second
  js = ymds2js( self.year, self.month, self.day, sod )
  return, js
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

  ;; fill doy from year, month, and day, and maybe hour, minute, second
  if self.doy eq -1 AND self.day ne -1 AND self.month ne -1 then begin
     if self.year ne -1 then y=self.year else begin 
        y = (bin_date(systime(0)))[0]
        ;;MESSAGE, "Using current year for leap-year calculations", /CONTINUE
     endelse
     self.doy = ymd2dn( y, self.month, self.day )
     if self.hour ne -1 then self.doy = self.doy + self.hour/24.
     if self.minute ne -1 then self.doy = self.doy + self.minute/(60*24.)
     if self.second ne -1 then self.doy = self.doy + self.second/(60*60*24.)
  endif

  ;; fill month and/or day from DOY
  if self.doy ne -1 AND (self.day eq -1 OR self.month eq -1) then begin
     if self.year ne -1 then y=self.year else begin 
        y = (bin_date(systime(0)))[0]
        ;;MESSAGE, "Using current year for leap-year calculations", /CONTINUE
     endelse
     ;;caldat, julday(1,1,y)+doy, month, day
     ydn2md, y, ceil(self.doy), month, day
     if self.day eq -1 then begin
        self.day = day
        if (self.doy mod 1 ne 0) then self.day = self.day-1+(self.doy mod 1)
     endif
     if self.month eq -1 then self.month = month
     ;; OR fill in doy from month and/or day
  endif

  ;; fill strmonth from month?
  if self.month ne -1 AND self.strmonth eq '' THEN $
     self.strmonth = (TheMonths())[self.month-1]

  ;; fill month from strmonth
  if self.strmonth ne '' and self.month eq -1 then begin
     self.month=where(strlowcase(theMonths(/abb)) eq strlowcase(self.strmonth))
     if self.month eq -1 then $
        self.month=where(strlowcase(theMonths()) eq strlowcase(self.strmonth))
     if self.month eq -1 then MESSAGE, "Cannot determine numeric month from: "+self.strmonth
     self.month = self.month+1
  endif
  
  ;; Seconds given, nothing else?
  if self.second ne -1 AND self.minute eq -1 and self.hour eq -1 then begin
     self.hour = floor(self.second / (60*60.))
     self.second = self.second - (self.hour*60*60.)
     self.minute = floor(self.second / (60.))
     self.second = self.second - (self.minute*60)
  endif

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

function kdm_dt::init, now=now, _EXTRA=e
  if (self->kdm::init(_EXTRA=e) ne 1) then return, 0
  self->reSetProperty
  self->setProperty, kdm_dt_init=1B
  if NOT keyword_set( now ) then begin
     self->setProperty, _EXTRA=e
  endif else begin ;; NOW
     now = STRSPLIT( systime(/UTC), /EXTRACT )
     t = STRSPLIT( now[3], ":", /EXTRACT )
     self->setProperty, strmonth=now[1], day=now[2], year=now[4], $
                        hour=t[0], minute=t[1], second=t[2]
     self->autofill
  endelse
     
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

help, (obj_new('kdm_dt', /now))->getProperty(/all), /st
print, (obj_new('kdm_dt', year=2009, month=11, day=07, second=59908))->TimeStamp()
end

;; kdm_dt testing
;; print, (obj_new( 'kdm_dt', /NOW ))->TimeStamp()
;; end

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
