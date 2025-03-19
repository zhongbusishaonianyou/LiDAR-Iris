function  [Tx,Ty]=FFT_register(angle1,angle2)
  
    CROSS = exp(1i * (angle1 - angle2));
    PHASE = real(ifft2(CROSS));

    % Output (R2_F2_PHASE)
    % ---------------------------------------------------------------------
    % Decide whether to flip 180 or -180 depending on which was the closest

     [y, x] = find(PHASE == max(max(PHASE)));
  
    
    % Output (R, x, y)
    % ---------------------------------------------------------------------
    % Ensure correct translation by taking from correct edge
    
    Tx = x-1;
    Ty = y-1;
    % Show final image
%  for  ii=1:size(I1, 2)
%       if ii+Tx>size(I1, 2)
%               row=ii+Tx-size(I1, 2);
%       elseif ii+Tx<=0
%               row=ii+Tx+size(I1, 2);
%       else
%           row=ii+Tx;
%       end
%       for jj=1:size(I1, 1)
%           
%            image(jj,row)=I2(jj,ii);
%       end
%   end
%subplot(1,3,3);imshow(image);
end

