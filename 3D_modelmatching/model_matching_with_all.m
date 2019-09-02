%8sor with 2.8radius
angle_mic=0:45:315;
MicPos=(1/100)*2.8*[sind(angle_mic);cosd(angle_mic);zeros(1,length(angle_mic))];
%
folder_location=pwd;
elevation = [0,10,20,30,60,70,80];
for j= 1:length(elevation)
angle = 0:30:330;
%dirname=sprintf("model_matching_%dmic_%dsor",length(MicPos),length(angle));
dirname=sprintf("model_matching_%dmic_%dele",length(MicPos),elevation(j));
system_call=sprintf("mkdir %s",dirname);
system(system_call);
for i=1:length(angle)
    %[P_half SorPos SorLen p]=Mix3D_Plan_HRTF_function(MicPos,[angle(i),90;angle(i)+120,90;angle(i)+240,90]);
    [P_half SorPos SorLen p]=Mix3D_Plan_HRTF_function(MicPos,[angle(i),90]);
    display(angle(i));
    model_matching(angle,MicPos,angle(i),dirname,elevation(j));
end
end

elevation = 40;
angle=[0,32,58,90,122,148,180,212,238,270,302,328];
dirname=sprintf("model_matching_%dmic_%dele",length(MicPos),elevation);
system_call=sprintf("mkdir %s",dirname);
system(system_call);
for i=1:length(angle)
    %[P_half SorPos SorLen p]=Mix3D_Plan_HRTF_function(MicPos,[angle(i),90;angle(i)+120,90;angle(i)+240,90]);
    [P_half SorPos SorLen p]=Mix3D_Plan_HRTF_function(MicPos,[angle(i),90]);
    display(angle(i));
    model_matching(angle,MicPos,angle(i),dirname,elevation);
end
elevation = 50;
angle=[0,32,64,88,120,152,176,208,240,272,304,328];
dirname=sprintf("model_matching_%dmic_%dele",length(MicPos),elevation);
system_call=sprintf("mkdir %s",dirname);
system(system_call);
for i=1:length(angle)
    %[P_half SorPos SorLen p]=Mix3D_Plan_HRTF_function(MicPos,[angle(i),90;angle(i)+120,90;angle(i)+240,90]);
    [P_half SorPos SorLen p]=Mix3D_Plan_HRTF_function(MicPos,[angle(i),90]);
    display(angle(i));
    model_matching(angle,MicPos,angle(i),dirname,elevation);
end
%surround(angle,dirname);
