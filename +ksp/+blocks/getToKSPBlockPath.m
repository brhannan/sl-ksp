function p = getToKSPBlockPath(sys)
%KSP.BLOCKS.GETTOKSPBLOCKPATH Get path to ToKSP block
%   P = KSP.BLOCKS.GETTOKSPBLOCKPATH(SYS) returns P, the path to the ToKSP
%   block in system SYS. SYS is a character array containing the name of an open
%   model. An error is thrown if SYS does not contain exactly one ToKSP block.

validateattributes(sys,{'char'},{})
if ~bdIsLoaded(sys)
    error('ksp:blocks:getToKSPBlockPath:systemNotLoaded', ...
        'System "%s" is not loaded.',sys);
end
if bdIsLibrary(sys)
    error('ksp:blocks:getToKSPBlockPath:systemNotMdl', ...
        'System "%s" is not a model file.',sys);
end

blks = find_system(sys,'MaskType','ToKSP');

numBlocksFound = numel(blks);
if numBlocksFound ~= 1
    error('ksp:blocks:getToKSPBlockPath:incorrectNumBlksFound',   ...
        ['System %s was expected to contain 1 ToKSP block. ',     ...
        'Instead it contained %i.'],sys,numBlocksFound);
end

p = blks{1};

end % getToKSPBlockPath
