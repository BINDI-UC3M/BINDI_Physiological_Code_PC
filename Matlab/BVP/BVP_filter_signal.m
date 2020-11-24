    %> @file BVP_filter_signal.m
%> @brief Zero-phase Filter applyed to 1D signals specified by FIRCoeffs (such as GSR, ECG, etc…).
% 
%> @param Signal: the signal to filter (will use the .raw component). Not a bulk sig. !
%> @param FIRCoeffs: the coefficients of the filter
% 
%> @retval Signal: the filtered-signal
% 
%> @author Copyright UC3M
function Signal = BVP_filter_signal(Signal, FIRCoeffs)

if(nargin ~= 2 || nargout ~= 1)
	error('Usage: Signal = BVP_filter_signal(Signal, cutOffFreq)');
end

Signal__assert_mine(Signal);

rawSignal = Signal__get_raw(Signal);

newRaw = filtfilt(FIRCoeffs, 1, rawSignal);

Signal = Signal__set_raw(Signal, newRaw);

%Indicate that the signal has been filtered
Signal = Signal__set_preproc(Signal, 'filtered');

end