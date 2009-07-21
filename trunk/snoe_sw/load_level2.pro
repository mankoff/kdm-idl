pro load_level2, coords, ch, yyyyddd, $ ; inputs
                 data, $        ; outputs
                 lat=lat, lon=lon, $
                 sza=sza, sca=sca, $
                 ut=ut, spins=spins, norm=norm

if ( ( n_params() ne 4 ) or ( ch gt 2 ) ) then begin
    message, "Input Error", /CONT
    return
endif

doy = SNOE_DATE( yyyyddd, /from_yyyyddd, /to_doy )
ymd = SNOE_DATE( yyyyddd, /from_yyyyddd, /to_ymd )

dir = !SNOE.p.uvs+'level2/data/'
file = STRTRIM( ymd[0],2 ) + '_' + $
        STRING( doy, /PRINT, FORMAT='(I3.3)' ) + '_' + $
        coords + '_' + $
        STRTRIM( ch, 2 ) + '.dat.gz'

if ( file_exist( dir+file ) ) then begin
    openr, lun, dir+file, /get_lun, /compress
    d = assoc( lun, !SNOE.f.l2 )
    data = d[0]
endif else data = !SNOE.f.l2


lat   = reform( data[ 0:50, 31, * ] )
lon   = reform( data[ 0:50, 32, * ] )
sza   = reform( data[ 0:50, 33, * ] )
sca   = reform( data[ 0:50, 34, * ] )
ut    = reform( data[ 0:50, 35, * ] )
spins = reform( data[ 0:50, 36, * ] )
norm  = reform( data[ 0:50, 37, * ] )

return
end

