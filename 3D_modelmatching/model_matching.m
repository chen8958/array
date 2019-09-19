
%MicPos=(1/100)*[4.5*cosd(120),4.5*cosd(60),4.5,4.5*cosd(-60),4.5*cosd(-120),-4.5;4.5*sind(120),4.5*sind(60),0,4.5*sind(-60),4.5*sind(-120),0];

% angel=0:15:345;
% MicPos=(1/100)*4.5*[cosd(angel);sind(angel)];
% SorPos=[0 15 30 45 60 75 90 105 120 135 150 165 180 195 210 225 240 255 270 285 300 315 330 345];

% angel=0:60:300;
% MicPos=(1/100)*4.5*[cosd(angel);sind(angel)];
% SorPos=angel;
function [H_filter]=model_matching(angle,MicPos,elevation)
% angel=0:45:315;
% MicPos=(1/100)*4.5*[cosd(angel);sind(angel)]
SorPos=angle;

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
%for azimuth
kappa = [sind(SorPos(:)) cosd(SorPos(:)) elevation.*ones(length(angle),1)];

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
dic=angle;
cd(['elev' num2str(elevation)]);
for i=1:length(dic)
    if dic(i)<10   
        filenameL=sprintf("L%de00%da.wav",elevation,dic(i));
        [leftfilter,fsL]=audioread([filenameL]);
        tmp=fft(leftfilter);
        M(1,i,:)=tmp;
        
        filenameR=sprintf('R%de00%da.wav',elevation,dic(i));
        [rightfilter,fsR]=audioread([filenameR]);
        tmp=fft(rightfilter);
        M(2,i,:)=tmp;

    elseif dic(i)<100
        filenameL=sprintf('L%de0%da.wav',elevation,dic(i));
        [leftfilter,fsL]=audioread([filenameL]);
        tmp=fft(leftfilter);
        M(1,i,:)=tmp;
        
        filenameR=sprintf('R%de0%da.wav',elevation,dic(i));
        [rightfilter,fsR]=audioread([filenameR]);
        tmp=fft(rightfilter);
        M(2,i,:)=tmp;
    else
        filenameL=sprintf('L%de%da.wav',elevation,dic(i));
        [leftfilter,fsL]=audioread([filenameL]);
        tmp=fft(leftfilter);
        M(1,i,:)=tmp;
        
        filenameR=sprintf('R%de%da.wav',elevation,dic(i));
        [rightfilter,fsR]=audioread([filenameR]);
        tmp=fft(rightfilter);
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



end