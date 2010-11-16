;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;; This object encapsulates the Style
;; http://code.google.com/apis/kml/documentation/kmlreference.html#feature
;; 
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;; <Feature>
;; Syntax
;; <!-- abstract element; do not create -->
;; <!-- Feature id="ID" -->                <!-- Document,Folder,
;;                                              NetworkLink,Placemark,
;;                                              GroundOverlay,PhotoOverlay,ScreenOverlay -->
;;   <name>...</name>                      <!-- string -->
;;   <visibility>1</visibility>            <!-- boolean -->
;;   <open>0</open>                        <!-- boolean -->
;;   <atom:author>...<atom:author>         <!-- xmlns:atom -->
;;   <atom:link>...</atom:link>            <!-- xmlns:atom -->
;;   <address>...</address>                <!-- string -->
;;   <xal:AddressDetails>...</xal:AddressDetails>  <!-- xmlns:xal -->
;;   <phoneNumber>...</phoneNumber>        <!-- string -->
;;   <Snippet maxLines="2">...</Snippet>   <!-- string -->
;;   <description>...</description>        <!-- string -->
;;   <AbstractView>...</AbstractView>      <!-- Camera or LookAt -->
;;   <TimePrimitive>...</TimePrimitive>    <!-- TimeStamp or TimeSpan -->
;;   <styleUrl>...</styleUrl>              <!-- anyURI -->
;;   <StyleSelector>...</StyleSelector>
;;   <Region>...</Region>
;;   <Metadata>...</Metadata>              <!-- deprecated in KML 2.2 -->
;;   <ExtendedData>...</ExtendedData>      <!-- new in KML 2.2 -->
;; <-- /Feature -->
;;
;; Description
;; This is an abstract element and cannot be used directly in a
;; KML file. The following diagram shows how some of a
;; Feature's elements appear in Google Earth. 
;; Elements Specific to Feature
;;
;; <name>
;;     User-defined text displayed in the 3D viewer as the label for
;;     the object (for example, for a Placemark, Folder, or
;;     NetworkLink).  
;; <visibility>
;;     Boolean value. Specifies whether the feature is drawn in the 3D
;;     viewer when it is initially loaded. In order for a feature to
;;     be visible, the <visibility> tag of all its ancestors must also
;;     be set to 1. In the Google Earth List View, each Feature has a
;;     checkbox that allows the user to control visibility of the
;;     Feature. 
;; <open>
;;     Boolean value. Specifies whether a Document or Folder appears
;;     closed or open when first loaded into the Places
;;     panel. 0=collapsed (the default), 1=expanded. See also
;;     <ListStyle>. This element applies only to Document, Folder, and
;;     NetworkLink.  
;; <atom:author>
;;     KML 2.2 supports new elements for including data about the
;;     author and related website in your KML file. This information
;;     is displayed in geo search results, both in Earth browsers such
;;     as Google Earth, and in other applications such as Google
;;     Maps. The ascription elements used in KML are as follows: 
;;         * atom:author element - parent element for atom:name
;;         * atom:name element - the name of the author
;;         * atom:link element - contains the href attribute
;;         * href attribute - URL of the web page containing the KML/KMZ file
;;     These elements are defined in the Atom Syndication Format. The
;;     complete specification is found at http://atompub.org. (see the
;;     sample that follows). 
;;     The <atom:author> element is the parent element for
;;     <atom:name>, which specifies the author of the KML feature. 
;; <atom:link href="..." >
;;     Specifies the URL of the website containing this KML or KMZ
;;     file. Be sure to include the namespace for this element in any
;;     KML file that uses it: xmlns:atom="http://www.w3.org/2005/Atom"
;;     (see the sample that follows). 
;; <address>
;;     A string value representing an unstructured address written as
;;     a standard street, city, state address, and/or as a postal
;;     code. You can use the <address> tag to specify the location of
;;     a point instead of using latitude and longitude
;;     coordinates. (However, if a <Point> is provided, it takes
;;     precedence over the <address>.) To find out which locales are
;;     supported for this tag in Google Earth, go to the Google Maps
;;     Help.  
;; <xal:AddressDetails>
;;     A structured address, formatted as xAL, or eXtensible Address
;;     Language, an international standard for address
;;     formatting. <xal:AddressDetails> is used by KML for geocoding
;;     in Google Maps only. For details, see the Google Maps API
;;     documentation. Currently, Google Earth does not use this
;;     element; use <address> instead. Be sure to include the
;;     namespace for this element in any KML file that uses it:
;;     xmlns:xal="urn:oasis:names:tc:ciq:xsdschema:xAL:2.0" 
;; <phoneNumber>
;;     A string value representing a telephone number. This element is
;;     used by Google Maps Mobile only. The industry standard for
;;     Java-enabled cellular phones is RFC2806. 
;;     For more information, see http://www.ietf.org/rfc /rfc2806.txt. 
;; <Snippet maxLines="2" >
;;     A short description of the feature. In Google Earth,
;;     this description is displayed in the Places panel under
;;     the name of the feature. If a Snippet is not supplied,
;;     the first two lines of the <description> are used. In
;;     Google Earth, if a Placemark contains both a description
;;     and a Snippet, the <Snippet> appears beneath the
;;     Placemark in the Places panel, and the <description>
;;     appears in the Placemark's description balloon. This tag
;;     does not support HTML markup. <Snippet> has a maxLines
;;     attribute, an integer that specifies the maximum number
;;     of lines to display.  
;; <description>
;;     User-supplied content that appears in the description balloon.
;;
;;     The supported content for the <description> element changed
;;     from Google Earth 4.3 to 5.0. Specific information for each
;;     version is listed out below, followed by information common to
;;     both. 
;;
;;     KDM Note: See
;;     http://code.google.com/apis/kml/documentation/kmlreference.html#feature 
;;     for documentation on this section.
;;
;;     Google Earth 5.0
;;     ...
;;     Google Earth 4.3
;;     ...
;;
;;     Common information
;; 
;;     If your description contains no HTML markup, Google Earth
;;     attempts to format it, replacing newlines with <br> and
;;     wrapping URLs with anchor tags. A valid URL string for the
;;     World Wide Web is automatically converted to a hyperlink to
;;     that URL (e.g., http://www.google.com). Consequently, you do
;;     not need to surround a URL with the <a href="http://.."></a>
;;     tags in order to achieve a simple link.   
;;
;;     When using HTML to create a hyperlink around a specific word,
;;     or when including images in the HTML, you must use HTML entity
;;     references or the CDATA element to escape angle brackets,
;;     apostrophes, and other special characters. The CDATA element
;;     tells the XML parser to ignore special characters used within
;;     the brackets. This element takes the form of: 
;;
;;     <![CDATA[
;;       special characters here
;;     ]]> 
;;
;;     If you prefer not to use the CDATA element, you can use entity
;;     references to replace all the special characters. 
;;
;;     <description>
;;       <![CDATA[
;;     This is an image 
;;     <img src="icon.jpg"> 
;;     and we have a link http://www.google.com.
;;       ]]>
;;     </description>
;;
;;     Other Behavior Specified Through Use of the <a> Element
;;     KML supports the use of two attributes within the <a> element:
;;     href and type. 
;;
;;     The anchor element <a> contains an href attribute that specifies a URL.
;;
;;     If the href is a KML file and has a .kml or .kmz file
;;     extension, Google Earth loads that file directly when the user
;;     clicks it. If the URL ends with an extension not known to
;;     Google Earth (for example, .html), the URL is sent to the
;;     browser. 
;;
;;     The href can be a fragment URL (that is, a URL with a # sign
;;     followed by a KML identifier). When the user clicks a link that
;;     includes a fragment URL, by default the browser flies to the
;;     Feature whose ID matches the fragment. If the Feature has a
;;     LookAt or Camera element, the Feature is viewed from the
;;     specified viewpoint. 
;;
;;     The behavior can be further specified by appending one of the
;;     following three strings to the fragment URL: 
;;         * ;flyto (default) - fly to the Feature
;;         * ;balloon - open the Feature's balloon but do not fly to the Feature
;;         * ;balloonFlyto - open the Feature's balloon and fly to the Feature
;;
;;     For example, the following code indicates to open the file
;;     CraftsFairs.kml, fly to the Placemark whose ID is
;;     "Albuquerque," and open its balloon: 
;;
;;     <description>
;;       <![CDATA[ 
;;         <a href="http://myServer.com/CraftsFairs.kml#Albuquerque;balloonFlyto">
;;           One of the Best Art Shows in the West</a>
;;       ]]>
;;     </description> 
;;
;;     The type attribute is used within the <a> element when the href
;;     does not end in .kml or .kmz, but the reference needs to be
;;     interpreted in the context of KML. Specify the following: 
;;
;;     type="application/vnd.google-earth.kml+xml" 
;;
;;     For example, the following URL uses the type attribute to
;;     notify Google Earth that it should attempt to load the file,
;;     even though the file extension is .php: 
;;
;;     <a href="myserver.com/cgi-bin/generate-kml.php#placemark123"
;;        type="application/vnd.google-earth.kml+xml">
;;
;; <AbstractView>
;;     Defines a viewpoint associated with any element derived from
;;     Feature. See <Camera> and <LookAt>.  
;; <TimePrimitive>
;;     Associates this Feature with a period of time (<TimeSpan>) or a
;;     point in time (<TimeStamp>).  
;; <styleUrl>
;;     URL of a <Style> or <StyleMap> defined in a Document. If the
;;     style is in the same file, use a # reference. If the style is
;;     defined in an external file, use a full URL along with #
;;     referencing. Examples are 
;;
;;     <styleUrl>#myIconStyleID</styleUrl>
;;     <styleUrl>http://someserver.com/somestylefile.xml#restaurant</styleUrl>
;;     <styleUrl>eateries.kml#my-lunch-spot</styleUrl>
;;
;; <StyleSelector>
;;     One or more Styles and StyleMaps can be defined to customize
;;     the appearance of any element derived from Feature or of the
;;     Geometry in a Placemark. (See <BalloonStyle>, <ListStyle>,
;;     <StyleSelector>, and the styles derived from <ColorStyle>.) A
;;     style defined within a Feature is called an "inline style" and
;;     applies only to the Feature that contains it. A style defined
;;     as the child of a <Document> is called a "shared style." A
;;     shared style must have an id defined for it. This id is
;;     referenced by one or more Features within the <Document>. In
;;     cases where a style element is defined both in a shared style
;;     and in an inline style for a Feature—that is, a Folder,
;;     GroundOverlay, NetworkLink, Placemark, or ScreenOverlay—the
;;     value for the Feature's inline style takes precedence over the
;;     value for the shared style.  
;; <Region>
;;     Features and geometry associated with a Region are drawn only
;;     when the Region is active. See <Region>.  
;; <Metadata> (deprecated in KML 2.2; use <ExtendedData> instead) 
;; <ExtendedData>
;;     Allows you to add custom data to a KML file. This data can be
;;     (1) data that references an external XML schema, (2) untyped
;;     data/value pairs, or (3) typed data. A given KML Feature can
;;     contain a combination of these types of custom data.  
;;
;; Sample Use of HTML Elements within a Description
;;
;; KDM Note: I cut this section.
;;
;; Extends
;;     * <Object>
;;
;; Extended By
;;     * <Container>
;;     * <Overlay>
;;     * <Placemark>
;;     * <NetworkLink>
;;     * <gx:Tour>
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

pro kdm_kml_feature::KMLhead
  ;;self->buildsource, '<!-- Feature id="'+self.ID+'" -->'
end
pro kdm_kml_feature::KMLbody
  if self.name ne '' then self->buildsource, self->xmlTag("name",self.name)
  self->buildsource, self->xmlTag( "visibility", self.visibility*1 )
  self->buildsource, self->xmlTag( "open", self.open*1 )
  if self.description ne '' then self->buildsource, self->xmlTag( "description", self.description )
  if self.styleURL ne '' then self->buildsource, self->xmlTag( "styleUrl",self.styleURL )
  if self.snippet eq '' then self->buildsource, '<Snippet maxLines="0"></Snippet>' else begin
     sml = self.snipmaxlines eq 0 ? 2 : self.snipmaxlines
     self->buildsource, '<Snippet maxLines="'+STRTRIM(sml,2)+'">'+self.snippet+'</Snippet>'
  endelse
end
pro kdm_kml_feature::KMLtail
  ;;self->buildsource, '<!-- /Feature -->'
end

function kdm_kml_feature::init, _EXTRA=e
  if self->kdm_kml_object::init(_EXTRA=e) ne 1 then return, 0
  self->setProperty, _EXTRA=e
  return, 1
end
pro kdm_kml_feature::cleanup
  self->kdm_kml_object::cleanup
end 
pro kdm_kml_feature__define, class
  class = { kdm_kml_feature, $
            inherits kdm_kml_object, $
            name: '', $
            visibility: 0, $
            open: 0, $
            Snippet: '', $
            snipmaxlines: 0, $
            description: '', $
            ;; abstractview
            ;; timeprimitive, $
            styleURL: '' $
            ;;styleSelector, $
            ;; region
            ;; extendeddata
            
          }
end

;; o = obj_new('kdm_kml_feature', id='featID', name='TheFeature', description='My Description')
;; o->saveKML
;; end
