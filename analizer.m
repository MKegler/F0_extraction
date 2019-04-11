%Analyser

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

