function experiment_filtering(angle_mic,H_filter,wav_direction,elevation,dirname)
cd("C:\Users\chen\array\measure\impulse");

for i=1:length(angle_mic)
    load(['freq_azi' num2str(angle_mic(i)) 'mic' num2str(wav_direction) '.mat']);
    p_source(i,:)=m;
end
y=zeros(2,length(conv(p_source(1,:),reshape(H_filter(1,1,:),[1 length(H_filter)]))));
for i=1:length(angle_mic)
y(1,:)=y(1,:)+conv(p_source(i,:),reshape(real(H_filter(1,i,:)),[1 length(H_filter)]));
y(2,:)=y(2,:)+conv(p_source(i,:),reshape(real(H_filter(2,i,:)),[1 length(H_filter)]));
end
cd("C:\Users\chen\array\3D_modelmatching");
cd(dirname);
audiowrite(['model_matching_sor' num2str(wav_direction) 'ele' num2str(elevation) '.wav'],y.'/(max(abs(y),[],'all')),44100);
cd('..');
end