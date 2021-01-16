function [out_1_fastICA,out_2_gradientICA] = apply_eemdica_modified(signal,f_s)
  frec_inf=0.5;
  frec_sup=4.5;      
  seccion=length(signal);
  test = signal;
  SD = std(test);
  dimension=4;
  num_imf = dimension;
  eemdICA_b=zeros(seccion, dimension);
  imf_b = zeros(seccion, num_imf, dimension);
  
  %Add independent, identically distributed white noise
  % with zero-mean and SD equal to np times the SD of the 
  % original signal. In this case np = 0.05
  %Repeat that a number of times (e.g. 4), resulting 
  % into an ensemble of IMF sets
  for k=1:dimension
    eemdICA_b(:,k)=test+0.001*SD*randn(seccion,1);
    temp=[];
    [temp,~,~] = emd(eemdICA_b(:,k),'Interpolation','pchip','MaxNumIMF', num_imf,'Display',0);
    if(size(temp,2) < num_imf)
        t = size(temp,2);
        temp(:,t+1:num_imf) = 0;
    end
    imf_b(:,:,k)=temp;
  end
  
  %Average over the ensemble to obtain a set of averaged IMFs
  A_b = zeros(size(signal,1),num_imf);
  id_sum = 0;
  for i = 1:num_imf 
    for j = 1:dimension
        A_b(:,i) = A_b(:,i) + imf_b(:,i,j);
        if(imf_b(:,i,j) ~= 0)
            id_sum = id_sum + 1;
        end
    end
    if(id_sum ~= 0)
       A_b(:,i) = A_b(:,i) / id_sum;
    else
       A_b(:,i:end)=[];
       break
    end
    id_sum = 0;
  end
  
  
  [Z_ica_1, W_1, ~, ~] = fastICA(A_b',size(A_b,2));
  [Z_ica_2, W_2] = ICA_gradient(A_b);
  %[~,~,~,imfinsf1,~] = hht(Z_ica_1,f_s);
  %[~,~,~,imfinsf2,~] = hht(Z_ica_2,f_s);
  %imfinsf1_mediana=median(movmedian(imfinsf1,f_s));
  %imfinsf2_mediana=median(movmedian(imfinsf2,f_s));
  M = W_1^-1;
  Z_x_1 = Z_ica_1*M;
  Z_eemdICA_1 = zeros(size(Z_x_1,1),1);
  Y = fft(hanning(length(Z_x_1)).*Z_ica_1);
  P2 = abs(Y/length(Z_ica_1));
  P1 = P2(1:round(length(Z_ica_1)/2)+1,:);
  f = f_s*(0:round(length(Z_ica_1)/2))/length(Z_ica_1);
  [~,b]=max(P1);
  imfinsf1_mediana=f(b);
  allZero = 0;
  for k=1:size(Z_x_1,2)
    if(imfinsf1_mediana(k)>frec_inf && imfinsf1_mediana(k)<frec_sup)
      Z_eemdICA_1 = Z_eemdICA_1 + Z_x_1(:,k);
      allZero = 1;
    end
  end
  %In case of not finding high peak freq bwtn wanted freqs
  if allZero == 0
    while allZero == 0
      ic1=P1(:,1);
      ic2=P1(:,2);
      ic3=P1(:,3);
      ic4=P1(:,4);
      ic1(b(1))=[];
      ic2(b(2))=[];
      ic3(b(3))=[];
      ic4(b(4))=[];
      P1=[ic1 ic2 ic3 ic4];
      [~,b]=max(P1);
      imfinsf1_mediana=f(b);
      for k=1:size(Z_x_1,2)
        if(imfinsf1_mediana(k)>frec_inf && imfinsf1_mediana(k)<frec_sup)
          Z_eemdICA_1 = Z_eemdICA_1 + Z_x_1(:,k);
          allZero = 1;
        end
      end
    end
  end
  
  M = W_2^-1;
  Z_x_2 = Z_ica_2*M;
  Z_eemdICA_2 = zeros(size(Z_x_2,1),1);
  Y = fft(hanning(length(Z_x_2)).*Z_ica_2);
  P2 = abs(Y/length(Z_ica_2));
  P1 = P2(1:round(length(Z_ica_2)/2)+1,:);
  f = f_s*(0:round(length(Z_ica_2)/2))/length(Z_ica_2);
  [~,b]=max(P1);
  imfinsf2_mediana=f(b);
  allZero = 0;
  for k=1:size(Z_x_2,2)
    if(imfinsf2_mediana(k)>frec_inf && imfinsf2_mediana(k)<frec_sup)
      Z_eemdICA_2 = Z_eemdICA_2 + Z_x_2(:,k);
      allZero = 1;
    end
  end
  %In case of not finding high peak freq bwtn wanted freqs
  if allZero == 0
    while allZero == 0
      ic1=P1(:,1);
      ic2=P1(:,2);
      ic3=P1(:,3);
      ic4=P1(:,4);
      ic1(b(1))=[];
      ic2(b(2))=[];
      ic3(b(3))=[];
      ic4(b(4))=[];
      P1=[ic1 ic2 ic3 ic4];
      [~,b]=max(P1);
      imfinsf2_mediana=f(b);
      for k=1:size(Z_x_2,2)
        if(imfinsf2_mediana(k)>frec_inf && imfinsf2_mediana(k)<frec_sup)
          Z_eemdICA_2 = Z_eemdICA_2 + Z_x_2(:,k);
          allZero = 1;
        end
      end
    end
  end
  
  out_1_fastICA=Z_eemdICA_1;
  out_2_gradientICA=Z_eemdICA_2;
end