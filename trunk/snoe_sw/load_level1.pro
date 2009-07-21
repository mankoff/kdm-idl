; $Id: load_level1.pro,v 1.2 2002/09/19 03:42:10 mankoff Exp $

PRO load_level1, yyyyddd, ch1, ch2

ymd = SNOE_DATE( yyyyddd, /from_yyyyddd, /to_ymd )
doy = SNOE_DATE( yyyyddd, /from_yyyyddd, /to_doy )

;;; build the file names
dir = !SNOE.p.uvs+'level1/data/'
fname = STRTRIM( ymd[0],2 ) + '_' + STRING( doy, /PRINT, FORMAT='(I3.3)' )
f1 = dir+fname+'_1.dat.gz'
f2 = dir+fname+'_2.dat.gz'
IF ( file_exist( f1 ) ) THEN BEGIN ; data exists in both channels or in none
    ;;; open the files
    openr, lun1, f1, /compress, /get_lun
    openr, lun2, f2, /compress, /get_lun
    ch1 = assoc( lun1, FLTARR( 500, 90, 16 ) )
    ch2 = assoc( lun2, FLTARR( 500, 90, 16 ) )
   
    ch1 = ch1[0]
    ch2 = ch2[0] 
    free_lun, lun1, lun2
ENDIF ELSE BEGIN
    ch1 = FLTARR( 500, 90, 16 )
    ch2 = FLTARR( 500, 90, 16 )
ENDELSE
RETURN
END

;
; $Log: load_level1.pro,v $
; Revision 1.2  2002/09/19 03:42:10  mankoff
; Added RCS vars
;
