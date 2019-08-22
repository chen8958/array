% clc;
% clear all;
% 
% dic=0:15:345;
% cd('elev0');
% for i=1:length(dic)
%     if dic(i)==0   
%         filenameL=sprintf('L0e000a.wav');
%         [leftfilter,fsL]=audioread([filenameL]);
%         M(1,i,:)=leftfilter;
%         
%         filenameR=sprintf('R0e000a.wav');
%         [rightfilter,fsR]=audioread([filenameR]);
%         M(2,i,:)=rightfilter;
%     elseif dic(i)<100
%         filenameL=sprintf('L0e0%da.wav',dic(i));
%         [leftfilter,fsL]=audioread([filenameL]);
%         
%         M(1,i,:)=leftfilter;
%         
%         filenameR=sprintf('R0e0%da.wav',dic(i));
%         [rightfilter,fsR]=audioread([filenameR]);
%         
%         M(2,i,:)=rightfilter;
%     else
%         filenameL=sprintf('L0e%da.wav',dic(i));
%         [leftfilter,fsL]=audioread([filenameL]);
%         
%         M(1,i,:)=leftfilter;
%         
%         filenameR=sprintf('R0e%da.wav',dic(i));
%         [rightfilter,fsR]=audioread([filenameR]);
%        
%         M(2,i,:)=rightfilter;
%     end
% end
% cd('..');


%%
%observe for G
% angel=0:15:345;
% MicPos=(1/100)*4.5*[cos(angel);sin(angel)];
% SorPos=[0 15 30 45 60 75 90 105 120 135 150 165 180 195 210 225 240 255 270 285 300 315 330 345];
% [D MicNum]=size(MicPos);
% [D SorNum]=size(SorPos);
% fs=44100;
% c=343.0;
% NWIN=1024;
% hopsize=NWIN/2;                                                            % 50% overlap
%     %% FFT
% NFFT=2^nextpow2(NWIN);
% df=fs/NFFT;
% Freqs=0:df:(NFFT/2-1)*df;
% %%from forward
% kappa = [sind(SorPos(:)) cosd(SorPos(:))];
% for ff=1:length(Freqs)
%     k = 2*pi*Freqs(ff)/c;
%     for ss = 1:SorNum
%         for m = 1:MicNum
%             G(m,ss,ff) =exp(1j*k*kappa(ss,:)*MicPos(:,m));
%         end
%     end
% end
% 
for ss = 1:SorNum
    for m = 1:MicNum
        g1=ifft(G(m,ss,:));
        g(:)=g1(1,1,:);
        %plot(abs(g));
        freqz(reshape(G(m,ss,:),[1 length(G(m,ss,:))]),1)
        title(['ss=' num2str(ss) 'm=' num2str(m)]);
    end
end


%%
%observe for M
% for ss = 1:SorNum
%     for m = 1:2
%         g1=ifft(M(m,ss,:));
%         g(:)=g1(1,1,:);
%         plot(abs(g));
%         title(['ss=' num2str(ss) 'm=' num2str(m)]);
%     end
% end

% for ss = 1:SorNum
%     for m = 1:2
%         g1=ifft(H(m,ss,:));
%         g(:)=g1(1,1,:);
%         plot(abs(g));
%         title(['ss=' num2str(ss) 'm=' num2str(m)]);
%     end
% end
%%
%observe for H
% for ss = 1:SorNum
%     for m = 1:2
% %         g1=ifft(H(m,ss,:));
%         g(:)=H_filter(m,ss,:);
%         plot(abs(g));
%         title(['ss=' num2str(ss) 'm=' num2str(m)]);
%     end
% end

%%
%observe for G
% for ss = 1:SorNum
%     for m = 1:MicNum
%         g1=ifft(G(m,ss,:));
%         g(:)=g1(1,1,:);
%         plot(abs(g));
%         title(['ss=' num2str(ss) 'm=' num2str(m)]);
%     end
% end

%%
%observe for HG
for ss = 1:SorNum
        for ch = 1:2
            for ff=1:length(Freqs)
                g(ch,ff)=H(ch,:,ff)*G(:,ss,ff);
            end
            g1=ifft(g(ch,:));
            g=g1;
            plot(real(g));
            title(['ss=' num2str(ss) 'm=' num2str(ch)]);
        end
end
