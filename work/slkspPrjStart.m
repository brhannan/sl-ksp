function slkspPrjStart()
%SLKSPPRJSTART sl-ksp project startup tasks

% edit sys.path if <sl-ksp root>/src is not on it already
ksp.addSrcToPythonPath();

% open example model
mdl = 'kspdemo';
open_system(mdl)

end