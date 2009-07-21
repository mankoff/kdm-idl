;
;date conversion procedure
;

pro date_cv,date,month,day,_EXTRA=e

ymd=snoe_date(date,/from_doy,/to_ymd,_EXTRA=e)
months=['Jan','Feb','Mar','Apr','May','Jun','Jul','Aug','Sep','Oct','Nov','Dec']

month=months[ymd[1]-1]

day= STRING( ymd[2], /PRINT, FORMAT='(I2.2)' )
;IDL> date_cv,7
;      7  Jan07

print,date,'  ',month,day

return
end


