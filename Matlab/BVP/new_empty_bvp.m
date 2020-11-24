%> @file new_empty_bvp.m
%> @brief Creates a new BVP empty signal
%> @retval Signal an empty @b BVP signal
function Signal = new_empty_bvp()

Signal = Signal__new_empty();
Signal = Signal__set_signame(Signal, BVP__get_signame());
Signal = Signal__set_unit(Signal, 'undef');

%Create IBI information.
Signal.IBI = Signal__new_empty(); 

%Inter beat interval (empty if not computed) a vector otherwise
Signal.IBI = Signal__set_signame(Signal.IBI, 'IBI');

%For the moment the user cannot choose it
Signal.IBI = Signal__set_unit(Signal.IBI, 's'); 

%...TBD...For the moment the user cannot choose it?
%Signal.IBI = Signal__set_samprate(Signal.IBI, 8);

end
