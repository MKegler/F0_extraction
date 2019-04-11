%transpose imf

imf_for_hilbert = imf';

%compute hilbert transform

for p=1:size(imf_for_hilbert,2)-1
    di(:,p) = hilbert(imf_for_hilbert(:,p));

end

%countertranspose di
di = di';

Inst_Ampl = abs(di);
Inst_Angle = angle(di);

%Unwrap phase
Inst_Angle_Unwrap = unwrap(Inst_Angle')';

% Approximate Derivatives
f = Inst_Angle_Unwrap;      % range
Inst_Freq = diff(f')'/h;   % first derivative

%pad the matrix
Inst_Freq_Pad = [zeros(size(Inst_Freq,1),1) Inst_Freq];

% Hz convertion  (rad/s to Hz)
Inst_Freq_Pad_Hz = Inst_Freq_Pad./(2*pi);

%Inverting matrix to get positive frequencies
Inst_Freq_Pad_Hz = Inst_Freq_Pad_Hz.*(-1);

%cut out negative frequencies left
B = Inst_Freq_Pad_Hz>0;
Inst_Freq_Pad_Hz = Inst_Freq_Pad_Hz.*B;

clear di B f p imf_for_hilbert Inst_Angle Inst_Angle_Unwrap Inst_Freq Inst_Freq_Pad
