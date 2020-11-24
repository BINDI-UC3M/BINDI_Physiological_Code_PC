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
%> @file PLETtoBPM.m
%> @brief Search for the upper peak, if systolic upstroke is desired, simply negate the signal
% 
%> @param data the pletysmograph data
%> @param fe sampling frequency
%> @param methodPeak detection method for choice in case of many peak (default 'max')
%>   'sharp': the shapest peak
%>   'max: the highest peak
%>   'first': the first peak of the two
%> @param SizeWindow for mean filtering, 0-> no fitlering (default fe/50) 
%> @param verbose display a graph of the result if 1 (default 0)
% 
%> @retval bpm Heart rate in bpm
%> @retval delta Heart rate in time
%> @retval t vecteur contenant les samples central des deux pics ayant servi a
%> calculer le bpm
%> @retval listePic liste des echantillon ou il y a eu des pics detect�
%> Ver 2 : n'utilise pas les wavlet mais seulement la d�riv�e du signal
%> Ver 3 : plus de gros filtrage et choix des pics suivant differetes methodes
% 
%> @author Guillaume Chanel 2015
%> @author DTE UC3M 2016

function [bpm, delta_t, t, listePic] = PLETtoBPM(data, fe, methodPeak, SizeWindow, verbose)

if(nargin < 3)
    methodPeak = 'first';
end
if(nargin < 4)
   SizeWindow = round(fe/50);
end
if(nargin < 5)
    verbose = 0;
end

% Just in case any pure DC residual over the whole signal
%data = data - mean(data);

% Apply this in case the signal is not filtered before
if(SizeWindow ~= 0)
  %dataS = filtfilt(ones(1, SizeWindow)/SizeWindow, 1, [repmat(data(1),SizeWindow,1);data]);
  %dataS = dataS(SizeWindow+1:end);
  %dataS = medfilt1(data,SizeWindow);
  dataS = data;
else
  dataS = data;
end

%% Two alternative PLETtoBPM methods (delineation)
% A) TEAP Like based on first derivative and three peak finders methods
% B) DTE-UC3M Like based on first and second derivative and finite state
% machine for identifying the following characteristics within the waves:
%     B.1) Systolic Peak
%     B.2) Possible incisura if any
%     B.3) Possible Dicrotic Notch if any
%     B.4) Possible Dicrotic Peak if any
% The alternative B is based on the arterial line waveform. Take into
% account that this wave depends on the age of the user and the position of
% the sensor. Another key aspect is that characteristics points 
% (dicrotic notchs,etc.) are stored to compute useful features (as PWV, etc.).
% delineation = 1 / TEAP
% delineation = 2 / UC3M
delineation = 1;

% First derivative from filtered bvp data
diffS = diff(dataS);

% Second derivative from first derivative bvp data
diffSS = diff(diffS);

 %Procedure to keep only peaks that are separated by at least T_lim seconds
 %other are considered as the same peak and one of the two is selected
 %according to the choosen method. Also peaks that are lie alone in the
 %first T_lim seconds are removed (cannot dentermine wich peak it is...)
 T_lim = 0.35;
 limit = ceil(T_lim*fe);

%% TEAP Delineation
if (delineation == 1)
  
  %looking for positive peaks : decreasing slope = 0
  listePic = [];
  for(iSpl = 1:length(diffS)-1)
      %If there is a slope == 0 // do not take into account in the last sample
      if((diffS(iSpl) > 0) & (diffS(iSpl+1) < 0)) 
          listePic = [listePic iSpl+(diffS(iSpl) / (diffS(iSpl) - diffS(iSpl+1)))];
      elseif ((diffS(iSpl)==0) & (diffS(iSpl+1) < 0))
          listePic = [listePic iSpl];
      end
  end
  %Sure to keep that ?
  listePic = round(listePic);
  
  
  %Remove too early first peak
  if((listePic(1) < limit) && (listePic(2) - listePic(1) >= limit))
      listePic = listePic(2:end);
  end
  
  %remove other peaks
  iPic = 1;
  while(iPic<=length(listePic)-1)
      %If two peaks are too close keep the one depending on the method
      if( (listePic(iPic+1) - listePic(iPic)) < limit)
          switch(methodPeak)
              case 'sharp'
                  nbSplFwd = round(0.05*fe);
                  if(listePic(iPic+1)+nbSplFwd > length(dataS))
                      nbSplFwd = length(dataS) - listePic(iPic+1);
                      warning(['Not enough signal to look 0.05s ahead, looking at ' num2str(nbSplFwd/fe) 's ahead'])
                  end
                  sharp2 = dataS(listePic(iPic+1)) - dataS(listePic(iPic+1)+nbSplFwd);
                  sharp1 = dataS(listePic(iPic)) - dataS(listePic(iPic)+nbSplFwd);
                  if(sharp1 < sharp2)
                      choice = 2;
                  else
                      choice = 1;
                  end
              case 'max'
                  [dummy, choice] = max([data(listePic(iPic)) data(listePic(iPic+1))]);
              case 'first'
                  choice = 1;
              otherwise
                  error([methodPeak ' method is unknown']);
          end
          if(choice==1)
              listePic(iPic+1) = [];
          else
              listePic(iPic) = [];
          end
      else
          iPic = iPic + 1;
      end
  
  end
%% UC3M delineation
elseif delineation == 2
    
    %looking for first and second crossing sections
    %looking for positive peaks : decreasing slope = 0
    listePic = [];
    listeValley = [];
    %FSM: systolicPeak(1), diastolicIncisura(2), 
    %diastolicNotch(3), diastolicPeak(4), undef(0),
    %syspossiblePeak(-1),diaspossibleIncisura(-2),
    %diaspossibleNotch(-3),diaspossiblePeak(-4),
    %rarexception(-5)
    sysPeaks = [1];
    dicPeaks = [1];
    dicNotch = [1];
    dicIncisura = [1];
    sysposPeaks = [];
    dicposPeaks = [];
    dicposNotch = [];
    dicposIncisura = [];
    % This is the threshold for dicrotic peak
    threshold_dic = 0.6;
    state = 0;
    prev_state = 0;
    countPeaks = 0;
    countValleys = 0;
    for(i = 2:length(diffSS)-1)
        %In case the two are crossing
         %In case there is a peak
        if diffSS(i)<diffS(i) && diffSS(i+1)>diffS(i+1)
           listePic = [listePic i];
%         elseif diffSS(i)==diffS(i) && diffSS(i+1)>diffS(i)
%            listePic = [listePic i];
        %In case there is a valley
        elseif diffSS(i+1)<diffS(i+1) && diffSS(i)>diffS(i)
           listeValley = [listeValley i];
%         elseif diffSS(i)==diffS(i) && diffSS(i+1)<diffS(i)
%            listeValley = [listeValley i];
        end
        
        %Time to check what type of point we have
     if state ~= -5
            %We just started
            % Evaluate the detected peaks and valleys 
            if length(listePic)>2 && length(listeValley)>1
              %In case there is an usual sys-dias-sys wave
              if dataS(listePic(2))<dataS(listePic(1))-dataS(listePic(1))*(1-threshold_dic) && ...
                  dataS(listePic(3))<=dataS(listePic(1))+dataS(listePic(1))*(1-threshold_dic ) && ... 
                  dataS(listePic(3))>=dataS(listePic(1))-dataS(listePic(1))*(1-threshold_dic )  && ...
                  (state == 0 || state == 4) && ...
                  listePic(1)-sysPeaks(end)>limit
                  sysPeaks = [sysPeaks listePic(1)];
                  if length(listeValley)<3
                    dicNotch = [dicNotch listeValley(1)];
                  elseif length(listeValley)<4
                      dicNotch = [dicNotch listeValley(2)];
                  end
                  dicPeaks = [dicPeaks listePic(2)];
                  sysPeaks = [sysPeaks listePic(3)];
                  state = 1;%systolicPeak;
               %In case there is an usual dias-sys-dias wave
              elseif (dataS(listePic(1))<dataS(listePic(2))-dataS(listePic(2))*(1-threshold_dic) || dataS(listePic(1))<dataS(listePic(2))) && ...
                     (dataS(listePic(3))<dataS(listePic(2))-dataS(listePic(2))*(1-threshold_dic )|| dataS(listePic(3))<dataS(listePic(2)))&& ...
                          (state == 0 || state == 1) && ...
                          listePic(2)-sysPeaks(end)>limit %&& listePic(1)-dicPeaks(end)>limit && listePic(3)-listePic(1)>limit
                  dicPeaks = [dicPeaks listePic(1)];
                  sysPeaks = [sysPeaks listePic(2)];
                  if length(listeValley)<3
                    dicNotch = [dicNotch listeValley(2)];
                  elseif length(listeValley)<4
                    dicNotch = [dicNotch listeValley(1)];
                    dicNotch = [dicNotch listeValley(3)];
                  end
                  dicPeaks = [dicPeaks listePic(3)];
                  state = 4;%diastolicPeak;
              %In case there is not dicrotic peak or diastolic part,
              %sys-sys-sys
              elseif  dataS(listePic(2))<=dataS(listePic(1))+dataS(listePic(1))*(1-threshold_dic ) && ... 
                          dataS(listePic(2))>=dataS(listePic(1))-dataS(listePic(1))*(1-threshold_dic ) && ...
                          dataS(listePic(3))<=dataS(listePic(2))+dataS(listePic(2))*(1-threshold_dic ) && ... 
                          dataS(listePic(3))>=dataS(listePic(2))-dataS(listePic(2))*(1-threshold_dic ) && ...
                          listePic(2)-listePic(1)>limit && listePic(3)-listePic(2)>limit && listePic(1)-sysPeaks(end)>limit
                  sysPeaks = [sysPeaks listePic(1)];
                  sysPeaks = [sysPeaks listePic(2)];
                  sysPeaks = [sysPeaks listePic(3)];
                  state = 1;%systolicPeak;
               %In case there is incisura and dicrotic peak - wave is
               %sys-incisura-dias
              elseif  (dataS(listePic(2))<dataS(listePic(1))-dataS(listePic(1))*(1-threshold_dic) || dataS(listePic(2))<dataS(listePic(1))) && ...
                      (dataS(listePic(3))<dataS(listePic(1))-dataS(listePic(1))*(1-threshold_dic) || dataS(listePic(3))<dataS(listePic(2)) || ...
                      (dataS(listePic(3))<dataS(listePic(1))-dataS(listePic(1))*(1-threshold_dic) && dataS(listePic(3))>dataS(listePic(2)))) && ...
                         (dataS(listePic(3))-dataS(listeValley(2)))<(dataS(listePic(2))-dataS(listeValley(1))) %&& ...
                  sysPeaks = [sysPeaks listePic(1)];
                  dicIncisura = [ dicIncisura listePic(2)];
                  if length(listeValley)<3
                    dicNotch = [dicNotch listeValley(2)];
                  elseif length(listeValley)<4
                      dicNotch = [dicNotch listeValley(3)];
                  end
                  dicPeaks = [dicPeaks listePic(3)];
                  state = 4;%diastolicPeak;
               %In case there is incisura and dicrotic peak - wave is
               %incisura-dias-sys
              elseif  dataS(listePic(2))<dataS(listePic(1)) && ...
                          dataS(listePic(3))>dataS(listePic(2)) && ...
                          (dataS(listePic(3))-dataS(listeValley(2)))>(dataS(listePic(1))-dataS(listeValley(2)))  && ... % listePic(2)-listePic(1)<limit && listePic(3)-listePic(2)<limit &&
                          listePic(3)-sysPeaks(end)>limit && ... % listePic(2)-sysPeaks(end)<limit && ...
                          (state == 0 || state == 1)
                  dicIncisura = [dicIncisura listePic(1)];
                  dicNotch = [dicNotch listeValley(1)];
                  dicPeaks = [dicPeaks listePic(2)];
                  sysPeaks = [sysPeaks listePic(3)];
                  state = 1;%systolicPeak;
               %In case the previous dic peak was actually a incisura and
               %the wave result into inc-dic-sys-dic
              elseif  dataS(listePic(3))<dataS(listePic(2)) && ...
                      dataS(listePic(1))<dataS(dicPeaks(end)) && ...
                      dataS(listePic(1))<dataS(listePic(2)) && ...
                      dataS(sysPeaks(end))>dataS(dicPeaks(end)) && ...
                      listePic(2)-sysPeaks(end)>limit && ... % listePic(2)-sysPeaks(end)<limit && ...
                          (state == 0 || state == 4)
                  dicIncisura = [dicIncisura dicPeaks(end)];
                  dicNotch(end) =  listeValley(1);
                  dicPeaks(end) = listePic(1);
                  sysPeaks = [sysPeaks listePic(2)];
                  dicPeaks = [dicPeaks listePic(3)];
                  state = 4;%systolicPeak;
              else
                  prev_state = state;
                  state = 0;
              end
              if state~=0
                %state=0;
                listePic = [];
                listeValley = [];
              else
                state= -5;
                countPeaks = length(listePic);
                countValleys = length(listeValley);
              end
            end
      elseif state == -5 && countPeaks == length(listePic) && countValleys ==length(listeValley)
        % Evaluate cases that are not within a perfect BVP waveform
        %In case sys-dias-sys, but second sys is not within the +-
        %threshold range
         if dataS(listePic(2))<dataS(listePic(1))-dataS(listePic(1))*(1-threshold_dic) && ...
            dataS(listePic(3))>dataS(listePic(2)) && ...
            (prev_state == 0 || prev_state == 1) && ...
            listePic(1)-sysPeaks(end)>limit && listePic(3)-listePic(1)>limit
                  sysPeaks = [sysPeaks listePic(1)];
                  if length(listeValley)<3
                    dicNotch = [dicNotch listeValley(1)];
                  elseif length(listeValley)<4
                      dicNotch = [dicNotch listeValley(2)];
                  end
                  dicPeaks = [dicPeaks listePic(2)];
                  sysPeaks = [sysPeaks listePic(3)];
                  state = 1;%systolicPeak;
          %In case sys-dias-sys, but signal presents distortion, we
          %trust on to the temporal limit
         elseif listePic(3)-listePic(1) > limit &&...
                ((listePic(1) - sysPeaks(end) > limit && sysPeaks(end)~=1) || (dataS(listePic(1))>dataS(listePic(2)) && ...
                  dataS(listePic(2))<dataS(listePic(3))))
                  sysPeaks = [sysPeaks listePic(1)];
                  if length(listeValley)<3
                    dicNotch = [dicNotch listeValley(1)];
                  elseif length(listeValley)<4
                      dicNotch = [dicNotch listeValley(2)];
                  end
                  dicPeaks = [dicPeaks listePic(2)];
                  sysPeaks = [sysPeaks listePic(3)];
                  state = 1;%systolicPeak;
          %In case dias-sys-dias, but signal presents distortion, we
          %trust on to the temporal limit 
         elseif (prev_state == 0 || prev_state == 1) && listePic(3)-listePic(1) > limit && ...
                  ((listePic(2) - sysPeaks(end) > limit && sysPeaks(end)~=1) || (dataS(listePic(1))<dataS(listePic(2)) && ...
                  dataS(listePic(2))>dataS(listePic(3))))
                  dicPeaks = [dicPeaks listePic(1)];
                  sysPeaks = [sysPeaks listePic(2)];
                  dicPeaks = [dicPeaks listePic(3)];
                  if length(listeValley)<3
                    dicNotch = [dicNotch listeValley(2)];
                  elseif length(listeValley)<4
                    dicNotch = [dicNotch listeValley(1)];
                    dicNotch = [dicNotch listeValley(3)];
                  end
                  state = 4;%diastolicPeak;
          %In case inci-dias-sys, but signal presents distortion, we
          %trust on to the temporal limit 
         elseif (prev_state == 0 || prev_state == 1) && listePic(3) - sysPeaks(end) > limit  && ...
                  ((listePic(2) - dicPeaks(end) > limit && dicPeaks(end)~=1) || (dataS(listePic(1))>dataS(listePic(2)) && ...
                  dataS(listePic(2))<dataS(listePic(3))))
                  dicIncisura = [dicIncisura listePic(2)];
                  dicNotch = [dicNotch listeValley(1)];
                  dicPeaks = [dicPeaks listePic(1)];
                  sysPeaks = [sysPeaks listePic(3)];
                  state = 1;%systolicPeak;
         %In case dias-sys-sys, but signal presents distortion, we
         %trust on to the temporal limit 
         elseif (prev_state == 0 || prev_state == 1) && listePic(3)-listePic(2) > limit && ...
                  ((listePic(2) - sysPeaks(end) > limit && sysPeaks(end)~=1) || (dataS(listePic(1))<dataS(listePic(2)) && ...
                  dataS(listePic(1))<dataS(listePic(3))))
                  dicPeaks = [dicPeaks listePic(1)];
                  sysPeaks = [sysPeaks listePic(2)];
                  sysPeaks = [sysPeaks listePic(3)];
                  state = 1;%systolicPeak;
         end
         if state~=0
           %state=0;
           listePic = [];
           listeValley = [];
         else
           state= -5;
           countPeaks = length(listePic);
           countValleys = length(listeValley);
         end
      elseif state == -5 && countPeaks< length(listePic) && countValleys<length(listeValley)
        % Evaluate rare cases
        %In case dias-sys-dias, but second dias is higher than sys
        state=0;
        listePic = [];
        listeValley = [];
     end
     hold off;
    plot(data);
    hold on;plot(sysPeaks,data(round(sysPeaks)),'+');
    plot(dicNotch(2:end),data(round(dicNotch(2:end))),'*')
    plot(dicPeaks(2:end),data(round(dicPeaks(2:end))),'o')
   end
    listePic=sysPeaks(2:end);
    temp = diff(listePic);
    [~,b] = find(temp<limit);
    listePic(b) = [];
end

%% Check at least two peaks were obtained
if (length(listePic) < 2)
    error('There should be at least 2 peaks to detect');
end

%% Compute bpm from the pic list
[bpm delta_t t] = PICtoBPM(listePic, fe);

if(verbose)
    figure; hold on;
    plot(data);
    plot(dataS,'r');
    plot(diffS,'g');
    plot(listePic,data(round(listePic)),'+')
    plot(listePic,dataS(round(listePic)),'+r')
    plot(listePic,diffS(round(listePic)),'+g')
    plot(t,bpm,'c*-')
end
end
