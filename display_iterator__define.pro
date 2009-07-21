;; display_iterator__define
;;
;; Generic iterator object that calls a classes ::display method with
;; some controls...



pro data::cleanup
  message, "Cleanup", /CONTINUE
end 
function display_iterator::init, _EXTRA=e
  return, 1
end
PRO display_iterator__define, class
  compile_opt DEFINT32
  compile_opt STRICTARR
  class = { display_iterator, $
            debug_display_iterator: 0B }
END
