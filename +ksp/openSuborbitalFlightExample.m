function openSuborbitalFlightExample()
%KSP.OPENSUBORBITALFLIGHTEXAMPLE Load KSP Toolbox suborbital example.

%    Copyright 2020 Brian Hannan.

% edit sys.path if <sl-ksp root>/src is not on it already
ksp.addSrcToPythonPath();

% open example model
mdl = 'kspdemo';
open_system(mdl)

end