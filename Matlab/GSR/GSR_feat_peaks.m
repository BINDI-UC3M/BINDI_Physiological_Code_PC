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
%> @file GSR_feat_peaks.m
%> @brief Computes the number of peaks from a GSR signal. It is based on the analysis of
%> local minima and local maxima preceding the local minima.
% 
%> @param  GSRsignal: the GSR signal.
%> @param  ampThresh: the amplitude threshold in Ohms from which a peak is detected.
%>             Default is 100 Ohm
% 
%> @retval  nbPeaks: the # of peaks in the signal
%> @retval  ampPeaks [1xP]: the amplitude of the peaks (maxima - minima)
%> @retval  riseTime [1xP]: the duration of the rise time of each peak
%> @retval  posPeaks [1xP]: index of the detected peaks in the GSR signal
% 
%> @author Copyright XXX 2011
%> @author Copyright Frank Villaro-Dixon, 2014
function [nbPeaks, ampPeaks, riseTime, recoveryTime, aup, stdSCR, posPeaks, phasicGSR] = GSR_feat_peaks(GSRsignal)


%Make sure we have a GSR signal
GSRsignal = GSR__assert_type(GSRsignal);
GSR_raw = Signal__get_raw(GSRsignal);

% if(~Signal__has_preproc_lowpass(GSRsignal))
% 	warning(['For the function to work well, you should low-pass the signal' ...
% 	         '. Preferably with a median filter']);
% end

if(nargin < 2)
% 	ampThresh = 100;%Ohm
    ampThresh = 0;%Ohm
end

if(nargin < 1)
	error('Usage: [nbPeaks, ampPeaks, riseTime, posPeaks, GSRsignal] = GSR_feat_peaks(GSRsignal, ampThresh)');
end

%% Two alternative GSR_feat_peaks methods (component separation)
% A) SparsEDA based - built-in algorithm to extract SCL and substract it to
%    signal to get SCR. No operations yet deployed with SCR driver.
% B) DTE-UC3M Like based on peak-through methodology
% separation = 1 / SparsEDA
% separation = 2 / UC3M
separation = 2;

  if separation == 1
    %TBD...
    graphics = 0;
    epsilon  = 1;
    Kmax   = 40;
    samprate = Signal__get_samprate(GSRsignal);
    sr=samprate;
    dmin = 1.25*sr;  % Minimum distance between activations
    rho = 0.025;
    reAdjust = 0;
    
    %% Apply SparsEDA
    if(length(GSR_raw)/sr < 80)
      reAdjust = 1;
      dif = ceil(80 - length(GSR_raw)/sr);
      difhalf = ceil(dif/2);
      GSR_raw = [GSR_raw(1)*ones(difhalf*sr,1); GSR_raw';GSR_raw(end)*ones(difhalf*sr,1);];
    end
    [driver, SCL, signalOut ,~] = sparsEDA(GSR_raw,sr,graphics,epsilon,Kmax,dmin,rho);
    GSR_phasic = signalOut - SCL';
    if reAdjust
      GSR_phasic = GSR_phasic(difhalf*8:(end-difhalf*8));
    end
    phasicGSR = GSR_phasic;
  else
    tWindowSec = 4;

    %Search low and high peaks
    %low peaks are the GSR appex reactions (highest sudation)
    %High peaks are used as starting points for the reaction
    samprate = Signal__get_samprate(GSRsignal);
    %GSR=(1./GSR_raw)*1e6;
    GSR=GSR_raw;
    GSR_median = movmedian(GSR, [tWindowSec*samprate tWindowSec*samprate]);
    GSR_phasic = GSR - GSR_median;
    %GSR_phasic = detrend(GSR);
%     [GSR_phasic, p, GSR_tonic, l, d, e, obj] = cvxEDA(zscore(GSR), 1/samprate);
%     figure, hold all
%     tm = (1:length(GSR))'/samprate;
%     plot(tm, (GSR))
%     plot(tm, GSR_phasic)
%     plot(tm, p)
%     plot(tm, GSR_tonic)
    phasicGSR = GSR_phasic;
    %GSR_tonic  = GSR-detrend(GSR);
    %GSR_tonic  = GSR_median;
  end
    
    stdSCR = std(GSR_phasic);

    %For each low peaks find it's nearest high peak and check that there is no
    %low peak between them, if there is one, reject the peak (OR SEARCH FOR CURVATURE)
    riseTime = []; %vector of rise time for each detected peak
    recoveryTime = []; %vector of recovery time for each detected peak
    ampPeaks = []; %vector of relative amplitude for each detected peak
    absAmpPeaks = []; %vector of absolute amplitude for each detected peak
    posPeaks = []; %vector of final indexes of low peaks
    aup=[];        %area under identified scr
    %uS units
    peakOnset_th = 0.01;
    peakOffset_th = 0;
    %SCR minimum duration is 1 sec
    SCRminDuration = samprate*1; 
    onsets=[];
    offsets=[];
    ctr_peak = 1;
    finding_offset = 0;
    for i=1:length(GSR_raw)-1 
      %Find peak onset >peakOnset_th (uS)
      if GSR_phasic(i)>peakOnset_th && GSR_phasic(i+1)>GSR_phasic(i) && finding_offset==0
        onsets=[onsets;i];
        last_onset = i;
        finding_offset = 1;
      elseif GSR_phasic(i)<=peakOffset_th && finding_offset == 1
        %Find peak offset ==peakOffset_th, check that SCR duration is at least
        %SCRminDuration
        if length(onsets)>0 && length(offsets)==(length(onsets)-1) ...
            && (i-onsets(end))>SCRminDuration
          offsets=[offsets;i];
          last_offset = i;
          finding_offset = 0;
          %Annotate onset and offset and find peak--> max(GSR_raw)
          peakTimes(ctr_peak,:)=[last_onset, last_offset];
          [peak_raw, peak_pos] = max(GSR_phasic(peakTimes(ctr_peak,1):peakTimes(ctr_peak,2)));
          aup(ctr_peak)=trapz(GSR_phasic(peakTimes(ctr_peak,1):peakTimes(ctr_peak,2)));
          riseTime(ctr_peak)=peak_pos;
          recoveryTime(ctr_peak)=(last_offset-last_onset)-peak_pos;
          ampPeaks(ctr_peak)=peak_raw-GSR_phasic(peakTimes(ctr_peak,1));
          posPeaks(ctr_peak)=peak_pos+last_onset-1;
          %absAmpPeaks(ctr_peak)=GSR_raw(posPeaks(ctr_peak));
          ctr_peak = ctr_peak + 1;
        else
            %The SCR duration is less than one second, omit this SCR
            onsets(end) = [];
            finding_offset = 0;
        end
      end
      nbPeaks = length(ampPeaks);
    end
end















