function  [des_angle]=FFT(des1)
%     % Convert both to FFT, centering on zero frequency component
%     figure(1);
%     subplot(1,3,1);imshow(I1);
%     subplot(1,3,2);imshow(I2);
% 
     Image = 1/255*double(des1);
    Image_fft = fftshift(fft2(Image))/(80*360);   
    des_angle = angle(Image_fft);
     
    % Output (FA, FB)
    % ---------------------------------------------------------------------
    % Convolve the magnitude of the FFT with a high pass filter)
end

