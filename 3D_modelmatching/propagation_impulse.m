function propagation_impulse(angle,MicPos,elevation)
SorPos=angle;
[D MicNum]=size(MicPos);
[D SorNum]=size(SorPos);
fs=44100;
c=343.0;
NWIN=2048;
hopsize=NWIN/2;                                                            % 50% overlap
%delay=0;
delay=1293;
%% FFT
NFFT=2^nextpow2(NWIN);
df=fs/NFFT;
Freqs=0:df:(NFFT/2-1)*df;
%kappa = [cosd(SorPos(:,1)).*sind(SorPos(:,2)) sind(SorPos(:,1)).*sind(SorPos(:,2)) cosd(SorPos(:,2))];
%for azimuth
kappa = [sind(SorPos) cosd(SorPos) sind(elevation)];

for ff=1:length(Freqs)
    k = 2*pi*Freqs(ff)/c;
        for m = 1:MicNum
            %G_tmp(m,ss,ff) =exp(1j*k*kappa(ss,:)*MicPos(:,m));
            G_tmp(m,ff) =exp(1j*k*kappa*MicPos(:,m));
        end
end
for m = 1:MicNum
    G(m,:)=cat(2,reshape(G_tmp(m,:),[1,length(G_tmp)]),zeros(1,1),conj(fliplr(reshape(G_tmp(m,2:end),[1,length(G_tmp)-1]))));
end


for m = 1:MicNum
    G_impulse(m,:)=circshift((ifft(reshape(G(m,:),[1,NFFT]))),delay);
end


for MicNo=1:MicNum
    audiowrite(['p' num2str(MicNo) '.wav'],G_impulse(MicNo,:)/max(abs(G_impulse(MicNo,:))),fs);
end
display("mix3D done");
end