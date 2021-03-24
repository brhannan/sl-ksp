function addSrcToPythonPath()
%KSP.ADDSRCTOPYTHONPATH Add <sl-ksp root>/src to sys.path.
%   KSP.ADDSRCTOPYTHONPATH adds <sl-ksp root folder>/src/ to sys.path. This
%   allows Python to use .../src/slksp.py, which is used by KSP Toolbox to
%   communicate with KSP.
%
%   Before using this function, ensure that the MATLAB Engine API for
%   Python is set up. See MATLAB documentation for more info on the MATLAB 
%   Engine API for Python. If this step has not been completed, an error 
%   will be thrown.
%
%   See KSP Toolbox documentation or the MATLAB documentation page
%   "Get Started with MATLAB Engine API for Python" for more info.
%
%   % EXAMPLE:
%       ksp.addSrcToPythonPath

%    Copyright 2020 Brian Hannan.

% make sure MATLAB/Python are set up correctly before py commands are used
checkPythonMLSetup();

% go to /src
slksproot = ksp.getSlkspRootDir();
srcFldr = fullfile(slksproot,'src');
if exist(srcFldr,'dir') ~= 7
    error('ksp:addSrcToPythonPath:srcDirNotFound', ...
        ['Unable to find KSP src folder. This folder was expected to ' ...
        'be found at "%s".',srcFldr]);
end

% is '<project root>/src' on the Python path?
srcIsOnPyPath = isDirOnPyPath(srcFldr);

% add .../src to path if it isn't there yet
if srcIsOnPyPath
    % Do nothing.
    % Lines below are commented because this functiion is called in example
    % project startup and the diagnostic below is not useful when called
    % from a startup callback.
    % fprintf(['%s is already in sys.path. sys.path will not be ' ...
    %    'modified.\n'],pwd);
else
    fprintf('Adding "%s" to Python sys.path.\n',srcFldr);
    insert(py.sys.path,int32(0),srcFldr);
end

end % addSrcToPythonPath


%--------------------------------------------------------------------------
function tf = isDirOnPyPath(p)
% returns true if input P is on python path

validateattributes(p,{'char'},{})
myPyPath = py.sys.path;
% convert from list to cell array
myPyPathCell = cellfun(@char,cell(myPyPath),'UniformOutput',false);
% is input path p on python path?
tf = any(strcmp(p,myPyPathCell));

end % isDirOnPyPath


%--------------------------------------------------------------------------
function checkPythonMLSetup()
% Make sure that MATLAB and Python are talking to each other. Errors if
% they aren't. This prevents mysterious "py.<some python command>" not
% found errors from happening.

try
    % try a py command that will be used by addSrcToPythonPath()
    py.sys.path;
catch
    % print help message if it failed
    error('ksp:addSrcToPythonPath:invalidPythonSetup',                  ...
        ['MATLAB API Engine for Python is not set up correctly. The '   ...
        'command\npy.sys.path\n'                                        ...
        'failed. See KSP Toolbox documentation or\n'                    ...
        'https://www.mathworks.com/help/matlab/matlab_external/'        ...
        'get-started-with-matlab-engine-for-python.html\n'              ...
        'for help.']);
end

end % checkPythonMLSetup