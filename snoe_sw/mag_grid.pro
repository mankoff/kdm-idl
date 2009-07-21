; $Id: mag_grid.pro,v 1.7 2002/09/26 01:05:03 mankoff Exp $
;
; $Author: mankoff $
; $Revision: 1.7 $
; $Date: 2002/09/26 01:05:03 $
;
;+
; NAME:
;	MAG_GRID
;
; PURPOSE:
;       Return a magnetic grid warped to the current map projection,
;       that can be overlayed on an image.
;
; CATEGORY:
;       SNOE, image, mapping
;
; CALLING SEQUENCE:
;       result = mag_grid()
;
; INPUTS:
;       NONE
;
; OPTIONAL INPUTS:
;       NONE
;
; KEYWORD PARAMETERS:
;       HIRES:  Set this keword equal to one (1) to produce a high
;               quality grid. This may take some time (less than a
;               minute). The default is a low quality (but quick)
;               image
;
;       MAGTHICK: Set this to the line thickness desired.
;
;       OVAL:   Set this to the thickness desired for the auroral oval
;               grid lines (i.e. the 60 and 70 degree latitude lines)
;
;       LATDEL, LONDEL: See MAP_GRID documentation
;
; OUTPUTS:
;       This function returns a bytescaled image. The size is the size
;       of the current device. The array returned contains the value 1
;       where the field lines are, and 0 everywhere else.
;
; SIDE EFFECTS:
;       NONE known
;
; RESTRICTIONS:
;       Must call map_set before this function
;       Requires mag_grid.pro
;
; PROCEDURE:
;       This function warps a CGM magnetic lookup table (LUT) onto the
;       current map projection. Since our LUTs are at a 1 degree
;       resolution, the quality of the lines is poor. Hence the /HIRES
;       keyword. The algorithm is the same in this case, but the image
;       is created much larger (approx 20 times), and then shrunk
;       down. The result is a higher quality image.
;
; EXAMPLE:
;
;        ;;; set up and display the data
;        MAP_SET, 88.5, 277.5, /cyl, /iso
;        TV, MAP_IMAGE( data, xx, yy ), xx, yy
;        img = TVRD()
;
;        ;;; get the grid for the above map_set projection
;        grid0 = MAG_GRID()
;        grid1 = MAG_GRID( /HIRES, YEAR=2000, magthick=2, oval=4 )
;
;        ;;; overlay grid on image, and display
;        magGridColor = 255
;        img[ WHERE( grid1 EQ 1 ) ] = magGridColor
;        TV, img
;
; MODIFICATION HISTORY:
; 	Written by:	Ted Fisher, Summer 2000
;       Oct, 2001       TAF: made lots of misc usability improvements
;       Oct, 2001       KDM: added documentation, removed xysize
;       Jul, 2002       KDM: Removed YEAR keyword. LOAD_CGM has
;                            own. Uses _EXTRA=e
;
;-

FUNCTION mag_grid, hires=hires, magthick=magthick, $
                   oval=oval, kfactor=kfactor, latdel=latdel, $
                   londel=londel, _EXTRA=e

mGridColor = 1
disp = !d.name

IF ( NOT keyword_set( magthick ) ) THEN magthick = 1
IF ( n_elements( latdel ) EQ 0 ) THEN latdel = 10
IF ( n_elements( londel ) EQ 0 ) THEN londel = 30

IF ( disp EQ 'X' ) THEN BEGIN
    xsize = !d.x_size
    ysize = !d.y_size
ENDIF ELSE IF ( disp EQ 'Z' ) THEN BEGIN
    saved_z =  tvrd()           ; store the current image in the z buffer
    xsize = (size(saved_z,/dim))[0]
    ysize = (size(saved_z,/dim))[1]
ENDIF ELSE IF ( disp EQ 'PS' ) THEN BEGIN 
            ;;; convert from m^-5 to pixels
    xsize = floor(float(!d.x_size) / 28.)
    ysize = floor(float(!d.y_size) / 28.)
ENDIF

;;; set up the z buffer
set_plot,'z'                    
    
; a scaling factor to get smoother lines
IF ( keyword_set( kfactor ) ) THEN BEGIN
    k = kfactor
ENDIF ELSE IF ( keyword_set ( hires ) ) THEN BEGIN
    k = 20                
ENDIF ELSE BEGIN 
    k = 3
ENDELSE 

device,set_resolution=[361*k,181*k]
erase

load_cgm, mag, grid='mag'
mag = reform(temporary(mag), 65341, 6)
    
; lat and lon separation
n = latdel
m = londel

dummy = 999.99
    
glat = mag[*,0]
glon = mag[*,1]
mlat = mag[*,2]
mlon = mag[*,3]  

                                ; set the parallels
FOR i=-90, 90, n DO BEGIN
    index = where((mlat EQ i)     AND $
                  (   i NE 0)     AND $
                  (glat LT dummy) AND $
                  (glon LT dummy), count)
    IF(count GT 0) THEN BEGIN
        lattemp = glat[index]
        lontemp = glon[index]
        
        plots, fix(lontemp[0]*k), fix((lattemp[0]+90)*k), $
               color=mGridColor, /device, _EXTRA=e,thick=magthick*k
        
        FOR j=1., count-1 DO BEGIN
            
            IF ( keyword_set( oval ) AND (i EQ -70 OR $
                                          i EQ -60 OR $
                                          i EQ  60 OR $
                                          i EQ  70)) THEN BEGIN
                thickness = oval*k
            ENDIF ELSE BEGIN 
                thickness = magthick*k
            ENDELSE
            
            IF ( abs( lontemp[j] - lontemp[j-1] ) GT 90 ) THEN BEGIN
                
                a = [fix(lontemp[j-1]*k), fix((lattemp[j-1]+90)*k)]
                d = [fix(lontemp[j]*k),   fix((lattemp[j]+90)*k)]
                
                c = [0,     (a[1]+d[1])/2]
                b = [361*k-1, (a[1]+d[1])/2]
                
                plots, [[a],[b]], $
                       color=mGridColor, /device, _EXTRA=e, $
                       thick=thickness
                plots, [[c],[d]], $
                       color=mGridColor, /device, _EXTRA=e, $
                       thick=thickness
                
            ENDIF ELSE BEGIN
                plots, fix(lontemp[j]*k), $
                       fix((lattemp[j]+90)*k), $
                       /CONTINUE, color=mGridColor, /device,      $
                       _EXTRA=e, thick=thickness   
            ENDELSE
        ENDFOR 
    ENDIF 
ENDFOR 

lat_toler = 5   ; tolerance to get around the poorly defined cgm equator

; set the meridians
FOR i = 0, 361, m DO BEGIN
    index = where((mlon EQ i)                                    AND $
                  ((mlat GT lat_toler) OR (mlat LT -lat_toler))  AND $
                  (glat LT dummy)                                AND $
                  (glon LT dummy), count) 
    
    IF ( count GT 0 ) THEN BEGIN
        lattemp = glat[index]
        lontemp = glon[index]
        
        plots, fix(lontemp[0]*k), fix((lattemp[0]+90)*k), $
               color=mGridColor, /device, _EXTRA=e, thick=magthick*k
        
        FOR j = 1., count-1 DO BEGIN 
            IF ( abs( lontemp[j] - lontemp[j-1] ) GT 90 ) THEN BEGIN
                
                a = [fix(lontemp[j-1]*k), fix((lattemp[j-1]+90)*k)]
                d = [fix(lontemp[j]*k),   fix((lattemp[j]+90)*k)]
                
                b = [0,     (a[1]+d[1])/2]
                c = [361*k-1, (a[1]+d[1])/2]
                
                plots, [[a],[b]], $
                       color=mGridColor, /device, _EXTRA=e, $
                       thick=magthick*k
                plots, [[c],[d]], $
                       color=mGridColor, /device, _EXTRA=e, $
                       thick=magthick*k
            ENDIF ELSE BEGIN 
                plots, fix(lontemp[j]*k), $
                       fix((lattemp[j]+90)*k), $   
                       /CONTINUE, color=mGridColor, /device,      $   
                       _EXTRA=e, thick=magthick*k
            ENDELSE 
        ENDFOR 
    ENDIF 
ENDFOR 

cgm_temp = tvrd()
device, set_resolution=[xsize, ysize]
erase
tv, map_image(cgm_temp, xx, yy, lonmin=0, lonmax=360, /compress), xx, yy
cgm_temp = tvrd()

; display cleanup and restoration
set_plot, disp                
IF ( disp EQ 'Z' ) THEN BEGIN 
    size = size( saved_z, /dim )
    xs = size[ 0 ] & ys = size[ 1 ]
    device, set_resolution=[ xs, ys ]
    erase
    tv, saved_z
ENDIF 
RETURN, CGM_TEMP
END                             ; mag_grid

;
; $Log: mag_grid.pro,v $
; Revision 1.7  2002/09/26 01:05:03  mankoff
; added - to close IDL comment
;
; Revision 1.6  2002/07/24 02:19:05  mankoff
; Removed YEAR keyword (LOAD_CGM has its own, use _EXTRA=e)
; Added documentation
;
;
