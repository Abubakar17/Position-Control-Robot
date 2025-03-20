clc;
%%Creating s1Tuner and configuring it
% Create s1Tuner interface
TunedBlocks = {"PD1", "PD2", "PD3"};
ST0 = slTuner('video7', TunedBlocks);

%Mark outputs of PID blocks as plant inputs
addPoint(ST0,TunedBlocks)

%Mark joint angles as plant outputs
addPoint(ST0,'Robot/qm');

%Mark reference signals
RefSignals = {...
    'video7/Signal Builder/q1','video7/Signal Builder/q2','video7/Signal Builder/q3'};
addPoint(ST0, RefSignals)

%%Defining Input and Output and Tuning the system
Controls = TunedBlocks; %actuator commands
Measurements = 'video7/Robot/qm'; %joint angle measurements
options = looptuneOptions('RandomStart',80','UseParallel',false);
TR = TuningGoal.StepTracking(RefSignals, Measurements, 0.05,0);
ST1 = looptune(ST0,Controls,Measurements,TR,options);

%%Update PID Block
writeBlockValue(ST1)