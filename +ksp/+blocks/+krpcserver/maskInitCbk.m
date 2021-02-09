function maskInitCbk(sys)
%KSP.BLOCKS.KRPSERVER.MASKINITCBK KRPCServer block mask initialization callback

validateattributes(sys,{'char'},{})

% check for existence of ToKSP, FromKSP blocks
% throws an error if not found
ksp.blocks.getToKSPBlockPath(sys);
ksp.blocks.getFromKSPBlockPath(sys);

end
