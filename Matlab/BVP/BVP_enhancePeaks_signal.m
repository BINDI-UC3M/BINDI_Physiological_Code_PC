%> @file BVP_enhancePeaks_signal.m
%> @brief BVP_enhancePeaks_signal enhance R to noise ratio by cubing, then normalising back
% 
%> @param   Signal: A BVP TEAP-UC3M-like signal
% 
%> @retval  Signal: A BVP TEAP-UC3M-like signal
% 
%> @author Copyright UC3M
function Signal = BVP_enhancePeaks_signal(Signal) 
  
  %Check if it is a signal
  Signal__assert_mine(Signal);

  %Get raw data
  raw = Signal__get_raw(Signal);
  
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
  
  %Set signal back
  Signal = Signal__set_raw(Signal, raw);
  
  %Set enhance attribute
  Signal = Signal__set_preproc(Signal, 'enhancePeaks');
  
end