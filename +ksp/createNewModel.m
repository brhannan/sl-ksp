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

%    Copyright 2020 Brian Hannan.

% Open a new model and set solver parameters.
hs = new_system();
open_system(hs);
set_param(hs,'Solver','FixedStepAuto');
set_param(hs,'FixedStep','0.1');

bdname = get_param(hs,'Name');

% Copy ksplib blocks to the model.
% KRPCServer
blkName = 'KRPCServer';
src = sprintf('ksplib/%s',blkName);
kspSrvDst = sprintf('%s/%s',bdname,blkName);
add_block(src,kspSrvDst,'Position',[416,36,566,121]);
% FromKSP
blkName = 'FromKSP';
src = sprintf('ksplib/%s',blkName);
fromKspDst = sprintf('%s/%s',bdname,blkName);
add_block(src,fromKspDst,'Position',[225,294,310,356]);
% Connect a Terminator to FromKSP block (to be replaced by user).
termDst = sprintf('%s/Terminator',bdname);
add_block('simulink/Commonly Used Blocks/Terminator',termDst, ...
    'Position',[385,315,405,335]);
add_line(bdname,'FromKSP/1','Terminator/1');
% ToKSP
blkName = 'ToKSP';
src = sprintf('ksplib/%s',blkName);
toKspDst = sprintf('%s/%s',bdname,blkName);
add_block(src,toKspDst,'Position',[665,294,755,356]);
% Add a Constant that produces the ToKSP input bus (to be replaced by
% user).
blkName = 'CreateToKSPBus';
src = sprintf('ksplib/%s',blkName);
constDst = sprintf('%s/%s',bdname,blkName);
add_block(src,constDst,'Position',[505,305,590,345]);
add_line(bdname,'CreateToKSPBus/1','ToKSP/1');
% Add comments to the canvas.
constAnnot = Simulink.Annotation(bdname, ...
    'Enter command >> buseditor to view contents of kspTxIn bus.');
constAnnot.Position = [390,415,665,427];
cmdsAnnot = Simulink.Annotation(bdname,                             ...
    ['Enter commands >> ksp.bus.getAll; kspTxIn0 = '                ...
    'Simulink.Bus.createMATLABStruct(''kspTxIn'') to create all '   ...
    'workspace data.']);
cmdsAnnot.Position = [271,385,828,397];

% Set up base WS data.
evalin('base','ksp.bus.getAll;')
evalin('base','kspTxIn0 = Simulink.Bus.createMATLABStruct(''kspTxIn'');')

end % createNewModel