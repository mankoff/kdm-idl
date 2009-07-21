; $Id: reprocess.pro,v 1.3 2002/09/22 01:19:57 mankoff Exp $
;
; $Author: mankoff $
; $Revision: 1.3 $
; $Date: 2002/09/22 01:19:57 $
;

;;; Run this code in any UVS levelX/ directory to reprocess the data

;.com proc_level1 proc_level2 proc_level3 proc_level4

cd, current=dir
dirs = STRSPLIT( dir, '/', /extract )
level = dirs[ n_elements( dirs )-1 ]


d0 = 1998070
d1 = SNOE_DATE( /from_today, /to_yyyyddd )

cmd = 'proc_' + level + ', ' + STRTRIM(d0,2) + ',' + STRTRIM(d1,2)
print, "running: " + cmd
dummy = execute( cmd )

;
; $Log: reprocess.pro,v $
; Revision 1.3  2002/09/22 01:19:57  mankoff
; Fixed the fix w/ CD. Haha.
;
; Revision 1.2  2002/09/21 23:53:11  mankoff
; I was using 'cd' incorrectly. Fixed.
;
; Revision 1.1  2002/09/21 00:43:46  mankoff
; Initial revision
;
