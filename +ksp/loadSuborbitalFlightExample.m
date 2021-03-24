function loadSuborbitalFlightExample()
%KSP.LOADSUBORBITALFLIGHTEXAMPLE Load KSP Toolbox suborbital example.

%    Copyright 2020 Brian Hannan.

slksproot = ksp.getSlkspRootDir();
examplePrj = fullfile(slksproot,'Slksp.prj');
openProject(examplePrj);

end