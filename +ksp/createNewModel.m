function createNewModel()
%KSP.CREATENEWMODEL Create a new KSP Toolbox model.
%   KSP.CREATENEWMODEL opens a new Simulink model. The model's solver is
%   set to Fixed-Step with step size 0.1. The following blocks are added to
%   the model: KRPCServer, ToKSP, FromKSP.
%
%   % EXAMPLE:
%       ksp.createNewModel
%
%   See also KSP.BUS.GETALL

hs = new_system();
open_system(hs);
set_param(hs,'Solver','FixedStepAuto');
set_param(hs,'FixedStep','0.1');

bdname = get_param(hs,'Name');

blkName = 'KRPCServer';
src = sprintf('ksplib/%s',blkName);
kspSrvDst = sprintf('%s/%s',bdname,blkName);
add_block(src,kspSrvDst,'Position',[416,36,566,121]);

blkName = 'FromKSP';
src = sprintf('ksplib/%s',blkName);
fromKspDst = sprintf('%s/%s',bdname,blkName);

add_block(src,fromKspDst,'Position',[225,294,310,356]);

termDst = sprintf('%s/Terminator',bdname);
add_block('simulink/Commonly Used Blocks/Terminator',termDst, ...
    'Position',[385,315,405,335]);

add_line(bdname,'FromKSP/1','Terminator/1');

blkName = 'ToKSP';
src = sprintf('ksplib/%s',blkName);
toKspDst = sprintf('%s/%s',bdname,blkName);
add_block(src,toKspDst,'Position',[665,294,755,356]);

blkName = 'CreateToKSPBus';
src = sprintf('ksplib/%s',blkName);
constDst = sprintf('%s/%s',bdname,blkName);
add_block(src,constDst,'Position',[505,305,590,345]);

add_line(bdname,'CreateToKSPBus/1','ToKSP/1');

constAnnot = Simulink.Annotation(bdname, ...
    'Creates bus kspTxOut.');
constAnnot.Position = [575,397,685,433];

end % createNewModel