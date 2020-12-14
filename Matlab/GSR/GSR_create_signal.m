%> @file GSR_create_signal.m
%> @brief GSR_create_signal gets a GSR signal from a variable
% 
%> @param   rawGSR [1xN]: the raw GSR signal
%> @param   sampRate [1x1]: the sampling rate, in Hz
% 
%> @retval  Signal: A GSR TEAP-like signal
% 
%> @author Copyright UC3M
function Signal = GSR_create_signal(rawGSR, sampRate)

  if(nargin ~= 2)
	error('Usage: BVP_aqn_variable(rawBVP, sampRate)');
  end
  
  %Max uSiemens allowed
  uSiemensMax = 41;

  %Create an empty structure signal
  %Signal = new_empty_gsr();
  Signal = Signal__new_empty();
  Signal = Signal__set_signame(Signal, 'GSR');
  Signal = Signal__set_samprate(Signal, sampRate);
  
  %If it is given in Siemens
  if(min(rawGSR) >= 0 && max(rawGSR) <= uSiemensMax)
    Signal = Signal__set_unit(Signal, 'uS');
  %If it is given in Ohm
  elseif(max(rawGSR) > uSiemensMax)
    Signal = Signal__set_unit(Signal, 'Ohm');
  elseif(min(rawGSR) < 0) %if the signal was baselined/relatived
  	Signal = Signal__set_absolute(Signal, false);
  end
  
  %Set raw data
  Signal = Signal__set_raw(Signal, Raw_convert_1D(rawGSR));

end