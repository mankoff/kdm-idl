;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
;  Copyright (c) 2007-2009 Ken Mankoff
; 
;  Copyright (c) 2007, Ken & Jose. Do what you want with the code.
; 
;  Copyright (c) 1997-2007, ITT Visual Information Solutions. All
;  rights reserved. Unauthorized reproduction is prohibited.
;
;  This originated as d_vectrack.pro (IDL Thunderstorm Demo)
;
;+
;  FILE:
;       xyztn.pro
;
;  CALLING SEQUENCE: xyztn, data=data
;
;  PURPOSE:
;       Visualization of 3D or 4D data
;
;  MAJOR TOPICS: Visualization
;
;  EXAMPLE:
;       Data can be any 3D or 4D or multiple 3D or 4D data. It must be
;       a struct named data. All variables must have the same
;       dimensions.
;
;       data = { foo: fltarr(10,10,10), bar: randomu(seed,10,10,10) }
;       XYZTN, data=data
;        
;
;  MODIFICATION HISTORY:
;       1/97,   ACY   - adapted from vec_track, written by D.D.
;       7/99,   KB    - used PARTICLE_TRACE and STREAMLINE.
;       7/07,   KDM,JC - Genericized for A. Fridlind and A. Ackerman.
;       1/09,   KDM   - improved for use on NBP09-01
;
;-
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Streamlines (Integrate V to get S)
PRO xyztnStreamlineTrace,vdata,start,auxdata,STEPS=steps,FRAC=frac, $
                         OUTVERTS = outverts, OUTCONN = outconn,  $
                         VERT_COLORS = vertcolors

  if (N_ELEMENTS(steps) eq 0) then steps = 100
  if (N_ELEMENTS(frac) eq 0) then frac = 1.0

  PARTICLE_TRACE,vdata,start,outverts,outconn, $
                 MAX_ITERATIONS=steps, MAX_STEPSIZE=frac,INTEGRATION=0, $
                 ANISOTROPY=[1,1,1]
  
  if((N_ELEMENTS(outconn) gt 0) and (SIZE(outverts, /N_DIMENSIONS) eq 2)) $
  then begin
     cdata = INTERPOLATE(auxdata,outverts[0,*],outverts[1,*],outverts[2,*])
     cdata = REFORM(cdata,N_ELEMENTS(outverts)/3)
     ;vertcolors = BYTSCL(cdata)
     vertcolors = cdata
  end
END



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Update the IsoSurface
PRO xyztnIsoSurfUpdate,sState,bUpdate
  IF (sState.bIsoShow AND ((bUpdate EQ 5) OR (bUpdate EQ 4))) THEN BEGIN
     sState.oVols[sState.iIsoVol]->GetProperty,DATA0=vdata,/NO_COPY
     SHADE_VOLUME,vdata,sState.fIsoLevel,fVerts,iConn
     IF (N_ELEMENTS(fVerts) LE 0) THEN $
        sState.oVols[sState.iIsoVol]->SetProperty,DATA0=vdata,/NO_COPY
     sState.oIsoPolygon->SetProperty,DATA=fVerts,POLYGONS=iConn
     sState.oVols[sState.iIsoVol]->SetProperty,DATA0=vdata,/NO_COPY
  ENDIF
END



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; draw the image planes
PRO xyztnPlanesUpdate,sState,bUpdate
  ;; Get the plane positions
  WIDGET_CONTROL, sState.wXSlider, GET_VALUE=x
  WIDGET_CONTROL, sState.wYSlider, GET_VALUE=y
  WIDGET_CONTROL, sState.wZSlider, GET_VALUE=z
  
  ;; Get the data
  sState.oVols[sState.iImgVol]->GetProperty,DATA0=vdata, $
     RGB_TABLE0=ctab,/NO_COPY
  
  ;; Draw the plans
  xyztnSampleOrthoPlane,vdata,0,x,sState.oSlices[0], $
                        sState.oImages[0],ctab,sState.iAlpha
  xyztnSampleOrthoPlane,vdata,1,y,sState.oSlices[1], $
                        sState.oImages[1],ctab,sState.iAlpha
  xyztnSampleOrthoPlane,vdata,2,z,sState.oSlices[2], $
                        sState.oImages[2],ctab,sState.iAlpha
  ;; Restore the data
  sState.oVols[sState.iImgVol]->SetProperty,DATA0=vdata,/NO_COPY


  ;; Vectors?
  IF sState.vec_show THEN BEGIN

     WIDGET_CONTROL, sState.wEvenField, GET_VALUE=stepsize
     WIDGET_CONTROL, sState.wScaleField, GET_VALUE=scale
     
     CASE sState.vec_color OF
        0: sState.oVols[0]->GetProperty,RGB_TABLE0=pal ; color
        1: pal=rebin(indgen(256),256,3)                ; grayscale
        2: pal = intarr( 256, 3 )                      ; black
        3: pal = INTARR( 256, 3 ) +255                 ; white
     ENDCASE

     ;; x,y,z
     u = (*sState.pdata).u & v = (*sState.pdata).v & w = (*sState.pdata).w
     xyztnMkVectors,u,v,w,fVerts,iConn, $
                    SCALE=scale, RANDOM=sState.bRandom, NVECTORS=nvectors,$
                    STEPSIZE=stepsize,Vc=vc,X=x
     if (size(fverts,/dim))[0] ne 0 then begin
        sState.oVectors[0]->SetProperty, $
           DATA=fVerts,POLYLINES=iConn, VERT_COLORS=transpose(pal[vc,*])
        xyztnMkVectors,u,v,w,fVerts,iConn, $
                       SCALE=scale, RANDOM=sState.bRandom, NVECTORS=nvectors,$
                       STEPSIZE=stepsize,Vc=vc,Y=y
        sState.oVectors[1]->SetProperty, $
           DATA=fVerts,POLYLINES=iConn, VERT_COLORS=transpose(pal[vc,*])
        xyztnMkVectors,u,v,w,fVerts,iConn, $
                       SCALE=scale, RANDOM=sState.bRandom, NVECTORS=nvectors,$
                       STEPSIZE=stepsize,Vc=vc,Z=z
        sState.oVectors[2]->SetProperty, $
           DATA=fVerts,POLYLINES=iConn, VERT_COLORS=transpose(pal[vc,*])
     ENDIF
     ;;; x,y,z, end
  ENDIF
END



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Change the TimeStep
FUNCTION xyztnChangeData,sState,iTimeStep
  
  ;; Can we do anything?
  ;IF (PTR_VALID(sState.pSteps)) THEN BEGIN
  IF (sState.nSteps ne 0) then begin
     
     ;; Is there anything to do?
     IF (iTimeStep GE sState.nSteps) THEN RETURN,0
     IF (iTimeStep EQ sState.curStep) THEN RETURN,0
     
     ;; Update volume data
     num_oVols = n_elements(sState.oVols)
     if num_oVols eq 1 then $
        sState.oVols[0]->SetProperty, $
        DATA0=reform(BYTSCL((*sState.pdata).(0)[*,*,*,iTimeStep], $
                            min=sstate.minmaxarr[0,0], $
                            max=sstate.minmaxarr[1,0])) $
     else $
        for i=0,n_elements(sState.oVols)-1 do $
           sState.oVols[i]->SetProperty, $
        DATA0=bytscl(reform((*sState.pdata).(i)[*,*,*,iTimeStep]), $
                     min=sstate.minmaxarr[0,i],max=sstate.minmaxarr[1,i])
     
     ;; And the current timestep
     sState.curStep = iTimeStep

     ;; recompute streamlines
     oList = sState.oStreamModel->Get(/ALL)
     sz=size(oList)
     IF (sz[2] EQ 11) THEN BEGIN
        FOR i=0,N_ELEMENTS(oList)-1 DO BEGIN
           oList[i]->GetProperty,UVALUE=xyz
           xyztnBuildRibbon,sState,oLIst[i],xyz
        END
     END

     ;; recompute the iso-surface and planes
     xyztnIsoSurfUpdate,sState,5
     xyztnPlanesUpdate,sState,4
     
     RETURN,1
  END
  RETURN,0
END


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Update the colorbar based on the Image selection
PRO xyztnColorBarUpdate,sState

  oList = sState.oCBTop->Get(/ALL)
  
  ;; New data space
  data = sState.minmaxarr[*, sState.iImgVol]
  fMin = min(data)
  fMax = max(data)
  sState.oCBTop->SetProperty,TRANSFORM=IDENTITY(4)
  dx = fMax-fMin
  sState.oCBTop->Translate,-(fMax+fMin)*0.5,0.0,0.0
  sState.oCBTop->Scale,1.0/dx,1.0/260.0,1.0
  sState.oCBTop->Translate,0.0,-0.725,0.0

  ;; The Image is (0)
  sState.oVols[sState.iImgVol]->GetProperty,RGB_TABLE0=pal
  pal = TRANSPOSE(pal)
  rgb = REFORM(pal[*,INDGEN(256*16) MOD 256],3,256,16)
  oList[0]->SetProperty,DATA=rgb,DIMENSIONS=[dx,16],LOCATION=[fMin,-40]

  ;; The Axis is (1)
  sTitle = sState.dnames[sState.iImgVol]
  oList[1]->GetProperty,TICKTEXT=oText,TITLE=oTitle
  oText->SetProperty,CHAR_DIMENSIONS=[0,0]
  oTitle->SetProperty,CHAR_DIMENSIONS=[0,0],STRING=sTitle
  oList[1]->SetProperty,RANGE=[fMin,fMax], LOCATION=[fMin,-40]
  ;;; Special GISS code
  if sTitle eq 'CLASS' then begin
     oText->SetProperty,STRINGS=['          un!c          class', $
                                 '          drizzle', $
                                 '          rain', $
                                 '           snow!c          low', $
                                 '           snow!c           hi', $
                                 '           snow!c          melt', $
                                 '           grpl!c           dry', $
                                 '           grpl!c           wet', $
                                 '           hail!c           small', $
                                 '           hail!c           large', $
                                 '           hail!c            rain' ]
  endif else begin
     oText->GetProperty,strings=uglystr
     oText->SetProperty,STRINGS=STRTRIM(STRING(uglystr,FORMAT='(F10.2)'),2)
  endelse
  
END


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Routine to read and setup the volume object palettes
PRO xyztnReadVoxelPalettes,vobj

  vColors = BYTARR(256,3,/NOZERO)
  vOpac = BYTARR(256,/NOZERO)
  
  OPENR, lun, /GET_LUN, $
         demo_filepath('storm.pal', SUBDIR=['examples','demo','demodata'])
  READU, lun,  vColors
  CLOSE, lun
  FREE_LUN, lun
  vcolors = congrid( congrid( vcolors[50:220,*],11,3 ), 256, 3 )
  
  OPENR, lun, /GET_LUN, $
         demo_filepath('storm.opa', SUBDIR=['examples','demo','demodata'])
  READU, lun,  vOpac
  CLOSE, lun
  FREE_LUN, lun
  
  FOR i=0,255 DO IF (vOpac[i] GT 128.0) THEN vOpac[i] = 128.0
  
  vobj->SetProperty,RGB_TABLE0=vColors,OPACITY_TABLE0=vOpac
  
END

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Update the plane images
PRO xyztnSampleOrthoPlane,data,axis,slice,oPoly,oImage,ctab,alpha

  sz=size(data)-1
  CASE axis OF
     0: BEGIN
        img = data[slice,*,*]
        img = REFORM(img,sz[2]+1,sz[3]+1,/OVERWRITE)
        fTxCoords = [[0,0],[1,0],[1,1],[0,1]]
        verts=[[slice,0,0],[slice,sz[2],0],[slice,sz[2],sz[3]],[slice,0,sz[3]]]
     END
     1: BEGIN
        img = data[*,slice,*]
        img = REFORM(img,sz[1]+1,sz[3]+1,/OVERWRITE)
        fTxCoords = [[0,0],[1,0],[1,1],[0,1]]
        verts=[[0,slice,0],[sz[1],slice,0],[sz[1],slice,sz[3]],[0,slice,sz[3]]]
     END
     2: BEGIN
        img = data[*,*,slice]
        img = REFORM(img,sz[1]+1,sz[2]+1,/OVERWRITE)
        fTxCoords = [[0,0],[1,0],[1,1],[0,1]]
        verts=[[0,0,slice],[sz[1],0,slice],[sz[1],sz[2],slice],[0,sz[2],slice]]
     END
  END
  
  ;; Convert to 3xNxM or 4xNxM
  sz=size(img)
  IF ((alpha[0] EQ 0) AND (alpha[1] EQ 255)) THEN BEGIN
     rgbtab=TRANSPOSE(ctab)
     rgb=rgbtab[*,img]
     rgb=REFORM(rgb,3,sz[1],sz[2],/OVERWRITE)
  END ELSE BEGIN
     rgbtab=bytarr(4,256)
     rgbtab[0:2,*]=TRANSPOSE(ctab)
     rgbtab[3,*] = 0
     rgbtab[3,alpha[0]:alpha[1]] = 255
     rgb=rgbtab[*,img]
     rgb=REFORM(rgb,4,sz[1],sz[2],/OVERWRITE)
  END

  oImage->SetProperty,DATA=rgb
  oPoly->SetProperty,DATA=verts,TEXTURE_COORD=fTxCoords
  
END






PRO xyztnMkVectors, u, v, w, fVerts, iConn, X=x, Y=y, Z=z, SCALE=scale,$
                    RANDOM=random, NVECTORS=nvectors, STEPSIZE=stepsize,$
                    bMAG=bMag, VC=vc
  
  ;; Ensure volumes match in number of elements.
  nSamples = N_ELEMENTS(u)
  IF (nSamples NE N_ELEMENTS(v) OR nSamples NE N_ELEMENTS(w)) THEN BEGIN
     MESSAGE,'Number of elements in u, v, and w must match.'
     RETURN
  ENDIF
  sz = SIZE(u)

  ;; Handle keywords, set defaults.
  IF (N_ELEMENTS(scale) EQ 0) THEN scale = 10.0
  IF (N_ELEMENTS(random) EQ 0) THEN random = 0
  IF (N_ELEMENTS(nvectors) EQ 0) THEN nvectors = 100
  IF (N_ELEMENTS(stepsize) eq 0) then stepsize = 1
  IF (N_ELEMENTS(bMag) EQ 0) THEN bMag = BYTSCL(SQRT(u^2+v^2+w^2))

  ;; Get plane information.
  doPlane = 0
  IF (N_ELEMENTS(x) GT 0) THEN BEGIN
     IF (random EQ 0) THEN BEGIN
        nRow = sz[2] / stepsize
        nCol = sz[3] / stepsize
     ENDIF
     doPlane = 1
  ENDIF
  IF (N_ELEMENTS(y) GT 0) THEN BEGIN
     IF (doPlane) THEN MESSAGE,'X, Y, and Z keywords are mutually exclusive'
     IF (random EQ 0) THEN BEGIN
        nRow = sz[3] / stepsize
        nCol = sz[1] / stepsize
     ENDIF
     doPlane = 2
  ENDIF
  IF (N_ELEMENTS(z) GT 0) THEN BEGIN
     IF (doPlane) THEN MESSAGE,'X, Y, and Z keywords are mutually exclusive'
     IF (random EQ 0) THEN BEGIN
        nRow = sz[2] / stepsize
        nCol = sz[1] / stepsize
     ENDIF
     doPlane = 3
  ENDIF
  IF (doPlane EQ 0) THEN MESSAGE, 'Must specify a plane.'
  
  ;; Grab max, min values in vector volumes.
  maxU = MAX(u, MIN=minU)
  maxV = MAX(v, MIN=minV)
  maxW = MAX(w, MIN=minW)
  
  ;; Compute the magnitude.
  mag = SQRT((maxU-minU)^2 + (maxV-minV)^2 + (maxW-minW)^2)
  fNorm = scale / mag
  
  nV = nRow*nCol

  if nv eq 0 then return
  fVerts = FLTARR(3, 2*nV)
  iConn = LONARR(3*nV)
  vc = BYTARR(2*nV)
  
  CASE doPlane OF
     1: BEGIN                   ; X=x
        x0 = REPLICATE(x,nV)
        y0 = REFORM((REPLICATE(1,nCol) # (LINDGEN(nRow)*stepsize)),nV)
        z0 = REFORM(((LINDGEN(nCol)*stepsize) # REPLICATE(1,nRow)),nV)
     END
     2: BEGIN                   ; Y=y
        y0 = REPLICATE(y,nRow*nCol)
        z0 = REFORM((REPLICATE(1,nCol) # (LINDGEN(nRow)*stepsize)),nV)
        x0 = REFORM(((LINDGEN(nCol)*stepsize) # REPLICATE(1,nRow)),nV)
     END
     3: BEGIN                   ; Z=z
        z0 = REPLICATE(z,nRow*nCol)
        y0 = REFORM((REPLICATE(1,nCol) # (LINDGEN(nRow)*stepsize)),nV)
        x0 = REFORM(((LINDGEN(nCol)*stepsize) # REPLICATE(1,nRow)),nV)
     END
  ENDCASE
  
  inds = LINDGEN(nV)
  v0 = transpose([[x0],[y0],[z0]])
  v1 = transpose([[x0+u[x0,y0,z0]*fNorm], $
                  [y0+v[x0,y0,z0]*fNorm], $
                  [z0+w[x0,y0,z0]*fNorm]])
  fVerts[*,inds*2] = v0[*,inds]
  fVerts[*,inds*2+1] = v1[*,inds]
  iConn[inds*3] = 2
  iConn[inds*3+1] = inds*2
  iConn[inds*3+2] = inds*2+1
  
  vc[inds*2] = bMag[x0,y0,z0]
  vc[inds*2+1] = bMag[x0,y0,z0]
END


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Convert a mouse point into a streamline...
FUNCTION xyztnDoStream,sEvent,sState,new_flag
  pick = sState.oWindow->PickData(sState.oView,$
                                  sState.oVols[0], $
                                  [sEvent.x,sEvent.y],dataxyz)
  IF (pick NE 1) THEN RETURN,0

  sState.oVols[sState.iStreamSel>0]->GetProperty, $
     xcoord_conv=xc,ycoord_conv=yc,zcoord_conv=zc
  IF (new_flag) THEN BEGIN
     sState.oStreamline = OBJ_NEW('IDLgrPolyline',UVALUE=dataxyz,$
                                  xcoord_conv=xc,ycoord_conv=yc,zcoord_conv=zc)
     sState.oStreamModel->Add,sState.oStreamline
  END
  xyztnBuildRibbon,sState,sState.oStreamline,dataxyz
  RETURN,1
END



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Compute a single Ribbon/Streamline
PRO xyztnBuildRibbon,sState,oObj,dataxyz
  
  if NOT ( XIASTREC( *sState.pData, 'u' ) AND $
           XIASTREC( *sState.pData, 'v' ) AND $
           XIASTREC( *sState.pData, 'w' ) ) THEN RETURN
  
  sState.oVols[sState.iStreamSel>0]->GetProperty,DATA0=auxdata, $
     RGB_TABLE0=auxpal, /NO_COPY
     
  auxpal = TRANSPOSE(auxpal)

  if sState.iStreamSel eq -2 then auxpal[*] = 0 ; black
  if sState.iStreamSel eq -1 then auxpal[*] = 255 ; white

  grAuxpal = OBJ_NEW('IDLgrPalette', auxpal[0, *], auxpal[1, *], auxpal[2, *])
  iStep = 100

  iStepFactor = XIASTREC(sState.meta,'tracer_length')?sState.meta.tracer_length:1
  iStep = iStep * iStepFactor

  ;; fFrac = 1.0/88.0  ;; 1.0/max velocity
  fFrac = .5 ;; step size

  t = sState.CurStep
  
  vdata = arrconcat( (*sState.pdata).u[*,*,*,t],(*sState.pdata).v[*,*,*,t] )
  vdata = arrconcat( vdata, (*sState.pdata).w[*,*,*,t] )
  vdata = transpose(vdata,[3,0,1,2])
  xyztnStreamlineTrace, vdata, dataxyz, auxdata,FRAC=fFrac, $
                        STEP=iStep,VERT_COLORS=vertcolors, $
                        OUTVERTS = outverts, OUTCONN = outconn

  IF ((N_ELEMENTS(outconn)GT 1)AND(SIZE(outverts,/N_DIMENSIONS)EQ 2))THEN BEGIN
     oObj->SetProperty,HIDE=0,DATA=outverts,POLYLINES = outconn, $
                       VERT_COLORS=vertcolors, PALETTE = grAuxpal
  END ELSE BEGIN
     oObj->SetProperty,HIDE=1
  END
  sState.oVols[sState.iStreamSel>0]->SetProperty,DATA0=auxdata,/NO_COPY
END



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Cleanup
pro xyztnCleanup, wTopBase
  WIDGET_CONTROL, wTopBase, GET_UVALUE=sState, /NO_COPY
  ;; Destroy the objects.
  OBJ_DESTROY, sState.oHolder
  ;; Destroy the time step data
  IF (PTR_VALID(sState.pData)) THEN BEGIN
     PTR_FREE,sState.pData
  END
  ;;  Restore the color table.
  TVLCT, sState.colorTable
  if sState.groupBase ne 0 then $
  if WIDGET_INFO(sState.groupBase, /VALID_ID) then $
     WIDGET_CONTROL, sState.groupBase, /MAP
end                             ;  of xyztnCleanup



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Main event handler
PRO xyztnEvent, sEvent
  
  WIDGET_CONTROL, sEvent.top, GET_UVALUE=sState, /NO_COPY
  WIDGET_CONTROL, sEvent.top, SET_UVALUE=sState, /NO_COPY
  
  if (TAG_NAMES(sEvent, /STRUCTURE_NAME) EQ  $
      'WIDGET_KILL_REQUEST') then begin
     WIDGET_CONTROL, sEvent.top, /DESTROY
     RETURN
  endif
  
  WIDGET_CONTROL, sEvent.id, GET_UVALUE=uval
  
  ;; By default, no updating is needed
  bUpdate = 0
  bRedraw = 0
  
  ;; Grab the UValue
  WIDGET_CONTROL, sEvent.top, GET_UVALUE=sState, /NO_COPY
  
  ;; Handle other events.
  CASE uval OF
     
     ;; Update the time
     'TIME_STEP': BEGIN
        IF (xyztnChangeData(sState,sEvent.value) GT 0) THEN BEGIN
           bRedraw = 1
           bUpdate = 4
        END
     END
     
     ;; Volumes variable changed
     'VREND_VOLSEL': BEGIN
        for i=0,n_elements(sState.oVols)-1 do $
           sState.oVols[i]->SetProperty,HIDE=1
        sState.iVrendVol = sEvent.index
        bRedraw = 1
        if sstate.bvolshow then begin
           sState.oVols[sState.iVrendVol]->SetProperty,HIDE=0
           demo_draw,sState.oWindow,sState.oView
        endif
     END

     ;; Show/Hide Volume
     'VREND_SHOW': BEGIN
        sState.bVolShow = 1-sState.bVolShow
        IF (sstate.bVolShow) then begin
           sState.oVols[sState.iVrendVol]->SetProperty,HIDE=0
           WIDGET_CONTROL,sEvent.top,/HOURGLASS
        endif else begin
           sState.oVols[sState.iVrendVol]->SetProperty,HIDE=1
        endelse 
        demo_draw, sState.oWindow, sState.oView, debug=sState.debug
     END
     
     ;; Show/Hide Image Planes
     'IMG_SHOW': BEGIN
        bUpdate = 4
        bRedraw = 1
        sState.bShow = 1-sState.bShow
        sState.oSlices[0]->SetProperty, $
           HIDE=(1-sState.bShow)+(1-sState.showPlane[0])
        sState.oSlices[1]->SetProperty, $
           HIDE=(1-sState.bShow)+(1-sState.showPlane[1])
        sState.oSlices[2]->SetProperty, $
           HIDE=(1-sState.bShow)+(1-sState.showPlane[2])
     END
     'SHOW_XPLANE': BEGIN
        bUpdate = 4
        bRedraw = 1
        sState.showPlane[0] = 1-sState.showPlane[0]
        sState.oSlices[0]->SetProperty, $
           HIDE=(1-sState.bShow)+(1-sState.showPlane[0])
        sState.oVectors[0]->SetProperty, $
           HIDE=(1-sState.vec_show)+(1-sState.showPlane[0])
        ;; sState.oImages[0]->SetProperty,HIDE=sState.showPlane[0]
     END
     'SHOW_YPLANE': BEGIN
        bUpdate = 4
        bRedraw = 1
        sState.showPlane[1] = 1-sState.showPlane[1]
        sState.oSlices[1]->SetProperty,$
           HIDE=(1-sState.bShow)+(1-sState.showPlane[1])
        sState.oVectors[1]->SetProperty, $
           HIDE=(1-sState.vec_show)+(1-sState.showPlane[1])
     END
     'SHOW_ZPLANE': BEGIN
        bUpdate = 4
        bRedraw = 1
        sState.showPlane[2] = 1-sState.showPlane[2]
        sState.oSlices[2]->SetProperty,$
           HIDE=(1-sState.bShow)+(1-sState.showPlane[2])
        sState.oVectors[2]->SetProperty, $
           HIDE=(1-sState.vec_show)+(1-sState.showPlane[2])
     END
     
     ;; Image variable changed
     'IMG_VOLSEL': BEGIN
        sState.iImgVol = sEvent.index
        xyztnColorBarUpdate,sState
        bUpdate = 4
        bRedraw = 1
     END

     'STREAM_SELECTOR': BEGIN
        sState.iStreamSel = sEvent.index -2 ; 'black','white', then vars
        bUpdate = 4
        bRedraw = 1
        ;; clear them too...
        oList = sState.oStreamModel->Get(/ALL)
        sz=size(oList)
        IF (sz[2] EQ 11) THEN OBJ_DESTROY,oList
     END
    'CLEAR_STREAMS' : BEGIN
       oList = sState.oStreamModel->Get(/ALL)
       sz=size(oList)
       IF (sz[2] EQ 11) THEN BEGIN
          OBJ_DESTROY,oList
          bRedraw = 1
       END
    END
    
    ;; Image variable changed
    'VEC_SHOW': BEGIN
       sState.vec_show = 1-sState.vec_show
       if sState.vec_show eq 1 then begin ; turn on
          ;;print, "on", sState.vec_show, sState.showPlane
          sState.oVectors[0]->SetProperty, $
             HID=(1-sState.vec_show)+(1-sState.showPlane[0])
          sState.oVectors[1]->SetProperty, $
             HID=(1-sState.vec_show)+(1-sState.showPlane[1])
          sState.oVectors[2]->SetProperty, $
             HID=(1-sState.vec_show)+(1-sState.showPlane[2])
       endif else begin         ; turn off
          ;;print, "off", sState.vec_show
          sState.oVectors[0]->SetProperty, HID=1-sState.vec_show
          sState.oVectors[1]->SetProperty, HID=1-sState.vec_show
          sState.oVectors[2]->SetProperty, HID=1-sState.vec_show
       endelse  
       bUpdate = 4
       bRedraw = 1
    END
    'N_EVEN': BEGIN
       bUpdate = 4
       bRedraw = 1
    END
    'SCALE': BEGIN
       bUpdate = 4
       bRedraw = 1
    END
    'VEC_COLOR': BEGIN
       sState.vec_color = sEvent.index
       bUpdate = 4
       bRedraw = 1
    END
    
;;    ;; Show/Hide Contour Planes
;;     'CONT_SHOW': BEGIN
;;        sState.bContShow = 1-sState.bContShow
;;        bUpdate = 4
;;        bRedraw = 1
;;        IF NOT (sState.bContShow) THEN sState.oIsopolygon->SetProperty,HIDE=1
;;     END
;;     ;; Contour variable changed
;;     'CONT_VOLSEL': BEGIN
;;        sState.iContVol = sEvent.index
;;        xyztnColorBarUpdate,sState
;;        bUpdate = 4
;;        bRedraw = 1
;;     END
    
    ;; Change min/max alpha (transparency) level for images
    'ALPHA_LEVEL': BEGIN
       WIDGET_CONTROL, sState.wAlpha[0], GET_VALUE=v1
       WIDGET_CONTROL, sState.wAlpha[1], GET_VALUE=v2
       IF (v1 GE v2) THEN BEGIN
          sState.iAlpha = [v2,v1]
       END ELSE BEGIN
          sState.iAlpha = [v1,v2]
       END
       bUpdate = 4
       bRedraw = 1
    END
    
    ;; Isosurface variable changed
    'ISO_VOLSEL': BEGIN
       sState.iIsoVol = sEvent.index
       Val = KDM_RANGE( sState.fIsoLevel, $
                        from = [0,255], $
                        to = sState.minmaxarr[*,sState.iIsoVol] )
       WIDGET_CONTROL, sState.wIsotext, SET_VALUE=STRTRIM(Val,2)
       IF (sState.bIsoShow) THEN BEGIN
          bUpdate = 5
          bRedraw = 1
       END
    END
    
    ;; Iso level changed
    'ISO_LEVEL': BEGIN
       WIDGET_CONTROL, sState.wIsoLevel, GET_VALUE=Val
       txtVal = KDM_RANGE( Val, from = [0,255], $
                           to = sState.minmaxarr[*,sState.iIsoVol] )
       WIDGET_CONTROL, sState.wIsotext, SET_VALUE=STRTRIM(txtVal, 2)
       sState.fIsoLevel = Val
       IF (sState.bIsoShow) THEN BEGIN
          bUpdate = 5
          bRedraw = 1
       END
    END
    
    ;; Show/Hide Isosurface
    'ISO_SHOW': BEGIN
       sState.bIsoShow = 1-sState.bIsoShow
       sState.oIsopolygon->SetProperty,HIDE=1-sState.bIsoShow
       IF (sState.bIsoShow) THEN BEGIN
          bUpdate = 5
          bRedraw = 1
       END ELSE BEGIN
          bRedraw = 1
       END
    END
    'ISO_ALPHA': BEGIN
       WIDGET_CONTROL, sState.wIsoAlpha, GET_VALUE=Val
       sState.oIsoPolygon->SetProperty, ALPHA=val/100.
       bUpdate = 5
       bRedraw = 1
    END
    
    ;; X plane location 
    'X_VALUE': BEGIN
       minmax = WIDGET_INFO(sState.wXSlider, /SLIDER_MIN_MAX)
       slider_value = XIASTREC(sState.meta,'xrange')?sState.meta.xrange:minmax
       WIDGET_CONTROL, sState.wXSlider, GET_VALUE=Val
       slider_value = kdm_range(Val, from = minmax, to = slider_value)
       WIDGET_CONTROL, sState.wXtext, SET_VALUE= $
                       STRtrim(string(slider_value, FORMAT='(F10.3)'), 2)
       bUpdate = 1
       bRedraw = 1
    END
    ;; Y plane location
    'Y_VALUE': BEGIN
       minmax = WIDGET_INFO(sState.wYSlider, /SLIDER_MIN_MAX)
       slider_value = XIASTREC(sState.meta,'yrange')?sState.meta.yrange:minmax
       WIDGET_CONTROL, sState.wYSlider, GET_VALUE=Val
       slider_value = kdm_range(Val, from = minmax, to = slider_value)
       WIDGET_CONTROL, sState.wYtext, SET_VALUE= $
                       STRtrim(string(slider_value, FORMAT='(F10.3)'), 2)
       bUpdate = 2
       bRedraw = 1
    END
    ;; Z plane location
    'Z_VALUE': BEGIN
       minmax = WIDGET_INFO(sState.wZSlider, /SLIDER_MIN_MAX)
       slider_value = XIASTREC(sState.meta,'zrange')?sState.meta.zrange:minmax
       if(n_elements(slider_value) gt 2) then $
          slider_value = [min(slider_value)/1e3, max(slider_value)/1e3]
       WIDGET_CONTROL, sState.wZSlider, GET_VALUE=Val
       slider_value = kdm_range(Val, from = minmax, to = slider_value)
       WIDGET_CONTROL, sState.wZtext, SET_VALUE= $
                       STRtrim(string(slider_value, FORMAT='(F10.3)'), 2)
       bUpdate = 3
       bRedraw = 1
    END
    
    ;; Refresh window
    'DRAW': BEGIN
       ;; Expose.
       IF (sEvent.type EQ 4) THEN BEGIN
          demo_draw, sState.oWindow, sState.oView, debug=sState.debug
          WIDGET_CONTROL, sEvent.top, SET_UVALUE=sState, /NO_COPY
          RETURN
       ENDIF
       ;; Handle trackball updates.
       bHaveTransform = sState.oTrack->Update( sEvent, TRANSFORM=qmat )
       IF (bHaveTransform NE 0) THEN BEGIN
          IF sEvent.modifiers eq 0 then begin
             sState.oGroup->GetProperty, TRANSFORM=t
             sState.oGroup->SetProperty, TRANSFORM=t#qmat
          ENDIF ELSE IF sEvent.modifiers eq 1 then begin ; shift = scale
             ;; help, sEvent, /st
             sct = sEvent.y / 200.
             transform = [[sct, 0, 0, 0.0], [0, sct, 0, 0.0], $
                          [0, 0, sct, 0.0], [0, 0, 0, 1]]
             sstate.oTop->SetProperty, transform=transform
          ENDIF
          bRedraw = 1
       ENDIF
       
       ;; Handle other events: PICKING, quality changes, etc. 
       ;;  Button press.
       IF (sEvent.type EQ 0) THEN BEGIN
          
          IF (sEvent.press EQ 4) THEN BEGIN ; Right mouse.
             IF (xyztnDoStream(sEvent,sState,1)) THEN BEGIN
                bRedraw = 1
                sState.btndown = 4b
                sState.oWindow->SetProperty, QUALITY=sState.dragq
                WIDGET_CONTROL, sState.wDraw, /DRAW_MOTION
             END
          END ELSE IF (sEvent.press EQ 1) THEN BEGIN ; other mouse button.
             sState.btndown = 1b
             sState.oWindow->SetProperty, QUALITY=sState.dragq
             WIDGET_CONTROL, sState.wDraw, /DRAW_MOTION
             bRedraw = 1
          ENDIF ELSE BEGIN      ; middle mouse
             oList = sState.oStreamModel->Get(/ALL)
             sz=size(oList)
             IF (sz[2] EQ 11) THEN BEGIN
                OBJ_DESTROY,oList
                bRedraw = 1
             END
          END
       ENDIF
       
       ;; Button motion.
       IF (sEvent.type EQ 2) THEN BEGIN
          IF (sState.btndown EQ 4b) THEN BEGIN ; Right mouse button.
             status = xyztnDoStream(sEvent,sState,0)
             bRedraw = 1
          ENDIF
       ENDIF
       
       
       IF (sEvent.press EQ 1) THEN BEGIN ; other mouse button.
          sState.btndown = 1b
          sState.oWindow->SetProperty, QUALITY=sState.dragq
          WIDGET_CONTROL, sState.wDraw, /DRAW_MOTION
          bRedraw = 1
       ENDIF
       ;; Button release.
       IF (sEvent.type EQ 1) THEN BEGIN
          IF (sState.btndown EQ 1b) THEN BEGIN
             sState.oWindow->SetProperty, QUALITY=2
             bRedraw = 1
          ENDIF
          sState.btndown = 0b
          WIDGET_CONTROL, sState.wDraw, DRAW_MOTION=0
       ENDIF
    END
    
    'QUIT' : BEGIN
       WIDGET_CONTROL, sEvent.top, SET_UVALUE=sState, /NO_COPY
       WIDGET_CONTROL, sEvent.top, /DESTROY
       RETURN
    END
    'SAVE': BEGIN
       objImg = sState.oWindow->Read()
       objImg->getProperty, data=img
       FOR d=0,2 DO img[d,*,*] = rotate(reform(img[d,*,*]),7)
       saveFile = DIALOG_PICKFILE( /OVERWRITE_PROMPT, /WRITE, $
                                   DEFAULT_EXTENSION="png", $
                                   FILE='xyztn_', TITLE='Save Image as PNG', $
                                   FILTER=[['*.png;*.PNG','.*'],$
                                           ['PNG Images','All Files']] )
       IF SaveFile NE '' THEN WRITE_PNG, saveFile, img, ORDER=1
       OBJ_DESTROY, objImg
    END
    
    ELSE: MESSAGE, "UI Event with no handler", /CONT
    
 ENDCASE
  
  ;; Update the current display
  IF (bUpdate NE 0) THEN BEGIN
     xyztnPlanesUpdate,sState,bUpdate
     xyztnIsoSurfUpdate,sState,bUpdate
  ENDIF
  
  ;; Redraw the graphics
  IF (bRedraw) THEN BEGIN
     demo_draw, sState.oWindow, sState.oView, debug=sState.debug
  ENDIF
  
  ;; Restore state.
  WIDGET_CONTROL, sEvent.top, SET_UVALUE=sState, /NO_COPY
END




;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Entry routine. Main procedure
PRO xyztn, $
   LOADDATA=fname, $
   DATA=DATA, META=META, $
   AUTO_TRANSPARENCY=AUTO_TRANSPARENCY
  
  IF NOT KEYWORD_SET(data) AND NOT KEYWORD_SET( fname ) THEN BEGIN
     print, ' '
     print, 'xyztn info-'
     print, 'Usage: IDL> xyztn, data="structure with 3D data'
     print, '...or...'
     print, 'Usage: IDL> xyztn, load="file with 3d array or structure"'
     print, 'See README.TXT for more information'
     return
  ENDIF
  
  IF (N_ELEMENTS(fWidth) EQ 0) THEN fWidth = 1.0
  IF (N_ELEMENTS(fname) NE 0) THEN restore, fname ; get data var
  ;; else, data and meta passed in when xyztn called
  
  ;; if vectors then append SQRT(vectors)
  IF XIASTREC( data, 'u' ) AND $
     XIASTREC( data, 'v' ) AND $
     XIASTREC( data, 'w' ) THEN BEGIN
     MESSAGE, "Detected U,V,W Vectors. " + $
              "Creating and appending SQRT(u^2+v^2+w^2)", /CONTINUE
     data = CREATE_STRUCT( data, $
                           'sqrt_uvw', SQRT(data.u^2+data.v^2+data.w^2) )
  END
  
  ;;  Get the screen size.
  Device, GET_SCREEN_SIZE = screenSize
  ;;  Set up dimensions of the drawing (viewing) area.
  if ScreenSize[0] GE 1800 then ScreenSize[0] = 1800
  xdim = screenSize[0]*0.7
  ydim = xdim*0.8
  
  ;;  Get the current color vectors to restore when this application is exited.
  TVLCT, savedR, savedG, savedB, /GET
  ;;  Build color table from color vectors
  colorTable = [[savedR],[savedG],[savedB]]
  
  ;; Get the data size
  sz = SIZE(data.(0),/DIM)
  xMax = sz[0] - 1
  yMax = sz[1] - 1
  zMax = sz[2] - 1
  if n_elements(sz) eq 3 then nSteps = 0 else nSteps = sz[3]-1
  nMax = n_tags(data) - 1

  ;;  Create widgets.
  wTopBase = WIDGET_BASE(/COLUMN, $
                         TITLE="XYZTN (4D multi-variate) Visualizer", $
                         XPAD=0, YPAD=0, $
                         /TLB_KILL_REQUEST_EVENTS, $
                         TLB_FRAME_ATTR=1, MBAR=barBase, $
                         UNAME='XYZTN:tlb')


  ;;  Create the menu bar. It contains the file/quit, edit/ shade-style
  wFileButton = WIDGET_BUTTON(barBase, VALUE='File', /MENU)
  wSaveButton = WIDGET_BUTTON(wFileButton,VALUE='Save', UVALUE='SAVE')
  wQuitButton = WIDGET_BUTTON(wFileButton,VALUE='Quit', UVALUE='QUIT')

  wTopRowBase = WIDGET_BASE(wTopBase,/ROW,/FRAME)
  wGuiBase = WIDGET_BASE(wTopRowBase, /COLUMN)

  wRowBase = WIDGET_BASE(wGuiBase, /COLUMN )
  wFrameBase = WIDGET_BASE(wRowBase, /COLUMN, /FRAME)

  dnames = tag_names(data)
  wLabel = WIDGET_LABEL(wFrameBase,VALUE='Planes')


  ;; Plane controls
  wRow = WIDGET_BASE(wFrameBase,/ROW)
  wRowB = WIDGET_BASE(wRow,/ROW,/NONEXCLUSIVE)
  
  wImgShow = WIDGET_BUTTON(wRowB,VALUE='Image',UVAL='IMG_SHOW')
  wIVolSel = WIDGET_DROPLIST(wRow,VALUE=dnames, $
                             FRAME=frame,UVAL='IMG_VOLSEL')
  WIDGET_CONTROL,wImgShow,/SET_BUTTON

  ;; Contour
;;   wRow = WIDGET_BASE(wFrameBase,/ROW)
;;   wRowB = WIDGET_BASE(wRow,/ROW,/NONEXCLUSIVE)
;;   wContShow = WIDGET_BUTTON(wRowB,VALUE='Contour',UVAL='CONT_SHOW')
;;   wIVolSel = WIDGET_DROPLIST(wRow,VALUE=dnames, $
;;                              FRAME=frame,UVAL='CONT_VOLSEL')
  
  ;; Possible vector
  IF XIASTREC(data,'U') AND $
     XIASTREC(data,'V') AND $
     XIASTREC(data,'W')THEN BEGIN
     wfb_save = wFrameBase
     wFrameBase = WIDGET_BASE(wRowBase, /COLUMN, /FRAME )
     wText = WIDGET_LABEL(wFrameBase, VALUE='Vectors' )
     wVecBase = WIDGET_BASE(wFrameBase,/NONEXCLUSIVE)
     wIVecSel = WIDGET_BUTTON(wVecBase,VALUE="Vector Planes",UVAL='VEC_SHOW')
     wVecColor = WIDGET_DROPLIST(wFrameBase,UVAL='VEC_COLOR', TITLE='Color: ',$
                                 VALUE=['SQRT(u^2+v^2+w^2)','Grayscale', $
                                        'Black','White'] )
     wEvenField = CW_FIELD(wFrameBase, /INTEGER, $
                           TITLE='Sample Every Nth, N=', XSIZE=2, $
                           UVALUE='N_EVEN',VALUE=1, /RETURN_EVENTS)
     wScaleField = CW_FIELD(wFrameBase, /FLOAT, TITLE='Vector Length = ', $
                            UVALUE='SCALE', VALUE=15, XSIZE=8,/RETURN_EVENTS)
     
     wRow0 = WIDGET_BASE(wFrameBase,/ROW)
     wRow1 = WIDGET_BASE(wRow0,/ROW,/NONEXCLUSIVE)
     
     wSVolSel = WIDGET_DROPLIST(wRow0,VALUE=['Black','White',dnames], $
                                ;;FRAME=frame, $
                                UVAL='STREAM_SELECTOR', $
                                UNAME='STREAM_SELECTOR', $
                                TITLE='Streams:' )

;;      desc = REPLICATE({ flags:0, name:'' }, n_elements(dnames)+4)  
;;      desc.flags = [ 1, 0, 0, 1, 0, 0, 0, 0, 0, 0 ]  
;;      desc.name = [ 'Black', 'Black', 'White', 'Variable', dnames ]
;;      wText = WIDGET_LABEL(wRow0, VALUE='Streams:' )
;;      wSVolSel = CW_PDMENU( wRow0, desc, UVAL='STREAM_SELECTOR', $
;;                            UNAME='STREAM_SELECTOR' )
     wClearStreams = WIDGET_BUTTON(wRow0,VALUE='Clear', $
                                   UVALUE='CLEAR_STREAMS', $
                                   UNAME='D_VECTRACK:clearstreams')
     wFrameBase = wfb_save
  ENDIF ELSE BEGIN
     wEvenField = 0B
     wScaleField = 0B
  ENDELSE
  
  ;; Planes for image/contour/vectors
  wRow = WIDGET_BASE(wFrameBase,/ROW)
  wRowB = WIDGET_BASE(wRow,/ROW,/NONEXCLUSIVE)
  wXPlaneShow = WIDGET_BUTTON(wRowB,VALUE='X:',UVAL='SHOW_XPLANE' )
  WIDGET_CONTROL, wXPlaneShow, /SET_BUTTON
  wXSlider = WIDGET_SLIDER(wRow, MAXIMUM=xMax, UVALUE='X_VALUE', $
                           VALUE=xMax*0.75, /SUPPRESS_VALUE, /DRAG)
  slider_value = XIASTREC(meta,'xrange')?meta.xrange:[0, xMax]
  slider_value = kdm_range(xMax*0.75, from = [0, xMax], to = slider_value)
  wXtext = WIDGET_LABEL(wRow, VALUE=STRtrim(slider_value, 2))

  wRow = WIDGET_BASE(wFrameBase,/ROW)
  ;wText = WIDGET_LABEL(wRow, VALUE='Y:' )
  wRowB = WIDGET_BASE(wRow,/ROW,/NONEXCLUSIVE)
  wYPlaneShow = WIDGET_BUTTON(wRowB,VALUE='Y:',UVAL='SHOW_YPLANE' )
  WIDGET_CONTROL, wYPlaneShow, /SET_BUTTON
  wYSlider = WIDGET_SLIDER(wRow, MAXIMUM=yMax, UVALUE='Y_VALUE', $
                           value=yMax*0.50, /SUPPRESS_VALUE, /DRAG )
  slider_value = XIASTREC(meta,'yrange')?meta.yrange:[0, yMax]
  slider_value = kdm_range(yMax*0.50, from = [0, yMax], to = slider_value)
  wYtext = WIDGET_LABEL(wRow, VALUE=STRtrim(slider_value, 2))

  wRow = WIDGET_BASE(wFrameBase,/ROW)
  ;wText = WIDGET_LABEL(wRow, VALUE='Z:' )
  wRowB = WIDGET_BASE(wRow,/ROW,/NONEXCLUSIVE)
  wZPlaneShow = WIDGET_BUTTON(wRowB,VALUE='Z:',UVAL='SHOW_ZPLANE' )
  WIDGET_CONTROL, wZPlaneShow, /SET_BUTTON
  wZSlider = WIDGET_SLIDER(wRow, MAXIMUM=zMax, UVALUE='Z_VALUE', $
                           VALUE=zMax*0.10, /SUPPRESS_VALUE, /DRAG)
  slider_value = XIASTREC(meta,'zrange')?meta.zrange:[0, zMax]
  if (n_elements(slider_value) gt 2) then $
     slider_value = [min(slider_value)/1e3, max(slider_value)/1e3]
  slider_value = kdm_range(zMax*0.10, from = [0, zMax], to = slider_value)
  wZtext = WIDGET_LABEL(wRow, VALUE=STRtrim(slider_value, 2))

  ;; Transparency min/max (alpha channel) for Images
  wSpace = WIDGET_LABEL(wFrameBase,VALUE='Image Transparency')
  ;; Calculate the transparency value = mode+1
  ;; Mode requires sorting which is computationally expensive.Make it optional
  ;; default to on
  if n_elements( AUTO_TRANSPARENCY ) eq 0 then AUTO_TRANSPARENCY=1
  if keyword_set(AUTO_TRANSPARENCY) then begin
     minModeMean = min([mode(data.(0)),mean(data.(0))])
     transparencyMin = KDM_RANGE(minModeMean, $
                                 from = [min(data.(0)),max(data.(0))], $
                                 to = [0,255] )
     if transparencyMin eq -999.9 then transparencyMin = -1
     transparencyMin = transparencyMin + 1
  endif else transparencyMin = 0
  wRow = WIDGET_BASE(wFrameBase,/ROW)
  wText = WIDGET_LABEL(wRow, VALUE='Min:' )
  wAlphamin = WIDGET_SLIDER(wRow,/SUPPRESS_VALUE,UVAL='ALPHA_LEVEL', $
                            MAXIMUM=255,VALUE=transparencyMin, /DRAG)
  wRow = WIDGET_BASE(wFrameBase,/ROW)
  wText = WIDGET_LABEL(wRow, VALUE='Max:' )
  wAlphamax = WIDGET_SLIDER(wRow,/SUPPRESS_VALUE,UVAL='ALPHA_LEVEL', $
                            MAXIMUM=255,VALUE=255, /DRAG)
  
  
  
  ;; Volume
  wFrameBase = WIDGET_BASE(wRowBase, /COLUMN, /FRAME)
  wRow0 = WIDGET_BASE(wFrameBase,/ROW)
  wRow1 = WIDGET_BASE(wRow0,/ROW,/NONEXCLUSIVE)
  wVRender = WIDGET_BUTTON(wRow1, VALUE='Volume', $
                           UVALUE='VREND_SHOW', UNAME='XYZTN:volrendr')
  wVVolSel = WIDGET_DROPLIST(wRow0,VALUE=dnames,UVAL='VREND_VOLSEL')

  ;; Isosurface
  wFrameBase = WIDGET_BASE(wRowBase, /COLUMN, /FRAME)
  wRow0 = WIDGET_BASE(wFrameBase,/ROW)
  wRow1 = WIDGET_BASE(wRow0,/ROW,/NONEXCLUSIVE)
  wIsotoggle = WIDGET_BUTTON(wRow1,VALUE='Iso',UVALUE='ISO_SHOW')
  wSVolSel = WIDGET_DROPLIST(wRow0,VALUE=dnames,UVAL='ISO_VOLSEL')
  
  wRow2 = WIDGET_BASE(wFrameBase,/ROW)
  wText = WIDGET_LABEL(wRow2, VALUE='Iso Level' )
  wIsoLevel = WIDGET_SLIDER(wRow2,/SUPPRESS_VALUE, UVAL='ISO_LEVEL', $
                            MAXIMUM=255,VALUE=128, $
                            UNAME='XYZTN:iso_level', /DRAG)
  wIsoText = WIDGET_LABEL(wRow2,VALUE='0.00000')
  wIsoAlpha = CW_KDM_SLIDER(wFrameBase,UVAL='ISO_ALPHA', $
                            MINIMUM=0,MAXIMUM=100, VALUE=100, /DRAG, $
                            LABELS=STRING(STRTRIM(INDGEN(101)/100.,2), $
                                          FORMAT='(F4.2)'), $
                            TITLE='Iso Alpha')
  wGuiBase3 = WIDGET_BASE(wFrameBase,/COLUMN,/NONEXCLUSIVE)
  
  ;; Time
  IF (nSteps GT 0) THEN BEGIN
     TimeTextStr = XIASTREC( meta,'time' ) ? meta.time : indgen(nSteps+1)
     wFrameBase = WIDGET_BASE(wGuiBase, /COLUMN, /FRAME)
     wTimeStep = CW_KDM_SLIDER(wFrameBase, UVAL='TIME_STEP', max=nSteps,/DRAG, $
                               title='Time: ', LABEL=STRTRIM(TimeTextStr,2))
  END ELSE BEGIN
     wTimeStep = 0 
  ENDELSE
  
  wDraw = WIDGET_DRAW(wTopRowBase, XSIZE=xdim, YSIZE=ydim, UVALUE='DRAW', $
                      RETAIN=0, /EXPOSE_EVENTS, /BUTTON_EVENTS, $
                      GRAPHICS_LEVEL=2, UNAME='XYZTN:draw')
  
  
  ;;  Realize the base widget.
  WIDGET_CONTROL, wTopBase, /REALIZE
  
  ;;  Returns the top level base in the appTLB keyword
  appTLB = wTopBase

  ;; Get the window id of the drawable.
  WIDGET_CONTROL, wDraw, GET_VALUE=oWindow

  ;; Compute viewplane rect based on aspect ratio.
  aspect = FLOAT(xdim) / FLOAT(ydim)
  myview = [-0.5, -0.5, 1, 1] * 1.7
  IF (aspect > 1) THEN BEGIN
     myview[0] = myview[0] - ((aspect-1.0)*myview[2])/2.0
     myview[2] = myview[2] * aspect
  ENDIF ELSE BEGIN
     myview[1] = myview[1] - (((1.0/aspect)-1.0)*myview[3])/2.0
     myview[3] = myview[3] * aspect
  ENDELSE
  
  ;; Drop the view down a bit to make room for the colorbar
  ;; myview[1] = myview[1] - 0.1
  myview[1] = myview[1] - 0.15
  
  ;; Create view.
  oView = OBJ_NEW('IDLgrView', PROJECTION=2,$
                  VIEWPLANE_RECT=myview,COLOR=[50,50,70])

  ;; Create model.
  oTop = OBJ_NEW('IDLgrModel')
  oTop->Scale,0.8,0.8,0.8
  oGroup = OBJ_NEW('IDLgrModel')
  oTop->Add, oGroup
  
  ;; Compute coordinate conversion to normalize.
  maxDim = MAX([xMax, yMax, zMax])
  xxscl = XIASTREC( meta, 'xscale' ) ? meta.xscale : 1
  xs = [-0.5 * xMax/maxDim,1.0/maxDim] * xxscl
  yyscl = XIASTREC( meta, 'yscale' ) ? meta.yscale : 1
  ys = [-0.5 * yMax/maxDim,1.0/maxDim] * yyscl
  ;;zs = [(-zMin2/(zMax2-zMin2))-0.5, 1.0/(zMax2-zMin2)]
  zzscl = XIASTREC( meta, 'zscale' ) ? meta.zscale : 1
  zs = [-0.5*zMax/maxDim, 1.0/maxDim] * zzscl
  
  ;; Create the axis objects.
  oXTitle = OBJ_NEW('IDLgrText', XIASTREC(meta,'xtitle')?meta.xtitle:'X')
  TickValues = makex(0, xMax, xMax*.25)
  _range = XIASTREC(meta,'xrange')?meta.xrange:[0, xMax]
  TickValues = kdm_range(TickValues, from = [0, xMax], to = _range)
  oTickValues = OBJ_NEW('IDLgrText', STRINGS= $
                        STRtrim(string(TickValues,FORMAT='(F10.2)'), 2))
  oAxis = OBJ_NEW('IDLgrAxis', 0, COLOR=[255,255,255], $
                  RANGE=[0,xMax], /EXACT, $
                  MAJOR=n_elements(TickValues), $
                  TITLE=oXTitle, TICKTEXT=oTickValues, TICKLEN=2, $
                  XCOORD_CONV=[xs[0],xs[1]], $
                  YCOORD_CONV=ys, $
                  ZCOORD_CONV=zs)
  oGroup->Add, oAxis
  

  oYTitle = OBJ_NEW('IDLgrText', XIASTREC(meta,'ytitle')?meta.ytitle:'Y')
  TickValues = makex(0, yMax, yMax*.25)
  _range = XIASTREC(meta,'yrange')?meta.yrange:[0, yMax]
  TickValues = kdm_range(TickValues, from = [0, yMax], to = _range)
  oTickValues = OBJ_NEW('IDLgrText', STRINGS= $
                        STRtrim(string(TickValues, FORMAT='(F10.2)'), 2))
  oAxis = OBJ_NEW('IDLgrAxis', 1, COLOR=[255,255,255], $
                  RANGE=[0,yMax], /EXACT, $
                  MAJOR=n_elements(TickValues), $
                  TITLE=oYTitle, TICKTEXT=oTickValues, TICKLEN=2,$
                  XCOORD_CONV=xs, $
                  YCOORD_CONV=[ys[0],ys[1]], $
                  ZCOORD_CONV=zs)
  oGroup->Add, oAxis
  


  oZTitle = OBJ_NEW('IDLgrText', XIASTREC(meta,'ztitle')?meta.ztitle:'Z')
  TickValues = makex(0, zMax, zMax*.25)
  _range = XIASTREC(meta,'zrange')?meta.zrange:[0, zMax]
  if(n_elements(_range) gt 2)then _range = [min(_range)/1e3, max(_range)/1e3]
  TickValues = kdm_range(TickValues, from = [0, zMax], to = _range)
  oTickValues = OBJ_NEW('IDLgrText', STRINGS= $
                        STRtrim(string(TickValues, FORMAT='(F10.2)'), 2))
  oAxis = OBJ_NEW('IDLgrAxis', 2, COLOR=[255,255,255], $
                  RANGE=[0,zMax-1],$
                  /EXACT, MAJOR=n_elements(TickValues), $
                  TITLE=oZTitle, TICKTEXT=oTickValues, TICKLEN=2, $
                  XCOORD_CONV=xs, $
                  YCOORD_CONV= -ys, $
                  ZCOORD_CONV=[zs[0],zs[1]])
  oGroup->Add, oAxis
  

  ;; wireframe box
  oBox = OBJ_NEW('IDLgrPolyline', $
                 [[0,0,0],[xMax,0,0],[0,yMax,0],[xMax,yMax,0], $
                  [0,0,zMax],[xMax,0,zMax],[0,yMax,zMax],$
                  [xMax,yMax,zMax]], $
                 COLOR=[200,200,200], $
                 POLYLINE=[5,0,1,3,2,0,5,4,5,7,6,4,2,0,4,2,1,5,2,2,6,2,3,7],$
                 XCOORD_CONV=xs, YCOORD_CONV=ys, ZCOORD_CONV=zs)
  oGroup->Add, oBox
  
  oXPolyline = OBJ_NEW('IDLgrPolyline', COLOR=[255,255,255], HIDE=1, $
                       XCOORD_CONV=xs, YCOORD_CONV=ys, ZCOORD_CONV=zs)
  oYPolyline = OBJ_NEW('IDLgrPolyline', COLOR=[255,255,255], HIDE=1, $
                       XCOORD_CONV=xs, YCOORD_CONV=ys, ZCOORD_CONV=zs)
  oZPolyline = OBJ_NEW('IDLgrPolyline', COLOR=[255,255,255], HIDE=1, $
                       XCOORD_CONV=xs, YCOORD_CONV=ys, ZCOORD_CONV=zs)
  oGroup->Add, oXPolyline
  oGroup->Add, oYPolyline
  oGroup->Add, oZPolyline
  
  ;; slice image-form objects (texture mapping)
  oXImage = OBJ_NEW('IDLgrImage',dist(5),HIDE=1)
  oYImage = OBJ_NEW('IDLgrImage',dist(5),HIDE=1)
  oZImage = OBJ_NEW('IDLgrImage',dist(5),HIDE=1)
  oXPolygon = OBJ_NEW('IDLgrPolygon', COLOR=[255,255,255], HIDE=1,$
                      TEXTURE_MAP=oXImage, TEXTURE_INTERP=1, $
                      XCOORD_CONV=xs, YCOORD_CONV=ys, ZCOORD_CONV=zs)
  oYPolygon = OBJ_NEW('IDLgrPolygon', COLOR=[255,255,255], HIDE=1,$
                      TEXTURE_MAP=oYImage, TEXTURE_INTERP=1, $
                      XCOORD_CONV=xs, YCOORD_CONV=ys, ZCOORD_CONV=zs)
  oZPolygon = OBJ_NEW('IDLgrPolygon', COLOR=[255,255,255], HIDE=1,$
                      TEXTURE_MAP=oZImage, TEXTURE_INTERP=1, $
                      XCOORD_CONV=xs, YCOORD_CONV=ys, ZCOORD_CONV=zs)
  oGroup->Add, oXPolygon
  oGroup->Add, oYPolygon
  oGroup->Add, oZPolygon

  ;; Contours (on image planes)
;  oXContour = OBJ_NEW('IDLgrContour')
;  oYContour = OBJ_NEW('IDLgrContour')
;  oZContour = OBJ_NEW('IDLgrContour')
;  oGroup->Add, oContour

  
  ;; Iso Surface objects
  oIsoPolygon = OBJ_NEW('IDLgrPolygon', COLOR=[127,127,127], HIDE=1,$
                        SHADING=1,XCOORD_CONV=xs, $
                        YCOORD_CONV=ys, ZCOORD_CONV=zs)
  oGroup->Add, oIsoPolygon

  ;; Stream line objects holder
  oStreamModel = OBJ_NEW('IDLgrModel')
  oGroup->Add, oStreamModel


  minmaxarr = fltarr( 2, nMax+1 )
  for i=0, nMax do begin
     dtmp = data.(i)
     minmaxarr[*,i] = [ min(dtmp), max(dtmp) ]
     dtmpB = BYTSCL( dtmp )
     vol = OBJ_NEW('IDLgrVolume', DATA0 = dtmpB[*,*,*,0], $
                   /ZERO_OPACITY_SKIP, /ZBUFFER, HIDE=1, $
                   XCOORD_CONV=xs, YCOORD_CONV=ys, ZCOORD_CONV=zs, $
                   HINTS=2)
     oGroup->Add, vol
     xyztnReadVoxelPalettes,vol
     vol->SetProperty,OPACITY_TABLE0=((findgen(256)/16)^2.0)/4.0
     if i eq 0 then volarr = [vol] else volarr = [volarr, vol]
  endfor
  
  ;; Grab the Volume color table for use by the image objects
  vol->GetProperty,RGB_TABLE0=ctab
  oPal = OBJ_NEW('IDLgrPalette',ctab[*,0],ctab[*,1],ctab[*,2])
  oXImage->SetProperty,PALETTE=oPal
  oYImage->SetProperty,PALETTE=oPal
  oZImage->SetProperty,PALETTE=oPal
  
  ;; Create some lights.
  oLight = OBJ_NEW('IDLgrLight', LOCATION=[2,2,2], TYPE=1, INTENSITY=0.8)
  oTop->Add, oLight
  oLight = OBJ_NEW('IDLgrLight', TYPE=0, INTENSITY=0.5)
  oTop->Add, oLight
  
  ;; Create the color bar annotation (lower left corner)
  oCBTop = OBJ_NEW('IDLgrModel')
  
  rgb = bytarr(3,256,16)
  rgb[0,*,*] = indgen(256*16) MOD 256
  rgb[1,*,*] = indgen(256*16) MOD 256
  rgb[2,*,*] = indgen(256*16) MOD 256
  oImage = OBJ_NEW('IDLgrImage',rgb,DIMENSIONS=[256,16])
  oCBTitle = OBJ_NEW('IDLgrText','Grayscale')
  oCBAxis = OBJ_NEW('IDLgrAxis',range=[0,256],/EXACT,COLOR=[255,255,255], $
                    TICKLEN=15,MAJOR=12,MINOR=2,TITLE=oCBTitle)
  
  oCBTop->Add,oImage
  oCBTop->Add,oCBAxis
  
  oView->Add,oCBTop
  
  ;; Place the model in the view.
  oView->Add, oTop
  
  ;; Rotate to standard view for first draw.
  oGroup->Rotate, [1,0,0], -90
  oGroup->Rotate, [0,1,0], 30
  oGroup->Rotate, [1,0,0], 30

  ;; Create a trackball.
  oTrack = OBJ_NEW('Trackball', [xdim/2, ydim/2.], xdim/2.)

  ;; Create a holder object for easy destruction.
  oHolder = OBJ_NEW('IDL_Container')
  oHolder->Add, oView
  oHolder->Add, oTrack
  oHolder->Add, oXTitle
  oHolder->Add, oYTitle
  oHolder->Add, oZTitle
  oHolder->Add, oTickValues
  oHolder->Add, oCBTitle
  oHolder->Add, oPal
  oHolder->Add, oXImage
  oHolder->Add, oYImage
  oHolder->Add, oZImage

  ;; Save state.
  sState = {nSteps: nSteps,        $
            curStep: 0,            $
            nVars: nMax, $
            pData: PTR_NEW(data,/NO_COPY), $
            meta: XIASTREC(meta) ? meta : 0, $
            btndown: 0b,           $
            dragq: 2,              $
            dnames: dnames,        $
            minmaxarr: minmaxarr,  $ 
            bShow: 0b,             $
            bContShow: 0B,         $
            bImage: 0b,            $
            bRandom: 0b,           $
            oHolder: oHolder,      $
            oTrack:oTrack,         $
            wXSlider:wXSlider,     $
            wXtext:wXtext,         $
            wYSlider:wYSlider,     $
            wYtext:wYtext,         $
            wZSlider:wZSlider,     $
            wZtext:wZtext,         $
            showplane:[1,1,1],     $
            wIsoLevel: wIsoLevel,  $
            wIsoAlpha: wIsoAlpha,  $
            wIsoText: wIsoText,    $
            wAlpha: [wAlphamin,wAlphamax],    $
            wTimeStep: wTimeStep,  $
            wEvenField: wEvenField,$
            wScaleField: wScaleField, $
            wDraw: wDraw,          $
            wLabel: wLabel,        $
            oWindow: oWindow,      $
            oView: oView,          $
            oTop: oTop,            $
            oGroup: oGroup,        $
            oCBTop: oCBTop,        $
            oCBAxis: oCBAxis,      $
            iAlpha: [transparencyMin,255],       $ ; KDM
            iContVol: 0,            $
            iImgVol: 0,            $
            iVrendVol: 0,          $
            iStreamSel: -2,         $
            wSvolSel: wSVolSel,    $
            oVols: volarr,         $
            oSlices: [oXPolygon,oYPolygon,oZPolygon], $
            oIsopolygon: oIsopolygon, $
            oImages: [oXImage,oYImage,oZImage], $
;            oContours: [oXContour, oYContour, oZContour], $
            oVectors: [oXPolyline, oYPolyline, oZPolyline ], $
            vec_show: 0B,          $
            vec_color: 0,          $ ; color (gray,black,white)
            iIsoVol: 0,            $
            fIsoLevel: 128,        $
            fWidth: fWidth,        $
            bIsoShow: 0,           $
            bVolShow: 0,           $
            oStreamModel: oStreamModel, $
            oStreamline: OBJ_NEW(), $
            ColorTable: colorTable,$ ; Color table to restore at exit
            debug: keyword_set(debug), $
            groupBase: 0 $     ;; Base of Group Leader
           }
  
  ;;Update the Iso level with some proper default value
  WIDGET_CONTROL, sState.wIsotext, $
    SET_VALUE=strcompress(STRING((.5*(sState.minmaxarr[1,sState.iIsoVol]) + $
                                  (sState.minmaxarr[0,sState.iIsoVol]*(.5)))))

  ;; Initialize with an interesting view
  sState.bShow=1
  sState.bImage=1
  sState.bIsoShow=0
  sState.bVolShow = 0
  
  xyztnColorBarUpdate,sState
  xyztnIsoSurfUpdate,sState,5
  xyztnPlanesUpdate,sState,4
  
  sState.oSlices[0]->SetProperty,HIDE=0
  sState.oSlices[1]->SetProperty,HIDE=0
  sState.oSlices[2]->SetProperty,HIDE=0
  sState.oIsopolygon->SetProperty,HIDE=0
  
  
  WIDGET_CONTROL, wTopBase, SET_UVALUE=sState, /NO_COPY
  
  XMANAGER, 'XYZTN', wTopBase, $
            EVENT_HANDLER='xyztnEvent', $
            /NO_BLOCK, $
            CLEANUP='xyztnCleanup'
  
END

