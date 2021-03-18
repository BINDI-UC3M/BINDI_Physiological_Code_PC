%> @file SKT_create_signal.m
%> @brief SKT_create_signal gets a SKT signal from a variable
% 
%> @param   rawBVP [1xN]: the raw SKT signal
%> @param   sampRate [1x1]: the sampling rate, in Hz
% 
%> @retval  Signal: A SKT TEAP-like signal
% 
%> @author Copyright UC3M
function Signal = SKT_create_signal(rawHST, sampRate)


if(nargin ~= 2)
	error('Usage: SKT_create_signal(rawHST, sampRate)');
end

%Signal = SKT__new_empty();
Signal = Signal__new_empty();
Signal = Signal__set_signame(Signal, 'SKT');
Signal = Signal__set_unit(Signal, 'degC');

Signal = Signal__set_samprate(Signal, sampRate);

if(median(rawHST) > 70)
	warning(['The signal given seems to be given in °F. I need °C ! ' ...
	         'Automatic conversion applied. ' ...
	         'And stop using Fahrenheit, nobody uses it anyway !']);
	rawHST = (rawHST - 32) .* (5/9);
end

if(median(rawHST) < 4 && median(rawHST) > -4) %we may have a relative signal
	Signal = Signal__set_absolute(Signal, false);
elseif(median(rawHST) < 20 || median(rawHST) > 45)
	error(['Something seems wrong with the HST signal: temperatures outside' ...
	       ' range (20; 54)']);
end


Signal = Signal__set_raw(Signal, Raw_convert_1D(rawHST));

end
