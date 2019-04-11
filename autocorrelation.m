%% calculate autocorrelation for pitch tracking

maxlag = round(Fs/50); % F0 is greater than 50Hz => 20ms maxlag

%% these functions are taken and modified from: Naotoshi Seo, April 2008
%  visit:  http://note.sonots.com/SciSoftware/Pitch.html#v44c5761

[r] = spCorr(Xenv, Fs, maxlag);
[f0] = spPitchCorr(r, Fs);
[F0, T, R] = spPitchTrackCorr(Xenv, Fs, 50, 49, maxlag, 1);

%%
F0Smooth = spline(T,[0, F0, 0],D);

A = (Xenv ~=0);
F0New = F0Smooth.*A';
F0New(F0New == 0) = NaN;

%narrowing frequencies around fundamental frequency range:
% (i) frequency outside 50-400Hz range are set to zero

B = F0New>60 & F0New<400;
F0New = F0New.*B;

F0New(F0New == 0) = NaN;

% (iii)instantaneous freq with a variation larger than 10Hz within 1ms are set to zero.
frame_length = 1; %window width in ms

nsample = round(frame_length  * Fs / 1000); % convert ms to points

%padding the matrix:
OriginalF0New = F0New;
[m,p] = size(F0New);
dummyMat = zeros(m,nsample);
F0New = [F0New dummyMat];
F0New(F0New == 0) = NaN;
p = length(F0New);

F0Auto = [];

pos = 1; i = 1;
    while (pos+nsample-1 < p)
        frame = F0New(1,pos:pos+nsample-1);
        if abs(max(frame)-min(frame))>= 10
            F0Auto(1,i) = NaN;
        else 
            F0Auto(1,i) = F0New(1,i);
        end
        pos = pos + 1;
        i = i + 1;
    end


F0New = OriginalF0New;
TotF0Auto = F0Auto;

hold on
plot(D,TotF0Auto,'r','linew',2);
legend('F0 pitch track','F0 pitch track kept');
xlabel('Time (s)');
ylabel('Frequency (Hz)');
hold off

clear p A yy maxlag r F0 f0 R F0Smooth F0resampled pos OriginalF0New F0New dummyMat frame frame_length i m nsample T B