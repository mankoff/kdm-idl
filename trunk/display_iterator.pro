;; display_iterator
;;
;; Generic iterator object that calls a classes ::display method with
;; some controls...

pro display_iterator, o, $
                      verbose=verbose, $
                      _EXTRA=e
  MESSAGE, "C-c C-y in Emacs to enter Input Mode", /CONTINUE
  idx = 0
  while 1 do begin
     oo = o[idx]
     oo->display, _EXTRA=e

     if keyword_set(verbose) then begin
        n = oo->getProperty(/note)
        if n ne '' then print, n
     endif

     input:
     k = GET_KBRD( )
     IF ( k EQ string(10b) ) THEN k = 'n' ; enter
     CASE k OF
        'i': BEGIN 
           n = oo->getProperty(/note)
           if n ne '' then print, n
           goto, input
        END
        't': BEGIN 
           savetomain, oo, 'oo'
           goto, input
        END
        'p': idx=(idx-2)>(-1)
        'q': GOTO, done
        ELSE: 
     ENDCASE
     idx=idx+1 < (n_elements(o)-1)
  endwhile
  done:
end
