;+
;
; NAME:
;	KDM_GEOCODE
;
; PURPOSE:
;   This function geocodes or reverse geocodes using the Google Maps
;   API Web Service. Geocode means that the user provides an address
;   and this function returns the latitude and longitude. Reverse 
;   geocode takes a lat,lon pair and returns a human street address.
;
; CATEGORY:
;   Map
;
; CALLING SEQUENCE:
;   Result = KDM_GEOCODE( ADDRESS='Somewhere' )
;   Result = KDM_GEOCODE( lat=42, lon=24 )
;
; KEYWORD PARAMETERS:
;   ADDRESS: A string containing an address
;   LATITUDE: A latitude
;   LONGITUDE: A longitude
;   STATUS: The status message returned by the Google Maps API
;
;   Note that either ADDRESS OR (LATITUDE AND LONGITUDE) should be
;   supplied, but not all three.
;
; OUTPUTS:
;   A structure containing 3 fields, the address, the latitude, and
;   the longitude.
;
; RESTRICTIONS:
;   Needs web access.
;
; EXAMPLE:
;
;    To find out the latitude and longitude of the white house:
;    print, kdm_geocode( addr='1600 Pennsylvania Avenue, Washington, DC' )
;    Note that the addr field returned is different than the input address.
;
;    You can supply an address with a typo (should be Koshland), no
;    city, and no state, and it will still return valid lat/lon coordinates.
;    addr = kdm_geocode( addr='225 koshlnd 95064' )
;    help, addr.lat, addr.lon, addr.addr
;
;    Reveres geocoding works too, but in this case it provides an
;    address range not one specific house number.
;    print, kdm_geocode( lat='36.989759', lon='-122.06587' )
;
; MODIFICATION HISTORY:
; 	Written by:	Ken Mankoff, 2010-03-24.
;
;-


function kdm_geocode, $
   address=addr_in, $                   ; input an address
   latitude=lat_in, longitude=lon_in, $ ; OR input the lat AND lon coordinates
   status=status, $
   _EXTRA=e
  
  ;; remove spaces from address if one was provided
  if keyword_set(addr_in) then begin
     addr = addr_in
     IF STREGEX( addr, ' ', /BOOLEAN ) THEN $
        addr = STRJOIN( STRSPLIT( addr, ' ', /EXTRACT ), '+' )
  endif

  ;; decide if we'll geocode an address or reverse geocode coordinates
  if keyword_set( addr ) then query="address="+addr ELSE $
     query="latlng="+STRTRIM(lat_in,2)+','+STRTRIM(lon_in,2)

  ;; set up the data request from Google
  SOCKET, lun, 'maps.google.com', 80, /get, ERROR=err, _EXTRA=e
  if err ne 0 then MESSAGE, !ERROR_STATE.MSG
  PRINTF, lun, "GET http://maps.google.com/maps/api/geocode/json?" + $
          query + $
          ;;"address="+addr + $
          "&sensor=false"
  json = ''
  while not EOF(lun) DO begin   ; read the data from Google
     READF, lun, json
     json_all = ARRCONCAT( json_all, json )
     ;; save three fields of interest: address, and lat,lon
     ;; reverse geocoding returns all possible values, from closest
     ;; (rooftop) to farthest (country). We only return the first, the
     ;; highest resolution reverse geocode, hence the KEYWORD_SET logic.
     IF NOT KEYWORD_SET(addr_out) AND STREGEX( json, "formatted_address", /BOOLEAN ) THEN $
        addr_out = ( STREGEX( json, '.*:\ "(.*)".*', /EXTRACT, /SUB ) )[1]
     IF NOT KEYWORD_SET(lat_out) AND STREGEX( json, '"lat":', /BOOL ) THEN $
        lat_out = ( STREGEX( json, '.*:\ (.*),', /EXTRACT, /SUB ) )[1]
     IF NOT KEYWORD_SET(lng_out) AND STREGEX( json, '"lng":', /BOOL ) THEN $
        lng_out = ( STREGEX( json, '.*:\ (.*)', /EXTRACT, /SUB ) )[1]
     IF STREGEX( json, '"status":', /BOOL ) THEN $
        status = ( STREGEX( json, '.*:\ "(.*)",', /EXTRACT, /SUB ) )[1]
  endwhile
  FREE_LUN, lun

  if status eq 'OK' then $
     return, { addr:addr_out, lat:DOUBLE(lat_out), lon:DOUBLE(lng_out) }

  MESSAGE, status, /CONTINUE
  return, { addr:'', lat:0, lon:0, status:status }
end


;; testing code
print, kdm_geocode( addr='1600 Pennsylvania Avenue, Washington, DC' )
addr = kdm_geocode( addr='225 koshlnd 95064' ) ;; typo in street, no city or state!
help, addr.lat, addr.lon, addr.addr
print, kdm_geocode( lat='36.989759', lon='-122.06587' )

no = kdm_geocode( address="Foo Land, Somewhere", status=status )
help, no, status
end
