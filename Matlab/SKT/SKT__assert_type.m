%> @file SKT__assert_type.m
%> @brief Asserts that the given signal is a SKT one
% 
%> @author Copyright UC3M
function Signal = SKT__assert_type(Signal)

if(nargin ~= 1 || nargout ~= 1)
	error('Usage: Signal = SKT__assert_type(Signal)');
end

Signal = Signal__assert_type(Signal, 'SKT');

