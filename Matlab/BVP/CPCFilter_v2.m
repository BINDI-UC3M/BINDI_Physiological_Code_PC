function [ clean_signal, c1, c2 ] = CPCFilter_v2(signal,acc_data,plotg)
  %CPC --> y[n] = lambda * y1[n] + (1 ? lambda)y2[n]
  %        y1[n] comes from NLMS and y2[n] comes from RLS adaptative
  %        filters
  %acc signal must contain the three acc signals
  [rows,~] = size(acc_data);
  if rows ~= 3
      error('You do not have three ACC signals, X, Y, Z');
  end
  
  %Iterations
  origSignal = signal;
  cpcIterations = 1;
  
  for k=1:cpcIterations
      
    %First Cascade with NLMS
    temp = signal;
    for i = 1:rows
      x = acc_data(i,:)';
      d = temp;
      N = 64;
      mu = 0.025;
      alpha = 0.999;
      it = 1;
      [~,e] = nlms1(x,d,N,mu,alpha,it);
      temp = e;
    end
    clean_signal_c1 = temp;
  
    %Second Cascade with RLS
    temp = signal;
    for i=1:rows
      x = acc_data(i,:);
      d = temp;
      N = 64;
      delta = 1;
      lambda = 0.999;
      it = 1;
      [~,e] = rls1(x,d,N,delta,lambda,it);
      temp = e;
    end
    clean_signal_c2 = temp;
  
    % Add based on CPC and Lambda y[n] = lambda * y1[n] + (1 ? lambda)y2[n];
    lambda = 0.5;
    clean_signal = lambda .*  clean_signal_c1 + (1 - lambda).*clean_signal_c2;
    c1 = clean_signal_c1;
    c2 = clean_signal_c2;
    % Calculate SNR improvement
    SNRi_c1    = 10*log10(var(signal)/var(c1));
    disp([num2str(SNRi_c1) 'dB SNR Improvement'])
    SNRi_c2    = 10*log10(var(signal)/var(c2));
    disp([num2str(SNRi_c2) 'dB SNR Improvement'])
    SNRi_ct    = 10*log10(var(signal)/var(clean_signal));
    disp([num2str(SNRi_ct) 'dB SNR Improvement'])
    snr = [SNRi_c1 SNRi_c2 SNRi_ct];
    [~, c] = max(snr);
    cleans = [c1 c2 clean_signal];
    clean_signal = cleans(:,c);
    clean_signal = max(abs(clean_signal)) + clean_signal;
    %AGC second try
    iterations = 4;
    for j=1:iterations
      clean_signal = ...
      BVP_enhancePeaks_signal(clean_signal);
    end
    clean_signal = zscore(clean_signal);
  end
  
  if plotg 
    figure;
    plot(origSignal);
    hold on;
    plot(clean_signal);
    title('Result of CPC Filter')
    xlabel('Samples');
    legend('Reference', 'Filtered', 'Location', 'NorthEast');
    title('Comparison of Filtered Signal to Reference Input');
  end  
end

function [W,e] = nlms1(x,d,N,mu,alpha,I,Wini,Xini)
%x-reference input, here the reference to noise, 'n1'
%d-desired or primary input, here the signal plus noise, 's+no'
%N-no. of taps i.e., filter length or order
%mu-step-size or convergence parameter usually 
%(i) 0<mu<1/lambdam where lambdam is the largest diagonal value of eignvalue matrix of autocorrelation matrix of x or 
%(ii) 0<mu<(1/N*Sxm) where Sxm-maximum of PSD of x or
%(iii) 0<mu<(1/N*Px),where Px-signal power of x or approximately 
%(iv) 0<mu<1;
%lower the mu value, better the noise removal but slower the speed of
%convergence and VICE VERSA. Try changing dynamically mu according to (i)
%or (ii) or (iii) for every iteration. Add a small positive value < 0.1 to
%denominator of (ii) and (iii) in order to avoid division-by-zero in case of zero signal power
%alpha-small positive real value approximately 0<alpha<1, closer to unity
%I-no. of iterations
%Wini-initial weight vector
%Xini-initial state vector i.e., initial values of reference input
%W-final weight vector
%e-error signal e=d-W*x, this is the signal recovered
%Example code: load('ecg.mat'); [W,e]=nlms2(ol,x,d,N,mu,alpha,Wini,Xini)
%Please refer to (1) Adaptive Filter Theory by Simon Haykin (2) PDF file
%attached to this and (3) Adaptive Signal Processing by Widrow and Stearns.
Lx = length(x);
[m,n] = size(x);
if (n>m)
   x = x.';
end
if (~exist('I'))
    itr = 1;
else
    itr = I;
end
if (~exist('Wini'))
   W = zeros(N,1);
else
   if (length(Wini)~=N)
      error('Weight initialization does not match filter length');
   end
   W = Wini;
end
if (~exist('Xini'))
   x = [zeros(N-1,1); x];
else
   if (length(Xini)~=(N-1))
      error('State initialization does not match filter length minus one');
   end
   x = [Xini; x];
end
for i = 1:itr
    for k = 1:Lx
       X = x(k+N-1:-1:k);
       y = W'*X;
       e(k,1) = d(k,1) - y;
       p = alpha + X'*X;
       W = W + ((2*mu*e(k,1))/p)*X;
    end
end
end

function [W,e]=rls1(x,d,N,delta,lambda,I,Wini,Pini,Xini)
%ol-original signal, 's'
%x-reference input, here the reference to noise, 'n1'
%d-desired or primary input, here the signal plus noise, 's+no'
%N-no. of taps i.e., filter length or order
%delta-inverse of estimated signal power, typically, 0<delta<1
%lambda-small positive real value approximately 0<lambda<1, closer to unity
%Wini-initial weight vector
%Xini-initial state vector i.e., initial values of reference input
%W-final weight vector
%e-error signal e=d-W*x, this is the signal recovered
%Example code: load('ecg.mat'); [W,e]=rls1(ecg,no,ecgn,4,0.1,0.9);
if (~exist('I','var')||isempty(I))
   itr = 1;
else
   itr = I;
end
if (~exist('Wini','var')||isempty(Wini))
   W = zeros(N,1);
else
   if (length(Wini)~=N)
      error('Weight initialization must match filter length');
   end
   W = Wini;
end
if (~exist('Pini','var')||isempty(Pini))
   P = diag((ones(N,1)/delta));
else
   if ((size(Pini,1)~=N) || (size(Pini,2)~=N))
      error('Initial inverse must me square NxN');
   end
   P = Pini; 
end
		
Lx = length(x);
[m,n] = size(x);
if (n>m)
   x = x.';
end
if (~exist('Xini','var')||isempty(Xini))
   x = [zeros(N-1,1); x];
else
   if (length(Xini)~=(N-1))
      error('State initialization must match filter length minus one');
   end
   x = [Xini; x];
end
for j=1:itr
    for i = 2:Lx
       X = x(i+N-1:-1:i); %reference noise
       Pi = P*X;                     %1
       k = Pi/(lambda + X'*Pi);      %2
       y(i,1) = W'*X;                %3
       e(i,1) = d(i,1) - y(i,1);     %4
       W = W + k*e(i,1);             %5
       P = (P - (k*(X')*P))/lambda;  %6
    end
end
end

function Signal = BVP_enhancePeaks_signal(Signal) 
 
  %Get raw data
  raw = Signal;
  
  hmean = mean(raw);
  minim = hmean;
  maxim = hmean;
  curVal = 0;
  
  %Cubbing process
  for i=1:length(raw)
    curVal = raw(i)^2;
	raw(i) = curVal;
	if curVal < minim
	  minim = curVal;
	end
	if curVal > maxim 
	  maxim = curVal;
	end
  end
  
  %Normalize back to 1-1024
  for i=1:length(raw)
    raw(i) = mapfun(raw(i),minim,maxim,1,1024);
  end
  
end