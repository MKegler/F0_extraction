%envelope threshhold for silence removal

frame = 10; % in ms

[yupper,ylower] = envelope(X, round(frame * Fs / 1000), 'peak');


Xenv=X;

Xenv((abs(yupper-ylower) > 0.1*max(X))==0) = 0;

TotXenv = Xenv;
TotX = X;
TotD = D;

% figure
% plot(D, X,'b', D, Xenv,'r',D, yupper,'g',D,ylower,'g','linew',1);
% title('signal envelope (red signal is kept)')
% xlabel('Time')
% ylabel('Amplitude')

clear frame ylower yupper