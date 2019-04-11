%preparing IMFs for crossfading adding overlapping sides

frame_length = 5; % window width in ms for F0


%%  F0
nsample = round(frame_length  * Fs / 1000); % convert ms to points

%crossfade function. crossfading window will be double nsamples/framelength
x=linspace(0,pi,(2*nsample));
W = ((1+(cos(x)))/2); %half cosine window

dummyMat = zeros(m,nsample);
pannedimfNEW = [dummyMat imfNEW dummyMat];
crossIMF0_0 = [dummyMat zeros(m,length(IMF0)) dummyMat];
crossIMF0_1 = [dummyMat zeros(m,length(IMF0)) dummyMat];
Z = zeros(m,length(crossIMF0_0));
clear dummyMat

map0 = zeros(m,length(crossIMF0_0));
z = 0;

for j = 1:m
    p = nsample+1;
    while (p < n+nsample) 

       while z <= 2
           if IMF0(j,p-nsample) == 0 && IMF0(j,p-nsample+1) ~= 0 %&& IMF0(j,p-nsample+2) ~= 0 %&& any(IMF0(:,p-nsample) ~= 0)
               
               crossIMF0_0(j,:) = [zeros(1,(p-nsample)), (1-W), ones(1,(length(crossIMF0_0)-(p+nsample)))];

               z=z+1;
               p=p+1;

           elseif IMF0(j,p-nsample) ~= 0 && IMF0(j,p-nsample+1) == 0 %&& IMF0(j,p-nsample+2) == 0 %&& any(IMF0(:,p-nsample+1) ~= 0)
               
               crossIMF0_1(j,:) = [ones(1,(p-nsample)), (W),zeros(1,(length(crossIMF0_0)-(p+nsample)))];

               z=z+1;
               p=p+1;
               
           else
               p = p+1;
               
           end
           
           if p >= n+nsample
               break
           end
           
           if z == 2
               
               Z = crossIMF0_0 .* crossIMF0_1;
               z = 0;
               
               break
           end
       end

       map0 = map0 + Z;
       Z = zeros(m,length(crossIMF0_0));
       crossIMF0_0 = zeros(m,length(crossIMF0_0));
       crossIMF0_1 = zeros(m,length(crossIMF0_0));
       z=0;
       
       if p >= n+nsample

           break
       end    
       
    end
end    


map0(:,1:nsample) = [];
map0(:, end-nsample+1:end) = [];

IMF0X  = sum(imfNEW.*map0);

clear nsample x W 
clear pannedimfNEW crossIMF0_0 crossIMF0_1 Z z p

%% 1st Harmonic
nsample = round((frame_length  * Fs / 1000)/2); % for 1st harmonic window is halved and so on..
x=linspace(0,pi,(2*nsample));
W = ((1+(cos(x)))/2);

dummyMat = zeros(m,nsample);
pannedimfNEW = [dummyMat imfNEW dummyMat];
crossIMF1_0 = [dummyMat zeros(m,length(IMF1)) dummyMat];
crossIMF1_1 = [dummyMat zeros(m,length(IMF1)) dummyMat];
Z = zeros(m,length(crossIMF1_0));
clear dummyMat

map1 = zeros(m,length(crossIMF1_0));
z = 0;

for j = 1:m
    p = nsample+1;
    while (p < n+nsample) 

       while z <= 2
           if IMF1(j,p-nsample) == 0 && IMF1(j,p-nsample+1) ~= 0 %&& IMF1(j,p-nsample+2) ~= 0 %&& any(IMF1(:,p-nsample) ~= 0)
               
               crossIMF1_0(j,:) = [zeros(1,(p-nsample)), (1-W), ones(1,(length(crossIMF1_0)-(p+nsample)))];
               
               z=z+1;
               p=p+1;

           elseif IMF1(j,p-nsample) ~= 0 && IMF1(j,p-nsample+1) == 0 %&& IMF1(j,p-nsample+2) == 0 %&& any(IMF1(:,p-nsample+1) ~= 0)
               
               crossIMF1_1(j,:) = [ones(1,(p-nsample)), (W),zeros(1,(length(crossIMF1_0)-(p+nsample)))];
               
               z=z+1;
               p=p+1;
               
           else
               p = p+1;

           end
           
           if p >= n+nsample
               break
           end
           
           if z == 2
               
               Z = crossIMF1_0 .* crossIMF1_1;
               z = 0;
               
               break
           end
       end
       
       map1 = map1 + Z;
       Z = zeros(m,length(crossIMF1_0));
       crossIMF1_0 = zeros(m,length(crossIMF1_0));
       crossIMF1_1 = zeros(m,length(crossIMF1_0));
       z = 0;
       
       if p >= n+nsample

           break
       end    
       
    end
end    


map1(:,1:nsample) = [];
map1(:, end-nsample+1:end) = [];

IMF1X  = sum(imfNEW.*map1);

clear nsample x W 
clear map1 pannedimfNEW crossIMF1_0 crossIMF1_1 Z z p

%% 2nd Harmonic
nsample = round((frame_length  * Fs / 1000)/3); 
x=linspace(0,pi,(2*nsample));
W = ((1+(cos(x)))/2);

dummyMat = zeros(m,nsample);
pannedimfNEW = [dummyMat imfNEW dummyMat];
crossIMF2_0 = [dummyMat zeros(m,length(IMF2)) dummyMat];
crossIMF2_1 = [dummyMat zeros(m,length(IMF2)) dummyMat];
Z = zeros(m,length(crossIMF2_0));
clear dummyMat

map2 = zeros(m,length(crossIMF2_0));
z = 0;

for j = 1:m
    p = nsample+1;
    while (p < n+nsample) 

       while z <= 2
           if IMF2(j,p-nsample) == 0 && IMF2(j,p-nsample+1) ~= 0 %&& IMF2(j,p-nsample+2) ~= 0 %&& any(IMF2(:,p-nsample) ~= 0)
               
               crossIMF2_0(j,:) = [zeros(1,(p-nsample)), (1-W), ones(1,(length(crossIMF2_0)-(p+nsample)))];
               
               z=z+1;
               p=p+1;

           elseif IMF2(j,p-nsample) ~= 0 && IMF2(j,p-nsample+1) == 0 %&& IMF2(j,p-nsample+2) == 0 %&& any(IMF2(:,p-nsample+1) ~= 0)
               
               crossIMF2_1(j,:) = [ones(1,(p-nsample)), (W),zeros(1,(length(crossIMF2_0)-(p+nsample)))];
               
               z=z+1;
               p=p+1;
               
           else
               p = p+1;

           end
           
           if p >= n+nsample
               break
           end
           
           if z == 2
               
               Z = crossIMF2_0 .* crossIMF2_1;
               z = 0;
               
               break
           end
       end
       
       map2 = map2 + Z;
       Z = zeros(m,length(crossIMF2_0));
       crossIMF2_0 = zeros(m,length(crossIMF2_0));
       crossIMF2_1 = zeros(m,length(crossIMF2_0));
       z = 0;
       
       if p >= n+nsample

           break
       end    
       
    end
end    


map2(:,1:nsample) = [];
map2(:, end-nsample+1:end) = [];

IMF2X  = sum(imfNEW.*map2);

clear nsample x W 
clear map2 pannedimfNEW crossIMF2_0 crossIMF2_1 Z z p

%% 3rd Harmonic
nsample = round((frame_length  * Fs / 1000)/4);
x=linspace(0,pi,(2*nsample));
W = ((1+(cos(x)))/2);

dummyMat = zeros(m,nsample);
pannedimfNEW = [dummyMat imfNEW dummyMat];
crossIMF3_0 = [dummyMat zeros(m,length(IMF3)) dummyMat];
crossIMF3_1 = [dummyMat zeros(m,length(IMF3)) dummyMat];
Z = zeros(m,length(crossIMF3_0));
clear dummyMat

map3 = zeros(m,length(crossIMF3_0));
z = 0;

for j = 1:m
    p = nsample+1;
    while (p < n+nsample) 

       while z <= 2
           if IMF3(j,p-nsample) == 0 && IMF3(j,p-nsample+1) ~= 0 %&& IMF3(j,p-nsample+2) ~= 0 %&& any(IMF3(:,p-nsample) ~= 0)
               
               crossIMF3_0(j,:) = [zeros(1,(p-nsample)), (1-W), ones(1,(length(crossIMF3_0)-(p+nsample)))];

               z=z+1;
               p=p+1;

           elseif IMF3(j,p-nsample) ~= 0 && IMF3(j,p-nsample+1) == 0 %&& IMF3(j,p-nsample+2) == 0 %&& any(IMF3(:,p-nsample+1) ~= 0)
               
               crossIMF3_1(j,:) = [ones(1,(p-nsample)), (W),zeros(1,(length(crossIMF3_0)-(p+nsample)))];

               z=z+1;
               p=p+1;
               
           else
               p = p+1;
               
           end
           
           if p >= n+nsample
               break
           end
           
           if z == 2
               
               Z = crossIMF3_0 .* crossIMF3_1;
               z = 0;
               
               break
           end
       end

       map3 = map3 + Z;
       Z = zeros(m,length(crossIMF3_0));
       crossIMF3_0 = zeros(m,length(crossIMF3_0));
       crossIMF3_1 = zeros(m,length(crossIMF3_0));
       z = 0;
       
       if p >= n+nsample

           break
       end    
       
    end
end    


map3(:,1:nsample) = [];
map3(:, end-nsample+1:end) = [];

IMF3X  = sum(imfNEW.*map3);

clear nsample x W 
clear map3 pannedimfNEW crossIMF3_0 crossIMF3_1 Z z p

%% 4th Harmonic
nsample = round((frame_length  * Fs / 1000)/5);
x=linspace(0,pi,(2*nsample));
W = ((1+(cos(x)))/2);

dummyMat = zeros(m,nsample);
pannedimfNEW = [dummyMat imfNEW dummyMat];
crossIMF4_0 = [dummyMat zeros(m,length(IMF4)) dummyMat];
crossIMF4_1 = [dummyMat zeros(m,length(IMF4)) dummyMat];
Z = zeros(m,length(crossIMF4_0));
clear dummyMat

map4 = zeros(m,length(crossIMF4_0));
z = 0;

for j = 1:m
    p = nsample+1;
    while (p < n+nsample) 

       while z <= 2
           if IMF4(j,p-nsample) == 0 && IMF4(j,p-nsample+1) ~= 0 %&& IMF4(j,p-nsample+2) ~= 0 %&& any(IMF4(:,p-nsample) ~= 0)
               
               crossIMF4_0(j,:) = [zeros(1,(p-nsample)), (1-W), ones(1,(length(crossIMF4_0)-(p+nsample)))];

               z=z+1;
               p=p+1;

           elseif IMF4(j,p-nsample) ~= 0 && IMF4(j,p-nsample+1) == 0 %&& IMF4(j,p-nsample+2) == 0 %&& any(IMF4(:,p-nsample+1) ~= 0)
               
               crossIMF4_1(j,:) = [ones(1,(p-nsample)), (W),zeros(1,(length(crossIMF4_0)-(p+nsample)))];

               z=z+1;
               p=p+1;
               
           else
               p = p+1;
               
           end
           
           if p >= n+nsample
               break
           end
           
           if z == 2
               
               Z = crossIMF4_0 .* crossIMF4_1;
               z = 0;
               
               break
           end
       end

       map4 = map4 + Z;
       Z = zeros(m,length(crossIMF4_0));
       crossIMF4_0 = zeros(m,length(crossIMF4_0));
       crossIMF4_1 = zeros(m,length(crossIMF4_0));
       z = 0;
       
       if p >= n+nsample

           break
       end    
       
    end
end    


map4(:,1:nsample) = [];
map4(:, end-nsample+1:end) = [];

IMF4X  = sum(imfNEW.*map4);

clear nsample x W 
clear map4 pannedimfNEW crossIMF4_0 crossIMF4_1 Z z p


%%
clear p j z Z x W samples nsample frame_length dummyMat pannedimfNEW
clear IMF0 IMF1 IMF2 IMF3 IMF4
clear crossIMF0_0 crossIMF0_1 crossIMF1_0 crossIMF1_1 crossIMF2_0 crossIMF2_1 crossIMF3_0 crossIMF3_1 crossIMF4_0 crossIMF4_1
clear map0 map1 map2 map3 map4
