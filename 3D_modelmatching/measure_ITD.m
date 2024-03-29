clc;
clear all;
itd=zeros(9,12);
ild=zeros(9,12);

dic=0:30:330;
elevation = [0,10,20,30,60,70,80];
for j=1:length(elevation)
dirname=sprintf("model_matching_24mic_%dele",elevation(j));
cd(dirname);
for i=1:length(dic)
[y(i,:,:),fs]=audioread(['model_matching_sor' num2str(dic(i)) 'ele' num2str(elevation(j)) '.wav']);
end
for i=1:length(dic)
% [c,lags] = xcorr(conv(y,leftfilter),conv(y,rightfilter));
[c,lags] = xcorr(y(i,:,1),y(i,:,2));
% stem(lags,c);
% title(['now=' num2str(i)]);
[val,idx]=max(c);
itd(elevation(j)/10+1,i)=lags(idx);
end

for i=1:length(dic)
l_sound=fft(y(i,:,1));
r_sound=fft(y(i,:,2));
ild(elevation(j)/10+1,i)=sum(abs(l_sound.*l_sound))/sum(abs(r_sound.*r_sound));
end
cd('..');
end

elevation = 40;
dic=[0,32,58,90,122,148,180,212,238,270,302,328];
dirname=sprintf("model_matching_24mic_%dele",elevation);
cd(dirname);
for i=1:length(dic)
[y(i,:,:),fs]=audioread(['model_matching_sor' num2str(dic(i)) 'ele' num2str(elevation) '.wav']);
end
for i=1:length(dic)
% [c,lags] = xcorr(conv(y,leftfilter),conv(y,rightfilter));
[c,lags] = xcorr(y(i,:,1),y(i,:,2));
% stem(lags,c);
% title(['now=' num2str(i)]);
[val,idx]=max(c);
itd(elevation/10+1,i)=lags(idx);
end
for i=1:length(dic)
l_sound=fft(y(i,:,1));
r_sound=fft(y(i,:,2));
ild(elevation/10+1,i)=sum(abs(l_sound.*l_sound))/sum(abs(r_sound.*r_sound));
end
cd('..');

elevation = 50;
dic=[0,32,64,88,120,152,176,208,240,272,304,328];
dirname=sprintf("model_matching_24mic_%dele",elevation);
cd(dirname);
for i=1:length(dic)
[y(i,:,:),fs]=audioread(['model_matching_sor' num2str(dic(i)) 'ele' num2str(elevation) '.wav']);
end
for i=1:length(dic)
% [c,lags] = xcorr(conv(y,leftfilter),conv(y,rightfilter));
[c,lags] = xcorr(y(i,:,1),y(i,:,2));
% stem(lags,c);
% title(['now=' num2str(i)]);
[val,idx]=max(c);
itd(elevation/10+1,i)=lags(idx);
end
for i=1:length(dic)
l_sound=fft(y(i,:,1));
r_sound=fft(y(i,:,2));
ild(elevation/10+1,i)=sum(abs(l_sound.*l_sound))/sum(abs(r_sound.*r_sound));
end
cd('..');
figure(1);
contourf(0:30:330,0:10:80,mag2db(ild));
xlabel("azimuth");
ylabel("elevation");
title("ILD beta=0.001");
colorbar;
figure(2);
contourf(0:30:330,0:10:80,itd);
xlabel("azimuth");
ylabel("elevation");
title("ITD beta=0.001");
colorbar;




%
% figure(1);
% plot(dic,mag2db(ild(:,2)));
% xlabel("angle");
% ylabel("dB");
% title(["model matching 8mic 24sor ILD"]);
% 
% figure(2);
% plot(dic,(itd(:,2)/44.1))
% xlabel("angle");
% ylabel("ms");
% title(["model matching 8mic 24sor ITD"]);
% cd('..');
