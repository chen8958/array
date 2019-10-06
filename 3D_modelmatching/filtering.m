function filtering(MicNum,H_filter,wav_direction,elevation,dirname)
for i=1:MicNum
    [p(i,:) fs]=audioread("p"+i+".wav");
    p_source(i,:)=resample(p(i,:),44100,fs);
end
% y=zeros(2,length(conv(p_source(1,:),reshape(H_filter(1,1,:),[1 length(H_filter)]))));
% for i=1:MicNum
% y(1,:)=y(1,:)+conv(p_source(i,:),reshape(real(H_filter(1,i,:)),[1 length(H_filter)]));
% y(2,:)=y(2,:)+conv(p_source(i,:),reshape(real(H_filter(2,i,:)),[1 length(H_filter)]));
% end


for i=1:MicNum
    P(i,:)=fft(p_source(i,:));
end
for i=1:MicNum
    H(1,i,:)=fft(H_filter(1,i,:),length(P));
    H(2,i,:)=fft(H_filter(2,i,:),length(P));
end
for i=1:length(P)
    Y(:,:,i)=H(:,:,i)*P(:,i);
end

y(1,:)=ifft(reshape(Y(1,1,:),[1,length(Y)]));
y(2,:)=ifft(reshape(Y(2,1,:),[1,length(Y)]));


cd(dirname);
audiowrite(['model_matching_sor' num2str(wav_direction) 'ele' num2str(elevation) '.wav'],y.'/(max(abs(y),[],'all')),44100);
cd('..');
end
