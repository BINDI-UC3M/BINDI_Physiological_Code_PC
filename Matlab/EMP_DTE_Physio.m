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
  if ~any(strcmpi(type,{'BBDDLab_Bindi','DEAP','MAHNOB','WESAD','BioSpeech'}))
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
        %Creation of signals from BBDDLab data
        Results = EMP_DTE_Physio_BBDDLab_Bindi(data_in, response_in);
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
      %TBD...
      
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
      while(stop<length(bvp_sig_neutro.raw))
        bvp_sig_cpy.raw = bvp_sig_neutro.raw(start:stop);
        [data_features{i,k}.BINDI.Neutro.BVP_feats(window_num,:), ...
         data_features{i,k}.BINDI.Neutro.BVP_feats_names] = ...
            BVP_features_extr(bvp_sig_cpy);
        %TBD...        
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