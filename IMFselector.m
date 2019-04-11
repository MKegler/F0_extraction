% choose the IMFs!

%first cut out the silent parts
[m,n] = size(Inst_Ampl);

E = ~isnan(F0Auto);
E =[E;repmat(E,m-1,1)];


%apply silence mapping to imfs Ampl and Freq
Inst_AmplNEW = Inst_Ampl.*E;
Inst_AmplNEW(Inst_AmplNEW == 0) = NaN;
Inst_FreqNEW = Inst_Freq_Pad_Hz.*E;
Inst_FreqNEW(Inst_FreqNEW == 0) = NaN;


Index0 = [];
Index1 = [];
Index2 = [];
Index3 = [];
Index4 = [];
 
%Smooth each ImFs (Freq) to run comparison with F0Auto and harmonics

Inst_Freq_Smooth = [];

for p = 1:m
    
    A = smooth(D,Inst_FreqNEW(p,:),0.02,'loess');
    
    Inst_Freq_Smooth = [Inst_Freq_Smooth; A'];
    
end

%silence smoothed matrix of frequencies
Inst_Freq_Smooth = Inst_Freq_Smooth.*E;
Inst_Freq_Smooth(Inst_Freq_Smooth == 0) = NaN;

%comparison wit F0Auto and Harmonics for building Index mapping
for p=1:m
    A0 = abs(Inst_Freq_Smooth(p,:)-F0Auto)<0.2*(F0Auto);
    Index0 = [Index0; A0];
    
    A1 = abs(Inst_Freq_Smooth(p,:)-(2*F0Auto))<0.2*(2*F0Auto);
    Index1 = [Index1; A1];
    
    A2 = abs(Inst_Freq_Smooth(p,:)-(3*F0Auto))<0.2*(3*F0Auto);
    Index2 = [Index2; A2];
    
    A3 = abs(Inst_Freq_Smooth(p,:)-(4*F0Auto))<0.2*(4*F0Auto);
    Index3 = [Index3; A3];
    
    A4 = abs(Inst_Freq_Smooth(p,:)-(5*F0Auto))<0.2*(5*F0Auto);
    Index4 = [Index4; A4];
end

%mapping Index on Freq and Amp

Inst_Freq0 = Inst_FreqNEW.*Index0;
Inst_Freq0(Inst_Freq0 == 0) = NaN;
Inst_Freq1 = Inst_FreqNEW.*Index1;
Inst_Freq1(Inst_Freq1 == 0) = NaN;
Inst_Freq2 = Inst_FreqNEW.*Index2;
Inst_Freq2(Inst_Freq2 == 0) = NaN;
Inst_Freq3 = Inst_FreqNEW.*Index3;
Inst_Freq3(Inst_Freq3 == 0) = NaN;
Inst_Freq4 = Inst_FreqNEW.*Index4;
Inst_Freq4(Inst_Freq4 == 0) = NaN;

Inst_Ampl0 = Inst_AmplNEW.*Index0;
Inst_Ampl0(Inst_Ampl0 == 0) = NaN;
Inst_Ampl1 = Inst_AmplNEW.*Index1;
Inst_Ampl1(Inst_Ampl1 == 0) = NaN;
Inst_Ampl2 = Inst_AmplNEW.*Index2;
Inst_Ampl2(Inst_Ampl2 == 0) = NaN;
Inst_Ampl3 = Inst_AmplNEW.*Index3;
Inst_Ampl3(Inst_Ampl3 == 0) = NaN;
Inst_Ampl4 = Inst_AmplNEW.*Index4;
Inst_Ampl4(Inst_Ampl4 == 0) = NaN;



ImfF0 = NaN(m,n);
ImfF1 = NaN(m,n);
ImfF2 = NaN(m,n);
ImfF3 = NaN(m,n);
ImfF4 = NaN(m,n);

for j=1:n

        [maxi, Ampi] = max(Inst_Ampl0(:,j));   
        p = Ampi;
        ImfF0(p,j) = Inst_Freq0(p,j);
        
        [maxi, Ampi] = max(Inst_Ampl1(:,j));   
        p = Ampi;
        ImfF1(p,j) = Inst_Freq1(p,j);
        
        [maxi, Ampi] = max(Inst_Ampl2(:,j));   
        p = Ampi;
        ImfF2(p,j) = Inst_Freq2(p,j);
        
        [maxi, Ampi] = max(Inst_Ampl3(:,j));   
        p = Ampi;
        ImfF3(p,j) = Inst_Freq3(p,j);
        
        [maxi, Ampi] = max(Inst_Ampl4(:,j));   
        p = Ampi;
        ImfF4(p,j) = Inst_Freq4(p,j);
      

end

imfNEW = imf(1:m,:);

IMF0 = imfNEW.*(~isnan(ImfF0));
IMF1 = imfNEW.*(~isnan(ImfF1));
IMF2 = imfNEW.*(~isnan(ImfF2));
IMF3 = imfNEW.*(~isnan(ImfF3));
IMF4 = imfNEW.*(~isnan(ImfF4));

clear maxi j p Ampi A0 A1 A2 A3 A4 Amp E A
clear Index0 Index1 Index2 Index3 Index4
clear Inst_Ampl0 Inst_Ampl1 Inst_Ampl2 Inst_Ampl3 Inst_Ampl4
clear Inst_Freq0 Inst_Freq1 Inst_Freq2 Inst_Freq3 Inst_Freq4
clear ImfF0 ImfF1 ImfF2 ImfF3 ImfF4
clear Inst_Ampl Inst_AmplNEW Inst_Freq_Pad_Hz 
clear Inst_FreqNEW Inst_Freq_Smooth
