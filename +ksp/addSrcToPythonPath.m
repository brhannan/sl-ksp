function addSrcToPythonPath()
%KSP.ADDSRCTOPYTHONPATH Add <sl-ksp root>/src to sys.path.
%   KSP.ADDSRCTOPYTHONPATH adds <sl-ksp root folder>/src/ to sys.path. This
%   allows Python to use .../src/slksp.py, which is used by KSP Toolbox to
%   communicate with KSP.
%
%   This function should be used only during KSP Toolbox setup.
%
%   % EXAMPLE:
%       ksp.addSrcToPythonPath

% go to /src
proj = currentProject();
root = proj.RootFolder;
srcFldr = fullfile(root,'src');
cd(srcFldr)

% is <project root>/src on the python path?
cwdIsOnPyPath = isCurrDirOnPyPath();

% add .../src to path if it isn't there yet
if cwdIsOnPyPath
    fprintf(['%s is already in sys.path. sys.path will not be ' ...
        'modified.\n'],pwd);
else
    fprintf('Adding %s to sys.path.\n',pwd);
    insert(py.sys.path,int32(0),pwd);
end

% return to project root dir
cd(root)

end % addSrcToPythonPath


%--------------------------------------------------------------------------
function tf = isCurrDirOnPyPath()
% returns true if cwd is on python path

myPyPath = py.sys.path;
% convert from list to cell array
myPyPathCell = cellfun(@char,cell(myPyPath),'UniformOutput',false);
% is cwd on python path?
tf = any(strcmp(pwd,myPyPathCell));

end % isCurrDirOnPyPath