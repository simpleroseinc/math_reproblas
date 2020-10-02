NB. init

coclass 'jreproblas'

path=: jpath '~addons/math/reproblas/'

3 : 0''
if. UNAME-:'Linux' do.
  DLL=: '"',path,'libreproblas.so.2"'
elseif. UNAME-:'Win' do.
  DLL=: '"',path,'reproblas.dll"'
elseif. do.
  DLL=: ''
end.
)

REPROBLAS_VERSION=: 2.1

NB. cd=: 15!:0

NB. =========================================================
NB. reproducible sum

dsum=: monad define
cmd=. DLL,' reproBLAS_dsum >+ d i &d i'
cmd cd (#y);y;1
)

NB. =========================================================
NB. reproducible dot product

ddot=: dyad define
cmd=. DLL,' reproBLAS_ddot >+ d i &d i &d i'
assert. ($x)=$y
cmd cd (#x);x;1;y;1
)

NB. =========================================================
NB. reproducible matrix-vector multiplication

dgemv=: dyad define
cmd=. DLL,' reproBLAS_dgemv + n c c i i d &d i &d i d *d i'
assert. 2=#$x
m=. 0{$x
n=. 1{$x
assert. n=#y
> _2 { cmd cd 'R';'N';m;n;1.;x;n;y;1;0.;(m$0.);1
)

NB. =========================================================
NB. reproducible matrix-matrix multiplication

dgemm=: dyad define
cmd=. DLL,' reproBLAS_dgemm + n c c c i i i d &d i &d i d *d i'
assert. 2=#$x
assert. 2=#$y
m=. 0{$x
k=. 1{$x
n=. 1{$y
assert. k=0{$y
> _2 { cmd cd 'R';'N';'N';m;n;k;1.;x;k;y;n;0.;((m,n)$0.);n
)
