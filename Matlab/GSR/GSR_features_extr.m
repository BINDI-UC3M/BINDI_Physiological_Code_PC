%> @file GSR_feat_extr.m
%> @brief Computes GSR features
% 
%> @param  GSRsignal: the GSR signal.
%> @param  varargin: you can choose which features to extract (see featureSelector)
%>            the list of available features is:
%>               - nbPeaks: number of GSR peaks per second
%>               - ampPeaks: average amplitude of peaks
%>               - riseTime: average rise time of peaks
%>               - meanGSR: average GSR value
%>               - stdGSR: variance of GSR
% 
%> @retval  GSR_feats: list of features values
%> @retval  GSR_feats_names: names of the computed features (it is good pratice to
%>                   check this vector since the order of requested features
%>                   can be different than the requested one)
%> @author Copyright XXX 2011
%> @author Copyright Frank Villaro-Dixon, 2014
%> @author Copyright UC3M, 2016
function [GSR_feats, GSR_feats_names] = GSR_features_extr(GSRsignal,varargin)

% Check inputs and define unknown values
narginchk(1, Inf);

%Check signals and get sample rate
GSRsignal = GSR__assert_type(GSRsignal);
% if(~Signal__has_preproc_lowpass(GSRsignal))
% 	warning(['For the function to work well, you should low-pass the signal' ...
% 			'. Preferably with a median filter']);
% end
samprate = Signal__get_samprate(GSRsignal);
GSR_raw = Signal__get_raw(GSRsignal);

% Define full feature list and get features selected by user
% featuresNames = {'nbPeaks', 'ampPeaks', 'riseTime', ...
%                  'recoveryTime', 'aup', 'meanGSR', 'stdGSR',...
%                  'firstQuartileGSR','thirdQuartileGSR','sp0005','sp0515',...
%                  'sp_energyRatio', 'dfa','rrate','det','lmax','ent','lam','tt','corDim'};
featuresNames = {'nbPeaks', 'ampPeaks', 'riseTime', ...
                 'recoveryTime', 'aup', 'meanGSR', 'stdGSR',...
                 'firstQuartileGSR','thirdQuartileGSR','sp0005','sp0515',...
                 'sp_energyRatio'};
%featuresNames = {'meanGSR', 'stdGSR'};
GSR_feats_names = featuresSelector(featuresNames,varargin{:});

signalUnit = Signal__get_unit(GSRsignal);

if strcmp(signalUnit, 'Ohm')
%      disp('The GSR unit is Ohm');
     featuresNames = {'nbPeaks', 'ampPeaks', 'meanGSR', 'stdGSR',...
                 'firstQuartileGSR','thirdQuartileGSR','sp0005','sp0515',...
                 'sp_energyRatio', 'dfa','rrate','det','lmax','ent','lam','tt','corDim'};
     %featuresNames = {'meanGSR', 'stdGSR'};
     GSR_feats_names = featuresSelector(featuresNames,varargin{:});
	 raw = Signal__get_raw(GSRsignal);
	 raw = 1./(raw);
     GSRsignal = Signal__set_raw(GSRsignal, raw);
     GSRsignal = Signal__set_unit(GSRsignal, 'uS')
     signalUnit = Signal__get_unit(GSRsignal);
elseif strcmp(signalUnit, 'nS')
	%convert from nano siemens to resistance
	raw = Signal__get_raw(GSRsignal);
	raw = 1./(raw*10E9);
	GSRsignal = Signal__set_raw(GSRsignal, raw);
	ampThresh = 100;%Ohm
elseif strcmp(signalUnit, 'uS')
%     disp('The GSR unit is uS');
else
	error(['The GSR unit (' ...
	       signalUnit ') is unknown; please fix it - a threshold shall be adjusted to the unit'])
end

%If some features are selected
if(~isempty(GSR_feats_names))
	
	if any(strcmp('nbPeaks',GSR_feats_names)) || any(strcmp('ampPeaks',GSR_feats_names)) || any(strcmp('riseTime',GSR_feats_names))
		
        if strcmp(signalUnit, 'uS')
 		  [nbPeaks, ampPeaks, riseTime, recoveryTime, aup, stdSCR, posPeaks, phasicGSR] = GSR_feat_peaks(GSRsignal);
        elseif strcmp(signalUnit, 'Ohm')
          [nbPeaks, ampPeaks, riseTime, posPeaks, phasicGSR] = GSR_feat_peaks_Ohm(GSRsignal);
        end
%         [nbPeaks, ampPeaks, riseTime, posPeaks] = GSR_feat_peaks(GSRsignal);
        if nbPeaks == 0
          nbPeaks = 0;
          ampPeaks = 0;
          if any(strcmp('riseTime',GSR_feats_names)) || any(strcmp('recoveryTime',GSR_feats_names)) || any(strcmp('aup',GSR_feats_names))
            %absAmpPeaks = 0;
            riseTime = 0;
            recoveryTime = 0;
            aup = 0;
          end
        else
          nbPeaks = nbPeaks;%/(length(GSRsignal.raw)/samprate);
		  ampPeaks = mean(ampPeaks);
          if any(strcmp('riseTime',GSR_feats_names)) || any(strcmp('recoveryTime',GSR_feats_names)) || any(strcmp('aup',GSR_feats_names))
            %absAmpPeaks = mean(absAmpPeaks);
		    riseTime = mean(riseTime)/samprate;  
            recoveryTime = mean(recoveryTime)/samprate;
            aup = sum(aup);
          end
        end
		
		%TODO what is this good for? posPeaks
	end
	
	%mean computation
	if any(strcmp('meanGSR',GSR_feats_names))
		%meanGSR = Signal_feat_mean(GSRsignal);
        meanGSR = mean(GSR_raw);
	end
	
	%standard devisation computation
    if any(strcmp('stdGSR',GSR_feats_names))
		%stdGSR = Signal_feat_std(GSRsignal);
        stdGSR = std(GSR_raw);
    end
    %first quartile
    if any(strcmp('firstQuartileGSR',GSR_feats_names))
		%firstQuartileGSR = Signal_feat_quant(GSRsignal, 0.25);
        firstQuartileGSR = quantile(GSR_raw, 0.25);
    end
    
    %third quartile
    if any(strcmp('thirdQuartileGSR',GSR_feats_names))
		%thirdQuartileGSR = Signal_feat_quant(GSRsignal, 0.75);
        thirdQuartileGSR = quantile(GSR_raw, 0.75);
    end
    
    %spectral power in 0.0-0.5Hz band
    welch_window_size_GSR = floor(length(GSR_raw)-samprate);
    if any(strncmp('sp',GSR_feats_names,2))
		[P, f] = pwelch(GSR_raw, welch_window_size_GSR, [], [], samprate);
        P=P/sum(P);
		%power spectral featyres
		sp0005 = log(sum(P(f>0.0 & f<=0.5))+eps);
		sp0515 = log(sum(P(f>0.5 & f<=1.5))+eps);
		sp_energyRatio = log(sum(P(f<0.5))/sum(P(f>0.5 & f<1.5))+eps);
    end
    
    %Faster faster ..
    GSR_raw=downsample(GSR_raw,4);
    
     %dfa - Detrended Fluctuation Analysis
    if any(strcmp('dfa',GSR_feats_names))
     pts = round(length(GSR_raw)/10):10:length(GSR_raw);
	 [dfa_out,~] = DFA_fun(GSR_raw,pts);
     dfa = dfa_out(1);
    end
    
    %rqa_stat - RQA statistics - [recrate DET LMAX ENT TND LAM TT]
    if any(strcmp('rrate',GSR_feats_names))
      %Determining embedding dimension m and time lag (delay time) t
      [y,eLag,eDim]=phaseSpaceReconstruction(GSR_raw,'MaxLag',500);
      
      % phase space plot
      %y = phasespace(GSR_raw,3,10);
%       figure('Position',[100 400 460 360]);
%       plot3(y(:,1),y(:,2),y(:,3),'-','LineWidth',1);
%       title('GSR time-delay embedding - state space plot','FontSize',10,'FontWeight','bold');
%       grid on;
%       set(gca,'CameraPosition',[25.919 27.36 13.854]);
%       xlabel('x(t)','FontSize',10,'FontWeight','bold');
%       ylabel('x(t+\tau)','FontSize',10,'FontWeight','bold');
%       zlabel('x(t+2\tau)','FontSize',10,'FontWeight','bold');
%       set(gca,'LineWidth',2,'FontSize',10,'FontWeight','bold');

      % color recurrence plot
      %cerecurr_y(y);
      recurdata = cerecurr_y(y);
      
      %S. Schinkel, O. Dimigen, and N. Marwan, “Selection of Recurrence
      %Threshold for Signal Detection,” The European Physical J.-Special
      %Topics, vol. 164, no. 1, pp. 45-53, 2008
      e_thr=0.1*mean(mean(recurdata));

      % black-white recurrence plot
      %tdrecurr_y(recurdata,e_thr);
      recurrpt = tdrecurr_y(recurdata,e_thr);

      %Recurrence quantification analysis
      % rqa_stat - RQA statistics - [recrate DET LMAX ENT LAM TT]
      rqa = recurrqa_y(recurrpt);
      %[rrate,det,lmax,ent,lam,tt]
      rrate=rqa(1);
      det=rqa(2);
      lmax=rqa(3);
      ent=rqa(4);
      lam=rqa(5);
      tt=rqa(6);
      
      %Correlation Dimension to calculate D 2.
      %(Note: it is the measure of chaotic signal complexity in multidimensional 
      % phase space and is the slope of the correlation integral versus 
      % the range of radius of similarity)
      corDim=correlationDimension(GSR_raw,eLag,eDim,'NumPoints',100)/2;
    end
	
	%Write the values to the final vector output
	for i = 1:length(GSR_feats_names)
		eval(['GSR_feats(i) = ' GSR_feats_names{i} ';']);
	end
	
else %no features selected
	GSR_feats = [];
end

end

