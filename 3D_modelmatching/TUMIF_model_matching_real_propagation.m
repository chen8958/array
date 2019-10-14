function [H_filter]=TUMIF_model_matching_real_propagation(angle,MicPos,elevation,dirname,im_angle)


mic_angle = 0:15:345;
cd('..');
cd('.\measure\impulse');
MicNum=length(mic_angle);
SorNum=length(angle);

for ss = 1:length(im_angle)
    for M =1:length(mic_angle)
        load(['freq_azi' num2str(im_angle(ss)) 'mic' num2str(mic_angle(M)) '.mat']);
        G(M,ss,:)=fft(m);
    end
end

cd('..');
cd('..');
cd('.\3D_modelmatching');
delay=1300;
NFFT=length(G);

%%
%M
%dic=0:15:345;
%dic=[90,45,0,315,270,225,180,135]
dic=angle;
cd(['elev' num2str(elevation)]);
clear M;
for i=1:length(dic)
    if dic(i)<10   
        filenameL=sprintf("L%de00%da.wav",elevation,dic(i));
        [leftfilter,fsL]=audioread([filenameL]);
        leftfilter=[zeros(delay,1);leftfilter];
        tmp=fft(leftfilter,NFFT);
        M(1,i,:)=tmp;
        
        filenameR=sprintf('R%de00%da.wav',elevation,dic(i));
        [rightfilter,fsR]=audioread([filenameR]);
        rightfilter=[zeros(delay,1);rightfilter];
        tmp=fft(rightfilter,NFFT);
        M(2,i,:)=tmp;

    elseif dic(i)<100
        filenameL=sprintf('L%de0%da.wav',elevation,dic(i));
        [leftfilter,fsL]=audioread([filenameL]);
        leftfilter=[zeros(delay,1);leftfilter];
        tmp=fft(leftfilter,NFFT);
        M(1,i,:)=tmp;
        
        filenameR=sprintf('R%de0%da.wav',elevation,dic(i));
        [rightfilter,fsR]=audioread([filenameR]);
        rightfilter=[zeros(delay,1);rightfilter];
        tmp=fft(rightfilter,NFFT);
        M(2,i,:)=tmp;
    else
        filenameL=sprintf('L%de%da.wav',elevation,dic(i));
        [leftfilter,fsL]=audioread([filenameL]);
        leftfilter=[zeros(delay,1);leftfilter];
        tmp=fft(leftfilter,NFFT);
        M(1,i,:)=tmp;
        
        filenameR=sprintf('R%de%da.wav',elevation,dic(i));
        [rightfilter,fsR]=audioread([filenameR]);
        rightfilter=[zeros(delay,1);rightfilter];
        tmp=fft(rightfilter,NFFT);
        M(2,i,:)=tmp;
    end
    %display(['filename = ' filenameL]);
end
cd('..');

%%
%processing
for i=1:length(G)
    %H(:,:,i)=M(:,:,i)*pinv(G(:,:,i));
    %H(:,:,i)=(inv(G(:,:,i)*G(:,:,i)')*G(:,:,i)*M(:,:,i)')';
    H(:,:,i)=(inv(G(:,:,i)*G(:,:,i)'+0.001*eye(size(G(:,:,i),1)))*G(:,:,i)*M(:,:,i)')';
    
    ER(:,:,i)=H(:,:,i)*G(:,:,i);
end
% 
% for i=1:MicNum
%     H_whole(1,i,:)=cat(3,H(1,i,:),conj(fliplr(H(1,i,:))));
%     H_whole(2,i,:)=cat(3,H(2,i,:),conj(fliplr(H(2,i,:))));
% end

% for i=1:2
%     for j=1:MicNum
%         H_pad(i,j,:)=cat(3,H(1,i,:),zeros(1,1),fliplr(conj(H(1,i,2:end))));
%     end
% end
for i=1:MicNum
    H_filter(1,i,:)=ifft(H(1,i,:));
    H_filter(2,i,:)=ifft(H(2,i,:));
end
cd(dirname);
for i=1:SorNum
filename=sprintf('L%dele%da.wav',elevation,dic(i));
audiowrite(filename,ifft(reshape(ER(1,i,:),[length(ER(1,i,:)), 1]) ),44100 );
filename=sprintf('R%dele%da.wav',elevation,dic(i));
audiowrite(filename,ifft(reshape(ER(2,i,:),[length(ER(1,i,:)), 1]) ),44100 );
end
cd("..");


end