%This file is part of TEAP.
%
%TEAP is free software: you can redistribute it and/or modify
%it under the terms of the GNU General Public License as published by
%the Free Software Foundation, either version 3 of the License, or
%(at your option) any later version.
%
%TEAP is distributed in the hope that it will be useful,
%but WITHOUT ANY WARRANTY; without even the implied warranty of
%MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
%GNU General Public License for more details.
%
%You should have received a copy of the GNU General Public License
%along with TEAP.  If not, see <http://www.gnu.org/licenses/>.
% 
%> @file ECG__compute_IBI.m
%> @brief Computes the IBI if it is not yet available
%> @param  ECGSignal: the ECG signal
%> @retval  ECGSignal: the ECG signal containing the computed IBI signal
%
%> @author Copyright Guillaume Chanel 2015
function BVPSignal = ECG__compute_IBI( BVPSignal )

%Compute the signal if it has not been already computed
if(isempty(Signal__get_raw(BVPSignal.IBI)))
	
	%Get information on the ECG signal
	rawSignal = Signal__get_raw(BVPSignal);
	samprate = Signal__get_samprate(BVPSignal);

	%Compute IBI
	newfs = 200; %Hz, as needed by rpeakdetect
% 	ECG = resample(rawSignal, newfs, samprate); %WARN what happens if samprate/newfs is not a integer ?
    ECG = rawSignal;
	if size(ECG,1)<size(ECG,2)
		ECG = ECG';
	end
	[hrv, R_t, R_amp, R_index, S_t, S_amp] = rpeakdetect(ECG, newfs); %FIXME: there seem to be a problem with filter side effects (begin and end)
	[~, IBI,t_IBI, listePeak] = correctBPM(R_index, newfs);
	
% 	%If the number of detected peaks is lower than 2 than IBI cannot be
% 	%computed
% 	if(length(listePeak) < 2)
% 		warning(['A least 2 peaks are needed to compute IBI but ' num2str(length(listePeak)) ' were found: result will be NaN'])
% 		ECGSignal.IBI = Signal__set_raw(ECGSignal.IBI,IBI);
% 	else
% 		%Attribute the computed signal to IBI to check if range is correct
% 		% This is done now because this can cause problems in the resampling
% 		ECGSignal.IBI = Signal__set_raw(ECGSignal.IBI,IBI);
% 		Signal__assert_range(ECGSignal.IBI, 0.25, 1.5, 1);
% 		
% 		%Resample the signal with the one requested for IBI
% 		IBI_samprate = Signal__get_samprate(ECGSignal.IBI);
% 		IBI = interpIBI(listePeak/newfs,IBI_samprate,listePeak(end)/newfs)';
% 	
% 		%Attribute the computed signal to IBI
% 		ECGSignal.IBI = Signal__set_raw(ECGSignal.IBI,IBI);
% 	end

 %Set interpolated IBI
%     BVPSignal.IBI.interp = IBI_interp;
    
	%Attribute the computed signal to IBI
	%BVPSignal.IBI = Signal__set_raw(BVPSignal.IBI,IBI_interp);
    BVPSignal.IBI = Signal__set_raw(BVPSignal.IBI,IBI);
    BVPSignal.IBI.timelocations = t_IBI;
end

end

