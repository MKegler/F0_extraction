
% EMD:  Emprical mode decomposition
%
% imf = emd(x)
%
% x   - input signal (must be a column vector)
%
%
% imf - Matrix of intrinsic mode functions (each as a row)
%       with residual in last row.
%
% See:  Huang et al, Royal Society Proceedings on Math, Physical, 
%       and Engineering Sciences, vol. 454, no. 1971, pp. 903-995, 
%       8 March 1998
%
% Modified from: Ivan Magrin-Chagnolleau  <ivan@ieee.org>
% 
%

function imf = Autoemd(x);

c = x(:)'; % copy of the input signal (as a row vector)
N = length(x);

%for real time plots:
realtime = [];
threshold = []; %value of SD stopping criterion (usually 0.2-0.3)
%timeCheckVec = [];
IMFi = 0;
%-------------------------------------------------------------------------
% loop to decompose the input signal into successive IMF

imf = []; % Matrix which will contain the successive IMF, and the residue

while (1) % the stop criterion is tested at the end of the loop
   
   %-------------------------------------------------------------------------
   % inner loop to find each imf
   
   h = c; % at the beginning of the sifting process, h is the signal
   SD = 1; % Standard deviation which will be used to stop the sifting process
   tic;
   while SD > 0.2
      % while the standard deviation is higher than 0.2-0.3 (typical values)
      
      % find local max/min points

      
      d = diff(h); % approximate derivative
      maxmin = []; % to store the optima (min and max without distinction so far)
      for i=1:N-2
         if d(i)==0                        % we are on a zero (max or min!)
            maxmin = [maxmin, i];
         elseif sign(d(i))~=sign(d(i+1))   % we are straddling a zero so
            maxmin = [maxmin, i+1];        % define zero as at i+1 (not i)
         end
      end
      
      if size(maxmin,2) < 2 % means: if maxmin has less than 2 columns 
                            % (does not find 2 zeroes anymore(a max and a min))
                            % then it is the residue! so break!
         break
      end
      
      % divide maxmin into maxes and mins
      if maxmin(1)>maxmin(2)              % first one is a max not a min
         maxes = maxmin(1:2:length(maxmin));
         mins  = maxmin(2:2:length(maxmin));
      else                                % is the other way around
         maxes = maxmin(2:2:length(maxmin));
         mins  = maxmin(1:2:length(maxmin));
      end
      
      % make endpoints both maxes and mins
      maxes = [1 maxes N];
      mins  = [1 mins  N];
      
      
      %-------------------------------------------------------------------------
      % spline interpolate to get max and min envelopes; form imf
      maxenv = spline(maxes,h(maxes),1:N);
      minenv = spline(mins, h(mins),1:N);
      
      m = (maxenv + minenv)/2; % mean of max and min envelopes
      prevh = h; % copy of the previous value of h before modifying it
      h = h - m; % substract mean to h
      
      
      
      % calculate standard deviation
      eps = 0.0000001; % to avoid zero values
      SD = sum ( ((prevh - h).^2) ./ (prevh.^2 + eps) );
     
      %%%%%%%%%%% real time plot of SD %%%%%%%%%%%%%%%%%%%
      
%       subplot(3,1,1);
%       hold on
%       plot(maxenv,'r','LineWidth',0.1)
%       plot(minenv,'r','LineWidth',0.1)
%       plot(h,'b','LineWidth',0.1)
%       plot(m,'k--','LineWidth',0.1)
%       axis tight
%       str1 = ['Envelopes, mean and signal'];
%       ylabel(str1)
%       
%       subplot(3,1,2);
%       realtime = [realtime SD];
%       plot(realtime, 'b')
%       hold on
%       threshold = [threshold 0.2];
%       plot(threshold, 'r')
%       axis([length(realtime)-100 length(realtime) 0 mean(realtime(ceil((end-(end/10))):end))])
%       str2 = ['SD value and threshold'];
%       ylabel(str2)
%       
%       subplot(3,1,3);
%       realtime = [realtime SD];
%       plot(realtime, 'b*')
%       hold on
%       threshold = [threshold 0.2];
%       plot(threshold, 'r')
%       axis([length(realtime)-100 length(realtime) 0 1])
%       str3 = ['SD value and threshold, zoomed in'];
%       ylabel(str3)
%       drawnow
%       clf

% %to avoid infinite loops
        timeCheck = toc;
        
        if timeCheck > 500 % it got into an infinite loop
            %timeCheckVec = [timeCheckVec timeCheck];
            
            fprintf('OPS! infinite loop!___________________________END IMF extraction\n');
            IMFi = 10;
            break
        end
   end
   
   
   maxIMFi = 11; %max number of IMFs to extract including residue
   
   IMFi = IMFi+1;
   
%    fprintf('IMF %d of %d extracted\n',IMFi,maxIMFi); 
   
   imf = [imf; h]; % store the extracted IMF in the matrix imf
   % if size(maxmin,2)<2, then h is the residue
   
   % stop criterion of the algo. (when h is monotonic function, 
   % which means that the algorithrm can't find max and min anymore)
   
   
% This version will calculate all the imf's (longer)
% 
%    if size(maxmin,2) < 2 %therefore maxmin has 1 coloumn 
%       break
%    end
% 

  
% This version will calculate only the firts 5 imf's (for autocorrelation comparison)
   if IMFi == maxIMFi | size(maxmin,2) < 2 %therefore maxmin has 1 coloumn 
       break
   end

   c = c - h; % substract the extracted IMF from the signal 
              % stored at the beginning in c

end

return


