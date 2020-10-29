NB. init

coclass 'jreproblas'

path=: jpath '~addons/math/reproblas/'

3 : 0''
if. UNAME-:'Linux' do.
  DLL=: '"',path,'libreproBLAS.so.2"'
elseif. UNAME-:'Win' do.
  DLL=: '"',path,'reproblas.dll"'
elseif. UNAME-:'Darwin' do.
  DLL=: '"',path,'libreproBLAS.2.dylib"'
elseif. do.
  DLL=: ''
end.
)

REPROBLAS_VERSION=: 2.1

doc=: 0 : 0
sum y
  add all of the elements of the input array, similar to +/ ,y

x sum y
  add the elements in the y matrix row-wise or column-wise, similar to
  +/"x y
  x gives the rank of the summation, 1 for row-wise and 2 for column-wise

x dot y
  compute the inner product of x and y, similar to x +/ .* y
  use the following table to determine the rank of the result

    rank of  x    y   result
             1    1    1
             2    1    1
             2    2    2

x (a matmul) y
  compute matrix multiplication of x and y with a scale factor a, similar
  to a&* x +/ .* y
  use the following table to determine the rank of the result

    rank of  x    y   result
             2    1    1
             2    2    2

  in other words, x (1. matmul) y is equivalent to x dot y
)

NB. cd=: 15!:0

NB. =========================================================
NB. reproducible sum

dsum=: monad define
cmd=. DLL,' reproBLAS_dsum >+ d i &d i'
cmd cd (#@, y);y;1
)

NB. =========================================================
NB. reproducible dot product

ddot=: dyad define
cmd=. DLL,' reproBLAS_ddot >+ d i &d i &d i'
assert. 1=#@$x
assert. 1=#@$y
cmd cd (#x);x;1;y;1
)

NB. =========================================================
NB. reproducible matrix-vector multiplication

dgemv=: dyad define
cmd=. DLL,' reproBLAS_dgemv + n c c i i d &d i &d i d *d i'
assert. 2=#@$x
'm n'=. $x
assert. n=#y
> _2 { cmd cd 'R';'N';m;n;1.;x;n;y;1;0.;(m$0.);1
)

NB. =========================================================
NB. reproducible matrix-matrix multiplication

dgemm=: dyad define
cmd=. DLL,' reproBLAS_dgemm + n c c c i i i d &d i &d i d *d i'
assert. 2=#@$x
assert. 2=#@$y
'm k'=. $x
'j n'=. $y
assert. j=k
> _2 { cmd cd 'R';'N';'N';m;n;k;1.;x;k;y;n;0.;((m,n)$0.);n
)

NB. =========================================================
NB. reproducible inner product (+/ . *)
dot=: dyad define
'rx ry' =: (#@$x), (#@$y)
if. rx=1 *. ry=1 do.
  x ddot y
elseif. rx=2 *. ry=1 do.
  x dgemv y
elseif. rx=2 *. ry=2 do.
  x dgemm y
else.
  'unimplemented' 13!:8[10
end.
)

incxdsum=: dyad define
cmd=. DLL,' reproBLAS_dsum >+ d i &d i'
assert. 1=#@$y
cmd cd (<.@%&x (_1+x+#y));y;x
)

NB. =========================================================
NB. reproducible summation
NB. sum y     -- add all of the elements of the input array
NB. x sum y   -- similar to +/"x y
sum=: verb define
dsum y
:
assert. x <: #@$y
if. x=1 do.
  dsum"1 y
elseif. x=2 do.
  assert. 2=#@$y
  incx=. {:@$y
  (,y) incx&incxdsum F:. }. 0,(incx-1)$1
else.
  'unimplemented' 13!:8[10
end.
)

NB. =========================================================
NB. reproducible matrix multiplication with scale factor
NB. x (m matmul) y  -- scale the result of x dot y by m
matmul=: adverb define
'rx ry' =: (#@$x), (#@$y)
if. rx=2 *. ry=1 do.
  cmd=. DLL_jreproblas_,' reproBLAS_dgemv + n c c i i d &d i &d i d *d i'
  'a b'=. $x
  assert. b=#y
  > _2 { cmd cd 'R';'N';a;b;m;x;b;y;1;0.;(a$0.);1
elseif. rx=2 *. ry=2 do.
  cmd=. DLL_jreproblas_,' reproBLAS_dgemm + n c c c i i i d &d i &d i d *d i'
  'a k'=. $x
  'j b'=. $y
  assert. j=k
  > _2 { cmd cd 'R';'N';'N';a;b;k;m;x;k;y;b;0.;((a,b)$0.);b
else.
  'unimplemented' 13!:8[10
end.
)
