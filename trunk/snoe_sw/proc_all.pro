;;; $Id: proc_all.pro,v 1.2 2002/09/21 01:10:03 mankoff Exp $
;;;
;;; $Author: mankoff $
;;; $Revision: 1.2 $
;;; $Date: 2002/09/21 01:10:03 $

;;; PURPOSE: Process a day (or days) through all levels

;;; the WHILE() statements below are because we have to wait for the
;;; files to finish gzipping (they then are named '.dat.gz') otherwise
;;; the programs will crash when reading in the files...

pro proc_all, yyyyddd0, yyyyddd1

if ( n_elements( yyyyddd1 ) eq 0 ) then yyyyddd1 = yyyyddd0
dom0 = SNOE_DATE( yyyyddd0, /from_yyyyddd, /to_dom )
dom1 = SNOE_DATE( yyyyddd1, /from_yyyyddd, /to_dom )
FOR i = dom0, dom1 DO BEGIN

    today = SNOE_DATE( i, /from_dom, /to_yyyyddd )

    cd, !SNOE.p.uvs+'level1'
    proc_level1, today
    
    cd, !SNOE.p.uvs+'level2'
    WHILE ( file_exist( !SNOE.p.uvs+'level1/data/*.dat') ) DO wait, 2
    proc_level2, today
    
    cd, !SNOE.p.uvs+'level3'
    WHILE ( file_exist( !SNOE.p.uvs+'level2/data/*.dat') ) DO wait, 2
    proc_level3, today
    
    cd, !SNOE.p.uvs+'level4'
    proc_level4, today
    
ENDFOR
return
end

;
; $Log: proc_all.pro,v $
; Revision 1.2  2002/09/21 01:10:03  mankoff
; now handles only one day input
;
; Revision 1.1  2002/09/20 23:56:58  mankoff
; Initial revision
;
