function p = getKRPCServerBlockPath(sys)
%KSP.BLOCKS.GETKPRCSERVERBLOCKPATH Get path to FromKSP block
%   P = KSP.BLOCKS.GETKPRCSERVERBLOCKPATH(SYS) returns P, the path to the
%   KRPCServer block in system SYS. SYS is a character array containing the name
%   of an open model. An error is thrown if SYS does not contain exactly one
%   KRPCServer block.

validateattributes(sys,{'char'},{})
if ~bdIsLoaded(sys)
    error('ksp:blocks:getKRPCServerBlockPath:systemNotLoaded', ...
        'System "%s" is not loaded.',sys);
end
if bdIsLibrary(sys)
    error('ksp:blocks:getKRPCServerBlockPath:systemNotMdl', ...
        'System "%s" is not a model file.',sys);
end

blks = find_system(sys,'MaskType','KRPCServer');

numBlocksFound = numel(blks);
if numBlocksFound ~= 1
    error('ksp:blocks:getKRPCServerBlockPath:incorrectNumBlksFound',   ...
        ['System %s was expected to contain 1 KRPCServer block. ',     ...
        'Instead it contained %i.'],sys,numBlocksFound);
end

p = blks{1};

end % getKRPCServerBlockPath
