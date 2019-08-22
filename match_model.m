%MicPos=[];
clc;
clear all;
%MicPos=(1/100)*[4.5*cosd(120),4.5*cosd(60),4.5,4.5*cosd(-60),4.5*cosd(-120),-4.5;4.5*sind(120),4.5*sind(60),0,4.5*sind(-60),4.5*sind(-120),0];

angel=0:15:345;
MicPos=(1/100)*4.5*[cos(angel);sin(angel)];

SorPos=[0 15 30 45 60 75 90 105 120 135 150 165 180 195 210 225 240 255 270 285 300 315 330 345];
[D MicNum]=size(MicPos);
[D SorNum]=size(SorPos);
fs=44100;
c=343.0;
NWIN=1024;
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
            G(m,ss,ff) =exp(1j*k*kappa(ss,:)*MicPos(:,m));
        end
    end
end

%%
%M
dic=0:15:345;
cd('elev0');
for i=1:length(dic)
    if dic(i)==0   
        filenameL=sprintf('L0e000a.wav');
        [leftfilter,fsL]=audioread([filenameL]);
        tmp=fft(cat(1,zeros(512,1),leftfilter));
        M(1,i,:)=tmp(1:length(tmp));
        
        filenameR=sprintf('R0e000a.wav');
        [rightfilter,fsR]=audioread([filenameR]);
        tmp=fft(cat(1,zeros(512,1),rightfilter));
        M(2,i,:)=tmp(1:length(tmp));
    elseif dic(i)<100
        filenameL=sprintf('L0e0%da.wav',dic(i));
        [leftfilter,fsL]=audioread([filenameL]);
        tmp=fft(cat(1,zeros(512,1),leftfilter));
        M(1,i,:)=tmp(1:length(tmp));
        
        filenameR=sprintf('R0e0%da.wav',dic(i));
        [rightfilter,fsR]=audioread([filenameR]);
        tmp=fft(cat(1,zeros(512,1),rightfilter));
        M(2,i,:)=tmp(1:length(tmp));
    else
        filenameL=sprintf('L0e%da.wav',dic(i));
        [leftfilter,fsL]=audioread([filenameL]);
        tmp=fft(cat(1,zeros(512,1),leftfilter));
        M(1,i,:)=tmp(1:length(tmp));
        
        filenameR=sprintf('R0e%da.wav',dic(i));
        [rightfilter,fsR]=audioread([filenameR]);
        tmp=fft(cat(1,zeros(512,1),rightfilter));
        M(2,i,:)=tmp(1:length(tmp));
    end
end
cd('..');

%%
%processing
for i=1:length(G)
     H(:,:,i)=M(:,:,i)*G(:,:,i)';
    %H(:,:,i)=(inv(G(:,:,i)*G(:,:,i)')*G(:,:,i)*M(:,:,i)')';
    %H(:,:,i)=(inv(G(:,:,i)*G(:,:,i)'+0.01*eye(size(G(:,:,i),2)))*G(:,:,i)*M(:,:,i)')';
end

for i=1:MicNum
    H_whole(1,i,:)=cat(3,H(1,i,:),zeros(1,1),conj(fliplr(H(1,i,2:end))));
    H_whole(2,i,:)=cat(3,H(2,i,:),zeros(1,1),conj(fliplr(H(2,i,2:end))));
end

for i=1:MicNum
    H_filter(1,i,:)=ifft(H_whole(1,i,:));
    H_filter(2,i,:)=ifft(H_whole(2,i,:));
end


for i=1:MicNum
    H_filter_transpose(1,i,1:512)= H_filter(1,i,513:1024);
    H_filter_transpose(1,i,513:1024)= H_filter(1,i,1:512);
    H_filter_transpose(2,i,1:512)= H_filter(2,i,513:1024);
    H_filter_transpose(2,i,513:1024)= H_filter(2,i,1:512);

end
% for i=1:MicNum
%     for j=1:SorNum
%     G_filter(i,j,:)=ifft(G(i,j,:));
%     G_filter(i,j,:)=ifft(G(i,j,:));
%     end
% end

for i=1:MicNum
    [p_source(i,:) fs]=audioread("p"+i+".wav");
end
y=zeros(2,length(conv(p_source(1,:),reshape(H_filter(1,1,:),[1 1024]))));

% for i=1:MicNum
% y(1,:)=y(1,:)+conv(p_source(i,:),reshape(H_filter(1,i,:),[1 1024]));
% y(2,:)=y(2,:)+conv(p_source(i,:),reshape(H_filter(2,i,:),[1 1024]));
% end

for i=1:MicNum
y(1,:)=y(1,:)+conv(p_source(i,:),reshape(H_filter_transpose(1,i,:),[1 1024]));
y(2,:)=y(2,:)+conv(p_source(i,:),reshape(H_filter_transpose(2,i,:),[1 1024]));
end

audiowrite(['model_matching.wav'],abs(y.')/max(abs(y.')),fs);
%audiowrite(['model_matching.wav'],abs(y.'),fs);