%8sor with 2.8radius
angle_mic=0:45:315;
MicPos=(1/100)*2.8*[sind(angle_mic);cosd(angle_mic);zeros(1,length(angle_mic))];
%
angle = 0:5:355;
dirname=sprintf("model_matching_%dmic_%dsor",length(MicPos),length(angle));
system_call=sprintf("mkdir %s",dirname);
system(system_call);
for i=1:length(angle)
    
    %[P_half SorPos SorLen p]=Mix3D_Plan_HRTF_function(MicPos,[angle(i),90;angle(i)+180,90]);
    [P_half SorPos SorLen p]=Mix3D_Plan_HRTF_function(MicPos,[angle(i),90]);
    display(angle(i));
    model_matching(angle,MicPos,angle(i),dirname);
    
end

surround(angle,dirname);
