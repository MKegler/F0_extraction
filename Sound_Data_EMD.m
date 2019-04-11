%% read audio file

[y,Fs] = audioread(speechfile);
y = resample(y, 441, 480);
Fs = 44100;


%% get rid of digital zeros at beginning and end of file. Only channel 1 is analysed (mono)...
... y must be coloumn vector

X = y(:,1);
begin = find(X,1,'first');
last = find(X,1,'last');

startPiece = X(1:begin-1);
finalPiece = X(last+1:end);

X = X(begin:last);

clear begin last

% resampling
times = 5; %resampling tot times (decreasing the vector tot times) 5 is used when Fs = 44100
X = resample (X,1,times); %resampling audio at around 8kHz
Fs = Fs/(times);

n = size(X,1);
t = n/Fs;       % time
h = t/n;       % step size
D = 0:h:t-h;    % domain (time vector)

clear times
