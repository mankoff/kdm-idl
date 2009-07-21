;; adapted from objtree::family, list
PRO objtree::hierarchy, Label=label, Recursive=recursive
   ; Process the keywords
   if not keyword_set( recursive ) then print, obj_class(self)
   IF (N_ELEMENTS (label) EQ 0) THEN label = '   -'

   c=self.children
   if ptr_valid(c) then begin 
      ;if n_elements(list) eq 0 then list=[*c] else list=[list,*c]    
      for i=0,n_elements(*c)-1 do begin
         print, label + obj_class(self)
         (*c)[i]->Hierarchy, label='    '+label, /recursive
      endfor
   endif 

END

o = obj_new('objtree' )
branch1 = obj_new('objtree')
branch2 = obj_new('objtree')
leaf1 = obj_new('objtree')
leaf2 = obj_new('objtree')
leaf3 = obj_new('objtree')

o->add, branch1
branch2->add, leaf2
o->add, branch2
branch1->add, leaf1
branch1->add, leaf1
branch1->add, leaf1
branch2->add, leaf3
o->hierarchy
end
