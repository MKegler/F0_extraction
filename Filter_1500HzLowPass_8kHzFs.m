function Hd = Filter_1500HzLowPass_8kHzFs
%FILTER_1500HZLOWPASS_8KHZFS Returns a discrete-time filter object.

% MATLAB Code
% Generated by MATLAB(R) 8.6 and the DSP System Toolbox 9.1.
% Generated on: 07-Apr-2016 12:46:06

% FIR Window Lowpass filter designed using the FIR1 function.

% All frequency values are in Hz.
Fs = 8820;  % Sampling Frequency

Fpass = 1500;            % Passband Frequency
Fstop = 1650;            % Stopband Frequency
Dpass = 0.057501127785;  % Passband Ripple
Dstop = 0.0001;          % Stopband Attenuation
flag  = 'scale';         % Sampling Flag

% Calculate the order from the parameters using KAISERORD.
[N,Wn,BETA,TYPE] = kaiserord([Fpass Fstop]/(Fs/2), [1 0], [Dstop Dpass]);

% Calculate the coefficients using the FIR1 function.
b  = fir1(N, Wn, TYPE, kaiser(N+1, BETA), flag);
Hd = dsp.FIRFilter( ...
    'Numerator', b);

% [EOF]