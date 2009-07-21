; $Id: doy.pro,v 1.2 2002/09/26 00:53:46 mankoff Exp $
; 
; $Author: mankoff $
; $Revisions$
; $Date: 2002/09/26 00:53:46 $
;
;+
; NAME:
;	DOY
;
; PURPOSE:
;       Print (or optionally return) the current UT DOY
;
; CATEGORY:
;       SNOE, date
;
; CALLING SEQUENCE:
;       DOY, today
;
; OPTIONAL OUTPUTS:
;       today: contains the day-of-year of today in London
;
; EXAMPLE:
;       To print the current doy:
;          IDL> DOY
;       To get the current doy in a variable:
;          IDL> DOY, var
;
; MODIFICATION HISTORY:
; 	Written by: KDM
;	2002-09-25: KDM; Added docs
;-

PRO doy, doy
cmd = 'date +%j'
spawn, cmd, out
IF ( n_params() EQ 0 ) THEN print, out[0]
doy = long( out[ 0 ] )
END

;
; $Log: doy.pro,v $
; Revision 1.2  2002/09/26 00:53:46  mankoff
; added docs
;
; Revision 1.1  2002/08/01 23:33:17  mankoff
; Initial revision
;
;
