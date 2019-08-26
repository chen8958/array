clc;clear ;close all

angel=0:60:300;
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
            G_tmp(m,ss,ff) =exp(1j*k*kappa(ss,:)*MicPos(:,m));
        end
    end
end
for ss = 1:SorNum
    for m = 1:MicNum
            %G_F(m,ss,:)=cat(3,G_tmp(m,ss,:),zeros(1,1),fliplr((G_tmp(m,ss,2:end))));
            G_F(m,ss,:)=cat(2,reshape(G_tmp(m,ss,:),[1,256]),zeros(1,1),fliplr(reshape(conj(G_tmp(m,ss,2:end)),[1,255])));
            %G_F(m,ss,:)=cat(3,G_tmp(m,ss,:),zeros(1,1),fliplr(G_tmp(m,ss,2:end)));
    end
end
for ss = 1:SorNum
    for m = 1:MicNum
            G(m,ss,:)=ifft(G_F(m,ss,:));
    end
end












%%
fig=1;%figure y/n 
%%
path=cd;
% cd('C:\Users\yicheng\Desktop\Master_Program\Inventek_project\3D_audio\code\Inventec_experiment\XTC')
cd([path '\XTC'])
load('L_1.mat');n_L_1=m;
load('L_2.mat');n_L_2=m;
load('L_3.mat');n_L_3=m;
load('L_4.mat');n_L_4=m;
load('R_1.mat');n_R_1=m;
load('R_2.mat');n_R_2=m;
load('R_3.mat');n_R_3=m;
load('R_4.mat');n_R_4=m;
cd([path])
%%
Lg =1000;
Lh =1001;               % tap of controller  (length)
Lm = Lg + Lh -1;        % requirement:  Lm = Lg1 + Lc1 -1

L_1=n_L_1(1:Lg);
L_2=n_L_2(1:Lg);
L_3=n_L_3(1:Lg);
L_4=n_L_4(1:Lg);
R_1=n_R_1(1:Lg);
R_2=n_R_2(1:Lg);
R_3=n_R_3(1:Lg);
R_4=n_R_4(1:Lg);

gg11 = [L_1';zeros(Lh-1,1)];
gg12 = [L_2';zeros(Lh-1,1)];
gg13 = [L_3';zeros(Lh-1,1)];
gg14 = [L_4';zeros(Lh-1,1)];
gg21 = [R_1';zeros(Lh-1,1)];
gg22 = [R_2';zeros(Lh-1,1)];
gg23 = [R_3';zeros(Lh-1,1)];
gg24 = [R_4';zeros(Lh-1,1)];
GG11 = zeros(1,Lh);
GG12 = zeros(1,Lh);
GG13 = zeros(1,Lh);
GG14 = zeros(1,Lh);
GG21 = zeros(1,Lh);
GG22 = zeros(1,Lh);
GG23 = zeros(1,Lh);
GG24 = zeros(1,Lh);

for i = 1:Lm
    GG11 = [gg11(i)  GG11(1:Lh-1)];
    G11(i,:) = GG11;
    GG12 = [gg12(i)  GG12(1:Lh-1)];
    G12(i,:) = GG12;
    GG13 = [gg13(i)  GG13(1:Lh-1)];
    G13(i,:) = GG13;
    GG14 = [gg14(i)  GG14(1:Lh-1)];
    G14(i,:) = GG14;
    GG21 = [gg21(i)  GG21(1:Lh-1)];
    G21(i,:) = GG21;
    GG22 = [gg22(i)  GG22(1:Lh-1)];
    G22(i,:) = GG22;
    GG23 = [gg23(i)  GG23(1:Lh-1)];
    G23(i,:) = GG23;
    GG24 = [gg24(i)  GG24(1:Lh-1)];
    G24(i,:) = GG24;
end
GG=[G11,G12,G13,G14;
   G21,G22,G23,G24];
G=[GG,zeros(size(GG));
   zeros(size(GG)),GG];
delay=700;

m1=[zeros(delay,1);1;zeros(Lm-delay-1,1)];
m0=zeros(Lm,1);
m=[m1;m0;m0;m1];

%%
beta = 10^-5;
h = G.'*((G*G.'+(beta^2)*eye(4*Lm))\m);
h11 = h(1:Lh,1);                       % controller
% h11 = h11(471:770);
h21 = h(Lh+1:Lh*2,1);
% h21 = h21(471:770);
h31 = h(2*Lh+1:Lh*3,1);
% h31 = h31(471:770);
h41 = h(3*Lh+1:Lh*4,1);
% h41 = h41(471:770);
h12 = h(4*Lh+1:Lh*5,1);
% h12 = h12(471:770);
h22 = h(5*Lh+1:Lh*6,1);
% h22 = h22(471:770);
h32 = h(6*Lh+1:Lh*7,1);
% h32 = h32(471:770);
h42 = h(7*Lh+1:Lh*8,1);
% h42 = h42(471:770);

% filter=[h11,h21,h31,h41,h12,h22,h32,h42];
%%
FileName='fig.';
cd([path '\audio'])
fs=44100;
[x1,Fs]=audioread('W.wav');
X1 = resample(x1,fs,Fs);
[x2,Fs]=audioread('Q.wav');
X2 = resample(x2,fs,Fs);

cd([path])
%%
% vv1=filter(h11,1,X1+0.7*X5+X3)+filter(h12,1,X2+0.7*X5+X4);
% vv2=filter(h21,1,X1+0.7*X5+X3)+filter(h22,1,X2+0.7*X5+X4);
% vv3=filter(h31,1,X1+0.7*X5+X3)+filter(h32,1,X2+0.7*X5+X4);
% vv4=filter(h41,1,X1+0.7*X5+X3)+filter(h42,1,X2+0.7*X5+X4);

vv1=filter(h11,1,X1)+filter(h12,1,X2);
vv2=filter(h21,1,X1)+filter(h22,1,X2);
vv3=filter(h31,1,X1)+filter(h32,1,X2);
vv4=filter(h41,1,X1)+filter(h42,1,X2);
%% Output
v1=vv1./max([abs(vv1);abs(vv2);abs(vv3);abs(vv4)]);
v2=vv2./max([abs(vv1);abs(vv2);abs(vv3);abs(vv4)]);
v3=vv3./max([abs(vv1);abs(vv2);abs(vv3);abs(vv4)]);
v4=vv4./max([abs(vv1);abs(vv2);abs(vv3);abs(vv4)]);
% cd('C:\Users\yicheng\Desktop\Master_Program\Inventek_project\3D_audio\code\Inventec_experiment\freefield_experiment_audio')
cd([path '\experiment_audio'])
% audiowrite(['XTC1.wav'],v1,fs);
% audiowrite(['XTC2.wav'],v2,fs);
% audiowrite(['XTC3.wav'],v3,fs);
% audiowrite(['XTC4.wav'],v4,fs);
cd([path])
y1=filter(n_L_1,1,v1)+filter(n_L_2,1,v2)+filter(n_L_3,1,v3)+filter(n_L_4,1,v4);
y2=filter(n_R_1,1,v1)+filter(n_R_2,1,v2)+filter(n_R_3,1,v3)+filter(n_R_4,1,v4);
yy1=y1/max([abs(y1);abs(y2)]);
yy2=y2/max([abs(y1);abs(y2)]);
yyy=[yy1,yy2];

% cd('C:\Users\yicheng\Desktop\Master_Program\3D_audio\3D_audio\code\Inventec_experiment\simulation_audio')
% % audiowrite(['TXTC.wav'],yyy,fs);
% cd(path)
 %% figure
 s(:,1)=filter(m1,1,X1)+filter(m0,1,X1);
 
switch fig
    case 1
figure;plot(y1,'b');hold on;plot(y2,'red');
xlabel('time (samples)');ylabel('magnitude');

figure;
[Pxy_error F]=cpsd(y1,y1,hann(1024),512,1024,fs);
Pxy_error= sqrt(Pxy_error.*fs/(1024)*2);
Pxy_error=20*log10(Pxy_error);
semilogx(F,Pxy_error,'b');
hold on
[Pxy_error F]=cpsd(s(:,1),s(:,1),hann(1024),512,1024,fs);
Pxy_error= sqrt(Pxy_error.*fs/(1024)*2);
Pxy_error=20*log10(Pxy_error);
semilogx(F,Pxy_error,'r');
xlabel('Frequency(Hz)');ylabel('Power/frequency(dB/Hz)');title(['Power spectral density(\beta=' num2str(beta) ')']);
xlim([200 20000]);
legend('ipsi','contra');

    case 2
end
