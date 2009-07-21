
;; kdm_define
;;
;; generic object all other objects might inherit
;;
;; http://www.dfanning.com/tips/getproperty.html

FUNCTION kdm::GetProperty, all=all, _Extra=extraKeyword
  
  ;; /ALL is from http://www.dfanning.com/code_tips/allprops.html
  ;;if (arg_present(all)) then begin
  if (keyword_set(all)) then begin
     all = create_struct(name=obj_class(self))
     struct_assign, self, all
     return, all
  endif

  ;; Error handling.
  Catch, theError
  IF theError NE 0 THEN BEGIN
     Catch, /Cancel
     MESSAGE, !Error_State.MSG, /CONTINUE
     RETURN, ""
  ENDIF
  
  ;; Only one property at a time can be returned.
  IF N_Elements(extraKeyword) EQ 0 THEN Message, 'Must indicate which property to return.'
  IF N_Tags(extraKeyword) GT 1 THEN Message, 'Only one property at a time can be returned.'
  
  ;; Pull keyword out of extra
  ;; structure. It will be in UPPERCASE
  ;; characters.
  keyword = (Tag_Names(extraKeyword))[0]
  
  ;; Obtain a structure definition of the object class.
  ok =  Execute("struct = {" + Obj_Class(self) + "}")
  
  ;; There should be only one match to
  ;; the structure fields. If there
  ;; are more, then you have used an
  ;; ambiguous keyword and you need more
  ;; characters in the keyword abbreviation.
  index = Where(StrPos(Tag_Names(struct), keyword) EQ 0, count)
  index = index[0]
  IF count GT 1 THEN Message, "Ambiguous keyword. Use more characters in it's specification."
  IF count EQ 0 THEN return, "";Message, 'Keyword not found.'
  
  if size(self.(index),/tname) eq 'POINTER' then $
     return, *(self.(index))
  RETURN, self.(index)
END

;; http://groups.google.com/group/comp.lang.idl-pvwave/browse_frm/thread/e433a11f73bc0bb1/5083a2d2a871508b?lnk=gst&q=__define+compile#5083a2d2a871508b
pro kdm::GetProperty,_REF_EXTRA=e
  tags=tag_names(create_struct(NAME=obj_class(self)))
  for i=0,n_elements(e)-1 do begin
     wh=where(tags eq e[i],cnt)
     if cnt eq 0 then continue
     val = self.(wh[0])
     if ptr_valid(val) then val=*val
     (scope_varfetch(e[i],/REF_EXTRA))=val
  endfor
end 

PRO kdm::SetProperty, _Extra=extraProperties
  ;; Error handling.
  Catch, theError
  IF theError NE 0 THEN BEGIN
     Catch, /Cancel
     MESSAGE, !Error_State.MSG, /CONTINUE
     RETURN
  ENDIF

  IF N_Elements(extraProperties) EQ 0 THEN BEGIN
     IF self->getProperty(/debug_kdm) THEN Message, 'Must indicate which property to set.', /CONTINUE
     return
  endif
  properties = Tag_Names(extraProperties)
  
  ;; Obtain a structure definition of the object class.
  ; ok =  Execute("struct = {" + Obj_Class(self) + "}")
  Call_Procedure , Obj_Class(self)+'__define', struct
  
  ;; Loop through the various properties and their values.
  FOR j=0L,N_Tags(extraProperties)-1 DO BEGIN
     theProperty = properties[j]
     index = Where(StrPos(Tag_Names(struct), theProperty ) EQ 0, count)
     index = index[0]
     IF count GT 1 THEN Message, "Ambiguous keyword: " + theProperty + ". Use more characters in it's specification."
     IF count EQ 0 THEN BEGIN
        ;;Message, 'Keyword not found:' + theProperty, /CONTINUE
        continue
     endif

     if size(self.(index),/tname) eq 'POINTER' then begin
        self.(index) = ptr_new(extraProperties.(j))
     endif else begin
        self.(index) = extraProperties.(j)
     endelse
  ENDFOR
END

pro kdm::cleanup
  ;; free memory allocated to pointer when destroying object
  ;ptr_free,self.ptr
  message, "Cleanup", /CONTINUE
end 

function kdm::init, debug_kdm=debug_kdm, _EXTRA=e
  self->setProperty, debug_kdm=debug_kdm
  if self->getProperty( /debug_kdm ) then message, "Init", /CONTINUE
  return, 1
end

PRO kdm__define, class
  compile_opt DEFINT32
  compile_opt STRICTARR
  class = { kdm, debug_kdm:0B }
END
