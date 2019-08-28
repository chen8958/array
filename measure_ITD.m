clc;
clear all;
dirname="model_matching_8mic_24sor";
cd(dirname);
dic=0:15:345;
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
figure(1);
plot(dic,mag2db(ild(:,2)));
xlabel("angle");
ylabel("dB");
title(["model matching 8mic 24sor ILD"]);

figure(2);
plot(dic,(itd(:,2)/44.1))
xlabel("angle");
ylabel("ms");
title(["model matching 8mic 24sor ITD"]);
cd('..');
