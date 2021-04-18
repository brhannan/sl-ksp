function openOrbitExample()
%KSP.OPENORBITEXAMPLE Load KSP Toolbox orbit example.

%    Copyright 2020 Brian Hannan.

% edit sys.path if <sl-ksp root>/src is not on it already
ksp.addSrcToPythonPath();

% open example model
mdl = 'orbitdemo';
open_system(mdl)

end