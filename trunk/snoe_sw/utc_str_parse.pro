
PRO utc_str_parse, utc, yy, dd, hh, mm, ss, ms

yy = LONG(STRMID( utc, 0, 4 ))
dd = FIX(STRMID( utc, 5,  7 ))
hh = FIX(STRMID( utc, 9, 10 ))
mm = FIX(STRMID( utc, 12,13 ))
ss = FIX(STRMID( utc, 15,16 ))
ms = FIX(STRMID( utc, 18,19 ))

IF ( isarray( utc ) ) THEN BEGIN
    yy = reform( yy )
    dd = reform( dd )
    hh = reform( hh )
    mm = reform( mm )
    ss = reform( ss )
    ms = reform( ss )
ENDIF

RETURN
END
