function surround(angle,dirname)

cd(dirname);
for i=1:length(angle)
filename = sprintf("model_matching%d.wav",angle(i));
[y(:,:,i),fs]=audioread(filename);
end
y_out=zeros(1,2);
for i=1:length(angle)
y_out=[y_out;y(:,:,i)];
end
audiowrite('surround.wav',y_out,fs);
cd('..');
end