function p = getSlkspRootDir()
%KSP.GETSLKSPROOTDIR returns the path to the sl-ksp folder.
%   P = SLKSP.GETSLKSPROOTDIR returns the full path to the parent directory
%   of the the /+ksp folder in character array P.

fileFullPath = mfilename('fullpath');
% call fileparts twice to remove (1) file name and (2) +ksp folder name
% this leaves '< some local path>/sl-ksp'
p = fileparts(fileparts(fileFullPath));

end