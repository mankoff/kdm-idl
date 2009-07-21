; $Id: plot_clear.pro,v 1.2 2002/09/26 01:07:00 mankoff Exp $
;
; $Author: mankoff $
; $Revision: 1.2 $
; $Date: 2002/09/26 01:07:00 $
;
;+
; NAME:
;	PLOT_CLEAR
;
; PURPOSE:
;       Reset system plotting variables
;
; CATEGORY:
;       Plotting
;
; CALLING SEQUENCE:
;       PLOT_CLEAR
;
; SIDE EFFECTS:
;       Resets system plotting variables
;
; MODIFICATION HISTORY:
; 	Written by: KDM; 1998-ish
;	2002-09-25: KDM; Added documentation
;
;-

PRO plot_clear

!x.style = 0
!y.style = 0
!z.style = 0
!x.ticks = 0
!y.ticks = 0
!z.ticks = 0
!x.range = 0
!y.range = 0
!z.range = 0
!x.thick = 1
!y.thick = 1
!z.thick = 1
!p.thick = 1
!p.charthick = 1
!p.title = ''
!p.subtitle = ''

!x.title = ''
!y.title = ''
!z.title = ''

!x.charsize = 1
!y.charsize = 1
!z.charsize = 1
!p.charsize = 1
!p.linestyle = 0
!p.psym = 0
!x.minor = 0
!y.minor = 0
!x.ticklen = .02
!y.ticklen = .02
!p.ticklen = .02
!p.multi = 0
!x.gridstyle = 0
!y.gridstyle = 0
!z.gridstyle = 0
!x.margin = [10,3]
!y.margin = [4,2]

!x.tickv = 0
!y.tickv = 0
!z.tickv = 0

!x.tickname=''
!y.tickname=''
!z.tickname=''

!p.position = 0

return
end

;
; $Log: plot_clear.pro,v $
; Revision 1.2  2002/09/26 01:07:00  mankoff
; added docs
;

