function [SorNum P_half SorPos SorLen source]=Mix3D_Pro_function(MicPos)
c=343;                                                                     % sound speed
fs=16000;                                                                  % sampling rate
[N M]=size(MicPos);
%% Sound source(s)
SorNum =2;                                     % Number of source(s) (音源數量)
SorLen = fs*3;                                % Length of source (取樣的點數)
display('Select source signals');
for SorCount=1:SorNum                                                      % 讀取幾次
    [filename, pathname]=uigetfile({'*.wav'},'File Selector');             % 選擇音檔
    [SorTemp,fs]=audioread([pathname filename]);                           % 讀取音檔
    SorTemp=SorTemp/abs(max(SorTemp));
    if length(SorTemp) > SorLen
        source(SorCount,:)=SorTemp(1:SorLen,1);                            % 音檔的點數 > 預設的點數 (SorLen) ;後面的１是選音軌
    elseif length(SorTemp) < SorLen
        source(SorCount,:)=[SorTemp' , zeros(1,SorLen-length(SorTemp))];    % 音檔的點數 < 預設的點數 (SorLen)→補0 沒有訊號
    else
        source(SorCount,:)=SorTemp;
    end
    % --input the source(s) position--
%     SorPos(1,SorCount)=input('source localization (x):');
%     SorPos(2,SorCount)=input('source localization (y):');
%     SorPos(3,SorCount)=input('source localization (z):');
      theta=input('theta:');
      phi = input('phi')
      kappa(SorCount,:)=[sind(theta)*sind(phi),cosd(theta)*sind(phi),cosd(phi)];
      SorPos(SorCount,:)=[theta,phi];
end

%% Windowing
NWIN=1024;
hopsize=NWIN/2;                                                            % 50% overlap
NumOfFrame=2*floor(SorLen/NWIN)-1;                                         % number of frames
win = hann(NWIN+1);                                                        % hanning window
win = win(1:end-1).';

%% FFT
NFFT=2^nextpow2(NWIN);
df=fs/NFFT;
Freqs=0:df:(NFFT/2-1)*df;
%%
p=zeros(M,SorLen);

for FrameNo=1:NumOfFrame
    % --time segment--
    t_start=(FrameNo-1)*hopsize;
    tt=(t_start+1):(t_start+NWIN);
    
    % --transform to frequency domain--
    for ss=1:SorNum
        source_win(ss,:)=source(ss,tt).*win;
        source_zp(ss,:)=[source_win(ss,:) zeros(1,(NFFT-NWIN))]; 
        SOURCE(ss,:)=fft(source_zp(ss,:),NFFT);
        SOURCE_half(ss,:)=SOURCE(ss,1:NFFT/2);
    end
    % --propagation--
    for ff=1:length(Freqs)
        k = 2*pi*Freqs(ff)/c;  
        for ss = 1:SorNum
            for m = 1:M
                A(m,ss) =exp(1j*k*kappa(ss,:)*MicPos(:,m));
%                 r = sqrt(sum((SorPos(:,ss)-MicPos(:,m)).^2));
%                 A(m,ss) =exp(-1j*k*r)/r;
            end
        end

        P_half(:,ff,FrameNo)=(A*SOURCE_half(:,ff))/SorNum;
    end
    
    for MicNo=1:M
        
        P(MicNo,:)=[P_half(MicNo,:,FrameNo),zeros(1,1),fliplr(conj(P_half(MicNo,2:end,FrameNo)))];
        p_part(MicNo,:)=(ifft(P(MicNo,:),NFFT));
        
        % --overlap and add--
        tt2 = 1:NWIN;
        p(MicNo,t_start+tt2)=p(MicNo,t_start+tt2)+p_part(MicNo,tt2); %
    end
end

for MicNo=1:M
    audiowrite(['p' num2str(MicNo) '.wav'],p(MicNo,:)/max(abs(p(MicNo,:))),fs);
end

end

