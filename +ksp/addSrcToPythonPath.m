function addSrcToPythonPath()
%KSP.ADDSRCTOPYTHONPATH Add <sl-ksp root>/src to the Python path.

proj = currentProject();
root = proj.RootFolder;
srcFldr = fullfile(root,'src');

cd(srcFldr)
insert(py.sys.path,int32(0),pwd);

cd(root)

end