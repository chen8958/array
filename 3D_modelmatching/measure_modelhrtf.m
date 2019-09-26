clc;
clear all;
itd=zeros(9,12);
ild=zeros(9,12);

dic=0:30:330;
elevation = [0,10,20,30,60,70,80];
for j=1:length(elevation)
dirname=sprintf("model_matching_72mic_%dele",elevation(j));
cd(dirname);
for i=1:length(dic)
    
        [y(i,:,1),fs]=audioread(['L' num2str(elevation(j)) 'ele' num2str(dic(i)) 'a.wav']);
        [y(i,:,2),fs]=audioread(['R' num2str(elevation(j)) 'ele' num2str(dic(i)) 'a.wav']);
    
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
dirname=sprintf("model_matching_72mic_%dele",elevation);
cd(dirname);
for i=1:length(dic)
    [y(i,:,1),fs]=audioread(['L' num2str(elevation) 'ele' num2str(dic(i)) 'a.wav']);
    [y(i,:,2),fs]=audioread(['R' num2str(elevation) 'ele' num2str(dic(i)) 'a.wav']);
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
dirname=sprintf("model_matching_72mic_%dele",elevation);
cd(dirname);
for i=1:length(dic)
    [y(i,:,1),fs]=audioread(['L' num2str(elevation) 'ele' num2str(dic(i)) 'a.wav']);
    [y(i,:,2),fs]=audioread(['R' num2str(elevation) 'ele' num2str(dic(i)) 'a.wav']);
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
title("ILD");
colorbar;
figure(2);
contourf(0:30:330,0:10:80,itd);
xlabel("azimuth");
ylabel("elevation");
title("ITD");
colorbar;
