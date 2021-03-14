function loadSuborbitalFlightExample()
%KSP.LOADSUBORBITALFLIGHTEXAMPLE Load KSP Toolbox suborbital example.

slksproot = ksp.getSlkspRootDir();
examplePrj = fullfile(slksproot,'Slksp.prj');
openProject(examplePrj);

end