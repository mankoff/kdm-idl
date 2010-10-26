pro kdm_kml_groundoverlay::KMLhead
  self->kdm_kml_overlay::KMLhead
  self->buildsource, '<GroundOverlay id="'+self.ID+'">'
end
pro kdm_kml_groundoverlay::KMLbody
  self->kdm_kml_overlay::KMLbody
  ;;self->buildsource, "<!-- Groundoverlay Body -->"
  
  self->buildsource, self->xmlTag( 'altitude', self.altitude )
  self->buildsource, self->xmlTag( 'altitudeMode', self.x_altitudemode )
  if keyword_set( self.north ) OR keyword_set( self.south ) OR keyword_set( self.east ) OR keyword_set( self.west ) then begin
     self->buildsource, '<LatLonBox>'
     self->buildsource, self->xmlTag( 'north', self.north )
     self->buildsource, self->xmlTag( 'south', self.south )
     self->buildsource, self->xmlTag( 'east', self.east )
     self->buildsource, self->xmlTag( 'west', self.west )
     self->buildsource, self->xmlTag( 'rotation', self.rotation )
     self->buildsource, '</LatLonBox>'
     coords = 1
  endif else if ( total(self.UL + self.LL + self.UR + self.LR) NE 0 ) then begin
     if n_elements(coords) ne 0 then MESSAGE, "Cannot have both edges and corners defined"
     self->buildsource, '<gx:LatLonQuad><coordinates>'
     self->buildsource, STRJOIN( STRTRIM( self.LL, 2 ), ',' )
     self->buildsource, STRJOIN( STRTRIM( self.UL, 2 ), ',' )
     self->buildsource, STRJOIN( STRTRIM( self.UR, 2 ), ',' )
     self->buildsource, STRJOIN( STRTRIM( self.LR, 2 ), ',' )
     self->buildsource, '</coordinates></gx:LatLonQuad>'
  endif else begin
     MESSAGE, "Must have one of edge or corner defined"
  endelse
end
pro kdm_kml_groundoverlay::KMLtail
  self->buildsource, '</GroundOverlay>'
  self->kdm_kml_overlay::KMLtail
end

function kdm_kml_groundoverlay::init, _EXTRA=e
  if self->kdm_kml_overlay::init(_EXTRA=e) ne 1 then return, 0
  self->setProperty, _EXTRA=e
  return, 1
end
pro kdm_kml_groundoverlay::cleanup
  self->kdm_kml_overlay::cleanup
end 
pro kdm_kml_groundoverlay__define, class
  arr = [0.0d, 0.0d, 0.0d]
  class = { kdm_kml_groundoverlay, $
            inherits kdm_kml_overlay, $
            altitude: 0.0d, $
            x_altitudemode: '', $
            ;; boundaries nested in LatLonBox
            north: 0.0, south: 0.0, east: 0.0, west: 0.0, $
            rotation: 0.0, $
            UL:arr, LL:arr, UR:arr, LR:arr }
end


;;
;; Testing
;;
img = bytarr(2,2)+255
write_png, 'test.png', img
kml = obj_new( 'kdm_kml', file='test.kml' )
d = obj_new( 'kdm_kml_document', visibility=1 )
f = obj_new( 'kdm_kml_folder', id='folder1', name='aFolder', visib=1 )

go = obj_new('kdm_kml_groundoverlay', href='test.png', $
             color='660000ff', $ ; transparent red
             north=10, south=-10, east=10, west=-10, visibi=1, name='GroundOverlay' )
f->add, go

go = obj_new('kdm_kml_groundoverlay', href='test.png', $
             color='6600ff00', $ ; transparent green
             visibi=1, name='GroundOverlay', $
             UL=[0,90], LL=[0,0], UR=[90,90], LR=[90,0] )
f->add, go

d->add, f
kml->add, d
kml->saveKML, /openGE
end
