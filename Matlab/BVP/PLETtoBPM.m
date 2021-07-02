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
    methodPeak = 'max';
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
    for i = 2:length(diffSS)-1
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
%      hold off;
%     plot(data);
%     hold on;plot(sysPeaks,data(round(sysPeaks)),'+');
%     plot(dicNotch(2:end),data(round(dicNotch(2:end))),'*')
%     plot(dicPeaks(2:end),data(round(dicPeaks(2:end))),'o')
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

%% -->This TMR-decision-based like is optional, comment if desired
%%[ADT Elsevier, Hang shin sink]
[picos_final, valles_final] = ADT(data, fe);

%%[ADS IJCA, Sirinivas]
[picos_final2, valles_final2] = ASP(data);

%TMR with three low complexity LCM-Slope-based algorithms
t = [picos_final.posicion];
t2 = [picos_final2.posicion];
nbSplFwd = round(0.05*fe);

listePic_new_ab = [];
for j=1:length(listePic)
  for k=1:length(t)
    if (t(k)<=listePic(j)+nbSplFwd && t(k)>=listePic(j)-nbSplFwd) 
      listePic_new_ab(j) = t(k);
      break
    end
  end
end

listePic_new_ac = [];
for j=1:length(listePic)
  for k=1:length(t2)
    if (t2(k)<=listePic(j)+nbSplFwd && t2(k)>=listePic(j)-nbSplFwd) 
      listePic_new_ac(j) = t2(k);
      break
    end
  end
end

listePic_new_bc = [];
for j=1:length(t)
  for k=1:length(t2)
    if (t2(k)<=t(j)+nbSplFwd && t2(k)>=t(j)-nbSplFwd) 
      listePic_new_bc(j) = t2(k);
      break
    end
  end
end

listePic_new = unique([listePic_new_ab, listePic_new_ac, listePic_new_bc]);
listePic_new(listePic_new==0)=[];
listePicOrig = listePic;
listePic = listePic_new;
% <--

%% Compute bpm from the pic list
[bpm delta_t t] = PICtoBPM(listePic, fe);

%% Verbose plots
if(verbose)
    figure; hold on;
    plot(data);
    plot(listePic,data(round(listePic)),'+')
%  if(verbose)   
    plot(dataS,'r');
    plot(diffS,'g');
    plot(listePic,dataS(round(listePic)),'+r')
    plot(listePic,diffS(round(listePic)),'+g')
    plot(t,bpm,'c*-')
end
end
%% Adaptive threshold method for the peak detection of photoplethysmographic waveform
function [picos_final, valles_final] = ADT(s_input, f_s)
inicio_ppg = 1;
picos_final     = 0;
valles_final    = 0;
[picos, valles] = delineateFirstDiffPPG(s_input);
tiempo_maximo = length(s_input);
slope_max = zeros(1, tiempo_maximo);
slope_min = zeros(1, tiempo_maximo);
if(isempty([picos.valor]) )%|| isempty([valles.valor]))
    %nothing
else
slope_max(1)= mean([picos.valor]);%0.2*max([picos.valor]);
% slope_min(1)= 0.2*min([valles.valor]);
Sr_max = -0.6;  % factor reductor de treshold superior experimental paper
Sr_min = 0.8;   % factor incrementador de treshold inferior experimental paper
muestras_IBI_previo = 0;
% muestras_IBI_previo_v = 0;
period_refractory = (0.6 * muestras_IBI_previo);
% period_refractory_v = (0.6 * muestras_IBI_previo_v);
i_p=1;
% i_v=1;
V_max = 0;
V_min = 0;
i_p_new = 1;
% i_v_new = 1;
picos_new(i_p_new) = picos(i_p);
% valles_new(i_v_new) = valles(i_v);

for k = 2:tiempo_maximo
    if(k + f_s < tiempo_maximo)
        inicio_ppg = k;
        fin_ppg = k + f_s;
    else
        inicio_ppg = k;
        fin_ppg = tiempo_maximo;
    end
    slope_max(k) = slope_max(k-1) + Sr_max * abs(V_max + std(s_input(inicio_ppg:round(fin_ppg)))) / (f_s);
    slope_min(k) = slope_min(k-1) + Sr_min * abs(V_min + std(s_input(inicio_ppg:round(fin_ppg)))) / (f_s);
    
    if(slope_max(k) < s_input(k) && period_refractory <= (picos(i_p).posicion - picos_new(i_p_new).posicion) && s_input(k) > s_input(k-1))
        slope_max(k) = s_input(k);
    end
%     if(slope_min(k) > s_input(k) && period_refractory_v <= (valles(i_v).posicion - valles_new(i_v_new).posicion) && s_input(k) < s_input(k-1))
%         slope_min(k) = s_input(k);
%     end
    if(k >= picos(i_p).posicion)
        if(picos(i_p).valor >= slope_max(k) && period_refractory <= (picos(i_p).posicion - picos_new(i_p_new).posicion))
            V_max = picos(i_p).valor;
            i_p_new = i_p_new + 1;
            picos_new(i_p_new) = picos(i_p);
            if(i_p_new >2)
                muestras_IBI_previo = picos_new(i_p_new).posicion - picos_new(i_p_new-1).posicion;
                period_refractory = round(0.7 * muestras_IBI_previo);
            else
                muestras_IBI_previo = 600;
                period_refractory = muestras_IBI_previo;
            end
        end       
         i_p = i_p + 1;
        if(i_p > length(picos))
            i_p = length(picos);
        end
    end
%     if(k >= valles(i_v).posicion)
%         if(valles(i_v).valor <= slope_min(k) && period_refractory_v <= (valles(i_v).posicion - valles_new(i_v_new).posicion))
%             V_min = valles(i_v).valor;
%             i_v_new = i_v_new + 1;
%             valles_new(i_v_new) = valles(i_v);
%             if(i_v_new > 2)
%                 muestras_IBI_previo_v = valles_new(i_v_new).posicion - valles_new(i_v_new-1).posicion;
%                 period_refractory_v = round(0.8 * muestras_IBI_previo_v);
%             else
%                 muestras_IBI_previo_v = 600;
%                 period_refractory_v = muestras_IBI_previo_v;
%             end
%         end
%             i_v = i_v+1;
%             if(i_v > length(valles))
%                 i_v = length(valles);
%             end            
%     end
end
%-----------------------------------------------------------------------------
picos_final     = picos_new;
% valles_final    = valles_new;
end
end
%% An Efficient and Automatic Systolic Peak Detection Algorithm for Photoplethysmographic Signals
function [picos_final, valles_final] = ASP(s_input)
 [picos, valles] = delineateFirstDiffPPG(s_input);
if (picos(1).posicion < valles(1).posicion)
    picos(1) = [];
%     fprintf('Filtro picos 1: primer pico eliminado.\n');
end

if(length(picos) > length(valles))
    picos(length(valles)+1:end)=[];
%     fprintf('Filtro picos 1: picos extras eliminados.\n');
elseif(length(picos) < length(valles))
    valles(length(picos)+1:end)=[];
%     fprintf('Filtro picos 1: valles extras eliminados.\n');
end

num_picos_pre   = length(picos);
num_picos_pos   = 0; 
iteraciones     = 0;

while(num_picos_pre ~= num_picos_pos && length(picos) > 2 )
    VPD             = [picos.valor] - [valles.valor];
    %lim_VPD         = zeros(size(VPD, 1), size(VPD, 2));    
    num_picos_pre   = length(picos);
    i               = 0;
    lim_VPD         = 0.7 * (VPD(1) + VPD(2)) / 3;
    if(VPD(1) > lim_VPD(1))
        i                   = i + 1;
        picos_nuevos(i)     = picos(1);
        valles_nuevos(i)    = valles(1);
    end
    for k = 2:length(VPD)-1
        lim_VPD(k)  = 0.7 * (VPD(k-1) + VPD(k) + VPD(k+1)) / 3;
        
        if(VPD(k) > lim_VPD(k))
            % ver picos
            i                   = i + 1;
            picos_nuevos(i)     = picos(k);
            valles_nuevos(i)    = valles(k);
        end
        
    end
    if(i> 0)
        picos           = picos_nuevos;
        valles          = valles_nuevos;
    end
    num_picos_pos   = length(picos);
    iteraciones     = iteraciones + 1;
end

% fprintf('ASP: converge after %i iterations.\n', iteraciones);
%-----------------------------------------------------------------------------
picos_final     = picos;
valles_final    = valles;

end
%% Sacar todos los picos y los valles
function [picos, valles] = delineateFirstDiffPPG(s_input)
  %looking for positive peaks : decreasing slope = 0
  %Take into account that smooth performs a 5-smoothing moving average
  %filter. This is done based on quantization problems resulting into 
  % zero-crossing for the first difference quite often.
  % Can be done by applying a AGC to not smooth the signal?
  diffS = smooth(diff(smooth(s_input)));
  listePic = [];
  listeValley = [];
  id_vtp          = 0;
  id_ptp          = 0;
  id_vtv          = 0;
  id_ptv          = 0;
  for iSpl = 1:length(diffS)-1
      %If there is a slope == 0 // do not take into account in the last sample
      if((diffS(iSpl) > 0) && (diffS(iSpl+1) < 0)) 
        listePic = [listePic iSpl+(diffS(iSpl) / (diffS(iSpl) - diffS(iSpl+1)))];
        id_vtp = id_vtp + 1;
        id_ptp = id_ptp + 1; 
        picos(id_ptp).posicion = round(listePic(end));
        picos(id_vtp).valor = s_input(round(listePic(end)));
      elseif ((diffS(iSpl)==0) && (diffS(iSpl+1) < 0))
        listePic = [listePic iSpl];
        id_vtp = id_vtp + 1;
        id_ptp = id_ptp + 1; 
        picos(id_ptp).posicion = round(listePic(end));
        picos(id_vtp).valor = s_input(round(listePic(end)));
      elseif ((diffS(iSpl) < 0) && (diffS(iSpl+1) > 0)) 
        listeValley = [listeValley iSpl+(diffS(iSpl) / (diffS(iSpl) - diffS(iSpl+1)))];
        id_vtv = id_vtv + 1;
        id_ptv = id_ptv + 1; 
        valles(id_ptv).posicion = round(listeValley(end));
        valles(id_vtv).valor = s_input(round(listeValley(end)));
      elseif ((diffS(iSpl)==0) && (diffS(iSpl+1) > 0))
        listeValley = [listeValley iSpl];
        id_vtv = id_vtv + 1;
        id_ptv = id_ptv + 1;
        valles(id_ptv).posicion = round(listeValley(end));
        valles(id_vtv).valor = s_input(round(listeValley(end)));
      end
  end
end