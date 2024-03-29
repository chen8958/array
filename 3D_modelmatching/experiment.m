angle_mic=0:15:345;
%MicPos=(1/100)*9.95*[sind(angle_mic);cosd(angle_mic);zeros(1,length(angle_mic))];
MicPos=(1/100)*12*[sind(angle_mic);cosd(angle_mic);zeros(1,length(angle_mic))];
[D MicNum]=size(MicPos);
folder_location=pwd;
elevation = [0,10,20,30,60,70,80];
angle = 0:30:330;
% dirname=sprintf("experiment_model_matching_%dmic_%dele",length(MicPos),0);
% system_call=sprintf("mkdir %s",dirname);
% system(system_call);
% %H_filter=model_matching(angle,MicPos,0,dirname);
% H_filter=model_matching_real_propagation(angle,MicPos,0,dirname);
% for i=1:length(angle)
%     display(angle(i));
%     experiment_filtering(angle_mic,H_filter,angle(i),0,dirname);
% end


for j= 1:length(elevation)
dirname=sprintf("experiment_model_matching_%dmic_%dele",length(MicPos),elevation(j));
% dirname=sprintf("experiment_TUMIF_model_matching_%dmic_%dele",length(MicPos),elevation(j));
system_call=sprintf("mkdir %s",dirname);
system(system_call);
% H_filter=model_matching(angle,MicPos,elevation(j),dirname);
% H_filter=TUMIF(angle,MicPos,elevation(j),dirname);
H_filter=model_matching_real_propagation(angle,MicPos,elevation(j),dirname,angle);
for i=1:length(angle)
    display(angle(i));
    experiment_filtering(angle_mic,H_filter,angle(i),elevation(j),dirname);
end
end


elevation = 40;
angle=[0,32,58,90,122,148,180,212,238,270,302,328];
dirname=sprintf("experiment_model_matching_%dmic_%dele",length(MicPos),elevation);
% dirname=sprintf("experiment_TUMIF_model_matching_%dmic_%dele",length(MicPos),elevation);
system_call=sprintf("mkdir %s",dirname);
system(system_call);
im_angle=0:30:330;
% H_filter=model_matching(angle,MicPos,elevation,dirname);
%H_filter=TUMIF(angle,MicPos,elevation,dirname);
H_filter=model_matching_real_propagation(angle,MicPos,elevation,dirname,im_angle);
for i=1:length(angle)
    
    display(angle(i));
    experiment_filtering(angle_mic,H_filter,im_angle(i),elevation,dirname);
    %filtering(MicNum,H_filter,angle(i),elevation,dirname);
end

elevation = 50;
angle=[0,32,64,88,120,152,176,208,240,272,304,328];
dirname=sprintf("experiment_model_matching_%dmic_%dele",length(MicPos),elevation);
% dirname=sprintf("experiment_TUMIF_model_matching_%dmic_%dele",length(MicPos),elevation);
system_call=sprintf("mkdir %s",dirname);
system(system_call);
% H_filter=model_matching(angle,MicPos,elevation,dirname);
%H_filter=TUMIF(angle,MicPos,elevation,dirname);
H_filter=model_matching_real_propagation(angle,MicPos,elevation,dirname,im_angle);
for i=1:length(angle)

    display(angle(i));
    experiment_filtering(angle_mic,H_filter,im_angle(i),elevation,dirname);
    %filtering(MicNum,H_filter,angle(i),elevation,dirname);
end
















