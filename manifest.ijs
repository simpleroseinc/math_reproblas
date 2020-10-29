NB. reproblas manifest

CAPTION=: 'REPROBLAS'

DESCRIPTION=: 0 : 0
ReproBLAS aims at providing users with a set of (Parallel and Sequential) Basic Linear Algebra Subprograms that guarantee reproducibility regardless of the number of processors, of the data partitioning, of the way reductions are scheduled, and more generally of the order in which the sums are computed.

This J addon comes with prebuilt shared libraries.

See also: https://bebop.cs.berkeley.edu/reproblas/
)

VERSION=: '1.0.1'

RELEASE=: 'j901 j902'

FOLDER=: 'math/reproblas'

LABCATEGORY=: 'Math'

FILES=: 0 : 0
reproblas.ijs
)

PLATFORMS=: 'win linux darwin'

FILESLINUX64=: 'libreproBLAS.so.2'
FILESWIN64=: 'reproBLAS.dll'
FILESDARWIN64=: 'libreproBLAS.2.dylib'
