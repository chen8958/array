function [H_filter]=TUMIF(angle,MicPos,elevation,dirname)
SorPos=angle;
[D MicNum]=size(MicPos);
[D SorNum]=size(SorPos);
Lg =256;
Lh =257;
L  =Lg+Lh-1;
fs=44100;
c=343.0;
NWIN=Lg;
hopsize=NWIN/2;                                                            % 50% overlap
delay=0; 

%delay=1293;
%% FFT
NFFT=2^nextpow2(NWIN);
df=fs/NFFT;
Freqs=0:df:(NFFT/2-1)*df;
%kappa = [cosd(SorPos(:,1)).*sind(SorPos(:,2)) sind(SorPos(:,1)).*sind(SorPos(:,2)) cosd(SorPos(:,2))];
%for azimuth
kappa = [sind(SorPos(:)) cosd(SorPos(:)) sind(elevation).*ones(length(angle),1)];

%sind(elevation).*ones(length(angle),1) have problem!!!!!

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
for ss = 1:SorNum
    for m = 1:MicNum
            G_impulse(m,ss,:)=circshift((ifft(reshape(G(m,ss,:),[1,NFFT]))),delay);
    end
end

GT=zeros(L*SorNum,Lh*MicNum);
for m=1:MicNum
    for ss=1:SorNum
        for shift=1:Lh
            sub_g(:,shift)=[zeros(1,shift-1),reshape(G_impulse(m,ss,:),[1,NFFT]),zeros(1,Lh-shift)];
        end
        GT((ss-1)*L+1:ss*L,(m-1)*Lh+1:m*Lh)=sub_g;
    end
end


% for ss = 1:SorNum
%     for m = 1:MicNum
%             G(m,ss,:)=fft(G_impulse(m,ss,:));
% 
%     end
% end



%%
%M
%dic=0:15:345;
%dic=[90,45,0,315,270,225,180,135]
dic=angle;
cd(['elev' num2str(elevation)]);
%delay=1300; 

M=zeros(L*SorNum,2);
for i=1:length(dic)
    if dic(i)<10   
        filenameL=sprintf("L%de00%da.wav",elevation,dic(i));
        [leftfilter,fsL]=audioread([filenameL]);
%         leftfilter=[zeros(delay,1);leftfilter];
%         tmp=fft(leftfilter,NFFT);
%         M(1,i,:)=tmp;
        M((i-1)*L+1:i*L,1)=leftfilter;
        
        filenameR=sprintf('R%de00%da.wav',elevation,dic(i));
        [rightfilter,fsR]=audioread([filenameR]);
%         rightfilter=[zeros(delay,1);rightfilter];
%         tmp=fft(rightfilter,NFFT);
%         M(2,i,:)=tmp;
        M((i-1)*L+1:i*L,2)=rightfilter;

    elseif dic(i)<100
        filenameL=sprintf('L%de0%da.wav',elevation,dic(i));
        [leftfilter,fsL]=audioread([filenameL]);
%         leftfilter=[zeros(delay,1);leftfilter];
%         tmp=fft(leftfilter,NFFT);
%         M(1,i,:)=tmp;
        M((i-1)*L+1:i*L,1)=leftfilter;
        
        filenameR=sprintf('R%de0%da.wav',elevation,dic(i));
        [rightfilter,fsR]=audioread([filenameR]);
%         rightfilter=[zeros(delay,1);rightfilter];
%         tmp=fft(rightfilter,NFFT);
%         M(2,i,:)=tmp;
        M((i-1)*L+1:i*L,2)=rightfilter;
    else
        filenameL=sprintf('L%de%da.wav',elevation,dic(i));
        [leftfilter,fsL]=audioread([filenameL]);
%         leftfilter=[zeros(delay,1);leftfilter];
%         tmp=fft(leftfilter,NFFT);
%         M(1,i,:)=tmp;
        M((i-1)*L+1:i*L,1)=leftfilter;
        
        filenameR=sprintf('R%de%da.wav',elevation,dic(i));
        [rightfilter,fsR]=audioread([filenameR]);
%         rightfilter=[zeros(delay,1);rightfilter];
%         tmp=fft(rightfilter,NFFT);
%         M(2,i,:)=tmp;
        M((i-1)*L+1:i*L,2)=rightfilter;
           
    end
    %display(['filename = ' filenameL]);
end
cd('..');

%%
%processing freqency domain
% for i=1:length(G)
%     %H(:,:,i)=M(:,:,i)*pinv(G(:,:,i));
%     %H(:,:,i)=(inv(G(:,:,i)*G(:,:,i)')*G(:,:,i)*M(:,:,i)')';
%     H(:,:,i)=(inv(G(:,:,i)*G(:,:,i)'+0.001*eye(size(G(:,:,i),1)))*G(:,:,i)*M(:,:,i)')';
%     
%     ER(:,:,i)=H(:,:,i)*G(:,:,i);
% end
%%
%TUMIF
%H=(inv(GT*GT'+0.001*eye(size(GT,1)))*GT*M')';
H=inv(GT.'*GT+0.001*eye(size(GT,2)))*GT.'*M;
IM=GT*H;


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
    H_filter(1,i,:)=H((i-1)*Lh+1:i*Lh,1);
    H_filter(2,i,:)=H((i-1)*Lh+1:i*Lh,2);
end
cd(dirname);
for i=1:SorNum
    IM_filter(1,i,:)=IM((i-1)*L+1:i*L,1);
    IM_filter(2,i,:)=IM((i-1)*L+1:i*L,2);
end


for i=1:SorNum
filename=sprintf('L%dele%da.wav',elevation,dic(i));
audiowrite(filename,reshape(IM_filter(1,i,:),[length(IM_filter(1,i,:)), 1]),44100 );
filename=sprintf('R%dele%da.wav',elevation,dic(i));
audiowrite(filename,reshape(IM_filter(2,i,:),[length(IM_filter(1,i,:)), 1]),44100 );
end
cd("..");



end