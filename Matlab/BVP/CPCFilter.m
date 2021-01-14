function [ clean_signal, c1, c2 ] = CPCFilter(signal,acc_data,plotg)
  %CPC --> y[n] = lambda * y1[n] + (1 ? lambda)y2[n]
  %        y1[n] comes from NLMS and y2[n] comes from RLS adaptative
  %        filters
  %acc signal must contain the three acc signals
  [rows,~] = size(acc_data);
  if rows ~= 3
      error('You do not have three ACC signals, X, Y, Z');
  end
  
  %Iterations
  cpcIterations = 1;
  
  for k=1:cpcIterations
      
  %First Cascade with NLMS
  filter_order = 84; 
  step_size = 0.005;
  temp = signal;
  mu = step_size; % step size
  nlms = dsp.LMSFilter('Length',filter_order, ...
    'Method','Normalized LMS',...
    'StepSizeSource','Input port', ...
    'WeightsOutputPort',false);
  for i = 1:rows
   x = acc_data(i,:)';
   d = temp;
   [~, err] = step(nlms,x,d,mu);
   temp = temp+err;
  end
  clean_signal_c1 = temp;
  
  %Second Cascade with RLS
  x       = signal;
  p       = 84;                % filter order
  lambda  = 1;              % forgetting factor 
  laminv  = 1/lambda;
  delta   = 1.0;              % initialization parameter
  w       = zeros(p,1);       % filter coefficients
  P       = delta*eye(p);     % inverse correlation matrix
  e       = x*0;              % error signal
  for i=1:rows
    n = acc_data(i,:);
    for m = p:length(x)
      % Acquire chunk of data
      y = n(m:-1:m-p+1)';
      % Error signal equation
      e(m) = x(m)-w'*y;
      % Parameters for efficiency
      Pi = P*y;
      % Filter gain vector update
      k = (Pi)/(lambda+y'*Pi);
      % Inverse correlation matrix update
      P = (P - k*y'*P)*laminv;
      % Filter coefficients adaption
      w = w + k*e(m);
    end
    
    %Reassign signal
    x = e;
  end
  clean_signal_c2 = x;
  
  % Add based on CPC and Lambda y[n] = lambda * y1[n] + (1 ? lambda)y2[n];
  lambda = 0.1;
  clean_signal = lambda .*  clean_signal_c1 + (1 - lambda).*clean_signal_c2;
  c1 = clean_signal_c1;
  c2 = clean_signal_c2;
  end
  
  if plotg 
    figure;
    plot(signal);
    hold on;
    plot(clean_signal);
    title('Result of CPC Filter')
    xlabel('Samples');
    legend('Reference', 'Filtered', 'Location', 'NorthEast');
    title('Comparison of Filtered Signal to Reference Input');
    % Calculate SNR improvement
    SNRi    = 10*log10(var(signal)/var(clean_signal));
    disp([num2str(SNRi) 'dB SNR Improvement'])
    SNRi    = 10*log10(var(signal)/var(c1));
    disp([num2str(SNRi) 'dB SNR Improvement'])
    SNRi    = 10*log10(var(signal)/var(c2));
    disp([num2str(SNRi) 'dB SNR Improvement'])
  end  
end