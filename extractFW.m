function F0 = extractFW(speechfile_in)

%% read audio file
% If sampled at 48k, resample to 44.1kHz

[y,Fs] = audioread(speechfile_in);

if size(y,2) > 1
fprintf('Detected more than 1 channel. Converting to mono!\n')
y = sum(y,2)/2;
end

if Fs == 48000
fprintf('Resampling from 48000 Hz to 44100 Hz!\n')
y = resample(y, 441, 480);
Fs = 44100;
end

%% get rid of digital zeros at beginning and end of file. Only channel 1 is analysed (mono)...
... y must be coloumn vector

X = y(:,1);

fprintf('Removing silence in the beggining and the end\n')
begin = find(X,1,'first');
last = find(X,1,'last');

startPiece = X(1:begin-1);
finalPiece = X(last+1:end);

X = X(begin:last);

clear begin last

%% Resampling
downsample_times = 5; %resampling tot times (decreasing the vector tot times) 5 is used when Fs = 44100
X = resample(X,1,downsample_times); %resampling audio at around 8kHz
if size(startPiece,1) > 0
startPiece = resample(startPiece,1,downsample_times);
end
if size(finalPiece,1) > 0
finalPiece = resample(finalPiece,1,downsample_times);
end
Fs = Fs/(downsample_times);

n = size(X,1);
t = n/Fs;       % time
h = t/n;       % step size
D = 0:h:t-h;    % domain (time vector)

%% Filtering

X = Data_Filtering_1500HzLowPass_8kHzFs(X);

%filter delay compensation
filterdelayLOW = round(mean(grpdelay(Filter_1500HzLowPass_8kHzFs)));

%removing first data (number of delayed samples) from signal and last data from time vector
D = D(1:end-filterdelayLOW);
X(1:filterdelayLOW) = [];  

n = size(X,1);
t = n/Fs;       % new time
totalTime = t;

%% Thresholding
%envelope threshhold for silence removal

frame = 10; % in ms

[yupper,ylower] = envelope(X, round(frame * Fs / 1000), 'peak');


Xenv=X;

Xenv((abs(yupper-ylower) > 0.1*max(X))==0) = 0;

TotXenv = Xenv;
TotX = X;
TotD = D;

clear frame ylower yupper

%% calculate autocorrelation for pitch tracking

maxlag = round(Fs/50); % F0 is greater than 50Hz => 20ms maxlag

%% these functions are taken and modified from: Naotoshi Seo, April 2008
%  visit:  http://note.sonots.com/SciSoftware/Pitch.html#v44c5761

[r] = spCorr(Xenv, Fs, maxlag);
[f0] = spPitchCorr(r, Fs);
[F0, T, R] = spPitchTrackCorr(Xenv, Fs, 50, 49, maxlag, 0);

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

% hold on
% plot(D,TotF0Auto,'r','linew',2);
% legend('F0 pitch track','F0 pitch track kept');
% xlabel('Time (s)');
% ylabel('Frequency (Hz)');
% hold off

clear p A yy maxlag r F0 f0 R F0Smooth F0resampled pos OriginalF0New F0New dummyMat frame frame_length i m nsample T B

%% Splitter

i = 1;
z = 1;
begin = 1;
TimeFrameStartEnd = [];

while i <= n-1
    if Xenv(i,1) ~= 0 && Xenv(i+1,1) == 0 && i>=(Fs/8) %in order to have an adequate number of points for the first piece
        clear A
        A = Xenv(begin:i);
        A = A(find(A,1,'first'):find(A,1,'last'));
        
        if length(A)>(Fs/8)
            piecesXenv{z} = Xenv(begin:i,1);
            piecesX{z} = X(begin:i,1);
            piecesTotF0Auto{z} = TotF0Auto(1,begin:i);
            TimeFrameStartEnd = [TimeFrameStartEnd; ((begin/Fs)-h), (i/Fs)];
            begin = i+1;
            z = z+1;
            i = i+1;
        else
            i = i+1;
        end
    else
            i = i+1;
    end
end

piecesXenv{z} = Xenv(begin:end,1);
piecesX{z} = X(begin:end,1);
piecesTotF0Auto{z} = TotF0Auto(1,begin:end);
TimeFrameStartEnd = [TimeFrameStartEnd; ((begin/Fs)-h), (i/Fs)];

clear begin i z

%% Analyser

i=1;

for i = 1:length(piecesX)
    
    clear X Xenv D n t samples F0Auto
    
    X = piecesX{1,i};
    Xenv = piecesXenv{1,i};
    F0Auto = piecesTotF0Auto{1,i};
    
    n = size(X,1);
    Ptimes = [];
    t = n/Fs;       % piece time
    Ptimes = [Ptimes, t]; %vector of pieces durations
    D = 0:h:t-h;    % domain (piece time vector)

    imf = Autoemd(X);
    Hilbert_Spectrum;
    IMFselector;
    IMFcrossfader;
    
    piecesF0{1,i} = IMF0X;
    piecesH1{1,i} = IMF1X;
    piecesH2{1,i} = IMF2X;
    piecesH3{1,i} = IMF3X;
    piecesH4{1,i} = IMF4X;
    
fprintf('piece %d of %d done\n',i,length(piecesX)); 

end

%% builder

% Adding the previously removed silent parts
F0 = [piecesF0{:}];
F0 = [startPiece; F0'; finalPiece];

% Padding mismatched lengths with zeros
y1 = resample(y,1,downsample_times);
diff_len = abs(size(y1, 1) - size(F0,1));
F0 = [F0; zeros(diff_len,1)];
crcorr = xcorr(F0, y1);
zero_lag = median([1:size(crcorr,1)]);
[vmax, amax] = max(crcorr);
fprintf('Latency: %d samples\n',amax-zero_lag) 

H1 = [startPiece, piecesH1{:}, finalPiece];

H2 = [startPiece, piecesH2{:}, finalPiece];

H3 = [startPiece, piecesH3{:}, finalPiece];

H4 = [startPiece, piecesH4{:}, finalPiece];

% save(speechfile_out, 'F0')

exitcode = 0;


