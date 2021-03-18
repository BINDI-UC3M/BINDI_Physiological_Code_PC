%> @file BVP_create_signal.m
%> @brief BVP_create_signal gets a BVP signal from a variable
% 
%> @param   rawBVP [1xN]: the raw BVP signal
%> @param   sampRate [1x1]: the sampling rate, in Hz
% 
%> @retval  Signal: A BVP TEAP-like signal
% 
%> @author Copyright UC3M
function Signal = BVP_create_signal(rawBVP, sampRate)

  if(nargin ~= 2)
	error('Usage: BVP_create_signal(rawBVP, sampRate)');
  end

  %Create an empty structure signal
  Signal = new_empty_bvp();
  
  %Set sampling rate
  Signal = Signal__set_samprate(Signal, sampRate);
  Signal.IBI = Signal__set_samprate(Signal.IBI, sampRate);

  %Set raw data
  Signal = Signal__set_raw(Signal, Raw_convert_1D(rawBVP));

end