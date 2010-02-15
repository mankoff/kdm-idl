;+
;
; $Id$
;
; NAME:
;	WIN2
;
; PURPOSE:
;   This is a replacement for the WINDOW procedure. It brings up a
;   window in my 2nd monitor, completely filling the monitor.
;
; CATEGORY:
;   Imaging
;
; CALLING SEQUENCE:
;   WIN2, Window_Index
;
; INPUTS:
;   See WINDOW
;
; OPTIONAL INPUTS:
;   See WINDOW
;	
; KEYWORD PARAMETERS:
;   See WINDOW
;
; SIDE EFFECTS:
;   See WINDOW
;
; RESTRICTIONS:
;   See WINDOW
;
; PROCEDURE:
;   Call WINDOW, but default the size and position to fill the 2nd monitor.
;
; MODIFICATION HISTORY:
; 	Written by:	Ken Mankoff. 2005-01-10
;               2010-02-02: Update for new monitor
;
; TODO:
;   Return focus to the calling window (currently, the window is created,
;   and focus (keyboard events) stay in the window. It should return to
;   the calling xterm/emacs session.
;
;-

pro win2, Window_Index, _EXTRA=e

if ( n_elements( Window_Index ) eq 0 ) then Window_Index = 0
window, Window_Index, xsize=1920, ysize=1200, xpos=1920, ypos=454, _EXTRA=e

end

