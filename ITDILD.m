clc;
clear all;
[sound,fs]=audioread(['female_16k_10s.wav']);
y = resample(sound,44100,fs);

dic=0:45:315;
cd('elev0');
itd=zeros(length(dic),2);
ild=zeros(length(dic),2);

fs=44100;
for i=1:length(dic)
    if dic(i)==0   
        filenameL=sprintf('L0e000a.wav');
        [leftfilter,fsL]=audioread([filenameL]);
        tmp=fft(leftfilter);
        M(1,i,:)=tmp;
        filenameR=sprintf('R0e000a.wav');
        [rightfilter,fsR]=audioread([filenameR]);
        tmp=fft(rightfilter);
        M(2,i,:)=tmp;
        
%         l_total=0;
%         r_total=0;
%         l_sound=fft(conv(y,leftfilter));
%         r_sound=fft(conv(y,rightfilter));
        l_sound=fft(leftfilter);
        r_sound=fft(rightfilter);
        ild(i,:)=[dic(i),sum(abs(l_sound.*l_sound))/sum(abs(r_sound.*r_sound))];
%         for j=1:length(l_sound)
%             l_total=
%             r_total=
%         end
        
%         [c,lags] = xcorr(conv(y,leftfilter),conv(y,rightfilter));
% %         [c,lags] = xcorr(leftfilter,rightfilter);
%         stem(lags,c);
%         title(['now=' num2str(i)]);
%         [val,idx]=max(c);
%         itd(i,:)=[dic(i),lags(idx)/fs];
        
    elseif dic(i)<100
        filenameL=sprintf('L0e0%da.wav',dic(i));
        [leftfilter,fsL]=audioread([filenameL]);
        tmp=fft(leftfilter);
        M(1,i,:)=tmp;
        
        filenameR=sprintf('R0e0%da.wav',dic(i));
        [rightfilter,fsR]=audioread([filenameR]);
        tmp=fft(rightfilter);
        M(2,i,:)=tmp;
        
%         l_sound=fft(conv(y,leftfilter));
%         r_sound=fft(conv(y,rightfilter));
        
        l_sound=fft(leftfilter);
        r_sound=fft(rightfilter);
        ild(i,:)=[dic(i),sum(abs(l_sound.*l_sound))/sum(abs(r_sound.*r_sound))];
        
%         [c,lags] = xcorr(conv(y,leftfilter),conv(y,rightfilter));
% %         [c,lags] = xcorr(leftfilter,rightfilter);
%         stem(lags,c)
%         title(['now=' num2str(i)]);
%         [val,idx]=max(c);
%         itd(i,:)=[dic(i),lags(idx)/fs];
    else
        filenameL=sprintf('L0e%da.wav',dic(i));
        [leftfilter,fsL]=audioread([filenameL]);
        tmp=fft(leftfilter);
        M(1,i,:)=tmp;
        
        filenameR=sprintf('R0e%da.wav',dic(i));
        [rightfilter,fsR]=audioread([filenameR]);
        tmp=fft(rightfilter);
        M(2,i,:)=tmp;
        
        
%         l_sound=fft(conv(y,leftfilter));
%         r_sound=fft(conv(y,rightfilter));
        
        l_sound=fft(leftfilter);
        r_sound=fft(rightfilter);
        ild(i,:)=[dic(i),sum(abs(l_sound.*l_sound))/sum(abs(r_sound.*r_sound))];
        
%         [c,lags] = xcorr(conv(y,leftfilter),conv(y,rightfilter));
% %         [c,lags] = xcorr(leftfilter,rightfilter);
%         stem(lags,c)
%         title(['now=' num2str(i)]);
%         [val,idx]=max(c);
%         itd(i,:)=[dic(i),lags(idx)/fs];
    end
end
cd('..');
plot(ild(:,1),mag2db(ild(:,2)));
xlabel('angle');
ylabel('dB');
title('HRTF ILD');
