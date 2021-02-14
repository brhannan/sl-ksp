function p = getFromKSPBlockPath(sys)
%KSP.BLOCKS.GETFROMKSPBLOCKPATH Get path to FromKSP block
%   P = KSP.BLOCKS.GETFROMKSPBLOCKPATH(SYS) returns P, the path to the FromKSP
%   block in system SYS. SYS is a character array containing the name of an open
%   model. An error is thrown if SYS does not contain exactly one FromKSP block.

validateattributes(sys,{'char'},{})
if ~bdIsLoaded(sys)
    error('ksp:blocks:getFromKSPBlockPath:systemNotLoaded', ...
        'System "%s" is not loaded.',sys);
end
% if bdIsLibrary(sys)
%     error('ksp:blocks:getFromKSPBlockPath:systemNotMdl', ...
%         'System "%s" is not a model file.',sys);
% end

blks = find_system(sys,'MaskType','FromKSP');

numBlocksFound = numel(blks);
if numBlocksFound ~= 1
    error('ksp:blocks:getFromKSPBlockPath:incorrectNumBlksFound',   ...
        ['System %s was expected to contain 1 FromKSP block. ',     ...
        'Instead it contained %i.'],sys,numBlocksFound);
end

p = blks{1};

end % getFromKSPBlockPath
