clc;
clear all;
itd=zeros(1,24);
ild=zeros(1,24);

dic=0:15:345;

dirname=sprintf("experiment_model_matching_24mic_0ele");
cd(dirname);
for i=1:length(dic)
[y(i,:,:),fs]=audioread(['model_matching_sor' num2str(dic(i)) 'ele0.wav']);
end

for i=1:length(dic)
% [c,lags] = xcorr(conv(y,leftfilter),conv(y,rightfilter));
[c,lags] = xcorr(y(i,:,1),y(i,:,2));
% stem(lags,c);
% title(['now=' num2str(i)]);
[val,idx]=max(c);
itd(i)=lags(idx);
end

for i=1:length(dic)
l_sound=fft(y(i,:,1));
r_sound=fft(y(i,:,2));
ild(i)=sum(abs(l_sound.*l_sound))/sum(abs(r_sound.*r_sound));
end
cd('..');


% 
% figure(1);
% contourf(0:30:330,0:10:80,mag2db(ild));
% xlabel("azimuth");
% ylabel("elevation");
% title("ILD beta=0.001");
% colorbar;
% figure(2);
% contourf(0:30:330,0:10:80,itd);
% xlabel("azimuth");
% ylabel("elevation");
% title("ITD beta=0.001");
% colorbar;
% 
% 
% 
