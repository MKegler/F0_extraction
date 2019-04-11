clear all
close all

din_aud = './SoundFiles/';
din_fw = './FWs/';

aud_names = dir(strcat(din_aud, 'Story*.wav'));
fw_names = dir(strcat(din_fw, 'Story*.mat'));

for i = 1:size(aud_names,1)
    disp(i)
    [sound, fs] = audioread(strcat(din_aud, aud_names(i).name));
    disp(fs)
    disp(size(sound,1)/(fs))
    
    fw = load(strcat(din_fw, fw_names(i).name));
    disp(size(fw.F0,2)/8820)
    
end