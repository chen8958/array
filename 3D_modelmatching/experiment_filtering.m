function experiment_filtering(angle_mic,H_filter,wav_direction,elevation,dirname)
cd("..")
cd(".\measure\impulse");

for i=1:length(angle_mic)
    load(['freq_azi' num2str(angle_mic(i)) 'mic' num2str(wav_direction) '.mat']);
    p_source(i,:)=m;
end

% y=zeros(2,length(conv(p_source(1,:),reshape(H_filter(1,1,:),[1 length(H_filter)]))));
% for i=1:length(angle_mic)
% y(1,:)=y(1,:)+conv(p_source(i,:),reshape(H_filter(1,i,:),[1 length(H_filter)]));
% y(2,:)=y(2,:)+conv(p_source(i,:),reshape(H_filter(2,i,:),[1 length(H_filter)]));
% end

for i=1:length(angle_mic)
    P(i,:)=fft(p_source(i,:));
end
for i=1:length(angle_mic)
    H(1,i,:)=fft(H_filter(1,i,:),length(P));
    H(2,i,:)=fft(H_filter(2,i,:),length(P));
end
for i=1:length(P)
    Y(:,:,i)=H(:,:,i)*P(:,i);
end

y(1,:)=ifft(reshape(Y(1,1,:),[1,length(Y)]));
y(2,:)=ifft(reshape(Y(2,1,:),[1,length(Y)]));





cd("..");
cd("..");
cd(".\3D_modelmatching");
cd(dirname);
audiowrite(['model_matching_sor' num2str(wav_direction) 'ele' num2str(elevation) '.wav'],y.'/(max(abs(y),[],'all')),44100);
cd('..');
end