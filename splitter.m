%splitter


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