clc;
clear all;
itd=zeros(9,12);
ild=zeros(9,12);

dic=0:30:330;
elevation = [0,10,20,30,60,70,80];
for j=1:length(elevation)
dirname=sprintf("elev%d",elevation(j));
cd(dirname);
for i=1:length(dic)
    if dic(i)>100
        [y(i,:,1),fs]=audioread(['L' num2str(elevation(j)) 'e' num2str(dic(i)) 'a.wav']);
        [y(i,:,2),fs]=audioread(['R' num2str(elevation(j)) 'e' num2str(dic(i)) 'a.wav']);
    elseif dic(i)>10
        [y(i,:,1),fs]=audioread(['L' num2str(elevation(j)) 'e0' num2str(dic(i)) 'a.wav']);
        [y(i,:,2),fs]=audioread(['R' num2str(elevation(j)) 'e0' num2str(dic(i)) 'a.wav']);
    else
        [y(i,:,1),fs]=audioread(['L' num2str(elevation(j)) 'e00' num2str(dic(i)) 'a.wav']);
        [y(i,:,2),fs]=audioread(['R' num2str(elevation(j)) 'e00' num2str(dic(i)) 'a.wav']);
    end
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
dirname=sprintf("elev%d",elevation);
cd(dirname);
for i=1:length(dic)
    if dic(i)>100
        [y(i,:,1),fs]=audioread(['L' num2str(elevation) 'e' num2str(dic(i)) 'a.wav']);
        [y(i,:,2),fs]=audioread(['R' num2str(elevation) 'e' num2str(dic(i)) 'a.wav']);
    elseif dic(i)>10
        [y(i,:,1),fs]=audioread(['L' num2str(elevation) 'e0' num2str(dic(i)) 'a.wav']);
        [y(i,:,2),fs]=audioread(['R' num2str(elevation) 'e0' num2str(dic(i)) 'a.wav']);
    else
        [y(i,:,1),fs]=audioread(['L' num2str(elevation) 'e00' num2str(dic(i)) 'a.wav']);
        [y(i,:,2),fs]=audioread(['R' num2str(elevation) 'e00' num2str(dic(i)) 'a.wav']);
    end
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
dirname=sprintf("elev%d",elevation);
cd(dirname);
for i=1:length(dic)
    if dic(i)>100
        [y(i,:,1),fs]=audioread(['L' num2str(elevation) 'e' num2str(dic(i)) 'a.wav']);
        [y(i,:,2),fs]=audioread(['R' num2str(elevation) 'e' num2str(dic(i)) 'a.wav']);
    elseif dic(i)>10
        [y(i,:,1),fs]=audioread(['L' num2str(elevation) 'e0' num2str(dic(i)) 'a.wav']);
        [y(i,:,2),fs]=audioread(['R' num2str(elevation) 'e0' num2str(dic(i)) 'a.wav']);
    else
        [y(i,:,1),fs]=audioread(['L' num2str(elevation) 'e00' num2str(dic(i)) 'a.wav']);
        [y(i,:,2),fs]=audioread(['R' num2str(elevation) 'e00' num2str(dic(i)) 'a.wav']);
    end
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


