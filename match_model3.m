%MicPos=[];
clc;
clear all;
%MicPos=(1/100)*[4.5*cosd(120),4.5*cosd(60),4.5,4.5*cosd(-60),4.5*cosd(-120),-4.5;4.5*sind(120),4.5*sind(60),0,4.5*sind(-60),4.5*sind(-120),0];

% angel=0:15:345;
% MicPos=(1/100)*4.5*[cosd(angel);sind(angel)];
% SorPos=[0 15 30 45 60 75 90 105 120 135 150 165 180 195 210 225 240 255 270 285 300 315 330 345];

% angel=0:60:300;
% MicPos=(1/100)*4.5*[cosd(angel);sind(angel)];
% SorPos=angel;
angel=0:45:315;
MicPos=(1/100)*4.5*[cosd(angel);sind(angel)]
SorPos=angel;

[D MicNum]=size(MicPos);
[D SorNum]=size(SorPos);
fs=44100;
c=343.0;
NWIN=512;
hopsize=NWIN/2;                                                            % 50% overlap
    %% FFT
NFFT=2^nextpow2(NWIN);
df=fs/NFFT;
Freqs=0:df:(NFFT/2-1)*df;
%kappa = [cosd(SorPos(:,1)).*sind(SorPos(:,2)) sind(SorPos(:,1)).*sind(SorPos(:,2)) cosd(SorPos(:,2))];
kappa = [sind(SorPos(:)) cosd(SorPos(:))];
for ff=1:length(Freqs)
    k = 2*pi*Freqs(ff)/c;
    for ss = 1:SorNum
        for m = 1:MicNum
            %G_tmp(m,ss,ff) =exp(1j*k*kappa(ss,:)*MicPos(:,m));
            G_tmp(m,ss,ff) =exp(1j*k*kappa(ss,:)*MicPos(:,m));
        end
    end
end
for ss = 1:SorNum
    for m = 1:MicNum
            G(m,ss,:)=cat(2,reshape(G_tmp(m,ss,:),[1,length(G_tmp)]),zeros(1,1),conj(fliplr(reshape(G_tmp(m,ss,2:end),[1,length(G_tmp)-1]))));
    end
end


%%
%M
%dic=0:15:345;
%dic=[90,45,0,315,270,225,180,135]
dic=angel;
cd('elev0');
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

    elseif dic(i)<100
        filenameL=sprintf('L0e0%da.wav',dic(i));
        [leftfilter,fsL]=audioread([filenameL]);
        tmp=fft(leftfilter);
        M(1,i,:)=tmp;
        
        filenameR=sprintf('R0e0%da.wav',dic(i));
        [rightfilter,fsR]=audioread([filenameR]);
        tmp=fft(rightfilter);
        M(2,i,:)=tmp;
    else
        filenameL=sprintf('L0e%da.wav',dic(i));
        [leftfilter,fsL]=audioread([filenameL]);
        tmp=fft(leftfilter);
        M(1,i,:)=tmp;
        
        filenameR=sprintf('R0e%da.wav',dic(i));
        [rightfilter,fsR]=audioread([filenameR]);
        tmp=fft(rightfilter);
        M(2,i,:)=tmp;
    end
    display(['filename = ' filenameL]);
end
cd('..');

%%
%processing
for i=1:length(G)
    H(:,:,i)=M(:,:,i)*pinv(G(:,:,i));
    
    %H(:,:,i)=(inv(G(:,:,i)*G(:,:,i)')*G(:,:,i)*M(:,:,i)')';
    %H(:,:,i)=(inv(G(:,:,i)*G(:,:,i)'+0.01*eye(size(G(:,:,i),2)))*G(:,:,i)*M(:,:,i)')';
    
    ER(:,:,i)=M(:,:,i)-H(:,:,i)*G(:,:,i);
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


% for i=1:MicNum
%     H_filter_transpose(1,i,1:length(H_filter)/2)= H_filter(1,i,length(H_filter)/2+1:end);
%     H_filter_transpose(1,i,length(H_filter)/2+1:length(H_filter))= H_filter(1,i,1:length(H_filter)/2);
%     H_filter_transpose(2,i,1:length(H_filter)/2)= H_filter(2,i,length(H_filter)/2+1:end);
%     H_filter_transpose(2,i,length(H_filter)/2+1:length(H_filter))= H_filter(2,i,1:length(H_filter)/2);
% 
% end

% for i=1:MicNum
%     for j=1:SorNum
%     G_filter(i,j,:)=ifft(G(i,j,:));
%     G_filter(i,j,:)=ifft(G(i,j,:));
%     end
% end

for i=1:MicNum
    [p(i,:) fs]=audioread("p"+i+".wav");
    p_source(i,:)=resample(p(i,:),44100,fs);
end
y=zeros(2,length(conv(p_source(1,:),reshape(H_filter(1,1,:),[1 length(H_filter)]))));

% for i=1:MicNum
% y(1,:)=y(1,:)+conv(p_source(i,:),reshape(H_filter(1,i,:),[1 1024]));
% y(2,:)=y(2,:)+conv(p_source(i,:),reshape(H_filter(2,i,:),[1 1024]));
% end

for i=1:MicNum
y(1,:)=y(1,:)+conv(p_source(i,:),reshape(real(H_filter_transpose(1,i,:)),[1 length(H_filter)]));
y(2,:)=y(2,:)+conv(p_source(i,:),reshape(real(H_filter_transpose(2,i,:)),[1 length(H_filter)]));
end

audiowrite(['model_matching.wav'],(y.')/max(abs(y.')),44100);
%audiowrite(['model_matching.wav'],abs(y.')/max(abs(y.')),fs);

%audiowrite(['model_matching.wav'],abs(y.'),fs);