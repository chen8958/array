clc;
clear all;
dic=30:60:330;
for i=1:length(dic)
[y(i,:,:),fs]=audioread(['model_matching' num2str(dic(i)) '.wav']);
end

itd=zeros(length(dic),2);
ild=zeros(length(dic),2);


for i=1:length(dic)
% [c,lags] = xcorr(conv(y,leftfilter),conv(y,rightfilter));
[c,lags] = xcorr(y(i,:,1),y(i,:,2));
stem(lags,c);
title(['now=' num2str(i)]);
[val,idx]=max(c);
itd(i,:)=[dic(i),lags(idx)];
end

for i=1:length(dic)
l_sound=fft(y(i,:,1));
r_sound=fft(y(i,:,2));
ild(i,:)=[dic(i),sum(abs(l_sound.*l_sound))/sum(abs(r_sound.*r_sound))];
end
plot(dic,mag2db(ild(:,2)))
