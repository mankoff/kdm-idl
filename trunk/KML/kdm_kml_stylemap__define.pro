;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;; This object encapsulates the StyleMap
;; http://code.google.com/apis/kml/documentation/kmlreference.html#stylemap
;; 
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;; <StyleMap>
;; Syntax
;;
;; <StyleMap id="ID">
;; <!-- extends StyleSelector -->
;;
;; <!-- specific to Style -->
;; <!-- elements specific to StyleMap -->
;;   <Pair id="ID">
;;    <key>normal</key>  <!-- kml:styleStateEnum:  normal or highlight -->
;;     <styleUrl>...</styleUrl> or <Style>...</Style>
;;   </Pair>
;; </StyleMap>
;;
;; Description
;;
;; A <StyleMap> maps between two different Styles. Typically a
;; <StyleMap> element is used to provide separate normal and
;; highlighted styles for a placemark, so that the highlighted version
;; appears when the user mouses over the icon in Google Earth. 
;;
;; Elements Specific to StyleMap
;;
;; <Pair> (required)
;;     Defines a key/value pair that maps a mode (normal or highlight)
;;     to the predefined <styleUrl>. <Pair> contains two elements
;;     (both are required): 
;;
;;         * <key>, which identifies the key
;;         * <styleUrl> or <Style>, which references the style. In
;;         <styleUrl>, for referenced style elements that are local to
;;         the KML document, a simple # referencing is used. For
;;         styles that are contained in external files, use a full URL
;;         along with # referencing. For example: 
;;
;;     <Pair> 
;;       <key>normal</key> 
;;       <styleUrl>http://myserver.com/foo.xml#example</styleUrl> 
;;     </Pair> 
;;
;; Extends
;;     * <StyleSelector>
;;
;; Contained By
;;     * any <Feature>
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


pro kdm_kml_stylemap::KMLhead
  self->buildsource, '<StyleMap id="'+self.ID+'">'
end
pro kdm_kml_stylemap::KMLbody
  if self.normal ne '' then begin
     hash = (strmid(self.normal,0,1) eq '#') ? '' : '#'
     self->buildsource, '<Pair>'
     self->buildsource, self->xmlTag( 'key', 'normal' )
     self->buildsource, self->xmlTag( 'styleUrl', hash+self.normal )
     self->buildsource, '</Pair>'
  endif
  if self.highlight ne '' then begin
     hash = (strmid(self.highlight,0,1) eq '#') ? '' : '#'
     self->buildsource, '<Pair>'
     self->buildsource, self->xmlTag( 'key', 'highlight' )
     self->buildsource, self->xmlTag( 'styleUrl', hash+self.highlight )
     self->buildsource, '</Pair>'
  endif
end
pro kdm_kml_stylemap::KMLtail
  self->buildsource, '</StyleMap>'
end

function kdm_kml_stylemap::init, _EXTRA=e
  if self->kdm_kml_styleselector::init(_EXTRA=e) ne 1 then return, 0
  self->setProperty, _EXTRA=e
  return, 1
end
pro kdm_kml_stylemap::cleanup
  self->kdm_kml_styleselector::cleanup
end 
pro kdm_kml_stylemap__define, class
  class = { kdm_kml_stylemap, $
            inherits kdm_kml_styleselector, $
            normal: '', $
            highlight: '' }
end

