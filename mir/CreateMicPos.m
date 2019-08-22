%%
clear all;close all; clc
%% create microphone
fs=16000;
limit_f=1000;
c=343;
r=c/(2*limit_f);    
MicPos1=ucaposition(6,0.1,0,0,0,0);
MicPos=[MicPos1];
%% Mixed Signal
[SorNum P_half SorPos SorLen source]=Mix3D_Pro_function(MicPos);
beta=0.1;
Sep_TIKR(beta,SorNum,MicPos,SorLen,SorPos,P_half);
Sep_DAS(SorNum,MicPos,SorLen,SorPos,P_half);



