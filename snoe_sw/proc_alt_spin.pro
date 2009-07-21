PRO PROC_alt_spin,altsh,sc_alt,spin_alt

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;inputs:
	;altsh = data(68,ispin,iorbit)  shift of altitude at index 48
	;sc_alt = data(69,ispin,iorbit) altitude of spacecraft per spin
;output
	;spin_alt=fltarr(65)		altitude range of spin
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

spin_alt=fltarr(65)

if sc_alt le 0. then begin
	spin_alt(0:64)=0.
	goto, skip
endif

phi=asin((6371.+ altsh)/(sc_alt))

del_theta=2.42e-3/(12.)*2.*!pi
x1=findgen(49)
x2=findgen(16)+1

th_up=phi+del_theta*reverse(x1)
th_down=phi-del_theta*(x2)

spin_alt(0:48)=sin(th_up)*(sc_alt)-6371.
spin_alt(49:64)=sin(th_down)*(sc_alt)-6371.

skip:

return
end
