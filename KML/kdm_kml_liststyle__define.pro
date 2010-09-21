
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;; This object encapsulates the ListStyle
;; http://code.google.com/apis/kml/documentation/kmlreference.html#liststyle
;; 
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;; <ListStyle>
;; Syntax
;;
;; <ListStyle id="ID">
;;   <!-- specific to ListStyle -->
;;   <listItemType>check</listItemType> <!-- kml:listItemTypeEnum:check,
;;                                           checkOffOnly,checkHideChildren,
;;                                          radioFolder -->
;;   <bgColor>ffffffff</bgColor>        <!-- kml:color -->
;;   <ItemIcon>                         <!-- 0 or more ItemIcon elements -->
;;     <state>open</state>   
;;       <!-- kml:itemIconModeEnum:open, closed, error, fetching0, fetching1, or fetching2 -->
;;     <href>...</href>                 <!-- anyURI -->
;;   </ItemIcon>
;; </ListStyle>
;;
;; Description
;; Specifies how a Feature is displayed in the list view. The list
;; view is a hierarchy of containers and children; in Google Earth,
;; this is the Places panel. 
;;
;; Elements Specific to ListStyle
;; <listItemType>
;;     Specifies how a Feature is displayed in the list view. Possible
;;     values are: 
;;         * check (default) - The Feature's visibility is tied to its
;;         item's checkbox. 
;;         * radioFolder - When specified for a Container, only
;;         one of the Container's items is visible at a time 
;;         * checkOffOnly - When specified for a Container or Network
;;         Link, prevents all items from being made visible at
;;         once—that is, the user can turn everything in the Container
;;         or Network Link off but cannot turn everything on at the
;;         same time. This setting is useful for Containers or Network
;;         Links containing large amounts of data. 
;;         * checkHideChildren - Use a normal checkbox for
;;         visibility but do not display the Container or
;;         Network Link's children in the list view. A checkbox
;;         allows the user to toggle visibility of the child
;;         objects in the viewer. 
;;
;; <bgColor>
;;     Background color for the Snippet. Color and opacity values are
;;     expressed in hexadecimal notation. The range of values for any
;;     one color is 0 to 255 (00 to ff). For alpha, 00 is fully
;;     transparent and ff is fully opaque. The order of expression is
;;     aabbggrr, where aa=alpha (00 to ff); bb=blue (00 to ff);
;;     gg=green (00 to ff); rr=red (00 to ff). For example, if you
;;     want to apply a blue color with 50 percent opacity to an
;;     overlay, you would specify the following:
;;     <color>7fff0000</color>, where alpha=0x7f, blue=0xff,
;;     green=0x00, and red=0x00. 
;; <ItemIcon>
;;     Icon used in the List view that reflects the state of a Folder
;;     or Link fetch. Icons associated with the open and closed modes
;;     are used for Folders and Network Links. Icons associated with
;;     the error and fetching0, fetching1, and fetching2 modes are
;;     used for Network Links. The following screen capture
;;     illustrates the Google Earth icons for these states:  
;;
;;     <state>
;;         Specifies the current state of the NetworkLink or
;;         Folder. Possible values are open, closed, error, fetching0,
;;         fetching1, and fetching2. These values can be combined by
;;         inserting a space between two values (no comma).  
;;     <href>
;;         Specifies the URI of the image used in the List View for
;;         the Feature.  
;;
;; Extends
;;     * <Object>
;;
;; Contained By
;;     * <Style> 
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


pro kdm_kml_liststyle::KMLhead
  self->buildsource, '<ListStyle id="'+self.ID+'">'
end
pro kdm_kml_liststyle::KMLbody
  if self.listItemType ne '' then self->buildsource, self->xmlTag( 'listItemType', self.listItemType )
  if self.bgColor ne '' then self->buildsource, self->xmlTag( 'bgColor', self.bgColor )
  if self.itemIcon ne '' then begin
     self->buildsource, '<ItemIcon>'
     self->buildsource, self->xmlTag( 'href', self.itemIcon )
     if self.state ne '' then self->buildsource, self->xmlTag( 'state', self.state )
     self->buildsource, '</ItemIcon>'
  endif
end
pro kdm_kml_liststyle::KMLtail
  self->buildsource, '</ListStyle>'
end

function kdm_kml_liststyle::init, _EXTRA=e
  if self->kdm_kml_object::init(_EXTRA=e) ne 1 then return, 0
  self->setProperty, _EXTRA=e
  return, 1
end
pro kdm_kml_liststyle::cleanup
  self->kdm_kml_object::cleanup
end 
pro kdm_kml_liststyle__define, class
  class = { kdm_kml_liststyle, $
            inherits kdm_kml_object, $
            listItemType: '', $
            bgcolor: '', $
            state: '', $
            itemIcon: '' }
end

