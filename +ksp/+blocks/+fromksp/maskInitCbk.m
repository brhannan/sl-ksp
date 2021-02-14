function maskInitCbk(sys)
%KSP.BLOCKS.TOKSP.MASKINITCBK ToKSP block mask initialization callback

validateattributes(sys,{'char'},{})

% check for existence of KRPCServer block
% throws an error if not found
ksp.blocks.getKRPCServerBlockPath(sys);

end
