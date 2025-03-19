function dis=GetHamming_dis(des1_T,des1_M,des2_T,des2_M,scale,down_shape)
    dis=inf;
%     bias = -1;
    for shift = scale - 2: scale + 2
    
        T2 = circshift(des2_T,shift,2);
        M2 = circshift(des2_M,shift,2);
        Mask = des1_M | M2;
        MaskBitsNum = sum(Mask(:));
        totalBits = 8*down_shape(1)*down_shape(2)- MaskBitsNum;
        C = xor(des1_T,T2)& (~Mask);
        bitsDiff = sum(C(:));
%         if (totalBits == 0)
%             dis = inf;
%         else
          currentDis = bitsDiff /totalBits;
            if (currentDis < dis )
                dis = currentDis;
%                 bias = shift;
            end
%     end    
     end
end