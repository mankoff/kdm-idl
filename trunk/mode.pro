
; http://groups.google.com/group/comp.lang.idl-pvwave/msg/43e7464c407bab29
Function Mode, Value
NumElements    = N_ELEMENTS( Value )
SortedValue    = [ Value( SORT( Value )),0]
SortedValue(NumElements)= NOT( SortedValue( NumElements-1 ))
ShiftedValue   = SHIFT( SortedValue,1 )
RunLengths    = WHERE( SortedValue NE ShiftedValue )
RunsShifted    = SHIFT( RunLengths,1 )
MaxRun     = MAX( Runlengths - RunsShifted, Index )
Mode     = SortedValue( RunsShifted( Index ))
Return, Mode
End

