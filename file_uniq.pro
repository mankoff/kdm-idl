
FUNCTION FILE_UNIQ

;+
; NAME:
;	FILE_UNIQ
;
; PURPOSE:
;       Returns a uniq filename, based upon the procedure the use ran.
;
; CATEGORY:
;       SNOE, File
;
; CALLING SEQUENCE:
;       Result = FILE_UNIQ()
;
; OUTPUTS:
;       A string, usabel as a filename, uniq to the current
;       directory. This is the FIRST part of a filename (before the
;       period). But it is unique anyways, regardless of the extension
;       you should choose to add on. 
;
; RESTRICTIONS:
;       Whatever restrictions are imposed by FINDFILE (presumably,
;       read access is required in the current directory)
;
; PROCEDURE:
;       Generate a UNIQ filename based upon the procedure that the
;       user typed at the command line, regardless of how many other
;       procedures were called before this one.
;
;       Use the Procedure stack to find the TOP procedure. Generate a
;       name based on it. Append a _XXXX four digit number to the
;       name. Then, search for that file (with a .*) in the current
;       directory.
;
; EXAMPLE:
;       From the command line, to generate a unique filename, type:
;           print, FILE_UNIQ() 
;       This string is usable and unique with ANY extension.
;
;       Call this procedure from inside some other procedures like
;       this:
;           SET_PLOT, 'ps'
;           DEVICE, /COLOR, BITS=8, FILENAME=file_uniq()+'.ps'
;       To generate a unique postscript filename.
;
;       Here is the real beauty of this procedure: If the user runs
;       "L4_lat_alt_disp" and this is called somewhere in it or one of
;       its subroutines, the filename will start with
;       L4_LAT_ALT_DISP_0000.ps, and then 0001.ps, etc... If the user
;       runs it from a different procedure, it will have a different name.
;
; MODIFICATION HISTORY:
; 	Written by: KDM; 2002-08-29
;   2002-09-01; KDM; Changed help call to use CALLS rather than /TRACEBACK
;   2010-05-14; KDM; Improved to detect folders not just files.
;
;-

;;; get the calling stack of PROCs and FCNs
help, calls=stack

;;; get the name of the bottom (the one the USER called)
tlc = stack[ n_elements( stack )-2 ] ; Top Level Call
name = (STRSPLIT( tlc, /EXTRACT ))[0]
if ( name EQ 'FILE_UNIQ' ) then pre = 'IDL_' ELSE pre = name + '_'
pre = STRLOWCASE( pre )

n = -1
WHILE 1 DO BEGIN
    n = n + 1
    file = pre + STRING( n, FORMAT='(I4.4)', /PRINT )
    f = findfile( file+'.*', count=count )
    if count eq 0 then break
    if n gt 9999 then MESSAGE, "Can't find unique file"
ENDWHILE
return, file

END

