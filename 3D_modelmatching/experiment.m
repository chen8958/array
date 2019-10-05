angle_mic=0:15:345;
%MicPos=(1/100)*9.95*[sind(angle_mic);cosd(angle_mic);zeros(1,length(angle_mic))];
MicPos=(1/100)*15*[sind(angle_mic);cosd(angle_mic);zeros(1,length(angle_mic))];
[D MicNum]=size(MicPos);
%
folder_location=pwd;

angle = 0:15:345;
%dirname=sprintf("model_matching_%dmic_%dsor",length(MicPos),length(angle));
dirname=sprintf("experiment_model_matching_%dmic_%dele",length(MicPos),0);
system_call=sprintf("mkdir %s",dirname);
system(system_call);
H_filter=model_matching(angle,MicPos,0,dirname);
for i=1:length(angle)
    %[P_half SorPos SorLen p]=Mix3D_Plan_HRTF_function(MicPos,[angle(i),90]);
    display(angle(i));
    experiment_filtering(angle_mic,H_filter,angle(i),0,dirname);
end


