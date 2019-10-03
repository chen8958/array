%% Low Frequency Compensation
clc;clear all;close all;
%% Data analysis
for i=1:14
    d=load ([num2str(i) '.txt']);
    G_re=d(:,3);                                % real part
    G_ima=d(:,4);                               % imaginary part
    G=G_re+G_ima*1i;                            % frequency response
    GGain=abs(G);                               % magnitude
%     figure(1)
%     loglog(GGain)
    
    % -- EQ --
%     ComGain1=ones(3201,1)./GGain;
%     G_re=G_re.*[ComGain1];
%     G_ima=G_ima.*[ComGain1];
    
    % -- Frequency weighting --
    ComGain1=(ones(100,1)).*0.001;
    ComGain2=(ones(400,1));
    ComGain3=(ones(2701,1)).*0.001;
    G_re=G_re.*[ComGain1;ComGain2;ComGain3];
    G_ima=G_ima.*[ComGain1;ComGain2;ComGain3];
    
    G=G_re+G_ima*1i;
    GGain=abs(G);
%     figure(2)
%     loglog(GGain)
    
    multi = 2.56;  % ����
    fn = 25600;    % �W�e (Hz)
    fs_ori = fn*multi;   % �����W�v
    df = d(2,2)-d(1,2);   % �W�v���j
    
    NN = (fs_ori/2)/df+1;  % 0 : df : fs/2  ���I��
    G_half = [G ; zeros(NN-length(G),1)].';    % �b�W��� 0
    G_frame=[G_half,fliplr(conj(G_half(:,2:end-1)))];
    y1ang = angle(G_frame)/pi*180;
    g = ifft(G_frame);
    
    % ===========  resample �q�쪺�T�� (pulse�q�쪺)=========================
    fs = 44100;  % �Q�n���W�v
    m = resample(g,fs,fs_ori);
%     figure(3);plot(m);
%     xlim([0 length(m)]);
%     xlabel('Time (samples)');ylabel('Magnitude');title('Impulse response')

cd('F:\2NB\impulse')
    save([ 'FW_' num2str(i) '.mat'],'m')
cd('F:\2NB\FR_measured')
end