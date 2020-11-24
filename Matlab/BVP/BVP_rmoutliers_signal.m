%> @file BVP_rmoutliers_signal.m
%> @brief Remove outliers based on the movmedian three-std of one second signal. One
%                  second should be enough to remove outliers. 
% 
%> @param Signal: the signal to filter (will use the .raw component). Not a bulk sig. !
% 
%> @retval Signal: the filtered-signal
% 
%> @author Copyright UC3M
function Signal = BVP_rmoutliers_signal(Signal)

if(nargout ~= 1)
	error('Usage: Signal = BVP_rmoutliers_signal(Signal)');
end

Signal__assert_mine(Signal);

rawSignal = Signal__get_raw(Signal);
samprate = Signal__get_samprate(Signal);

newRaw = rmoutliers(rawSignal,'movmedian',samprate);

Signal = Signal__set_raw(Signal, newRaw);

%Indicate that the signal has been rmoutlier
Signal = Signal__set_preproc(Signal, 'rmoutlier');

end