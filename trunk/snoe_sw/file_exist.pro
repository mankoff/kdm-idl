; $Id: file_exist.pro,v 1.1 2002/09/26 00:56:41 mankoff Exp $
;
; $Author: mankoff $
; $Revision: 1.1 $
; $Date: 2002/09/26 00:56:41 $
;
;+
; NAME:
;	FILE_EXIST
;
; PURPOSE:
;       This function returns true if the requested file exists
;
; CATEGORY:
;       SNOE, file, I/O
;
; CALLING SEQUENCE:
;       Result = FILE_EXIST( aFileName )
;
; INPUTS:
;       aFileName: A file name (with directory path)
;
; OUTPUTS:
;       1 if the file exists, 0 if it does not
;
; RESTRICTIONS:
;       No wildcards (*?)
;
; EXAMPLE:
;       if ( file_exist( 'foo.pro' ) ) then print, "foo exists!"
;
; MODIFICATION HISTORY:
; 	Written by: KDM; 2002-07-20
;	2002-09-25: KDM; added docs
;-

function file_exist,file
openr,lun,file,error=error,/get_lun
if error eq 0 then free_lun,lun
return,(error eq 0)
end

; $Log: file_exist.pro,v $
; Revision 1.1  2002/09/26 00:56:41  mankoff
; Initial revision
;
;

