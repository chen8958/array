% 
% fprintf("selec left channel :\n");
% [filenameL, pathname]=uigetfile({'*.wav'},'File Selector');             % ��ܭ���
% [leftfilter,fsL]=audioread([pathname filenameL]);
% 
% fprintf("selec right channel :\n");
% [filenameR, pathname]=uigetfile({'*.wav'},'File Selector');             % ��ܭ���
% [rightfilter,fsR]=audioread([pathname filenameR]);
% 
% % fprintf("selec wav :\n");
% % [filename, pathname]=uigetfile({'*.wav'},'File Selector');             % ��ܭ���
% % [wavfile,fs]=audioread([pathname filename]);
% [wavfile,fs]=audioread(['female_16k_10s.wav']);
% 
% output(:,1)=conv(wavfile,leftfilter);
% output(:,2)=conv(wavfile,rightfilter);
% audiowrite(filenameL,output,fs);

%%
dic=0:15:345;
cd('elev0');
for i=1:length(dic)
    if dic(i)==0   
        filenameL=sprintf('L0e000a.wav');
        [leftfilter,fsL]=audioread([filenameL]);
        M(1,i,:)=fft(leftfilter);
        filenameR=sprintf('R0e000a.wav');
        [rightfilter,fsR]=audioread([filenameR]);
        M(2,i,:)=fft(rightfilter);
    elseif dic(i)<100
        filenameL=sprintf('L0e0%da.wav',dic(i));
        [leftfilter,fsL]=audioread([filenameL]);
        M(1,i,:)=fft(leftfilter);
        filenameR=sprintf('R0e0%da.wav',dic(i));
        [rightfilter,fsR]=audioread([filenameR]);
        M(2,i,:)=fft(rightfilter);
    else
        filenameL=sprintf('L0e%da.wav',dic(i));
        [leftfilter,fsL]=audioread([filenameL]);
        M(1,i,:)=fft(leftfilter);
        filenameR=sprintf('R0e%da.wav',dic(i));
        [rightfilter,fsR]=audioread([filenameR]);
        M(2,i,:)=fft(rightfilter);
    end
end
cd('..');
% 
% cd('elev0');
% filenameL=sprintf('L0e000a.wav');
% [leftfilter,fsL]=audioread([filenameL]);
% M(1,1,:)=leftfilter;
% filenameR=sprintf('R0e000a.wav');
% [rightfilter,fsR]=audioread([filenameR]);
% M(2,1,:)=leftfilter;
% cd('..');
% 
% for i = 30:30:90
%     cd('elev0');
%     filenameL=sprintf('L0e0%da.wav',i);
%     [leftfilter,fsL]=audioread([filenameL]);
%     filenameR=sprintf('R0e0%da.wav',i);
%     [rightfilter,fsR]=audioread([filenameR]);
%     cd('..');
% %     [wavfile,fs]=audioread(['female_16k_10s.wav']);
% %     output(:,1)=conv(wavfile,leftfilter);
% %     output(:,2)=conv(wavfile,rightfilter);
% %     audiowrite(filenameL,output,fs);
% 
% end
% for i = 120:30:330
%     cd('elev0');
%     filenameL=sprintf('L0e%da.wav',i);
%     [leftfilter,fsL]=audioread([filenameL]);
%     filenameR=sprintf('R0e%da.wav',i);
%     [rightfilter,fsR]=audioread([filenameR]);
%     cd('..');
% %     [wavfile,fs]=audioread(['female_16k_10s.wav']);
% %     output(:,1)=conv(wavfile,leftfilter);
% %     output(:,2)=conv(wavfile,rightfilter);
% %     audiowrite(filenameL,output,fs);
% end