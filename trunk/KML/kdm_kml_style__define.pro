
;; This object encapsulates the Style
;; http://code.google.com/apis/kml/documentation/kmlreference.html#style
;; 
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;; <Style>
;; Syntax
;;
;; <Style id="ID">
;; <!-- extends StyleSelector -->
;;
;; <!-- specific to Style -->
;;   <IconStyle>...</IconStyle>
;;   <LabelStyle>...</LabelStyle>
;;   <LineStyle>...</LineStyle>
;;   <PolyStyle>...</PolyStyle>
;;   <BalloonStyle>...</BalloonStyle>
;;   <ListStyle>...</ListStyle>
;; </Style>
;;
;; Description
;;
;; A Style defines an addressable style group that can be referenced
;;by StyleMaps and Features. Styles affect how Geometry is presented
;;in the 3D viewer and how Features appear in the Places panel of the
;;List view. Shared styles are collected in a <Document> and must have
;;an id defined for them so that they can be referenced by the
;;individual Features that use them. 
;;
;; Use an id to refer to the style from a <styleUrl>.
;;
;; Extends
;;     * <StyleSelector>
;;
;; Contained By
;;     * any <Feature>
;;
;; Elements Specific to Style
;;     * <BalloonStyle>
;;     * <IconStyle>
;;     * <LabelStyle>
;;     * <LineStyle>
;;     * <ListStyle>
;;     * <PolyStyle>
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


pro kdm_kml_style::KMLhead
  self->buildsource, '<Style id="'+self.ID+'">'
end
pro kdm_kml_style::KMLbody
  ;;
end
pro kdm_kml_style::KMLtail
  self->buildsource, '</Style>'
end

function kdm_kml_style::init, _EXTRA=e
  if self->kdm_kml_styleselector::init(_EXTRA=e) ne 1 then return, 0
  self->setProperty, _EXTRA=e
  return, 1
end
pro kdm_kml_style::cleanup
  self->kdm_kml_styleselector::cleanup
end 
pro kdm_kml_style__define, class
  class = { kdm_kml_style, $
            inherits kdm_kml_styleselector }
end

