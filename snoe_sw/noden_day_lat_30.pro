PRO noden_day_lat_30, type, startday, lv=lv, sv=sv, orb=orb, lag8=lag8, $
                       ps=ps, help=help, fixgaps=fixgaps, _EXTRA=e

!fancy = 1
IF ((KEYWORD_SET(help)) OR (N_PARAMS() EQ 0)) THEN BEGIN
  PRINT, " "
  PRINT, "   NODEN_DAY_LAT_30, type, startday, lv=lv, sv=sv, orb=orb, $"
  PRINT, "                      fixgaps=fixgaps, ps=ps, help=help, $"
  PRINT, " "
  PRINT, "   type = 'geo' OR 'mag'"
  print, "   startday = yyyyddd start of plot (plot is 30 days long)"
  PRINT, "   orb = orbit of L3 to use [ 0 to 14 ] (uses L4 if not specified)"
  PRINT, "   lv = large[st] value of data. [ default: 60E7 ]"
  PRINT, "   sv = small[est] value of data. [ default: 3E7 ] (only with /log)"
  print, "   /lag8 = use 935_lag8/ directory [ default: /nitric2/uvs/935 ]"
  print, "   /fixgaps = fill in gaps less than 2 in X direction"
  PRINT, "   /help = display this message"
  PRINT, "   /ps = create postscript file 'idl.ps'"
  PRINT, " "
  print, "   this program makes 1 keogram 30 days in length"
  RETURN
ENDIF

IF (NOT KEYWORD_SET(ch)) THEN ch = 2
IF (NOT KEYWORD_SET(alt)) THEN alt = 106
IF (NOT KEYWORD_SET(lv)) THEN lv = 6.0e8
IF (NOT KEYWORD_SET(sv)) THEN sv = lv / 20.
IF (type EQ 'mag') THEN $
  ytitle = 'Geomagnetic Latitude' ELSE ytitle = 'Geographic Latitude'

day0 = snoe_date( startday, /from_yyyyddd, /to_mission )
day1 = day0 + 29
IF ( N_ELEMENTS( orb ) EQ 0 ) THEN BEGIN
    dir = !SNOE.p.uvs+'level4/'
    file = STRCOMPRESS('NO_' + STRING(ch) + '_day_' + type + '.dat', /REMOVE)
    fname = dir + file

    ;Open Data File
    OPENR, lun, fname, /get_lun, /swap_endian
    size = FSTAT(lun)
    size = size.size/(38.*29.*4.)
    input = ASSOC( lun, FLTARR( 38, 29, size ) )
    data = FLTARR( 30, 37 )
    data[ 0, 0 ] = transpose( reform( input[ 0:36, 19, day0:day1, 0 ] ) )
    lats = input[ 0:36, 28, 0 ]  ;latitude scale
    alts = fix( REFORM( input[ 37, 0:27, 0 ] ) ) ;altitude scale
ENDIF ELSE BEGIN
    dir = !SNOE.p.uvs+'level3/'
    file = STRCOMPRESS('NO_' + STRING(ch) + '_den_' + type + '.dat', /REMOVE)
    fname = dir + file

    ; Open Data File
    OPENR, lun, fname, /get_lun, /swap_endian
    size = FSTAT( lun )
    size = size.size / ( 38.*36.*15.*4 )
    input = ASSOC( lun, fltarr( 38, 36, 15 ) )

    data = FLTARR( 30, 37 )
    lat65n = fltarr( 30 ) & lat65s = lat65n & lat0 = lat65n
    FOR i=0, 29 DO BEGIN
        data[ i, 0 ] = transpose( input[ 0:36, 19, orb, i+day0 ] )
        lat0[i] = input[ 18, 32, orb, i+day0 ]
        lat65n[i] = input[ 30, 32, orb, i+day0 ]
        lat65s[i] = input[ 6, 32, orb, i+day0 ]
    ENDFOR
    midlon = input[ 0:36, 32, orb, day0+15 ]
    lats = input[ 0:36, 31, 0, 0 ]  ;latitude scale
ENDELSE
FREE_LUN, lun

IF KEYWORD_SET(ps) THEN BEGIN
    set_plot,'ps'
    !p.charsize = 1.0
    !p.charthick = 4
    !p.thick=4
    !x.thick=!p.thick & !y.thick=!p.thick
    DEVICE, /color, bits=8, /landscape, xsize=8.4, ysize=6.4
ENDIF
snoect

str_alt = STRCOMPRESS( '(' + STRING(alt), /REMOVE)
PRINT, 'sv:     ', strtrim(sv,2)
print, 'lv:     ', strtrim(lv,2)
print, 'MAX: ' + strtrim( max( data ), 2 )
data = (ALOG10( (data/ (sv) )>1) )
data = (255./ALOG10( lv/sv )) * data

IF ( keyword_set( fixgaps ) ) THEN BEGIN
    data = fix_gaps( data, /x, gap=2 )
ENDIF

xtickv = [ 0, 10, 20, 30 ]
xtickn = strtrim( [ snoe_date( day0, /from_mi, /to_doy ), $
                     snoe_date( day0+10, /from_mi, /to_doy ), $
                     snoe_date( day0+20, /from_mi, /to_doy ), $
                     snoe_date( day0+30, /from_mi, /to_doy ) ], 2 )
year = ( snoe_date( day0, /from_mi, /to_ymd ) )[ 0 ]
imdisp, data, /erase, /axis, title=ptitle, $
        yrange=[-90,90], yticklen=-.02, yticks=6, $
        yminor=3, ytitle=ytitle, ythick=ythick, $
        ystyle=1+8*( n_elements(orb) AND NOT n_elements( ps ) ), $
        xstyle=1, xticklen=-.02, xthick=xthick, xticks=3, $
        xtitle='Day of Year (' + strtrim(year,2) + ')', $
        xtickname=xtickn, xtickv=xtickv, xminor=10, $
        charsize=charsize, charthick=charthick, pthick=pthick, $
        position=[ 0.20, 0.20, 0.80, 0.70 ], /use, $
        /noscale, $
        _EXTRA=e

cbar_pos = [ 0.91, 0.20, 0.93, 0.70 ]
IF ( keyword_set( ps ) ) THEN cbar_pos = [ 0.86, 0.20, 0.88, 0.70 ]
cbar, /vert, /right, position=cbar_pos, $
      /ylog, /yst, yrange=[sv,lv], ytickv=[3e7,6e7,1e8,3e8,6e8], $
      ytickn=[' 3',' 6','10','30','60'], yticklen=0, $
      yticks=4, ytitle='Density (10!u7!n cm!u-3!n)', $
      chars=charsize, charth=charthick

IF ( n_elements( orb ) NE 0 AND n_elements( ps ) NE 1 ) THEN BEGIN
    axis, /yaxis, yrange=[-90, 90], yticks=6, yminor=3, /yst, $
          ytickv=[-90,-60,-30,0,30,60,90], $
          ytickn=strtrim(fix(midlon[ [0, 6, 12, 18, 24, 30, 36] ]),2), $
          yticklen=-0.02, $
          ytitle='Longitude (DOY ' + $
          strtrim( snoe_date( (day0+day1)/2.+1, /from_mi, /to_doy ), 2) + ')'

    line = indgen( 30 )
    gd0 = where( lat0 NE -999 )
    gd65n = where( lat65n NE -999 )
    gd65s = where( lat65s NE -999 )
    position=[ 0.20, 0.75, 0.80, 0.95 ]
    p_eq = position & p_eq[ 0 ] = (p_EQ[0]+p_EQ[2]) * .5
    p_65n = position & p_65n[ 0 ] = (p_65n[0]+p_65n[2]) * .33
    p_65s = position & p_65s[ 0 ] = (p_65s[0]+p_65s[2]) * .66
    ;;; set up the plot box
    plot, line, lat0, /nodata, /noerase, xticks=1, yticks=1, $
          yminor=0, xminor=0, xticklen=0.001, yticklen=0.001, $
          pos=position, xtickn=[' ',' '], ytickn=[' ',' '], /xst
    
    ;;; do the equator (in the middle)
    plot, line[gd0]+0.5, lat0[gd0], /noerase, xticks=1, yticks=1, $
          yminor=0, xminor=0, xticklen=0.001, yticklen=0.001, $
          pos=position, xtickn=[' ',' '], ytickn=[' ',' '], /yno, psym=2, $
          xrange=[ 0, 29 ], /xst, color=100, /yst, $
          yrange=[ floor(min(lat0[gd0])/10.)*10, ceil(max(lat0[gd0])/10.)*10 ]
    ;;; do 65N (on the right)
    plot, line[gd65n]+0.5, lat65n[gd65n], /noerase, xticks=1, yticks=1, $
          yminor=0, xminor=0, xticklen=0.001, yticklen=0.001, $
          pos=position, xtickn=[' ',' '], ytickn=[' ',' '], /yno, psym=2, $
          xrange=[ 0, 29 ], /xst, color=253, /yst, $
          yrange=[ floor(min(lat65n[gd65n])/10.)*10, ceil(max(lat65n[gd65n])/10.)*10 ]
    ;;; do 65s (on the left)
    plot, line[gd65s]+0.5, lat65s[gd65s], /noerase, xticks=1, yticks=1, $
          yminor=0, xminor=0, xticklen=0.001, yticklen=0.001, $
          pos=position, xtickn=[' ',' '], ytickn=[' ',' '], /yno, psym=2, $
          xrange=[ 0, 29 ], /xst, color=60, /yst, $
          yrange=[ floor(min(lat65s[gd65s])/10.)*10, ceil(max(lat65s[gd65s])/10.)*10 ]

    ;;; EQUATOR
    plot, line[gd0]+0.5, lat0[gd0], /noerase, /nodata, xticks=1, yticks=3, $
          xminor=0, xticklen=0.001, yticklen=-0.02, yminor=1, $
          pos=p_eq, xtickn=[' ',' '], /yno, ytickn=[' ','','',' '], $
          xrange=[ 0, 29 ], /xst, charth=2, ythick=3, yst=8, $
          yrange=[ floor(min(lat0[gd0])/10.)*10, ceil(max(lat0[gd0])/10.)*10 ]
    ;;; 65 NORTH
    plot, line[gd65n]+0.5, lat65n[gd65n], /noerase, /nodata, xticks=1, $
          yticks=3, $
          xminor=0, xticklen=0.001, yticklen=-0.02, yminor=1, $
          pos=p_65n, xtickn=[' ',' '], /yno, ytickn=[' ','','',' '], $
          xrange=[ 0, 29 ], /xst, charth=2, ythick=3, yst=8, $
          yrange=[ floor(min(lat65n[gd65n])/10.)*10, ceil(max(lat65n[gd65n])/10.)*10 ]
    ;;; 65 SOUTH
    plot, line[gd65s]+0.5, lat65s[gd65s], /noerase, /nodata, xticks=1, $
          yticks=3, $
          xminor=0, xticklen=0.001, yticklen=-0.02, yminor=1, $
          pos=p_65s, xtickn=[' ',' '], /yno, ytickn=[' ','','',' '], $
          xrange=[ 0, 29 ], /xst, charth=2, ythick=3, yst=8, $
          yrange=[ floor(min(lat65s[gd65s])/10.)*10, ceil(max(lat65s[gd65s])/10.)*10 ]

    ;;; white box
    plot, line, lat0, /nodata, /noerase, xticks=1, yticks=1, $
          yminor=0, xminor=0, xticklen=0.001, yticklen=0.001, $
          pos=position, xtickn=[' ',' '], ytickn=[' ',' '], /xst

    xyouts, 0.30, .96, '65N', /norm, color=253, chars=1.5, charth=2
    xyouts, 0.47, .96, 'EQ', /norm, color=100, chars=1.5, charth=2
    xyouts, 0.62, .96, '65S', /norm, color=60, chars=1.5, charth=2
ENDIF

IF (keyword_set(ps)) THEN BEGIN
    device, /close
    SET_PLOT, 'x'
    plot_clear
    print, " "
    PRINT, "file: idl.ps created (old file destroyed)"
   PRINT, "$clwb [options] idl.ps"
ENDIF
END
