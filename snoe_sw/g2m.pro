; $Id$
;
; $Author$
; $Revision$
; $Date$
;
;+
; NAME:
;	G2M
;
; PURPOSE:
;       Translate from geographic to magnetic (CGM) coordinates
;
; CATEGORY:
;       SNOE, coordinates
;
; CALLING SEQUENCE:
;       G2M, Glat, Glon, Year, Mlat, Mlon
;
; INPUTS:
;       Glat:   An array of latitudes. Should be in geographic
;               coords. This array can be of any size and of any
;               number of dimensions.
;       Glon:   A vector of geographic longitudes. Must contain a
;               valid number for each element in the Glat
;               array. Longitudes can be either -180W to 180E, or 0E
;               to 360E.
;       Year:   The year to use for the CGM model
;
; KEYWORD PARAMETERS:
;       LSHELL: Set this keyword to a variable that will contain the
;               Lshell values for each [Glat,Glon] pair.
;
;       BFIELD: Set this keyword to a variable that will contain the
;               B Field Strength for each [Glat,Glon] pair.
;
; OUTPUTS:
;       Mlat: (output) Magnetic latitudes corresponding to each
;               [Glat,Glon] pair
;       Mlon: (output) Magnetic longitudes corresponding to each
;               [Glat,Glon] pair. Matches each Mlat value. The output
;               longitudes are ALWAYS on a -180W to 180E grid.
;
; DEPENDENCIES:
;       Uses LOAD_CGM.PRO
;            RANGECIR.PRO
;
; EXAMPLE:
;       G2M, [-90,-60,-30,0,30,60,90], [0,0,0,0,0,0,0], 1998, Mlat, Mlon
;       G2M, [0], [0], 1998, Mlat, Mlon, lshell=lshell, bfield=bfield
;
; MODIFICATION HISTORY:
; 	Written by:	Ken Mankoff, September 2001.
;-

PRO G2M, gLat, gLon, year, cgmLat, cgmLon, lshell=lshell, bfield=bfield

if (n_params() eq 0) then doc_library, 'g2m'

;;; always work on -180W to 180E grid (the SNOE lon grid). 
rangecir, gLon
;if ( year eq 2001 or year eq 2002 ) then y = 2000 else y = year
y = year
load_cgm, cgm, year=y, grid='geo', /snoe

cgmLat = gLat & cgmlat[*]=0
cgmLon = cgmLat & lshell=cgmLat & bfield = cgmLat
n = n_elements( cgmLat )

FOR i = 0L, n-1 DO BEGIN 
    thisLat = gLat[ i ]+90
    thisLon = gLon[ i ]+180
    cgmLat[ i ] = cgm[ thisLon, thisLat, 2 ]
    cgmLon[ i ] = cgm[ thisLon, thisLat, 3 ]
    lshell[ i ] = cgm[ thisLon, thisLat, 4 ]
    bfield[ i ] = cgm[ thisLon, thisLat, 5 ]
ENDFOR

RETURN
END

;
; $Log$
;
