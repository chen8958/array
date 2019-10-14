azis=0:15:345;
mics=0:15:345;
for azi = 1:length(azis)
    for mic = 1:length(mics)
        cd('impulse');
        load(['freq_azi' num2str(azis(azi)) 'mic' num2str(mics(mic)) '.mat']);
        m(1:1280)=[];
        m=m(1:1024);
        cd('..');
        cd('re_impulse')
        save(['freq_azi' num2str(azis(azi)) 'mic' num2str(mics(mic)) '.mat'],'m')
        cd('..');
    end
end