% USAGE
%
%   function   [T] = loggabortemp1(WaveLength,sigmaOnf,dThetaOnSigma,theta2,sizer) 
%
%   Returns:
%
%         G             :   Returns 2D LogGabor complex number Template
%
%   Parameters :
%       sigmaOnf        >>    β         :   决定形状（有几个峰值）       β    ∈  （0,1） 
%       dThetaOnSigma   >>   dθσ       :   决定是（）  还是 ||         dθσ  ∈  （0,15）
%       theta2          >>    θ         :   方向                        θ    ∈   N[1,2,3,4]
%       WaveLength      >>    λ         :   波长                        λ    ∈  （3,25）
%
%       sizer                            :   生成模板的大小                    ∈   N[7,15,19,25]
%       





    
%   function   [T] = loggabortemp(WaveLength,sigmaOnf,dThetaOnSigma,theta2,rows,cols) 
%     
%  %    rows = sizer;
% %     cols = sizer;	
% 
% 
%     [x,y] = meshgrid([-cols/2:(cols/2-1)]/cols,[-rows/2:(rows/2-1)]/rows);
% 
%     radius = sqrt(x.^2 + y.^2);       
%     radius(round(rows/2+1),round(cols/2+1)) = 1; 
%     theta = atan2(-y,x);              
%     sintheta = sin(theta);
%     costheta = cos(theta);
%     clear x; clear y; clear theta;      
% 
%     thetaSigma = pi/4/dThetaOnSigma;  
%     angl = (theta2-1)*pi/4;           
% 
%     ds = sintheta * cos(angl) - costheta * sin(angl);    
%     dc = costheta * cos(angl) + sintheta * sin(angl);     
%     dtheta = abs(atan2(ds,dc)); 
% 
%     spread = exp((-dtheta.^2) / (2 * thetaSigma^2));     
% 
% 
% 
% 
%     fo = 1.0/WaveLength;           
% 
%     logGabor = exp((-(log(radius/fo)).^2) / (2 * log(sigmaOnf)^2));  
%     logGabor(round(rows/2+1),round(cols/2+1)) = 0; 
% 
%     filter = fftshift(logGabor .* spread); 
%     
%      T= ifftshift(ifft2(filter));
%   end  
  function EO=LogGaborFilter(des,nscale,minWaveLength,mult,sigmaOnf)
   rows = size(des,1);
   cols = size(des,2);
   EO=cell(4);
  % filtersum = zeros(1, cols);
    ndata = cols;
  if mod(ndata,2) == 1
        ndata=ndata-1;
  end
   logGabor =zeros(1, ndata);
   result = zeros(rows, ndata);
   radius = zeros(1, ndata / 2 + 1);
   radius(1, 1) = 1;
  for  i = 2: ndata / 2 + 1
    
        radius(1, i) = i /ndata;
  end
    wavelength = minWaveLength;
  for  s = 1:nscale
    
         fo = 1.0 / wavelength;
         %rfo = fo / 0.5;
         temp=power(log(radius/fo),2);
         temp=exp((-temp) / (2 * log(sigmaOnf) * log(sigmaOnf)));
         logGabor(1,1:ndata / 2 )=temp(:,1:ndata / 2 );
         logGabor(1,1)= 0;
        % filtersum = filtersum + logGabor;
        for  r =1:rows
            des_fft=fft(des(r,:));
            filter = fftshift(logGabor .*des_fft);
           T= ifftshift(ifft(filter));
           result(r,:)=T;
        end
        EO{s} = result;
       wavelength=wavelength* mult;
  end
    %filtersum = circshift(filtersum,cols /2,2);
  end
