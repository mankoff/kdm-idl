
;; s87 format from: http://pal.lternet.edu/data/datainfo/02jan/ctd
;;
;; <FILE_FORMAT>
;; STD:
;; 	Columnar ascii files with column definition header.
;;
;; s87:
;; 	Columnar ascii files with LDEO's s87 format header (4 lines)
;; 	TCCPP SSSS CC  SDD.DDDD SDDD.DDDD  YYYY/MM/DD YDA HH:MM  CRUISE_ID
;; 	$ Comment Line
;; 	$ Comment Line
;; 	@ column definitions (PR TE SA)
;;
;; 	T  -  data type (C: ctd, B: bottle, A: axbt, X: xbt)
;; 	CC - NODC country code of the platform
;; 	PP - NODC platform code
;; 	SSSS - station number
;; 	CC - cast number
;; 	SDD.DDDD - latitude in decimal degrees (S; sign, + optional)
;; 	SDDD.DDDD - longitude in decimal degrees
;; 	YY/MM/DD - date, year/month/day
;; 	YDA - year-day for year of collection
;; 	HH:MM - time, hour:minutes
;; 	CRUISE_ID - optional cruise identifier, one word
;;
;; 	PR - pressure column (decibars)
;; 	TE - temperature (degrees C)
;; 	SA - salinity

;; Sample header from SIMBA s87 file:
;; C3206 00063  001 -70.2600 -90.0970 2007/09/25 268 23:02  SIMBA
;; $ SIMBA event 63
;; $ 09/09/08 iannuzzi ses2s87 9000 maxPress c2007268a_001.std
;; @PR TE  SA


pro ctd::write_s87, file, $
                    _EXTRA=e
  openw, lun, file, /get_lun
  printf, lun, self->getProperty(/hdr)
  self->getProperty, depth=d, temp=t, salt=s
  for i = 0, n_elements(d)-1 do begin
     printf, lun, $
             STRING( d[i], FORMAT='(F8.3)' ), $
             STRING( t[i], FORMAT='(F8.3)' ), $
             STRING( s[i], FORMAT='(F8.3)' )
  endfor
  free_lun, lun
end

