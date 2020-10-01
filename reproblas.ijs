NB. init

coclass 'jreproblas'

path=: jpath '~addons/math/reproblas/'

3 : 0''
if. UNAME-:'Linux' do.
  DLL=: '"',path,'libreproblas.so.2'
elseif. UNAME-:'Win' do.
  DLL=: '"',path,'reproblas.dll'
elseif. do.
  DLL=: ''
end.
)

REPROBLAS_VERSION=: 2.1

NB. cd=: 15!:0

NB. =========================================================
NB. reproducible sum

dsum=: 3 : 0
cmd=. DLL,' reproBLAS_dsum >+ d i &d i'
cmd cd (#y);y;1
)
