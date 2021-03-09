 % <function name>(<arg1>,<agr2>,...) - <Brief Description>
%
% Usage:
%   >> <Out> = <function name>(<arg1>) 
%   >> <Out> = <function name>(<arg1>,<arg2>)
%   >>
%
% Inputs:
%   <DATA_IN> - <description>
%   <RESPONSE_IN> - <description>
%
% Optional inputs: ...
%                
%        
% Outputs:
%   <RESULTS>   - description
%
% Author: DTE UC3M
%
% Note: <description>.
% 
% <Aditional information>
% 
% Copyright (C) 2019 UC3M
%
% This program is free software; you can redistribute it and/or modify
% it under the terms of the GNU General Public License as published by
% the Free Software Foundation; either version 2 of the License, or
% (at your option) any later version.
%
% This program is distributed in the hope that it will be useful,
% but WITHOUT ANY WARRANTY; without even the implied warranty of
% MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
% GNU General Public License for more details.
%
% You should have received a copy of the GNU General Public License
% along with this program; if not, write to the Free Software
% Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307 USA
%%
function Results = EMP_DTE_Physio(data_in,response_in,type,~)

  %check inputs
  if nargin < 2
    error('Function requires at least two inputs.');
  end
  if ~any(strcmpi(type,{'BBDDLab_Bindi','BBDDLab_Bindi_All','DEAP',...
                        'MAHNOB','WESAD','BioSpeech','BioSpeechJustTrain','BBDDLab_EH'}))
   error('<type> must be: BBDDLab_Bindi or DEAP or MAHNOB or WESAD or BioSpeech.');
  end
  
  %Add folders and subfolders for the current Matlab session
  % Determine where your m-file's folder is.
  folder = fileparts(which(mfilename)); 
  % Add that folder plus all subfolders to the path.
  addpath(genpath(folder));
  
  %% Stage 1: Handle the data based on the dataset
  %Based on the type of database, select the appropiate action
  switch type
      case 'BBDDLab_Bindi'
        % NOTE: Take into account that in this case, the signals must
        % have been processed before using the pre-processing script.
        % If you are not sure, please contact technician.
        Results = EMP_DTE_Physio_BBDDLab_Bindi(data_in, response_in);
      case 'BBDDLab_EH'
        % NOTE: Take into account that in this case, the signals must
        % have been processed before using the pre-processing script.
        % If you are not sure, please contact technician.
        Results = EMP_DTE_Physio_BBDDLab_EH(data_in, response_in);        
      case 'BBDDLab_Bindi_All'
        % NOTE: Take into account that in this case, the signals must
        % have been processed before using the pre-processing script.
        % If you are not sure, please contact technician.
        Results = EMP_DTE_Physio_BBDDLab_Bindi_ALL(data_in, response_in);
      case 'BioSpeech'
        % NOTE: Take into account that in this case, the signals will
        % be processed (filtered) in this function.
        % If you are not sure about this function or its behavior, 
        % please contact technician.
        Results = EMP_DTE_Physio_BioSpeech(data_in, response_in);
      case 'BioSpeechJustTrain'
        % NOTE: Take into account that in this case, the features should
        % have been previously extracted and being stored into data_in.
        % If you are not sure about this function or its behavior, 
        % please contact technician.
        Results = EMP_DTE_Physio_BioSpeech_JustTrain(data_in, response_in);
      otherwise
        error('Not implemented yet.');
  end   
  
  %% TBD...
end

%% Function to handle the data coming from BBDDLab_Bindi
function Results_BBDDLab_Bindi = EMP_DTE_Physio_BBDDLab_Bindi(data_in, response_in)

  %% data_in is a struct based of volunteers (rows) and trials (columns)
  [volunteers, trials] = size(data_in);
  %sampling rate is 200Hz
  samprate_bbddlab = 200;
  %create data to store features
  %data_features = struct();
  
  for i=1:volunteers
    for k=1:trials-2
        
      %Create the BVP signals
      bvp_sig_neutro   = BVP_create_signal(data_in{i,k}.BINDI.Neutro.raw.bvp_filt, samprate_bbddlab);
      bvp_sig_video    = BVP_create_signal(data_in{i,k}.BINDI.Video.raw.bvp_filt, samprate_bbddlab);
      bvp_sig_labels   = BVP_create_signal(data_in{i,k}.BINDI.Labels.raw.bvp_filt, samprate_bbddlab);
      bvp_sig_recovery = BVP_create_signal(data_in{i,k}.BINDI.Recovery.raw.bvp_filt, samprate_bbddlab);
      
      %Create the GSR signals
      gsr_sig_neutro   = GSR_create_signal(data_in{i,k}.GSR.Neutro.raw.gsr_uS_filtered, samprate_bbddlab);
      gsr_sig_video    = GSR_create_signal(data_in{i,k}.GSR.Video.raw.gsr_uS_filtered, samprate_bbddlab);
      gsr_sig_labels   = GSR_create_signal(data_in{i,k}.GSR.Labels.raw.gsr_uS_filtered, samprate_bbddlab);
      gsr_sig_recovery = GSR_create_signal(data_in{i,k}.GSR.Recovery.raw.gsr_uS_filtered, samprate_bbddlab);
      
      %% Stage 2: Extracting Features %%
      % Deal with window and overlapping
      operational_window = 10; %seconds
      overlapin_window   = 1;  %seconds
      
      %Neutro
      start   = 1;
      stop    = operational_window*samprate_bbddlab;
      overlap =  overlapin_window*samprate_bbddlab;
      window_num = 1;
      bvp_sig_cpy = bvp_sig_neutro;
      gsr_sig_cpy   = gsr_sig_neutro;
      while(stop<length(bvp_sig_neutro.raw))
         %BVP processing
        bvp_sig_cpy.raw = bvp_sig_neutro.raw(start:stop);
        [data_features{i,k}.BINDI.Neutro.BVP_feats(window_num,:), ...
         data_features{i,k}.BINDI.Neutro.BVP_feats_names] = ...
            BVP_features_extr(bvp_sig_cpy);
        %GSR processing
         gsr_sig_cpy.raw = gsr_sig_neutro.raw(start:stop);
        [data_features{i,k}.BINDI.Neutro.GSR_feats(window_num,:), ...
         data_features{i,k}.BINDI.Neutro.GSR_feats_names] = ...
            GSR_features_extr(gsr_sig_cpy);    
        start = start + overlap;
        stop  = stop  + overlap;
        window_num = window_num + 1;
      end

      %Video
      start   = 1;
      stop    = operational_window*samprate_bbddlab;
      overlap =  overlapin_window*samprate_bbddlab;
      window_num = 1;
      bvp_sig_cpy = bvp_sig_video;
      while(stop<length(bvp_sig_video.raw))
        bvp_sig_cpy.raw = bvp_sig_video.raw(start:stop);
        [data_features{i,k}.BINDI.Video.BVP_feats(window_num,:), ...
         data_features{i,k}.BINDI.Video.BVP_feats_names] = ...
            BVP_features_extr(bvp_sig_cpy);
        %TBD...        
        start = start + overlap;
        stop  = stop  + overlap;
        window_num = window_num + 1;
      end
      
      %Labels
      start   = 1;
      stop    = operational_window*samprate_bbddlab;
      overlap =  overlapin_window*samprate_bbddlab;
      window_num = 1;
      bvp_sig_cpy = bvp_sig_labels;
      while(stop<length(bvp_sig_labels.raw))
        bvp_sig_cpy.raw = bvp_sig_labels.raw(start:stop);
        [data_features{i,k}.BINDI.Labels.BVP_feats(window_num,:), ...
         data_features{i,k}.BINDI.Labels.BVP_feats_names] = ...
            BVP_features_extr(bvp_sig_cpy);
        %TBD...        
        start = start + overlap;
        stop  = stop  + overlap;
        window_num = window_num + 1;
      end
      
      %Recovery
      start   = 1;
      stop    = operational_window*samprate_bbddlab;
      overlap =  overlapin_window*samprate_bbddlab;
      window_num = 1;
      bvp_sig_cpy = bvp_sig_recovery;
      while(stop<length(bvp_sig_recovery.raw))
        bvp_sig_cpy.raw = bvp_sig_recovery.raw(start:stop);
        [data_features{i,k}.BINDI.Recovery.BVP_feats(window_num,:), ...
         data_features{i,k}.BINDI.Recovery.BVP_feats_names] = ...
            BVP_features_extr(bvp_sig_cpy);
        %TBD...        
        start = start + overlap;
        stop  = stop  + overlap;
        window_num = window_num + 1;
      end
      
    end
  end
    
  %% Stage 3: Trainning the model - Validation
  %...TBD
  
  %% Stage 4: Testing the model - testing with unseen samples
  %...TBD
  
  %% Stage 5: Give back results
  Results_BBDDLab_Bindi.features = data_features;
  %...TBD
  
  %% Stage 6: Perform EDA (exploratory data analysis)
  %Example given by HR=60/IBI
  c_1=60./data_features{1, 1}.BINDI.Neutro.BVP_feats(:,3);        % Generate group 1
  c_2=60./data_features{1, 1}.BINDI.Recovery.BVP_feats(:,3);       % Generate group 2
  C = {c_1(:); c_2(:)};  % <--- Just vertically stack all of your groups here
  grp = cell2mat(arrayfun(@(i){i*ones(numel(C{i}),1)},(1:numel(C))')); 
  boxplot(vertcat(C{:}),grp, 'Labels',{'Neutro','Video'});
end

%% Function to handle the data coming from BBDDLab_Bindi
function Results_BBDDLab_EH = EMP_DTE_Physio_BBDDLab_EH(data_in, response_in)

  %% data_in is a struct based of volunteers (rows) and trials (columns)
  [volunteers, trials] = size(data_in);
  %sampling rate is 200Hz for BVP, and 10Hz for GSR and SKT
  samprate_bbddlab_bvp = 200;
  samprate_bbddlab_gsr = 10;
  %create data to store features
  %data_features = struct();
  
  for i=1:volunteers
    for k=1:trials
        
     %Display some info
     fprintf('Volunteer %d, Trial %d, extracting...\n',i,k);
        
      %Create the BVP signals
%        bvp_sig_neutro   = BVP_create_signal(data_in{i,k}.EH.Neutro.raw.bvp_filt, samprate_bbddlab_bvp);
      bvp_sig_video    = BVP_create_signal(data_in{i,k}.EH.Video.raw.bvp_filt, samprate_bbddlab_bvp);
       bvp_sig_labels   = BVP_create_signal(data_in{i,k}.EH.Labels.raw.bvp_filt, samprate_bbddlab_bvp);
       bvp_sig_recovery = BVP_create_signal(data_in{i,k}.EH.Recovery.raw.bvp_filt, samprate_bbddlab_bvp);
      
      %Create the GSR signals
%        gsr_sig_neutro   = GSR_create_signal(data_in{i,k}.GSR.Neutro.raw.gsr_uS_filtered_dn_sm, samprate_bbddlab_gsr);
      gsr_sig_video    = GSR_create_signal(data_in{i,k}.EH.Video.raw.gsr_uS_filtered_dn_sm, samprate_bbddlab_gsr);
       gsr_sig_labels   = GSR_create_signal(data_in{i,k}.EH.Labels.raw.gsr_uS_filtered, samprate_bbddlab_gsr);
       gsr_sig_recovery = GSR_create_signal(data_in{i,k}.EH.Recovery.raw.gsr_uS_filtered, samprate_bbddlab_gsr);
      
      %% Stage 2: Extracting Features %%
      % Deal with window and overlapping
      operational_window = 20; %seconds
      overlapin_window   = 1;  %seconds
      
      %Neutro
%       start_bvp   = 1;
%       stop_bvp    = operational_window*samprate_bbddlab_bvp;
%       start_gsr   = 1;
%       stop_gsr    = operational_window*samprate_bbddlab_gsr;
%       overlap_bvp = overlapin_window*samprate_bbddlab_bvp;
%       overlap_gsr = overlapin_window*samprate_bbddlab_gsr;      
%       window_num  = 1;
%       bvp_sig_cpy = bvp_sig_neutro;
%       gsr_sig_cpy = gsr_sig_neutro;
%       while(stop_bvp<length(bvp_sig_neutro.raw) && ...
%             stop_gsr<length(gsr_sig_neutro.raw))
%         %BVP processing
%         %To measure the time taken for each physio-processing uncomment the
%         %tic-toc commands
%         %tic
%         bvp_sig_cpy.raw = bvp_sig_neutro.raw(start_bvp:stop_bvp);
%         [data_features{i,k}.EH.Neutro.BVP_feats(window_num,:), ...
%          data_features{i,k}.EH.Neutro.BVP_feats_names] = ...
%             BVP_features_extr(bvp_sig_cpy);
%         %toc
%         %GSR processing
%         gsr_sig_cpy.raw = gsr_sig_neutro.raw(start_gsr:stop_gsr);
%         [data_features{i,k}.EH.Neutro.GSR_feats(window_num,:), ...
%          data_features{i,k}.EH.Neutro.GSR_feats_names] = ...
%             GSR_features_extr(gsr_sig_cpy);       
%         start_bvp = start_bvp + overlap_bvp;
%         stop_bvp  = stop_bvp  + overlap_bvp;
%         start_gsr = start_gsr + overlap_gsr;
%         stop_gsr  = stop_gsr  + overlap_gsr;
%         window_num = window_num + 1;
%       end
%       
%       %Check in case neutro is smaller than operational_window
%       %NOTE!!! --> if this is the case, just use the neutro to normalize
%       %data for intra-differences within the subject
%       if window_num == 1
%         %BVP processing
%         %To measure the time taken for each physio-processing uncomment the
%         %tic-toc commands
%         %tic
%         bvp_sig_cpy.raw = bvp_sig_neutro.raw;
%         [data_features{i,k}.EH.Neutro.BVP_feats(window_num,:), ...
%          data_features{i,k}.EH.Neutro.BVP_feats_names] = ...
%             BVP_features_extr(bvp_sig_cpy);
%         %toc
%         %GSR processing
%         gsr_sig_cpy.raw = gsr_sig_neutro.raw;
%         [data_features{i,k}.EH.Neutro.GSR_feats(window_num,:), ...
%          data_features{i,k}.EH.Neutro.GSR_feats_names] = ...
%             GSR_features_extr(gsr_sig_cpy); 
%       end

      %Video
      start_bvp   = 1;
      stop_bvp    = operational_window*samprate_bbddlab_bvp;
      start_gsr   = 1;
      stop_gsr    = operational_window*samprate_bbddlab_gsr;
      overlap_bvp = overlapin_window*samprate_bbddlab_bvp;
      overlap_gsr = overlapin_window*samprate_bbddlab_gsr;      
      window_num  = 1;
      bvp_sig_cpy = bvp_sig_video;
      gsr_sig_cpy = gsr_sig_video;
      while(stop_bvp<length(bvp_sig_video.raw) && ...
            stop_gsr<length(gsr_sig_video.raw))
        %BVP processing
        %To measure the time taken for each physio-processing uncomment the
        %tic-toc commands
        %tic
        bvp_sig_cpy.raw = bvp_sig_video.raw(start_bvp:stop_bvp);
        [data_features{i,k}.EH.Video.BVP_feats(window_num,:), ...
         data_features{i,k}.EH.Video.BVP_feats_names] = ...
            BVP_features_extr(bvp_sig_cpy);
        %toc
        %GSR processing
        gsr_sig_cpy.raw = gsr_sig_video.raw(start_gsr:stop_gsr);
        [data_features{i,k}.EH.Video.GSR_feats(window_num,:), ...
         data_features{i,k}.EH.Video.GSR_feats_names] = ...
            GSR_features_extr(gsr_sig_cpy);       
        start_bvp = start_bvp + overlap_bvp;
        stop_bvp  = stop_bvp  + overlap_bvp;
        start_gsr = start_gsr + overlap_gsr;
        stop_gsr  = stop_gsr  + overlap_gsr;
        window_num = window_num + 1;
      end
      
      %Labels
      start_bvp   = 1;
      stop_bvp    = operational_window*samprate_bbddlab_bvp;
      start_gsr   = 1;
      stop_gsr    = operational_window*samprate_bbddlab_gsr;
      overlap_bvp = overlapin_window*samprate_bbddlab_bvp;
      overlap_gsr = overlapin_window*samprate_bbddlab_gsr;      
      window_num  = 1;
      bvp_sig_cpy = bvp_sig_labels;
      gsr_sig_cpy = gsr_sig_labels;
      while(stop_bvp<length(bvp_sig_labels.raw) && ...
            stop_gsr<length(gsr_sig_labels.raw))
        %BVP processing
        %To measure the time taken for each physio-processing uncomment the
        %tic-toc commands
        %tic
        bvp_sig_cpy.raw = bvp_sig_labels.raw(start_bvp:stop_bvp);
        [data_features{i,k}.EH.labels.BVP_feats(window_num,:), ...
         data_features{i,k}.EH.labels.BVP_feats_names] = ...
            BVP_features_extr(bvp_sig_cpy);
        %toc
        %GSR processing
        gsr_sig_cpy.raw = gsr_sig_labels.raw(start_gsr:stop_gsr);
        [data_features{i,k}.EH.labels.GSR_feats(window_num,:), ...
         data_features{i,k}.EH.labels.GSR_feats_names] = ...
            GSR_features_extr(gsr_sig_cpy);       
        start_bvp = start_bvp + overlap_bvp;
        stop_bvp  = stop_bvp  + overlap_bvp;
        start_gsr = start_gsr + overlap_gsr;
        stop_gsr  = stop_gsr  + overlap_gsr;
        window_num = window_num + 1;
      end
      
      
%       start   = 1;
%       stop    = operational_window*samprate_bbddlab;
%       overlap =  overlapin_window*samprate_bbddlab;
%       window_num = 1;
%       bvp_sig_cpy = bvp_sig_labels;
%       while(stop<length(bvp_sig_labels.raw))
%         bvp_sig_cpy.raw = bvp_sig_labels.raw(start:stop);
%         [data_features{i,k}.BINDI.Labels.BVP_feats(window_num,:), ...
%          data_features{i,k}.BINDI.Labels.BVP_feats_names] = ...
%             BVP_features_extr(bvp_sig_cpy);
%         %TBD...        
%         start = start + overlap;
%         stop  = stop  + overlap;
%         window_num = window_num + 1;
%       end
%       
%       Recovery
        start_bvp   = 1;
        stop_bvp    = operational_window*samprate_bbddlab_bvp;
        start_gsr   = 1;
        stop_gsr    = operational_window*samprate_bbddlab_gsr;
        overlap_bvp = overlapin_window*samprate_bbddlab_bvp;
        overlap_gsr = overlapin_window*samprate_bbddlab_gsr;      
        window_num  = 1;
        bvp_sig_cpy = bvp_sig_recovery;
        gsr_sig_cpy = gsr_sig_recovery;
        while(stop_bvp<length(bvp_sig_recovery.raw) && ...
            stop_gsr<length(gsr_sig_recovery.raw))
        %BVP processing
        %To measure the time taken for each physio-processing uncomment the
        %tic-toc commands
        %tic
        bvp_sig_cpy.raw = bvp_sig_recovery.raw(start_bvp:stop_bvp);
        [data_features{i,k}.EH.recovery.BVP_feats(window_num,:), ...
         data_features{i,k}.EH.recovery.BVP_feats_names] = ...
            BVP_features_extr(bvp_sig_cpy);
        %toc
        %GSR processing
        gsr_sig_cpy.raw = gsr_sig_recovery.raw(start_gsr:stop_gsr);
        [data_features{i,k}.EH.recovery.GSR_feats(window_num,:), ...
         data_features{i,k}.EH.recovery.GSR_feats_names] = ...
            GSR_features_extr(gsr_sig_cpy);       
        start_bvp = start_bvp + overlap_bvp;
        stop_bvp  = stop_bvp  + overlap_bvp;
        start_gsr = start_gsr + overlap_gsr;
        stop_gsr  = stop_gsr  + overlap_gsr;
        window_num = window_num + 1;
        end

%       start   = 1;
%       stop    = operational_window*samprate_bbddlab;
%       overlap =  overlapin_window*samprate_bbddlab;
%       window_num = 1;
%       bvp_sig_cpy = bvp_sig_recovery;
%       while(stop<length(bvp_sig_recovery.raw))
%         bvp_sig_cpy.raw = bvp_sig_recovery.raw(start:stop);
%         [data_features{i,k}.BINDI.Recovery.BVP_feats(window_num,:), ...
%          data_features{i,k}.BINDI.Recovery.BVP_feats_names] = ...
%             BVP_features_extr(bvp_sig_cpy);
%         %TBD...        
%         start = start + overlap;
%         stop  = stop  + overlap;
%         window_num = window_num + 1;
%       end
      
    end 
  end
    
  %% Stage 3: Trainning the model - Validation
  %...TBD
  
  %% Stage 4: Testing the model - testing with unseen samples
  %...TBD
  
  %% Stage 5: Give back results
  Results_BBDDLab_EH.features = data_features;
  Results_BBDDLab_EH.operational_window = operational_window;
  Results_BBDDLab_EH.overlapin_window = overlapin_window;
  %...TBD
  
  %% Stage 6: Perform EDA (exploratory data analysis)
  %...TBD
end

%% Function to handle the data coming from BBDDLab_Bindi BUT without data 
%  segmentation
function Results_BBDDLab_Bindi = EMP_DTE_Physio_BBDDLab_Bindi_ALL(data_in, response_in)
 %% data_in is a struct based of volunteers (rows) and trials (columns)
  [volunteers, trials] = size(data_in);
  %sampling rate is 200Hz
  samprate_bbddlab = 200;
  %create data to store features
  %data_features = struct();
  
  for i=1:volunteers
    for k=1:trials-2
        
      %Create the BVP signals
      bvp_sig_neutro   = BVP_create_signal(data_in{i,k}.BINDI.Neutro.raw.bvp_filt, samprate_bbddlab);
      bvp_sig_video    = BVP_create_signal(data_in{i,k}.BINDI.Video.raw.bvp_filt, samprate_bbddlab);
      bvp_sig_labels   = BVP_create_signal(data_in{i,k}.BINDI.Labels.raw.bvp_filt, samprate_bbddlab);
      bvp_sig_recovery = BVP_create_signal(data_in{i,k}.BINDI.Recovery.raw.bvp_filt, samprate_bbddlab);
      
      %Create the GSR signals
      gsr_sig_neutro   = GSR_create_signal(data_in{i,k}.GSR.Neutro.raw.gsr_uS_filtered, samprate_bbddlab);
      gsr_sig_video    = GSR_create_signal(data_in{i,k}.GSR.Video.raw.gsr_uS_filtered, samprate_bbddlab);
      gsr_sig_labels   = GSR_create_signal(data_in{i,k}.GSR.Labels.raw.gsr_uS_filtered, samprate_bbddlab);
      gsr_sig_recovery = GSR_create_signal(data_in{i,k}.GSR.Recovery.raw.gsr_uS_filtered, samprate_bbddlab);
      
      %% Stage 2: Extracting Features %%
      % Deal with window and overlapping
      operational_window = 10; %seconds
      overlapin_window   = 1;  %seconds
      
      %Neutro
      %BVP processing
      [data_features{i,k}.BINDI.Neutro.BVP_feats(1,:), ...
      data_features{i,k}.BINDI.Neutro.BVP_feats_names] = ...
        BVP_features_extr(bvp_sig_neutro);
      %GSR processing
      [data_features{i,k}.BINDI.Neutro.GSR_feats(1,:), ...
      data_features{i,k}.BINDI.Neutro.GSR_feats_names] = ...
        GSR_features_extr(gsr_sig_neutro);    

      %Video
      %BVP processing
      [data_features{i,k}.BINDI.Video.BVP_feats(1,:), ...
      data_features{i,k}.BINDI.Video.BVP_feats_names] = ...
        BVP_features_extr(bvp_sig_video);
      %GSR processing
      [data_features{i,k}.BINDI.Video.GSR_feats(1,:), ...
      data_features{i,k}.BINDI.Video.GSR_feats_names] = ...
        GSR_features_extr(gsr_sig_video);  
      
      %Labels
      %BVP processing
      [data_features{i,k}.BINDI.Labels.BVP_feats(1,:), ...
      data_features{i,k}.BINDI.Labels.BVP_feats_names] = ...
        BVP_features_extr(bvp_sig_labels);
      %GSR processing
      [data_features{i,k}.BINDI.Labels.GSR_feats(1,:), ...
      data_features{i,k}.BINDI.Labels.GSR_feats_names] = ...
        GSR_features_extr(gsr_sig_labels);  
      
      %Recovery
      %BVP processing
      [data_features{i,k}.BINDI.Recovery.BVP_feats(1,:), ...
      data_features{i,k}.BINDI.Recovery.BVP_feats_names] = ...
        BVP_features_extr(bvp_sig_recovery);
      %GSR processing
      [data_features{i,k}.BINDI.Recovery.GSR_feats(1,:), ...
      data_features{i,k}.BINDI.Recovery.GSR_feats_names] = ...
        GSR_features_extr(gsr_sig_recovery);  
      
    end
  end
    
  %% Stage 3: Trainning the model - Validation
  %...TBD
  
  %% Stage 4: Testing the model - testing with unseen samples
  %...TBD
  
  %% Stage 5: Give back results
  Results_BBDDLab_Bindi.features = data_features;
  %...TBD
  
  %% Stage 6: Perform EDA (exploratory data analysis)
  %%...TBD
end

%% Function to handle the data coming from BioSpeech Database
function Results_BioSpeech = EMP_DTE_Physio_BioSpeech(data_in, response_in)
  %This function is done ad-hoc for the multimodal DTE-TSC work package
  %It is based on the BioSpeech database
  % Input: data_in --> this is an array of tables
  %        each table corresponds to one of the volunteers
  %        each table has three columns: Time, BVP, Skin
  
  %Get the number of volunteers and trials
  %Max Volunteers are 42 and max trial are 1
  [volunteers, trials] = size(data_in);
  %check values
  if volunteers > 84 || trials > 1
    error('Number of volunteers or trials exceed the maximun allowed');
  end
  
  for i=5:volunteers
    for k=1:trials
     
     %Sampling rate
     samprate_biospeech = 2048; %Hz
  
     %Display some info
     fprintf('Volunteer %d, extracting...\n',i);
     
     %% Stage 0: creating the signals in a TEAP-UC3M-like form %%
     % Take into account that the name of the different columns of the
     % table can be whether BVP & Skin or B_BVP & E_Skin_Cond
     % In case of the second, some samples are repeated to not have
     % problems when filtering the signal.
     try
      bvp_sig = BVP_create_signal(data_in{i,k}.BVP, samprate_biospeech);
     catch
      disp('Baseline BVP');
      bvp_sig = BVP_create_signal(data_in{i,k}.B_BVP(samprate_biospeech:end)...
                                   , samprate_biospeech);
     end
     
     try
      gsr_sig = GSR_create_signal(data_in{i,k}.Skin, samprate_biospeech);
     catch
      disp('Baseline GSR');
      gsr_sig = GSR_create_signal(data_in{i,k}.E_Skin_Cond(samprate_biospeech:end)...
                                  ,samprate_biospeech);
     end     
     
     % Remove outliers out of the signal. Outliers can be produced by
     % sequences in which the sensor is just starting or is malcfunctioning
     bvp_sig = Signal__rmoutliers(bvp_sig);
     gsr_sig = Signal__rmoutliers(gsr_sig);
     
     %% Stage 1: preprocessing - filtering signals %%
     
     % BVP:
     % 1.1: BVP filtering. Baseline wander and high frequencies removal
     % Apply Zero-phase bandpass digital filtering for the whole signal
     % without performing downsampling before filtering process
     % Fc1 = 0.2 Hz (-6dB) / Fc2 = 4 Hz (-6dB)
     % Fs  = 2048
     % Hamming Window
     FIRCoeffs = load('BVP_coeffs_highlowpass_2048.mat');
     if length(bvp_sig.raw)<=(length(FIRCoeffs.BVP_coeffs_lowpass)*3 - 3)
       %bvp_sig.raw = [bvp_sig.raw ];
     else
       bvp_sig = Signal__filter_signal(bvp_sig, FIRCoeffs.BVP_coeffs_lowpass);
       bvp_sig = Signal__set_preproc(bvp_sig, 'lowpass');
       bvp_sig = Signal__filter_signal(bvp_sig, FIRCoeffs.BVP_coeffs_highpass);
       bvp_sig = Signal__set_preproc(bvp_sig, 'highpass');
     end

     % Apply IIR Forward-Backward filtering
     bvp_sig = BVP_removebaselinewander_signal(bvp_sig, samprate_biospeech);
     
     % 1.2: BVP Automatic Gain Control
     % This is based on a fixed AGC. 
     % This AWG is based on cubing-normalized process.
     % Change the number of iterations to even enhance more peaks, but
     % be aware that a high number of iterations could introduce to much 
     % distortion to the signal.
     iterations = 1;
     for j=1:iterations
       bvp_sig = BVP_enhancePeaks_signal(bvp_sig); 
     end
     
     % 1.3: BVP Downsampling
     downsample_n = 32;
     samprate_biospeech = samprate_biospeech/downsample_n;
     bvp_sig = BVP_create_signal(downsample(bvp_sig.raw,downsample_n), ...
                                 samprate_biospeech);
     
     % 1.4: BVP advanced data processing: Wavelet Synchrosqueezed Transform
     time=0:1/samprate_biospeech:...
          (length(bvp_sig.raw)/samprate_biospeech - 1/samprate_biospeech);
     iterations = 2;
     for w=1:iterations
       figure;
       plot(time,bvp_sig.raw)
       hold on;
       imfs = emd(bvp_sig.raw,'Display',0);
       z =bvp_sig.raw';
       [~,b] = size(imfs);
       for j=3:b
         z = z - imfs(:,j);
       end
       [sst,F] = wsst(z,samprate_biospeech);
       t=find(F>0.8 & F<3.5);
       [fridge,iridge] = wsstridge(sst(t,:),2,F(1,t),'NumRifges',1);
       xrec = iwsst(sst(t,:),iridge);
       bvp_sig.raw = xrec(:,1) ;%+ xrec(:,2);
       plot(time,bvp_sig.raw);
       bvp_sig.raw=bvp_sig.raw';
       
       %Draw result:
       figure;
       plot(time,fridge,'k--','linewidth',4);
       hold on;
       contour(time,F(1,t),abs(sst(t,:)));
       ylim([0.5 3.5]);
     end
     
     % 1.5: BVP Automatic Gain Control over WST-Systolic extracted
     % This is based on a fixed AGC. 
     % This AWG is based on cubing-normalized process.
     % Change the number of iterations to even enhance more peaks, but
     % be aware that a high number of iterations could introduce to much 
     % distortion to the signal.
     iterations = 1;
     bvp_sig.raw = bvp_sig.raw + abs(min(bvp_sig.raw));
     for j=1:iterations         
       bvp_sig = BVP_enhancePeaks_signal(bvp_sig); 
     end
     
     % GSR:
     % For the Galvanic Skin Conductance within BioSpeech there is no need
     % to apply filtering stage. Check the EDA (Exploratory Data Analysis)
     % document.
     
     % 1.1: GSR Downsampling
     samprate_biospeech = 64;
     gsr_sig = GSR_create_signal(downsample(gsr_sig.raw,32), samprate_biospeech);
     
     %% Stage 2: Extracting Features %%
     % 2.1: Just test the complete set of data
     %[feat_all{i,k}.BVP_feats, feat_all{i,k}.BVP_names] = ...
     % BVP_features_extr(bvp_sig);     
     %[feat_all{i,k}.GSR_feats, feat_all{i,k}.GSR_names] = ...
     % GSR_features_extr(gsr_sig);  
    
     % 2.2: Deal with window and overlapping
     operational_window = 10; %seconds
     overlapin_window   = 1;  %seconds
     start   = 1;
     stop    = operational_window*samprate_biospeech;
     overlap =  overlapin_window*samprate_biospeech;
     window_num = 1;
     bvp_sig_cpy = bvp_sig;
     gsr_sig_cpy   = gsr_sig;
     while(stop<length(bvp_sig.raw) && stop<length(gsr_sig.raw))
         
       %BVP processing
       bvp_sig_cpy.raw = bvp_sig.raw(start:stop);
       [data_features{i,k}.BVP_feats(window_num,:), ...
        data_features{i,k}.BVP_feats_names] = ...
        BVP_features_extr(bvp_sig_cpy);
    
       %GSR processing
       gsr_sig_cpy.raw = gsr_sig.raw(start:stop);
       [data_features{i,k}.GSR_feats(window_num,:), ...
        data_features{i,k}.GSR_feats_names] = ...
        GSR_features_extr(gsr_sig_cpy);    
    
       start = start + overlap;
       stop  = stop  + overlap;
       window_num = window_num + 1;
     end
      
     
    end
  end

  %% Stage 3: Assign labels
  %peri   = {};
  %labels = {}; 
  if ~isempty(response_in)
    for i=1:volunteers
      for k=1:trials
        peri{:,:,i}   =[ (data_features{i,k}.BVP_feats(:,:)) (data_features{i,k}.GSR_feats(:,:))];
        labels{:,:,i} = response_in{i, k}.binary_labels(11:end); 
      end
    end
  end
  
  %% Stage 4: Perform EDA (exploratory data analysis)
  %Example given by HR=60/IBI
  %c_1=60./data_features{1, 1}.BINDI.Neutro.BVP_feats(:,3);        % Generate group 1
  %c_2=60./data_features{1, 1}.BINDI.Recovery.BVP_feats(:,3);       % Generate group 2
  %C = {c_1(:); c_2(:)};  % <--- Just vertically stack all of your groups here
  %grp = cell2mat(arrayfun(@(i){i*ones(numel(C{i}),1)},(1:numel(C))')); 
  %boxplot(vertcat(C{:}),grp, 'Labels',{'Neutro','Video'});
  
  %Get the balance dataset
  balance = [];
  if ~isempty(response_in)
    for i=1:volunteers
      class1 = numel(find(labels{:,:,i}==0));
      class2 = numel(find(labels{:,:,i}==1));
      balance = [balance; class1 class2];
    end
  end
  

  if ~isempty(response_in)
    for i=1:volunteers
      
      %Display some info
      fprintf('Volunteer %d, Trainning and Testing...\n',i);
      
      %% Stage 5: Trainning the model - Validation
      % Training for #volunteers except 'i'
      peri_temp = peri;
      peri_temp(:,:,i) = [];
      labels_temp = labels;
      labels_temp(:,:,i) = [];
      [result_train{i}] = trainModels_tvt(peri_temp, labels_temp, 'database',4,'model',1);
      %% Stage 6: Testing the model - Test
      %SVM
      for k = 1:5
        [tPredictions, tScores] = predict(result_train{i}.svm_simulation.Classifier.Trained{k}, zscore(peri{:,:,i}));
        confuM_t = confusionmat(string(num2cell(labels{:,:,i}+1)), string(tPredictions));
        sent   = confuM_t(2,2)/(confuM_t(2,2)+confuM_t(1,2));
        spet   = confuM_t(1,1)/(confuM_t(1,1)+confuM_t(2,1));
        gmeant(k) =sqrt(sent *spet);
      end
      result_train{i}.svm_test.gmean = gmeant;

      %KNN
      for k = 1:5
        [tPredictions, tScores] = predict(result_train{i}.knn_simulation.Classifier.Trained{k}, zscore(peri{:,:,i}));
        confuM_t = confusionmat(string(num2cell(labels{:,:,i}+1)), string(tPredictions));
        sent   = confuM_t(2,2)/(confuM_t(2,2)+confuM_t(1,2));
        spet   = confuM_t(1,1)/(confuM_t(1,1)+confuM_t(2,1));
        gmeant(k) =sqrt(sent *spet);
      end
      result_train{i}.knn_test.gmean = gmeant;
      
      %ENS
      for k = 1:5
        [tPredictions, tScores] = predict(result_train{i}.ens_simulation.Classifier.Trained{k}, zscore(peri{:,:,i}));
        confuM_t = confusionmat(string(num2cell(labels{:,:,i}+1)), string(tPredictions));
        sent   = confuM_t(2,2)/(confuM_t(2,2)+confuM_t(1,2));
        spet   = confuM_t(1,1)/(confuM_t(1,1)+confuM_t(2,1));
        gmeant(k) =sqrt(sent *spet);
      end
      result_train{i}.ens_test.gmean = gmeant;
      
    end
  end
  %% Stage 6: Give back results
  Results_BioSpeech.features_windows = data_features;
  %Results_BioSpeech.features_all     = feat_all;
  %...TBD
end

%% Function to handle the data coming from BioSpeech Database
function Results_BioSpeech = EMP_DTE_Physio_BioSpeech_JustTrain(data_in, response_in)
  %This function is done ad-hoc for the multimodal DTE-TSC work package
  %It is based on the BioSpeech database
  % Input: data_in --> this is an array of tables
  %        each table corresponds to BVP and GSR extracted features
  
  %Get the number of volunteers and trials
  %Max Volunteers are 42 and max trial are 1
  [volunteers, trials] = size(data_in.features_windows);
  %check values
  if volunteers > 84 || trials > 1
    error('Number of volunteers or trials exceed the maximun allowed');
  end
     
  %% Stage 3: Assign labels
  %peri   = [];
  %labels = {}; 
  if ~isempty(response_in)
    for i=1:volunteers
      for k=1:trials
        peri{:,:,i}   =[ (data_in.features_windows{i,k}.BVP_feats(:,:)) (data_in.features_windows{i,k}.GSR_feats(:,:))];
        [win, ~] = size(peri{:,:,i});
        labels{:,:,i} = response_in{i, k}.binary_labels(11:11+win-1); 
      end
    end
  end
  
  %% Stage 4: Perform EDA (exploratory data analysis)
  %Example given by HR=60/IBI
  %c_1=60./data_features{1, 1}.BINDI.Neutro.BVP_feats(:,3);        % Generate group 1
  %c_2=60./data_features{1, 1}.BINDI.Recovery.BVP_feats(:,3);       % Generate group 2
  %C = {c_1(:); c_2(:)};  % <--- Just vertically stack all of your groups here
  %grp = cell2mat(arrayfun(@(i){i*ones(numel(C{i}),1)},(1:numel(C))')); 
  %boxplot(vertcat(C{:}),grp, 'Labels',{'Neutro','Video'});
  
  %Get the balance dataset
  balance = [];
  if ~isempty(response_in)
    for i=1:volunteers
      class1 = numel(find(labels{:,:,i}==0));
      class2 = numel(find(labels{:,:,i}==1));
      balance = [balance; class1 class2];
    end
  end
  

  if ~isempty(response_in)
    for i=1:volunteers-42-1
      
      %Display some info
      fprintf('Volunteer %d, Trainning and Testing...\n',i);
      
      %% Stage 5: Trainning the model - Validation
      % Training for #volunteers except 'i'
      peri_temp = peri;
      peri_temp(:,:,[i i+42]) = [];
      %peri_temp(:,:,i+42) = [];
      labels_temp = labels;
      labels_temp(:,:,[i i+42]) = [];
      %labels_temp(:,:,i+42) = [];
      [result_train{i}] = trainModels_tvt(peri_temp, labels_temp, 'database',4,'model',1);
      %% Stage 6: Testing the model - Test
      %SVM
      for k = 1:5
        [tPredictions, tScores] = predict(result_train{i}.svm_simulation.Classifier.Trained{k},[ zscore(peri{:,:,i}) ; zscore(peri{:,:,i+42})]);
        confuM_t = confusionmat([string(num2cell(labels{:,:,i}+1)) ; string(num2cell(labels{:,:,i+42}+1))], string(tPredictions));
        [gl,pl]=size(confuM_t);
        if gl==1 && pl==1
          sent = 0;
          spet = 0;
        else
          sent   = confuM_t(2,2)/(confuM_t(2,2)+confuM_t(1,2));
          spet   = confuM_t(1,1)/(confuM_t(1,1)+confuM_t(2,1));
        end
        gmeant(k) =sqrt(sent *spet);
        confuM{k} =confuM_t;
      end
      [tPredictions, tScores] = predict(result_train{i}.svm_simulation.ClassifierAll,[ zscore(peri{:,:,i}) ; zscore(peri{:,:,i+42})]);
      confuM_t = confusionmat([string(num2cell(labels{:,:,i}+1)) ; string(num2cell(labels{:,:,i+42}+1))], string(tPredictions));
      [gl,pl]=size(confuM_t);
      if gl==1 && pl==1
        sent = 0;
        spet = 0;
      else
        sent   = confuM_t(2,2)/(confuM_t(2,2)+confuM_t(1,2));
        spet   = confuM_t(1,1)/(confuM_t(1,1)+confuM_t(2,1));
      end
      gmeant(k+1) =sqrt(sent *spet);
      confuM{k+1} =confuM_t;
      result_train{i}.svm_test.gmean = gmeant;
      result_train{i}.svm_test.confu = confuM;

      %KNN
      for k = 1:5
        [tPredictions, tScores] = predict(result_train{i}.knn_simulation.Classifier.Trained{k},[ zscore(peri{:,:,i}) ; zscore(peri{:,:,i+42})]);
        confuM_t = confusionmat([string(num2cell(labels{:,:,i}+1)) ; string(num2cell(labels{:,:,i+42}+1))], string(tPredictions));
        [gl,pl]=size(confuM_t);
        if gl==1 && pl==1
          sent = 0;
          spet = 0;
        else
          sent   = confuM_t(2,2)/(confuM_t(2,2)+confuM_t(1,2));
          spet   = confuM_t(1,1)/(confuM_t(1,1)+confuM_t(2,1));
        end
        gmeant(k) =sqrt(sent *spet);
        confuM{k} =confuM_t;
      end
      [tPredictions, tScores] = predict(result_train{i}.knn_simulation.ClassifierAll,[ zscore(peri{:,:,i}) ; zscore(peri{:,:,i+42})]);
      confuM_t = confusionmat([string(num2cell(labels{:,:,i}+1)) ; string(num2cell(labels{:,:,i+42}+1))], string(tPredictions));
      [gl,pl]=size(confuM_t);
      if gl==1 && pl==1
        sent = 0;
        spet = 0;
      else
        sent   = confuM_t(2,2)/(confuM_t(2,2)+confuM_t(1,2));
        spet   = confuM_t(1,1)/(confuM_t(1,1)+confuM_t(2,1));
      end
      gmeant(k+1) =sqrt(sent *spet);
      confuM{k+1} =confuM_t;
      result_train{i}.knn_test.gmean = gmeant;
      result_train{i}.knn_test.confu = confuM;
      
      %ENS
      for k = 1:5
        [tPredictions, tScores] = predict(result_train{i}.ens_simulation.Classifier.Trained{k},[ zscore(peri{:,:,i}) ; zscore(peri{:,:,i+42+1})]);
        confuM_t = confusionmat([string(num2cell(labels{:,:,i}+1)) ; string(num2cell(labels{:,:,i+42+1}+1))], string(tPredictions));
        [gl,pl]=size(confuM_t);
        if gl==1 && pl==1
          sent = 0;
          spet = 0;
        else
          sent   = confuM_t(2,2)/(confuM_t(2,2)+confuM_t(1,2));
          spet   = confuM_t(1,1)/(confuM_t(1,1)+confuM_t(2,1));
        end
        gmeant(k) =sqrt(sent *spet);
        confuM{k} =confuM_t;
      end
      [tPredictions, tScores] = predict(result_train{i}.ens_simulation.ClassifierAll,[ zscore(peri{:,:,i}) ; zscore(peri{:,:,i+42+1})]);
      confuM_t = confusionmat([string(num2cell(labels{:,:,i}+1)) ; string(num2cell(labels{:,:,i+42+1}+1))], string(tPredictions));
      [gl,pl]=size(confuM_t);
      if gl==1 && pl==1
        sent = 0;
        spet = 0;
      else
        sent   = confuM_t(2,2)/(confuM_t(2,2)+confuM_t(1,2));
        spet   = confuM_t(1,1)/(confuM_t(1,1)+confuM_t(2,1));
      end
      gmeant(k+1) =sqrt(sent *spet);
      confuM{k+1} =confuM_t;
      result_train{i}.ens_test.gmean = gmeant;
      result_train{i}.ens_test.confu = confuM;
      
    end
  end
  %% Stage 6: Give back results
  Results_BioSpeech.features_windows = data_features;
  Results_BioSpeech.results_windows  = result_train;
  %Results_BioSpeech.features_all     = feat_all;
  %...TBD
end