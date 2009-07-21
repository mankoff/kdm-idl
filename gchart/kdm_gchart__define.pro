
function kdm_gchart::url, url
  ;; url = http://chart.apis.google.com/chart?<parameter 1>&<parameter 2>&<parameter n> 
  url = "http://chart.apis.google.com/chart?"
  url = url + 'chs=' + STRTRIM(self.size[0],2)+'x'+STRTRIM(self.size[1],2)
  url = url + '&chd=' + self.odata->url()
  url = url + '&cht=' + self.odata->type()

  ;url = url + "&chxt=x,y,r,t"

  children = self->children()
  if total( ptr_valid(children) ) eq 1 then begin
     for c = 0, n_elements(*children)-1 do begin
        child = *children
        url = url + child[c]->url()
     endfor
  endif
  return, url
end

function kdm_gchart::image
  urlComponents = PARSE_URL(self->url()) 
  urlObj =OBJ_NEW('IDLnetURL') 
  urlObj->SetProperty, URL_SCHEME = urlComponents.scheme, $ 
                       URL_HOST = urlComponents.host, $ 
                       URL_PATH = urlComponents.path 
  file='kdm_gchart.out'
  result = urlObj->Get( $
           ;;/buffer, $
           ;;/string, $
           filename=file, $
           _EXTRA=e )
  read_png, file, img
  file_delete, file
  obj_destroy, urlObj
  return, img
end

pro kdm_gchart::setProperty, size=size, odata=odata, _EXTRA=e
  if keyword_set(size) then begin
     if LONG(size[0]) * LONG(size[1]) gt 300000 then $
        MESSAGE, "Chart size too large. Must be < 300,000 pixels"
     if max(size[0] gt 1000 ) OR max(size[1] gt 1000 ) then $
        message, "Chart dimension too large. Max width or height is 1,000 pixels"
  endif
  if keyword_set(odata) and obj_valid(self.odata) then obj_destroy, self.odata
  self->kdm::setProperty, size=size, odata=odata, _EXTRA=e
end

function kdm_gchart::init, _EXTRA=e
  kdm_requiresubclass, 'kdm'
  if self->kdm::init() ne 1 then return, 0
  self->setProperty, _EXTRA=e
  return, 1
end
pro kdm_gchart::cleanup
  obj_destroy, self.odata
  self->kdm::cleanup
  self->objtree::cleanup
end 
pro kdm_gchart__define, class
  class = { kdm_gchart, $
            size: [0,0], $
            odata: obj_new(), $
            inherits objtree, $
            inherits kdm }
end

;;data = obj_new( 'kdm_gchart_pie3d', data=[60,40] )
;;data = obj_new( 'kdm_gchart_venn', area=[60,40,20], ab=30, bc=3, ac=20, all=40 )
data = obj_new( 'kdm_gchart_lineplot', data=[[-100, 0, 10,30,100 ],[0,10,20,30,40]], range=[-100,200] )
;;data = obj_new( 'kdm_gchart_sparkline', data=[ 40,60,60,45,47,75,70,72 ] )
;;data = obj_new( 'kdm_gchart_xy', x0=indgen(5)*10, y0=[10,20,30,50,30], y1=indgen(5)*10, x1=[10,30,10,30,10] )

o = obj_new('kdm_gchart', size=[250,100], odata=data )

;;o->add, obj_new('kdm_gchart_axis', ylabel='Y Axis',
;;yrange=[-100,100] )
;; o->add, obj_new('kdm_gchart_axis', ylabel='Y Axis', yrange=[-100,100], xrange=[0,10], xlabel='Hello World' );, $
        ;tlabel='Top', rlabel='Right')

;o->add, obj_new('kdm_gchart_legend', legend=['NASDAQ','FTSE100','DOW'] )
;o->add, obj_new('kdm_gchart_label', labe=['Hello','World'])
;o->add, obj_new('kdm_gchart_title', title='The Title' )
o->add, obj_new( 'kdm_gchart_color', color=['FF0000','00FF00','0000FF'] )
print, o->url()

img = o->image()
sz = size(img,/dim)
if !d.window eq -1 then window, 0
if !d.x_size ne sz[1] OR !d.y_size ne sz[2] then window, 0, xsize=sz[1], ysize=sz[2]
tv, img, /true
end
