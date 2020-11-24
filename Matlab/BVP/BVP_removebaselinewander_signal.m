%> @file BVP_enhancePeaks_signal.m
%> @brief BVP_enhancePeaks_signal enhance R to noise ratio by cubing, then normalising back
% 
%> @param   Signal: A BVP TEAP-UC3M-like signal
% 
%> @retval  Signal: A BVP TEAP-UC3M-like signal
% 
%> @author Copyright UC3M
function Signal = BVP_removebaselinewander_signal(Signal,fs) 
  
  %Check if it is a signal
  Signal__assert_mine(Signal);

  %Get raw data
  raw = Signal__get_raw(Signal);
  
  %Get iir notch parameters
  w0 = 0.05;
  Q   = 0.005;
  w0 = 2*w0/fs;
  
  %Checks if w0 is within the range
  if w0 > 1 || w0 < 0
    warning("w0 should be such that 0 < w0 < 1");
  end
    
  %Get bandwidth
  bw = w0/Q;
  
  %Normalize inputs
  bw = bw*pi;
  w0 = w0*pi;
   
 %Compute -3dB atenuation
 gb = 1/sqrt(2);
   
 %Compute beta
 beta = (sqrt(1-gb^2)/gb)*tan(bw/2.0);
  
  %Compute gain
  gain = 1/(1+beta);
 
  %Compute numerator b and denominator a
  b = gain*([1, -2*cos(w0), 1]);
  a = ([1, -2*gain*cos(w0), (2*gain-1.0)]);
   
  %Filter the signal
  raw = filtfilt(b,a,raw);
%   raw = abs(raw);
  raw = max(abs(raw)) + raw;
%   raw = fliplr( raw );
%   raw = filtfilt(b,a,raw);
%   raw = fliplr( raw );
  
  %Set signal back
  Signal = Signal__set_raw(Signal, raw);
  
  %Set enhance attribute
  Signal = Signal__set_preproc(Signal, 'baselinewander');
  
end    