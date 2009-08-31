
pro test_simple, kml
  kml = obj_new('kdm_kml', file='test.kml')
  d = obj_new( 'kdm_kml_document', visibility=1 )
  kml->add, d
end

pro test_oneplacemark, kml
  kml = obj_new('kdm_kml', file='test.kml')
  d = obj_new( 'kdm_kml_document', visibility=1 )
  pm = obj_new('kdm_kml_placemark', lat=42, lon=42, alt=1e5, name="test" )
  d->add, pm
  kml->add, d
end


pro test_placemark_icon, kml
  kml = obj_new('kdm_kml', file='test.kml')
  d = obj_new( 'kdm_kml_document', visibility=1 )
  pm = obj_new('kdm_kml_placemark', lat=42, lon=42, alt=1e5, name="test", description='Hello, World' )
  pm->add, obj_new('kdm_kml_iconstyle', href='circle.png', color=[255,0,0], size=2.0 )
  d->add, pm
;;   pm = obj_new('kdm_kml_placemark', lat=43, lon=43, alt=1e5, name="test" )
;;   pm->add, obj_new('kdm_kml_iconstyle', href=kdm_colorspheres(pie=[1,2], colors=[[255,0,0],[0,0,255]] ) )
;;   d->add, pm
  kml->add, d
end

pro test_placemarks, kml
  kml = obj_new('kdm_kml', file='test.kml')
  d = obj_new( 'kdm_kml_document', visibility=1 )

  f0 = obj_new( 'kdm_kml_folder', id='folder0', name='One Empty Folder' )
  f1 = obj_new( 'kdm_kml_folder', id='folder1', name='One Full Folder' )

  p0 = obj_new( 'kdm_kml_placemark', lat=2, lon=2, id='P0', visibility=1, name='P0', description='Some Text' )
  p1 = obj_new( 'kdm_kml_placemark', id='P0', visibility=1, name='P0', description='Some Text', lat=1, lon=1 )
  f0->add, p0
  f0->add, p1

  ;;random placemarks
  for i = 0L, 10000 do begin
     istr = STRING(i,FORMAT='(I03)')
     p = obj_new('kdm_kml_placemark', $
                 id='Pid'+istr, $
                 lat=randomn(seed,1)*90, $
                 lon=randomu(seed,1)*360, $
                 x_altitudemode='relativeToGround', $
                 altitude=randomu(seed,1)*1e7, $
                 extrude=randomu(seed,1) gt 0.5, $
                 description='Some Text '+istr, $
                 name='Pid'+istr, $
                 visibility=1 )
     f1->add, p
  endfor
  d->add, f0
  d->add, f1
  kml->add, d
end

pro test_timespan, kml
  kml = obj_new('kdm_kml', file='test.kml')
  d = obj_new( 'kdm_kml_document', visibility=1 )
  kml->add, d
  f = obj_new( 'kdm_kml_folder', id='folder1', name='One Full Folder' )
  d->add, f
  ;; gridded placemarks w/ TimeSpan
  year = 1900
  for lat = -10, 10 do begin
     for lon = -10, 10 do begin
        p = obj_new('kdm_kml_placemark', $
                    lat=lat, lon=lon, vis=1, name='Foo', description='Bar', $
                    altitude=randomu(seed,1)*1e5, extrude=1, $
                    x_alt='relativeToGround')
        p->add, obj_new( 'kdm_kml_timespan', timebegin=year )
        f->add, p
        year++
     endfor
  endfor
end



pro test_groundoverlay, kml

  ;; three ground overlays (with timespans) and some placemarks to
  ;; check corners

  kml = obj_new('kdm_kml', file='/Users/mankoff/Desktop/test.kml')
  d = obj_new( 'kdm_kml_document', visibility=1 )
  f = obj_new( 'kdm_kml_folder', id='folder1', name='aFolder', visib=1 )

  go = obj_new('kdm_kml_groundoverlay', href='file:///Users/mankoff/desktop/overlay.png', $
               north=10, south=-10, east=10, west=-10, visibi=1, name='GroundOverlay' )
  go->add, obj_new( 'kdm_kml_timespan', timebegin=1900 )
  f->add, go

  go = obj_new('kdm_kml_groundoverlay', href='file:///Users/mankoff/desktop/overlay.png', $
               north=10, south=-10, east=30, west=10, visibi=1, name='GroundOverlay2' )
  go->add, obj_new( 'kdm_kml_timespan', timebegin=1920 )
  f->add, go

  go = obj_new('kdm_kml_groundoverlay', href='file:///Users/mankoff/desktop/overlay.png', $
               north=10, south=-10, east=50, west=30, visibi=1, name='GroundOverlay3' )
  go->add, obj_new( 'kdm_kml_timespan', timebegin=1950 )
  f->add, go

  ;; placemarks delimiting the first box
  f->add, obj_new('kdm_kml_placemark', lat=-10, lon=-10 )
  f->add, obj_new('kdm_kml_placemark', lat=-10, lon=10 )
  f->add, obj_new('kdm_kml_placemark', lat=10, lon=10 )
  f->add, obj_new('kdm_kml_placemark', lat=10, lon=-10 )
  d->add, f
  kml->add, d
end

pro test_linestring, kml
  kml = obj_new('kdm_kml', file='test.kml')
  d = obj_new( 'kdm_kml_document', visibility=1 )
  f = obj_new( 'kdm_kml_folder', id='folder1', name='aFolder', visib=1 )

  ls1 = obj_new('kdm_kml_placemark', lat=indgen(10)*(-2), lon=indgen(10)*2, $
                alt=indgen(10)*1e5, $
                x_altitudeMode='relativeToGround', visibility=1, tesselate=0 )
  ls1->add, obj_new( 'kdm_kml_timespan', timebegin=1950 )
  
  f->add, ls1
  d->add, f
  kml->add, d
end

pro test_balloon_style, kml
  ;; http://code.google.com/apis/kml/documentation/kmlreference.html#balloonstyle
  kml = obj_new('kdm_kml', file='test.kml')
  d = obj_new( 'kdm_kml_document', visibility=1, name="BalloonStyle.kml", open=1 )

  ;;f = obj_new( 'kdm_kml_folder', id='folder1', name='aFolder', visib=1 )
  st = obj_new('kdm_kml_style', id='exampleBalloonStyle')
  bs = obj_new( 'kdm_kml_balloonstyle', $
                bgcolor='ffffffbb', $
                text=kdm_cdata( '<b><font color="#CC0000" size="+3">$[name]</font></b>' + $
                                '<br/><br/>' + $
                                '<font face="Courier">$[description]</font>' + $
                                '<br/><br/>' + $
                                'Extra text that will appear in the description balloon' + $
                                '<br/><br/>' + $
                                '<!-- insert the to/from hyperlinks -->' + $
                                '<!-- $[geDirections] -->' ) $
                )
  p = obj_new( 'kdm_kml_placemark', lon=-122.370533, lat=37.823842, alt=0, $
               name='BalloonStyle', styleURL='#exampleBalloonStyle', $
               description='An example of a BalloonStyle', open=1, snippet=0 )

  kml->add, d
  d->add, st
  st->add, bs
  d->add, p
end


;; LinearRing
pro test_linearring, kml
  kml = obj_new('kdm_kml', file='test.kml')
  d = obj_new( 'kdm_kml_document', visibility=1, id='docID' )
  kml->add, d
  pl = obj_new( 'kdm_kml_placemark', name='PlaceMark', id='placeID', $
                description=kdm_cdata('Balloon contents...') )
  d->add, pl
  p = obj_new( 'kdm_kml_polygon', extrude=1, tessellate=1, $
      x_altitudeMode='clampToGround', id='polyID' )
  pl->add, p
  p->add, obj_new( 'kdm_kml_linearring', lat=[0,1,1,0,0]-0.5, $
                   lon=[0,0,1,1,0]-0.5, id='ringID' )
end

pro test_stylemap, kml
  kml = obj_new('kdm_kml', file='test.kml')
  d = obj_new( 'kdm_kml_document', visibility=1, id='docID' )
  kml->add, d
  pl = obj_new( 'kdm_kml_placemark', name='PlaceMark', id='placeID', $
                description=kdm_cdata('Balloon contents...'), snippet=0 )
  d->add, pl
  p = obj_new( 'kdm_kml_polygon', extrude=1, tessellate=1, $
      x_altitudeMode='clampToGround', id='polyID' )
  pl->add, p
  p->add, obj_new( 'kdm_kml_linearring', lat=[0,1,1,0,0]-0.5, $
                   lon=[0,0,1,1,0]-0.5, id='ringID' )

  ;; at this point we've set up a square of 1 degree lat/lon
  ;; centered on (0,0). Lets make it pretty. We want: A white boundary
  ;; line by default. When mouse-over, a bright green boundary line,
  ;; and fill the square in 50% shaded.
  style_normal = obj_new( 'kdm_kml_style', id='normal' )
  linestyle = obj_new( 'kdm_kml_linestyle', width=3, color='ffffffff' ) ; 3 thick and white
  polystyle = obj_new( 'kdm_kml_polystyle', color='00ffffff' ) ; transparent
  style_normal->add, linestyle->clone()
  style_normal->add, polystyle->clone()

  style_highlight = obj_new( 'kdm_kml_style', id='highlight' )
  linestyle = obj_new( 'kdm_kml_linestyle', width=3, color='ff00ff00' ) ; 3 thick and green
  polystyle = obj_new( 'kdm_kml_polystyle', color='66ffffff' ) ; 50% transparent
  style_highlight->add, linestyle->clone()
  style_highlight->add, polystyle->clone()
  
  style_map = obj_new( 'kdm_kml_stylemap', id='stylemap', $
                       normal=style_normal->getProperty(/id), $
                       highlight=style_highlight->getProperty(/id) )
  d->add, style_normal
  d->add, style_highlight
  d->add, style_map
  pl->setProperty, style='#'+style_map->getProperty(/id)
end  


;;test_simple, kml
;;test_oneplacemark, kml
;;test_placemarks, kml
;;test_placemark_icon, kml
;;test_timespan, kml
;;test_groundoverlay, kml
;;test_linestring, kml
;;test_balloon_style, kml
;;test_linearring, kml
test_stylemap, kml

;;kml->hierarchy
;;kml->saveKML, /kmz, /openge
kml->saveKML, /openGE
;kml->saveKML
;obj_destroy, kml
;spawn, 'cat test.kml'
end
