function p = getPkgRoot()
%GETPKGROOT Return the path to the folder that contains the +ksp folder.
%   P = KSP.UTILS.GETPKGROOT() called with no input arguments returns the 
%   path to the parent of the +ksp package folder in character array P.
%
%   % EXAMPLE:
%       p = ksp.utils.getPkgRoot()

path = fullfile(fileparts(mfilename('fullpath')));
slashIxs = regexp(path,filesep);

if numel(slashIxs) < 2
    error('ksp:utils:getPkgRoot:invalidPath',                       ...
        ['Expected the path to ksp.utils.getPkgRoot() (%s) to ',    ...
        'contain at least two "%s" characters.'],path,filesep);
end

% get second-to-last slash because parent level is two directories up
slashIx = slashIxs(end-1);

if slashIx < 2
    error('ksp:utils:getPkgRoot:invalidPath', ...
        ['Expected final slash (%s) in the path to getPkgRoot.m (%s) '  ...
        'to be at ix>1.'],filesep,path);
end

p = path(1:slashIx-1);

end