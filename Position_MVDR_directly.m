function [angel_plant]=Position_MVDR_directly(MicPos,SorPos)
c=343;
path=cd;
[D MicNum]=size(MicPos);
    %% Windowing
cd([path '\audio_R'])
[x1 fs]=audioread('female_16k_10s.wav');
SorLen=fs*4;
Source=[x1(1:fs*4)];
cd(path)
NWIN=1024;
hopsize=NWIN/2;                                                            % 50% overlap
NumOfFrame=2*floor(fs*4/NWIN)-1;                                           % number of frames
win = hann(NWIN+1);                                                        % hanning window
win = win(1:end-1).';
%% FFT
NFFT=2^nextpow2(NWIN);
df=fs/NFFT;
Freqs=0:df:(NFFT/2-1)*df;

%     for i=1:MicNum
%     x(i,1:4*fs)=p(i,1:4*fs);
%     fft_x(i,:)=fft(x(i,:),NFFT);
%     end
    
    
    angel_curve=zeros(1,180);
    angel_plant=zeros(length(Freqs),180);
    for deg=1:180
        for ff=1:length(Freqs)
            k = 2*pi*Freqs(ff)/c; 
            kappa = [cosd(SorPos(1))*sind(SorPos(2)) sind(SorPos(1))*sind(SorPos(2)) cosd(SorPos(2))];
            for MicNo=1:MicNum
                a_real(MicNo)=exp(1i*k*kappa*MicPos(:,MicNo));
            end
            
            k = 2*pi*Freqs(ff)/c; 
            kappa=[cosd(deg),sind(deg),0];
            for MicNo=1:MicNum
                a(MicNo)=exp(1i*k*kappa*MicPos(:,MicNo));
            end
            w=conj(a);
            %angel_curve(deg+90)=angel_curve(deg+90)+abs(w*fft_x(:,ff));
            %angel_plant(ff,deg+90)=abs(w*fft_x(:,ff));
            angel_curve(deg)=angel_curve(deg)+abs(w*a_real.');
            angel_plant(ff,deg)=abs(w*a_real.');
        end
    end
    figure(1)
    deg=1:180;
    pcolor(deg,Freqs,angel_plant);
    shading interp;
    figure(2)
    plot(deg,angel_curve);
    

end