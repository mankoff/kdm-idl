
pro usersym_dot
sym = FINDGEN(17) * (!PI*2/16.)  
USERSYM, COS(sym), SIN(sym), /FILL  
end
