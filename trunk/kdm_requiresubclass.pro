
;; given an object and a list of classnames, make sure the object IsA
;; each of the classnames

pro kdm_requiresubclass, obj, classname
  for c = 0, n_elements(classname)-1 do begin
     if not obj_isa(obj,classname[c]) then begin
        objname = obj_class(obj)
        MESSAGE, "Object "+objname+" Must inherit object: " + classname[c]
     endif
  endfor
end

