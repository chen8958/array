function surround(angle,dirname)
cd('audio_R');
[vocal,fs]=audioread('female_16k_10s.wav');
vocal=vocal(1:fs*4);
vocal=resample(vocal,44100,fs);
cd('..');
cd(dirname);

for i=1:length(angle)
filename = sprintf("model_matching_sor%dele0.wav",angle(i));
[y_input(:,:,i),fs]=audioread(filename);
y(:,1,i)=conv(y_input(:,1,i),vocal);
y(:,2,i)=conv(y_input(:,2,i),vocal);
end
y_out=zeros(1,2);
for i=1:length(angle)
y_out=[y_out;y(:,:,i)];
end

audiowrite('surround.wav',y_out/abs(max(y_out)),fs);
cd('..');
end