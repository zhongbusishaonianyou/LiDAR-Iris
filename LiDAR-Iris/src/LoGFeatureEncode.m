function [T,M]=LoGFeatureEncode(dec, nscale, minWaveLength, mult,sigmaOnf)

     list = LogGaborFilter(dec, nscale, minWaveLength, mult, sigmaOnf);
    Tlist=cell(8);
    Mlist=cell(8);
    for  i = 1:nscale
        arr_real=real(list{i});
        arr_imag=imag(list{i});
        Tlist{i} =arr_real > 0;
        Tlist{i + nscale}=arr_imag > 0;
        mag=abs(list{i});
        Mlist{i} = mag < 0.0001;
        Mlist{i + nscale}= mag< 0.0001;
    end
      T=vertcat(Tlist{1},Tlist{2},Tlist{3},Tlist{4},Tlist{5},Tlist{6},Tlist{7},Tlist{8});
      M=vertcat(Mlist{1},Mlist{2},Mlist{3},Mlist{4},Mlist{5},Mlist{6},Mlist{7},Mlist{8});
  
    end
