clear all
close all

fnames = dir('./SoundFiles/*.wav');
SavePath = char(fullfile('./FWs'));

for fi = 1:size(fnames,1)
    
fileName = strcat('./SoundFiles/', fnames(fi).name);
speechfile = char(fullfile(fileName));
disp(fileName);

F0 = extractFW(speechfile,1);

savename = strcat(fnames(fi).name(1:end-4), '_F0.mat');
fullFileName = fullfile(SavePath(1,:), savename);
disp(fullFileName)
save (fullFileName, 'F0');

clear F0

end
