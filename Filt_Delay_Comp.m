%filter delay compensation

filterdelayLOW = round(mean(grpdelay(Filter_1500HzLowPass_8kHzFs)));

%removing first data (number of delayed samples) from signal and last data from time vector
D = D(1:end-filterdelayLOW);
X(1:filterdelayLOW) = [];  

n = size(X,1);
t = n/Fs;       % new time
totalTime = t;

