%% MAIN FUCNTION
function out_struct = empatia_exp3_preprocess_v1_cont(parseEH)

%Select folder where data have been stored
selpath = uigetdir(cd,'Script Root Folder - Select Data Root Folder for BINDI, GSR and EH');
if selpath==0
  error("A valid folder must be specified");
end

%--------------------------------------------%
%Getting the raw data from trial's csv files
out_struct = struct([]);

%Getting the path directory for each wanted folder
% and checking its existence
% curr_path_bindi = strcat(selpath,'\Bindi\');
% curr_path_gsr = strcat(selpath,'\GSR\');
curr_path_eh = strcat(selpath,'\EH\');
% if ~exist(curr_path_bindi, 'dir') || ...
%    ~exist(curr_path_gsr, 'dir') || ...
%    ~exist(curr_path_eh, 'dir')
%   error("One of the following subfolders is missing: Bindi, GSR, EH");
% end

%Getting actual directories
% directory_data_bindi = dir(curr_path_bindi);
% directory_data_gsr = dir(curr_path_gsr);
directory_data_eh = dir(curr_path_eh);

%Taking the total number of patients based on the 
% number of subfolders within any of the main subfolders
% [patients_total_b,~]=size(directory_data_gsr);
% [patients_total_gsr,~]=size(directory_data_gsr);
[patients_total_eh,~]=size(directory_data_eh);
%check if all subfolders have the same number of patients
% if patients_total_b==patients_total_gsr && patients_total_gsr==patients_total_eh
%   patients_total = patients_total_b;
% else
%   error("Subfolders do NOT have the same number of patients");
% end

%The first two positions are the previous and the previous 
% of the previous folders
init_directory = 3;

%There must be a total of 10 videos for each patient
videos_total = 4;

for j = init_directory:7
    
%     out_struct{j-init_directory+1,videos_total+1}.BINDI.trial = [];
%     out_struct{j-init_directory+1,videos_total+1}.BINDI.samplesLostfile = [];
%     out_struct{j-init_directory+1,videos_total+1}.BINDI.samplesLostnum = [];
%     out_struct{j-init_directory+1,videos_total+1}.BINDI.samplesLostRow = [];
%     out_struct{j-init_directory+1,videos_total+1}.BINDI.allRaw = [];
    
%     out_struct{j-init_directory+1,videos_total+1}.GSR.trial = [];
%     out_struct{j-init_directory+1,videos_total+1}.GSR.samplesLostfile = [];
%     out_struct{j-init_directory+1,videos_total+1}.GSR.samplesLostnum = [];
%     out_struct{j-init_directory+1,videos_total+1}.GSR.samplesLostRow = [];
%     out_struct{j-init_directory+1,videos_total+1}.GSR.allRaw = [];
    
    %Apply parser for EH files
    if parseEH==1
      str_folder_eh = strcat(curr_path_eh, directory_data_eh(j).name);
      cd(str_folder_eh);
      python = strcat('python',{' '},selpath,'\autoParser_v2.py');
      system(string(python));  
      cd(selpath);
    end
    
    for i = 1:videos_total
        fprintf('Patient %s, Video %d data extracting...\n',directory_data_eh(j).name, i);
%         str_file_b = strcat(curr_path_bindi,...
% 		        directory_data_bindi(j).name,'\',directory_data_bindi(j).name);
%         str_file_g = strcat(curr_path_gsr,...
% 		        directory_data_gsr(j).name,'\',directory_data_gsr(j).name);
        str_file_e = strcat(curr_path_eh,...
		        directory_data_eh(j).name,'\',directory_data_eh(j).name);

        %%%%%%%%%%%%%%%%%%%%%%%%%% BINDI
%         out_struct{j-init_directory+1,i}.BINDI = empatia_preprocess_bfile(str_file_b,i);
%         out_struct{j-init_directory+1,videos_total+1}.BINDI.trial = [out_struct{j-init_directory+1,videos_total+1}.BINDI.trial; i];
%         out_struct{j-init_directory+1,videos_total+1}.BINDI.samplesLostfile = ...
%             [out_struct{j-init_directory+1,videos_total+1}.BINDI.samplesLostfile;  out_struct{j-init_directory+1,i}.BINDI.samplesLostfile];
%         out_struct{j-init_directory+1,videos_total+1}.BINDI.samplesLostnum = ...
%             [out_struct{j-init_directory+1,videos_total+1}.BINDI.samplesLostnum;  out_struct{j-init_directory+1,i}.BINDI.samplesLostnum];
%        out_struct{j-init_directory+1,videos_total+1}.BINDI.samplesLostRow = ...
%             [out_struct{j-init_directory+1,videos_total+1}.BINDI.samplesLostRow;  out_struct{j-init_directory+1,i}.BINDI.samplesLostRow];
%         out_struct{j-init_directory+1,videos_total+1}.BINDI.allRaw = ...
%             [out_struct{j-init_directory+1,videos_total+1}.BINDI.allRaw; out_struct{j-init_directory+1, i}.BINDI.allraw.gsr_ADC];
        
        %%%%%%%%%%%%%%%%%%%%%%%%%% GSR
% 		out_struct{j-init_directory+1,i}.GSR = empatia_preprocess_gfileNew(str_file_g,i);
%         out_struct{j-init_directory+1,videos_total+1}.GSR.trial = [out_struct{j-init_directory+1,videos_total+1}.GSR.trial; i];
%         out_struct{j-init_directory+1,videos_total+1}.GSR.samplesLostfile = ...
%             [out_struct{j-init_directory+1,videos_total+1}.GSR.samplesLostfile;  out_struct{j-init_directory+1,i}.GSR.samplesLostfile];
%         out_struct{j-init_directory+1,videos_total+1}.GSR.samplesLostnum = ...
%             [out_struct{j-init_directory+1,videos_total+1}.GSR.samplesLostnum;  out_struct{j-init_directory+1,i}.GSR.samplesLostnum];
%        out_struct{j-init_directory+1,videos_total+1}.GSR.samplesLostRow = ...
%             [out_struct{j-init_directory+1,videos_total+1}.GSR.samplesLostRow;  out_struct{j-init_directory+1,i}.GSR.samplesLostRow];
%         out_struct{j-init_directory+1,videos_total+1}.GSR.allRaw = ...
%             [out_struct{j-init_directory+1,videos_total+1}.GSR.allRaw; out_struct{j-init_directory+1, i}.GSR.allraw.gsr_uS];
        
        %%%%%%%%%%%%%%%%%%%%%%%%%%% EH
        out_struct{j-init_directory+1,i}.EH = empatia_preprocess_efile(str_file_e,i);
        %WTD

        out_struct{j-init_directory+1,i}.ParticipantNum = (directory_data_eh(j).name);
        out_struct{j-init_directory+1,i}.Trial = i;
        fprintf('Patient %s, Video %d data extracted\n',directory_data_eh(j).name, i);
    end
    disp("%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%")
end
%--------------------------------------------%

%Applying signal preprocessing 
% out_struct = empatia_preprocess_gsignalsNew(out_struct);
out_struct = empatia_preprocess_esignals(out_struct);
% out_struct = empatia_preprocess_bsignals(out_struct);

%Plotting the raw data
% out_struct = empatia_plot_allrawGsr(out_struct,1,1);
% empatia_preprocess_allraw(out_struct,1,1);

%Plotting BVP-features related correlations
%empatia_preprocess_bvpCorrelation(out_struct);

end

%% PREPROCESS FILEs FUNCTIONS
%Getting the raw data from BINDI's csv files
function out_s = empatia_preprocess_bfile(file,video)

% Step 0: Prepare the reading for the four file types

% Setup the Import Options and import the data
% variables_num = 6;
variables_num = 5;
filetypes_num = 4;
filetypes_str = {'N','V','E','D'};
%filetypes_str = {'N','V'};
% GSR, BVP, SKT, SKT2, Time
opts = delimitedTextImportOptions("NumVariables", variables_num);
% Specify range and delimiter
opts.DataLines = [2, Inf];
opts.Delimiter = ";";
% Specify column names and types
% opts.VariableNames = ["gsr", "bvp", "skt","skt2", "count" ,"time"];
opts.VariableNames = ["gsr", "bvp","skt2", "count" ,"time"];
opts.VariableTypes = ["double", "double", "double", "double","double"];
% opts.VariableTypes = ["double", "double", "double", "double", "double","double"];
% Specify file level properties
opts.MissingRule = "fill";
opts.ExtraColumnsRule = "addvars";
opts.EmptyLineRule = "read";
%  opts.ImportErrorRule = 'error';
% Specify variable properties
opts = setvaropts(opts,'FillValue',0);

%Declare all raw array and others for storing all experiment for current video
out_s.allraw.gsr_ADC = [];
out_s.allraw.gsr_Ohm = [];
out_s.allraw.gsr_uS = [];
out_s.allraw.count    = [];
  
% Import the data
for i = 1:filetypes_num
  %Variables for storing fails
  out_s.samplesLostfile = [];
  out_s.samplesLostnum  = [];
  out_s.samplesLostRow  = [];

  % out_s.samplesDuration = [];
  % out_s.samplesLostTotal = [];
  % out_s.samplesLostMax = [];
  % out_s.samplesWithoutLostMaxSec = [];
  
  %Read data
  str_file = strcat(file,'_',filetypes_str(i),'VIDEO',num2str(video),'.csv');
  
  % Step 1: Check if file is type .csv
  try 
    [~, ~, fExt] = fileparts(string(str_file));
  catch
    return;
  end

  switch lower(fExt)
    case '.csv'
      % A MATLAB file
      %disp("File is in the expected extension\n");
    otherwise  % Under all circumstances SWITCH gets an OTHERWISE!
      error('Unexpected file extension: %s', fExt);
  end
  
  % Step 2: Read all the text within the file
  try 
    data = readtable(string(str_file),opts);
  catch
    %out_s = []; 
    error('No file found with name: %s',str_file);
    %return;
  end
 
  %Step 2.1: check size of data
  [samples,var] = size(data);
  if var>variables_num
%       warning('Data column error: %s', string(str_file));
%       rows = find(~isnan(str2double(data.ExtraVar1)));
      rows = find((~strcmp(data.ExtraVar1,''))==1);
      if isempty(rows)
         rows = find((~strcmp(data.ExtraVar1,''))==1);
      end
      rows(rows==1)=[];
      rows(rows==length(data.ExtraVar1))=[];
      [fails] = length(rows);
      for k=1:fails
        out_s.samplesLostfile   = [out_s.samplesLostfile; i];
        if data.count(rows(k)+1) > data.count(rows(k)-1)
            out_s.samplesLostnum= [out_s.samplesLostnum; data.count(rows(k)+1)- data.count(rows(k)-1)];
            out_s.samplesLostRow = [out_s.samplesLostRow; rows(k)];
            warning('Data column error: %s // Lost: %d', string(str_file),data.count(rows(k)+1)- data.count(rows(k)-1));
        else
            data.count(rows(k)-1) = 1000 - data.count(rows(k)-1);
            out_s.samplesLostnum= [out_s.samplesLostnum; data.count(rows(k)+1)+ data.count(rows(k)-1)];
            out_s.samplesLostRow = [out_s.samplesLostRow; rows(k)];
            warning('Data column error: %s // Lost: %d', string(str_file),data.count(rows(k)+1)+ data.count(rows(k)-1));
        end
      end
  elseif samples==0
    %File is empty
    warning('File is empty: %s', string(str_file));
  else
    %if we are on recovery, omit the recovery results
    if i==filetypes_num
      %row_a = find(data.gsr == 0);
      data(data.gsr == 0,:) = [];
    end
    checkDiff = diff(data.count);
    row_a = find(checkDiff ~= 1 & checkDiff ~= -999);
    if isempty(row_a)
    else
       warning('Data column error: %s', string(str_file));
    end
  end
  
  % Step 3: Store data into struct
  switch i
      %Neutro
      case 1
        out_s.Neutro.raw.gsr = data.gsr;
        out_s.Neutro.raw.gsr(isnan(out_s.Neutro.raw.gsr))=[];
        out_s.allraw.gsr_ADC = [out_s.allraw.gsr_ADC;  out_s.Neutro.raw.gsr];
        out_s.allraw.gsr_Ohm = [out_s.allraw.gsr_Ohm;...
            -(1000000.*out_s.Neutro.raw.gsr)./(out_s.Neutro.raw.gsr - 16383)];
        out_s.allraw.gsr_uS = [out_s.allraw.gsr_uS ;(1./out_s.allraw.gsr_Ohm)*10e6];
        out_s.Neutro.raw.bvp = data.bvp;
        out_s.Neutro.raw.bvp(isnan(out_s.Neutro.raw.bvp))=[];
%         out_s.Neutro.raw.skt = data.skt;
%         out_s.Neutro.raw.skt(isnan(out_s.Neutro.raw.skt))=[];
        out_s.Neutro.raw.skt2 = data.skt2;
        out_s.Neutro.raw.skt2(isnan(out_s.Neutro.raw.skt2))=[];
        out_s.Neutro.raw.count = data.count;
        out_s.Neutro.raw.count(isnan(out_s.Neutro.raw.count))=[];
        out_s.allraw.count = [out_s.allraw.count  ; out_s.Neutro.raw.count];
        
        %Step 2.2: Get the lost variables
        out_s.Neutro.samplesDuration          = samples + sum(out_s.samplesLostnum);
        out_s.Neutro.samplesLostTotal         = sum(out_s.samplesLostnum);
        out_s.Neutro.samplesLostMax           = max(out_s.samplesLostnum);
        out_s.Neutro.samplesLostRow           = [1; out_s.samplesLostRow; samples];
        out_s.Neutro.samplesWithoutLostMax    = max(diff(out_s.samplesLostRow));
        
        disp("BINDI: Neutro successfull");
        
      %Video
      case 2
        out_s.Video.raw.gsr = data.gsr;
        out_s.Video.raw.gsr(isnan(out_s.Video.raw.gsr))=[];
        out_s.allraw.gsr_ADC = [out_s.allraw.gsr_ADC;  out_s.Video.raw.gsr];
        out_s.allraw.gsr_Ohm = [out_s.allraw.gsr_Ohm;...
            -(1000000.*out_s.Video.raw.gsr)./(out_s.Video.raw.gsr - 16383)];
        out_s.allraw.gsr_uS = [out_s.allraw.gsr_uS ;(1./out_s.allraw.gsr_Ohm)*10e6];
        out_s.Video.raw.bvp = data.bvp;
        out_s.Video.raw.bvp(isnan(out_s.Video.raw.bvp))=[];
%         out_s.Video.raw.skt = data.skt;
%         out_s.Video.raw.skt(isnan(out_s.Video.raw.skt))=[];
        out_s.Video.raw.skt2 = data.skt2;
        out_s.Video.raw.skt2(isnan(out_s.Video.raw.skt2))=[];
        out_s.Video.raw.count = data.count;
        out_s.Video.raw.count(isnan(out_s.Video.raw.count))=[];
        out_s.allraw.count = [out_s.allraw.count  ; out_s.Video.raw.count];
        
        %Step 2.2: Get the lost variables
        out_s.Video.samplesDuration          = samples + sum(out_s.samplesLostnum);
        out_s.Video.samplesLostTotal         = sum(out_s.samplesLostnum);
        out_s.Video.samplesLostMax           = max(out_s.samplesLostnum);
        out_s.Video.samplesLostRow           = [1; out_s.samplesLostRow; samples];
        out_s.Video.samplesWithoutLostMax    = max(diff(out_s.samplesLostRow));
        
        disp("BINDI: Video successfull");
        
      %Etiquetas
      case 3
        out_s.Labels.raw.gsr = data.gsr;
        out_s.Labels.raw.gsr(isnan(out_s.Labels.raw.gsr))=[];
        out_s.allraw.gsr_ADC = [out_s.allraw.gsr_ADC;  out_s.Labels.raw.gsr];
        out_s.allraw.gsr_Ohm = [out_s.allraw.gsr_Ohm;...
            -(1000000.*out_s.Labels.raw.gsr)./(out_s.Labels.raw.gsr - 16383)];
        out_s.allraw.gsr_uS = [out_s.allraw.gsr_uS ;(1./out_s.allraw.gsr_Ohm)*10e6];
        out_s.Labels.raw.bvp = data.bvp;
        out_s.Labels.raw.bvp(isnan(out_s.Labels.raw.bvp))=[];
%         out_s.Labels.raw.skt = data.skt;
%         out_s.Labels.raw.skt(isnan(out_s.Labels.raw.skt))=[];
        out_s.Labels.raw.skt2 = data.skt2;
        out_s.Labels.raw.skt2(isnan(out_s.Labels.raw.skt2))=[];
        out_s.Labels.raw.count = data.count;
        out_s.Labels.raw.count(isnan(out_s.Labels.raw.count))=[];
        out_s.allraw.count = [out_s.allraw.count  ; out_s.Labels.raw.count];
        
        %Step 2.2: Get the lost variables
        out_s.Labels.samplesDuration          = samples + sum(out_s.samplesLostnum);
        out_s.Labels.samplesLostTotal         = sum(out_s.samplesLostnum);
        out_s.Labels.samplesLostMax           = max(out_s.samplesLostnum);
        out_s.Labels.samplesLostRow           = [1; out_s.samplesLostRow; samples];
        out_s.Labels.samplesWithoutLostMax    = max(diff(out_s.samplesLostRow));
        
        disp("BINDI: Labels successfull");
        
      %Descanso/Recovery
      case 4
        out_s.Recovery.raw.gsr = data.gsr;
        out_s.Recovery.raw.gsr(isnan(out_s.Recovery.raw.gsr))=[];
        out_s.allraw.gsr_ADC = [out_s.allraw.gsr_ADC;  out_s.Recovery.raw.gsr];
        out_s.allraw.gsr_Ohm = [out_s.allraw.gsr_Ohm;...
            -(1000000.*out_s.Recovery.raw.gsr)./(out_s.Recovery.raw.gsr - 16383)];
        out_s.allraw.gsr_uS = [out_s.allraw.gsr_uS ;(1./out_s.allraw.gsr_Ohm)*10e6];
        out_s.Recovery.raw.bvp = data.bvp;
        out_s.Recovery.raw.bvp(isnan(out_s.Recovery.raw.bvp))=[];
%         out_s.Recovery.raw.skt = data.skt;
%         out_s.Recovery.raw.skt(isnan(out_s.Recovery.raw.skt))=[];
        out_s.Recovery.raw.skt2 = data.skt2;
        out_s.Recovery.raw.skt2(isnan(out_s.Recovery.raw.skt2))=[];
        out_s.Recovery.raw.count = data.count;
        out_s.Recovery.raw.count(isnan(out_s.Recovery.raw.count))=[];
        out_s.allraw.count = [out_s.allraw.count  ; out_s.Recovery.raw.count];
        
        %Step 2.2: Get the lost variables
        out_s.Recovery.samplesDuration          = samples + sum(out_s.samplesLostnum);
        out_s.Recovery.samplesLostTotal         = sum(out_s.samplesLostnum);
        out_s.Recovery.samplesLostMax           = max(out_s.samplesLostnum);
        out_s.Recovery.samplesLostRow           = [1; out_s.samplesLostRow; samples];
        out_s.Recovery.samplesWithoutLostMax    = max(diff(out_s.samplesLostRow));
        
        disp("BINDI: Recovery successfull");
        
      otherwise % Under all circumstances SWITCH gets an OTHERWISE!
        error('Unexpected file type\n');
  end
  
end

% % Step 4: Store feedback into struct
% % Setup the Import Options and import the data
% opts = delimitedTextImportOptions("NumVariables", 2);
% % Specify range and delimiter
% opts.DataLines = [1, Inf];
% opts.Delimiter = ";";
% % Specify column names and types
% opts.VariableNames = ["Category", "Value"];
% opts.VariableTypes = ["categorical", "string"];
% % Specify file level properties
% opts.ExtraColumnsRule = "ignore";
% opts.EmptyLineRule = "read";
% opts.ConsecutiveDelimitersRule = "join";
% % Specify variable properties
% opts = setvaropts(opts, "Value", "WhitespaceRule", "preserve");
% opts = setvaropts(opts, ["Category", "Value"], "EmptyFieldRule", "auto");
% % Import the data
% str_file = strcat(file,'_Encuesta.csv');
% feedback = readtable(str_file, opts);
% temp = (video - 1)*10 + 1;
% out_s.Feedback.Arousal_sr   = str2double(feedback(temp + 1,:).Value);
% out_s.Feedback.Valence_sr   = str2double(feedback(temp + 2,:).Value);
% out_s.Feedback.Dominance_sr = str2double(feedback(temp + 3,:).Value);
% out_s.Feedback.Emotion_sr   = feedback(temp + 8,:).Value;

% Step 5: Setting pre-processing Flag
out_s.Filtered = 0;

end

%Getting the raw data from GSR AD's csv files
function out_s = empatia_preprocess_gfile(file,video)

% Step 0: Prepare the reading for the four file types

% Setup the Import Options and import the data
variables_num = 9;
filetypes_num = 4;
filetypes_str = {'N','V','E','D'};
% GSR, BVP, SKT, SKT2, Time
opts = delimitedTextImportOptions("NumVariables", variables_num);

% Specify range and delimiter
opts.DataLines = [1, Inf];
opts.Delimiter = {'Rtia',':',';','(Real;Image)','(',')','Ohm---Mag','Ohm','Phase','`'};
% Specify column names and types
opts.VariableNames = ['var1','rtia','gsr','gsr_img',"gsr_mag",'gsr_phase','hour','min','sec'];
opts.VariableTypes = {'char', 'double' , 'double','double','double','double','double' ,'double','double'};
opts.SelectedVariableNames = {'gsr','gsr_mag'} ;
% Specify file level properties
opts.ExtraColumnsRule = "ignore";
opts.EmptyLineRule = "read";
% Specify variable properties
% opts = setvaropts(opts, "time", "InputFormat", "HH:mm:ss");
opts.ConsecutiveDelimitersRule='join';

% Import the data
for i = 1:filetypes_num
    
  %Read data
  str_file = strcat(file,'_',filetypes_str(i),'VIDEO',num2str(video),'.csv');
  
  % Step 1: Check if file is type .csv
  try 
    [~, ~, fExt] = fileparts(string(str_file));
  catch
    return;
  end

  switch lower(fExt)
    case '.csv'
      % A MATLAB file
      disp("File is in the expected extension\n");
    otherwise  % Under all circumstances SWITCH gets an OTHERWISE!
      error('Unexpected file extension: %s', fExt);
  end
  
  % Step 2: Read all the text within the file
  try 
    data = readtable(string(str_file),opts);
  catch
    out_s = [];
    return;
  end

  % Step 3: Store data into struct
  switch i
      %Neutro
      case 1
        out_s.Neutro.raw.gsr_real = data.gsr;
        out_s.Neutro.raw.gsr_real(isnan(out_s.Neutro.raw.gsr_real))=[];
        out_s.Neutro.raw.gsr_mag = data.gsr_mag;
        out_s.Neutro.raw.gsr_mag(isnan(out_s.Neutro.raw.gsr_mag))=[];
      %Video
      case 2
        out_s.Video.raw.gsr_real = data.gsr;
        out_s.Video.raw.gsr_real(isnan(out_s.Video.raw.gsr_real))=[];
        out_s.Video.raw.gsr_mag = data.gsr_mag;
        out_s.Video.raw.gsr_mag(isnan(out_s.Video.raw.gsr_mag))=[];
      %Etiquetas
      case 3
        out_s.Labels.raw.gsr_real = data.gsr;
        out_s.Labels.raw.gsr_real(isnan(out_s.Labels.raw.gsr_real))=[];
        out_s.Labels.raw.gsr_mag = data.gsr_mag;
        out_s.Labels.raw.gsr_mag(isnan(out_s.Labels.raw.gsr_mag))=[];
      %Descanso/Recovery
      case 4
        out_s.Recovery.raw.gsr_real = data.gsr;
        out_s.Recovery.raw.gsr_real(isnan(out_s.Recovery.raw.gsr_real))=[];
        out_s.Recovery.raw.gsr_mag = data.gsr_mag;
        out_s.Recovery.raw.gsr_mag(isnan(out_s.Recovery.raw.gsr_mag))=[];
      otherwise % Under all circumstances SWITCH gets an OTHERWISE!
        error('Unexpected file type\n');
  end
  
end

% Step 4: Store feedback into struct
%Not applicable for this sensor - File is in Bindi's Subfolder

% Step 5: Setting pre-processing Flag
out_s.Filtered = 0;

end

%Getting the raw data from GSRNew Circuit csv files
function out_s = empatia_preprocess_gfileNew(file,video)

% Step 0: Prepare the reading for the four file types

% Setup the Import Options and import the data
variables_num = 5;
filetypes_num = 4;
filetypes_str = {'N','V','E','D'};
% GSR, BVP, SKT, SKT2, Time
opts = delimitedTextImportOptions("NumVariables", variables_num);

% Specify range and delimiter
opts.DataLines = [2, Inf];
opts.Delimiter = {';'};
% Specify column names and types
opts.VariableNames = ["uS","count","pot1","recon","time"];
opts.VariableTypes = ["double", "double" ,"double","double","double"];
% Specify file level properties
opts.MissingRule = "fill";
opts.ExtraColumnsRule = "addvars";
opts.EmptyLineRule = "read";
%  opts.ImportErrorRule = 'error';
% Specify variable properties
opts = setvaropts(opts,'FillValue',0);

%Declare all raw array and others for storing all experiment for current video
out_s.allraw.gsr_uS = [];
out_s.allraw.count = [];
 
% Import the data
for i = 1:filetypes_num
  %Variables for storing fails
  out_s.samplesLostfile = [];
  out_s.samplesLostnum  = [];
  out_s.samplesLostRow  = [];
  
  %Read data
  str_file = strcat(file,'_',filetypes_str(i),'VIDEO',num2str(video),'.csv');
  
  % Step 1: Check if file is type .csv
  try 
    [~, ~, fExt] = fileparts(string(str_file));
  catch
    return;
  end

  switch lower(fExt)
    case '.csv'
      % A MATLAB file
      %disp("File is in the expected extension\n");
    otherwise  % Under all circumstances SWITCH gets an OTHERWISE!
      error('Unexpected file extension: %s', fExt);
  end
  
  % Step 2: Read all the text within the file
  try 
    data = readtable(string(str_file),opts);
  catch
    out_s = [];
    return;
  end
  
  %Step 2.1: check size of data
  [samples,var] = size(data);
  if var>variables_num
%       warning('Data column error: %s', string(str_file));
%       rows = find(~isnan(str2double(data.ExtraVar1)));
      rows = find((~strcmp(data.ExtraVar1,''))==1);
      if length(rows)==0
         rows = find((~strcmp(data.ExtraVar1,''))==1);
      end
      rows(rows==1)=[];
      rows(rows==length(data.ExtraVar1))=[];
      [fails] = length(rows);
      for k=1:fails
        out_s.samplesLostfile   = [out_s.samplesLostfile; i];
        if data.count(rows(k)+1) > data.count(rows(k)-1)
            out_s.samplesLostnum= [out_s.samplesLostnum; data.count(rows(k)+1)- data.count(rows(k)-1)];
            out_s.samplesLostRow = [out_s.samplesLostRow; rows(k)];
            warning('Data column error: %s // Lost: %d', string(str_file),data.count(rows(k)+1)- data.count(rows(k)-1));
        else
            data.count(rows(k)-1) = 1000000 - data.count(rows(k)-1);
            out_s.samplesLostnum= [out_s.samplesLostnum; data.count(rows(k)+1)+ data.count(rows(k)-1)];
            out_s.samplesLostRow = [out_s.samplesLostRow; rows(k)];
            warning('Data column error: %s // Lost: %d', string(str_file),data.count(rows(k)+1)+ data.count(rows(k)-1));
        end
      end
  elseif samples==0
    %File is empty
    warning('File is empty: %s', string(str_file));
  else
%     %if we are on recovery, omit the recovery results
%     if i==filetypes_num
%       %row_a = find(data.gsr == 0);
%       data(data.gsr == 0,:) = [];
%     end
    checkDiff = diff(data.count);
    row_a = find(checkDiff ~= 1 & checkDiff ~= -999999);
    if isempty(row_a)
    else
       warning('Data column error: %s', string(str_file));
    end
  end

  % Step 3: Store data into struct
  switch i
      %Neutro
      case 1
        out_s.Neutro.raw.gsr_uS = data.uS;
        out_s.Neutro.raw.gsr_uS(isnan(out_s.Neutro.raw.gsr_uS))=[];
%         rows_recon = find(data.recon == 1);
%         out_s.Neutro.raw.gsr_uS(1:rows_recon(end))=[]; 
        out_s.allraw.gsr_uS = [out_s.allraw.gsr_uS;  out_s.Neutro.raw.gsr_uS];
        out_s.Neutro.raw.count = data.count;
        out_s.Neutro.raw.count(isnan(out_s.Neutro.raw.count))=[];
        out_s.allraw.count = [out_s.allraw.count  ; out_s.Neutro.raw.count];
        out_s.Neutro.raw.recon = data.recon;
       
        %Step 2.2: Get the lost variables
        out_s.Neutro.samplesDuration          = samples + sum(out_s.samplesLostnum);
        out_s.Neutro.samplesLostTotal         = sum(out_s.samplesLostnum);
        out_s.Neutro.samplesLostMax           = max(out_s.samplesLostnum);
        out_s.Neutro.samplesLostRow           = [1; out_s.samplesLostRow; samples];
        out_s.Neutro.samplesWithoutLostMax    = max(diff(out_s.samplesLostRow));
        
        disp("GSR: Neutro successfull");
        
      %Video
      case 2
        out_s.Video.raw.gsr_uS = data.uS;
        out_s.Video.raw.gsr_uS(isnan(out_s.Video.raw.gsr_uS))=[];
%         rows_recon = find(data.recon == 1);
%         out_s.Video.raw.gsr_uS(1:rows_recon(end))=[]; 
        out_s.allraw.gsr_uS = [out_s.allraw.gsr_uS; out_s.Video.raw.gsr_uS];
        out_s.Video.raw.count = data.count;
        out_s.Video.raw.count(isnan(out_s.Video.raw.count))=[];
        out_s.allraw.count = [out_s.allraw.count  ; out_s.Video.raw.count];
        out_s.Video.raw.recon = data.recon;
       
        %Step 2.2: Get the lost variables
        out_s.Video.samplesDuration          = samples + sum(out_s.samplesLostnum);
        out_s.Video.samplesLostTotal         = sum(out_s.samplesLostnum);
        out_s.Video.samplesLostMax           = max(out_s.samplesLostnum);
        out_s.Video.samplesLostRow           = [1; out_s.samplesLostRow; samples];
        out_s.Video.samplesWithoutLostMax    = max(diff(out_s.samplesLostRow));
        
        disp("GSR: Video successfull");
        
      %Etiquetas
      case 3
        out_s.Labels.raw.gsr_uS = data.uS;
        out_s.Labels.raw.gsr_uS(isnan(out_s.Labels.raw.gsr_uS))=[];
%         rows_recon = find(data.recon == 1);
%         out_s.Labels.raw.gsr_uS(1:rows_recon(end))=[]; 
        out_s.allraw.gsr_uS = [out_s.allraw.gsr_uS  ;  out_s.Labels.raw.gsr_uS];
        out_s.Labels.raw.count = data.count;
        out_s.Labels.raw.count(isnan(out_s.Labels.raw.count))=[];
        out_s.allraw.count = [out_s.allraw.count  ; out_s.Labels.raw.count];
        out_s.Labels.raw.recon = data.recon;
        
        %Step 2.2: Get the lost variables
        out_s.Labels.samplesDuration          = samples + sum(out_s.samplesLostnum);
        out_s.Labels.samplesLostTotal         = sum(out_s.samplesLostnum);
        out_s.Labels.samplesLostMax           = max(out_s.samplesLostnum);
        out_s.Labels.samplesLostRow           = [1; out_s.samplesLostRow; samples];
        out_s.Labels.samplesWithoutLostMax    = max(diff(out_s.samplesLostRow));
        
        disp("GSR: Labels successfull");
        
      %Descanso/Recovery
      case 4
        out_s.Recovery.raw.gsr_uS = data.uS;
        out_s.Recovery.raw.gsr_uS(isnan(out_s.Recovery.raw.gsr_uS))=[];
%         rows_recon = find(data.recon == 1);
%         out_s.Recovery.raw.gsr_uS(1:rows_recon(end))=[]; 
        out_s.allraw.gsr_uS = [out_s.allraw.gsr_uS  ;  out_s.Recovery.raw.gsr_uS];
        out_s.Recovery.raw.count = data.count;
        out_s.Recovery.raw.count(isnan(out_s.Recovery.raw.count))=[];
        out_s.allraw.count = [out_s.allraw.count  ; out_s.Recovery.raw.count];
        out_s.Recovery.raw.recon = data.recon;
        
        %Step 2.2: Get the lost variables
        out_s.Recovery.samplesDuration          = samples + sum(out_s.samplesLostnum);
        out_s.Recovery.samplesLostTotal         = sum(out_s.samplesLostnum);
        out_s.Recovery.samplesLostMax           = max(out_s.samplesLostnum);
        out_s.Recovery.samplesLostRow           = [1; out_s.samplesLostRow; samples];
        out_s.Recovery.samplesWithoutLostMax    = max(diff(out_s.samplesLostRow));
        
        disp("GSR: Recovery successfull");
        
      otherwise % Under all circumstances SWITCH gets an OTHERWISE!
        error('Unexpected file type\n');
  end
  
end

% Step 4: Store feedback into struct
%Not applicable for this sensor - File is in Bindi's Subfolder

% Step 5: Setting pre-processing Flag
out_s.Filtered = 0;

end

%Getting the raw data from EH's csv files
function out_s = empatia_preprocess_efile(file,video)

% Step 0: Prepare the reading for the four file types

% Setup the Import Options and import the data
variables_num = 7; %number of columns
% filetypes_str = {'N','V','E','D'};
filetypes_str = {'N','V','E','D'};
filetypes_num = size(filetypes_str,2);

% "time", "packet_id", "skt", "bvp", "gsr", "resp", "emg"
% units: ºC ,rel.int., uS,    %   ,   mV
opts = delimitedTextImportOptions("NumVariables", variables_num);
% Specify range and delimiter
opts.DataLines = [3, Inf]; %it starts in the third line
opts.Delimiter = ";";
% Specify column names and types
opts.VariableNames = ["time", "packet_id", "skt", "bvp", "gsr","emg","resp"];
opts.VariableTypes = ["double", "double", "double", "double", "double", "double", "double"];
% Specify file level properties
opts.ExtraColumnsRule = "ignore";
opts.EmptyLineRule = "read";
% Specify variable properties
% opts = setvaropts(opts, "time", "InputFormat", "HH:mm:ss:xxxxxx");
 
%Declare all raw array for storing all experiment for current video
out_s.allraw.gsr_uS = [];
  
% Import the data
for i = 2:filetypes_num
    
  %Read data
  str_file = strcat(file,'_',filetypes_str(i),'VIDEO',num2str(video),'.csv.psd');
  
  % Step 1: Check if file is type .csv
  try 
    [~, ~, fExt] = fileparts(string(str_file));
  catch
    return;
  end

  switch lower(fExt)
    case '.psd'
      % A MATLAB file
      %disp("File is in the expected extension\n");
    otherwise  % Under all circumstances SWITCH gets an OTHERWISE!
      error('Unexpected file extension: %s', fExt);
  end
  
%   % Step 2: Read all the text within the file
  try 
    data = readtable(string(str_file),opts);
  catch
    out_s = [];
    return;
  end
  
  %Step 2.1: check size of data
  [samples,var] = size(data);
  if samples == 0
    %File is empty
    warning('File is empty: %s', string(str_file));
  else
    pkt_id_diff = diff(data.packet_id(1:end));
    rows = find(pkt_id_diff~=1);
    if ~isempty(rows)
      [fails] = length(rows);
      for k=1:fails
        warning('Data column error: %s // Error: %d', string(str_file),data.packet_id(rows(k)));
      end
    end
  end
  
% 
%"time", "packet_id", "skt", "bvp", "gsr", "emg", "resp", "acc1", "acc2", "acc3"
% Step 3: Store data into struct
   switch i
      %Neutro (N)
          case 1
            %out_s.Neutro.raw.date = data.time(1:end);
            %isnan not allowed for datetime type
            
            %out_s.Neutro.raw.packet_id = data.packet_id(1:end);
            %out_s.Neutro.raw.packet_id(isnan(out_s.Neutro.raw.packet_id))=[];
            
            out_s.Neutro.raw.skt = data.skt(1:end);
            out_s.Neutro.raw.skt(isnan(out_s.Neutro.raw.skt))=[];

            out_s.Neutro.raw.bvp = data.bvp(1:end);
            out_s.Neutro.raw.bvp(isnan(out_s.Neutro.raw.bvp))=[];
            
            out_s.Neutro.raw.gsr = data.gsr(1:end);
            out_s.Neutro.raw.gsr(isnan(out_s.Neutro.raw.gsr))=[];
            out_s.allraw.gsr_uS = [out_s.allraw.gsr_uS ;  out_s.Neutro.raw.gsr];
            
%             out_s.Neutro.raw.resp = data.resp(1:end);
%             out_s.Neutro.raw.resp(isnan(out_s.Neutro.raw.resp))=[];
%             
%             out_s.Neutro.raw.emg = data.emg(1:end);
%             out_s.Neutro.raw.emg(isnan(out_s.Neutro.raw.emg))=[];
%             
%             out_s.Neutro.raw.acc1 = data.acc1(1:end);
%             out_s.Neutro.raw.acc1(isnan(out_s.Neutro.raw.acc1))=[];
%             
%             out_s.Neutro.raw.acc2 = data.acc2(1:end);
%             out_s.Neutro.raw.acc2(isnan(out_s.Neutro.raw.acc2))=[];
%             
%             out_s.Neutro.raw.acc3 = data.acc3(1:end);
%             out_s.Neutro.raw.acc3(isnan(out_s.Neutro.raw.acc3))=[];
            
            disp("EH: Neutro successfull");
            
      %Video (V)
        case 2
            %out_s.Video.raw.date = data.time(1:end);
            %isnan not allowed for datetime type
            
            %out_s.Video.raw.packet_id = data.packet_id(1:end);
            %out_s.Video.raw.packet_id(isnan(out_s.Video.raw.packet_id))=[];
            
            out_s.Video.raw.skt = data.skt(1:end);
            out_s.Video.raw.skt(isnan(out_s.Video.raw.skt))=[];

            out_s.Video.raw.bvp = data.bvp(1:end);
            out_s.Video.raw.bvp(isnan(out_s.Video.raw.bvp))=[];
            
            out_s.Video.raw.gsr = data.gsr(1:end);
            out_s.Video.raw.gsr(isnan(out_s.Video.raw.gsr))=[];
            out_s.allraw.gsr_uS = [out_s.allraw.gsr_uS  ;  out_s.Video.raw.gsr];
            
%             out_s.Video.raw.resp = data.resp(1:end);
%             out_s.Video.raw.resp(isnan(out_s.Video.raw.resp))=[];
%             
%             out_s.Video.raw.emg = data.emg(1:end);
%             out_s.Video.raw.emg(isnan(out_s.Video.raw.emg))=[];
%             
%             out_s.Video.raw.acc1 = data.acc1(1:end);
%             out_s.Video.raw.acc1(isnan(out_s.Video.raw.acc1))=[];
%             
%             out_s.Video.raw.acc2 = data.acc2(1:end);
%             out_s.Video.raw.acc2(isnan(out_s.Video.raw.acc2))=[];
%             
%             out_s.Video.raw.acc3 = data.acc3(1:end);
%             out_s.Video.raw.acc3(isnan(out_s.Video.raw.acc3))=[];

            disp("EH: Video successfull");
            
      %Etiquetas (E)
       case 3
            %out_s.Labels.raw.date = data.time(1:end);
            %isnan not allowed for datetime type
            
            %out_s.Labels.raw.packet_id = data.packet_id(1:end);
            %out_s.Labels.raw.packet_id(isnan(out_s.Labels.raw.packet_id))=[];
            
            out_s.Labels.raw.skt = data.skt(1:end);
            out_s.Labels.raw.skt(isnan(out_s.Labels.raw.skt))=[];

            out_s.Labels.raw.bvp = data.bvp(1:end);
            out_s.Labels.raw.bvp(isnan(out_s.Labels.raw.bvp))=[];
            
            out_s.Labels.raw.gsr = data.gsr(1:end);
            out_s.Labels.raw.gsr(isnan(out_s.Labels.raw.gsr))=[];
            out_s.allraw.gsr_uS = [out_s.allraw.gsr_uS  ;  out_s.Labels.raw.gsr];
            
%             out_s.Labels.raw.resp = data.resp(1:end);
%             out_s.Labels.raw.resp(isnan(out_s.Labels.raw.resp))=[];
%             
%             out_s.Labels.raw.emg = data.emg(1:end);
%             out_s.Labels.raw.emg(isnan(out_s.Labels.raw.emg))=[];
%             
%             out_s.Labels.raw.acc1 = data.acc1(1:end);
%             out_s.Labels.raw.acc1(isnan(out_s.Labels.raw.acc1))=[];
%             
%             out_s.Labels.raw.acc2 = data.acc2(1:end);
%             out_s.Labels.raw.acc2(isnan(out_s.Labels.raw.acc2))=[];
%             
%             out_s.Labels.raw.acc3 = data.acc3(1:end);
%             out_s.Labels.raw.acc3(isnan(out_s.Labels.raw.acc3))=[];
            
            disp("EH: Labels successfull");
            
      %Descanso/Recovery (D)
       case 4
            %out_s.Recovery.raw.date = data.time(1:end);
            %isnan not allowed for datetime type
            
            %out_s.Recovery.raw.packet_id = data.packet_id(1:end);
            %out_s.Recovery.raw.packet_id(isnan(out_s.Recovery.raw.packet_id))=[];
            
            out_s.Recovery.raw.skt = data.skt(1:end);
            out_s.Recovery.raw.skt(isnan(out_s.Recovery.raw.skt))=[];

            out_s.Recovery.raw.bvp = data.bvp(1:end);
            out_s.Recovery.raw.bvp(isnan(out_s.Recovery.raw.bvp))=[];
            
            out_s.Recovery.raw.gsr = data.gsr(1:end);	
            out_s.Recovery.raw.gsr(isnan(out_s.Recovery.raw.gsr))=[];
            out_s.allraw.gsr_uS = [out_s.allraw.gsr_uS  ;  out_s.Recovery.raw.gsr];
            
%             out_s.Recovery.raw.resp = data.resp(1:end);
%             out_s.Recovery.raw.resp(isnan(out_s.Recovery.raw.resp))=[];
%             
%             out_s.Recovery.raw.emg = data.emg(1:end);
%             out_s.Recovery.raw.emg(isnan(out_s.Recovery.raw.emg))=[];
%             
%             out_s.Recovery.raw.acc1 = data.acc1(1:end);
%             out_s.Recovery.raw.acc1(isnan(out_s.Recovery.raw.acc1))=[];
%             
%             out_s.Recovery.raw.acc2 = data.acc2(1:end);
%             out_s.Recovery.raw.acc2(isnan(out_s.Recovery.raw.acc2))=[];
%             
%             out_s.Recovery.raw.acc3 = data.acc3(1:end);
%             out_s.Recovery.raw.acc3(isnan(out_s.Recovery.raw.acc3))=[];
            
            disp("EH: Recovery successfull");
            
      otherwise % Under all circumstances SWITCH gets an OTHERWISE!
             error('Unexpected file type\n');
   end
  
end

% % Step 4: Store feedback into struct
%Not applicable for this sensor - File is in Bindi's Subfolder

% Step 5: Setting pre-processing Flag
out_s.Filtered = 0;

end

%% PREPROCESS SIGNALs FUNCTIONS
%Applying signal preprocessing on Bindi signals
function out = empatia_preprocess_bsignals(data_struct)
  %Get patients and videos number
  [patients, videos] = size(data_struct);
  %Load filter coeffs
  FIRs = load('FIRs.mat');
  %Set sampling frequency and processing window
  Fs = 200;
  window_gsr     = 4;
  downsample_gsr = 20; % Fs' = 200/20 = 10Hz
  for j = 1:patients
    for i = 1:videos-1
        
      %GSR filtering - 0-0.05Hz(tonic) 0.05-1.5Hz(phasic) Low Pass 401 Taps
      
      %Neutro
      data_struct{j,i}.BINDI.Neutro.raw.gsr_filtered = ...
          filtfilt(FIRs.Coeffs_GSR,1,data_struct{j,i}.BINDI.Neutro.raw.gsr);
      data_struct{j,i}.BINDI.Neutro.raw.gsr_uS_filtered =...
          -(1000000.*data_struct{j,i}.BINDI.Neutro.raw.gsr_filtered)./...
          (data_struct{j,i}.BINDI.Neutro.raw.gsr_filtered - 16383);
	  data_struct{j,i}.BINDI.Neutro.raw.gsr_uS_filtered_dn = ...
          downsample(data_struct{j,i}.BINDI.Neutro.raw.gsr_uS_filtered,downsample_gsr);
      data_struct{j,i}.BINDI.Neutro.raw.gsr_uS_filtered_dn_sm = ...
          movmedian(movmean(data_struct{j,i}.BINDI.Neutro.raw.gsr_uS_filtered_dn,...
                           (Fs/downsample_gsr)),(Fs/downsample_gsr)/2);
%       data_struct{j,i}.BINDI.Neutro.raw.gsr_adc_tonic = ... 
%           movmedian(data_struct{j,i}.BINDI.Neutro.raw.gsr_filtered,...
%           [Fs*window_gsr Fs*window_gsr]);
%       data_struct{j,i}.BINDI.Neutro.raw.gsr_adc_phasic = ...
%           data_struct{j,i}.BINDI.Neutro.raw.gsr_filtered - ...
%                  data_struct{j,i}.BINDI.Neutro.raw.gsr_adc_tonic;
				 
      %Video
      data_struct{j,i}.BINDI.Video.raw.gsr_filtered = ...
          filtfilt(FIRs.Coeffs_GSR,1,data_struct{j,i}.BINDI.Video.raw.gsr);
      data_struct{j,i}.BINDI.Video.raw.gsr_uS_filtered =...
          -(1000000.*data_struct{j,i}.BINDI.Video.raw.gsr_filtered)./...
          (data_struct{j,i}.BINDI.Video.raw.gsr_filtered - 16383);
	  data_struct{j,i}.BINDI.Video.raw.gsr_uS_filtered_dn = ...
          downsample(data_struct{j,i}.BINDI.Video.raw.gsr_uS_filtered,downsample_gsr);
      data_struct{j,i}.BINDI.Video.raw.gsr_uS_filtered_dn_sm = ...
          movmedian(movmean(data_struct{j,i}.BINDI.Video.raw.gsr_uS_filtered_dn,...
                           (Fs/downsample_gsr)),(Fs/downsample_gsr)/2);
%       data_struct{j,i}.BINDI.Video.raw.gsr_adc_tonic = ... 
%           movmedian(data_struct{j,i}.BINDI.Video.raw.gsr_filtered,...
%           [Fs*window_gsr Fs*window_gsr]);
%       data_struct{j,i}.BINDI.Video.raw.gsr_adc_phasic = ...
%           data_struct{j,i}.BINDI.Video.raw.gsr_filtered - ...
%                  data_struct{j,i}.BINDI.Video.raw.gsr_adc_tonic;
             
      %Labels
      data_struct{j,i}.BINDI.Labels.raw.gsr_filtered = ...
          filtfilt(FIRs.Coeffs_GSR,1,data_struct{j,i}.BINDI.Labels.raw.gsr);
      data_struct{j,i}.BINDI.Labels.raw.gsr_uS_filtered =...
          -(1000000.*data_struct{j,i}.BINDI.Labels.raw.gsr_filtered)./...
          (data_struct{j,i}.BINDI.Labels.raw.gsr_filtered - 16383);
	  data_struct{j,i}.BINDI.Labels.raw.gsr_uS_filtered_dn = ...
          downsample(data_struct{j,i}.BINDI.Labels.raw.gsr_uS_filtered,downsample_gsr);
      data_struct{j,i}.BINDI.Labels.raw.gsr_uS_filtered_dn_sm = ...
          movmedian(movmean(data_struct{j,i}.BINDI.Labels.raw.gsr_uS_filtered_dn,...
                           (Fs/downsample_gsr)),(Fs/downsample_gsr)/2);
%       data_struct{j,i}.BINDI.Labels.raw.gsr_adc_tonic = ... 
%           movmedian(data_struct{j,i}.BINDI.Labels.raw.gsr_filtered,...
%           [Fs*window_gsr Fs*window_gsr]);
%       data_struct{j,i}.BINDI.Labels.raw.gsr_adc_phasic = ...
%           data_struct{j,i}.BINDI.Labels.raw.gsr_filtered - ...
%                  data_struct{j,i}.BINDI.Labels.raw.gsr_adc_tonic;
				 
      %Recovery
      if(length(data_struct{j,i}.BINDI.Recovery.raw.gsr)>(3*length(FIRs.Coeffs_GSR)))
        data_struct{j,i}.BINDI.Recovery.raw.gsr_filtered = ...
          filtfilt(FIRs.Coeffs_GSR,1,data_struct{j,i}.BINDI.Recovery.raw.gsr);
      elseif((length(data_struct{j,i}.BINDI.Recovery.raw.gsr)>(3*length(FIRs.Coeffs_GSR_smaller))))
        data_struct{j,i}.BINDI.Recovery.raw.gsr_filtered = ...
          filtfilt(FIRs.Coeffs_GSR_smaller,1,data_struct{j,i}.BINDI.Recovery.raw.gsr);
      else
        %Not filtering provided
        data_struct{j,i}.BINDI.Recovery.raw.gsr_filtered = smooth(data_struct{j,i}.BINDI.Recovery.raw.gsr,Fs/2);
      end
      data_struct{j,i}.BINDI.Recovery.raw.gsr_uS_filtered =...
          -(1000000.*data_struct{j,i}.BINDI.Recovery.raw.gsr_filtered)./...
          (data_struct{j,i}.BINDI.Recovery.raw.gsr_filtered - 16383);
	  data_struct{j,i}.BINDI.Recovery.raw.gsr_uS_filtered_dn = ...
          downsample(data_struct{j,i}.BINDI.Recovery.raw.gsr_uS_filtered,downsample_gsr);
      data_struct{j,i}.BINDI.Recovery.raw.gsr_uS_filtered_dn_sm = ...
          movmedian(movmean(data_struct{j,i}.BINDI.Recovery.raw.gsr_uS_filtered_dn,...
                           (Fs/downsample_gsr)),(Fs/downsample_gsr)/2);
%       data_struct{j,i}.BINDI.Recovery.raw.gsr_adc_tonic = ... 
%           movmedian(data_struct{j,i}.BINDI.Recovery.raw.gsr_filtered,[Fs*window_gsr Fs*window_gsr]);
%       data_struct{j,i}.BINDI.Recovery.raw.gsr_adc_phasic = ...
%           data_struct{j,i}.BINDI.Recovery.raw.gsr_filtered - ...
%                  data_struct{j,i}.BINDI.Recovery.raw.gsr_adc_tonic;
      
      %BVP 
      
      %Neutro
      data_struct{j,i}.BINDI.Neutro.raw.bvp_filt = ...
          filtfilt(FIRs.Coeffs_BVP,1,data_struct{j,i}.BINDI.Neutro.raw.bvp);
      data_struct{j,i}.BINDI.Neutro.raw.bvp_filt = ...
          data_struct{j,i}.BINDI.Neutro.raw.bvp_filt - ...
          BVP_removebaselinewander_signal(data_struct{j,i}.BINDI.Neutro.raw.bvp_filt,Fs);
      
      %Video
      data_struct{j,i}.BINDI.Video.raw.bvp_filt = ...
          filtfilt(FIRs.Coeffs_BVP,1,data_struct{j,i}.BINDI.Video.raw.bvp);
      data_struct{j,i}.BINDI.Video.raw.bvp_filt = ...
          data_struct{j,i}.BINDI.Video.raw.bvp_filt - ...
          BVP_removebaselinewander_signal(data_struct{j,i}.BINDI.Video.raw.bvp_filt,Fs);
      
      %Labels
      data_struct{j,i}.BINDI.Labels.raw.bvp_filt = ...
          filtfilt(FIRs.Coeffs_BVP,1,data_struct{j,i}.BINDI.Labels.raw.bvp);
      data_struct{j,i}.BINDI.Labels.raw.bvp_filt = ...
          data_struct{j,i}.BINDI.Labels.raw.bvp_filt - ...
          BVP_removebaselinewander_signal(data_struct{j,i}.BINDI.Labels.raw.bvp_filt,Fs);
      
      %Recovery
      data_struct{j,i}.BINDI.Recovery.raw.bvp = rmoutliers(data_struct{j,i}.BINDI.Recovery.raw.bvp);
      if(length(data_struct{j,i}.BINDI.Recovery.raw.bvp)>(3*length(FIRs.Coeffs_BVP)))
        data_struct{j,i}.BINDI.Recovery.raw.bvp_filt = ...
          filtfilt(FIRs.Coeffs_BVP,1,data_struct{j,i}.BINDI.Recovery.raw.bvp);
      elseif((length(data_struct{j,i}.BINDI.Recovery.raw.bvp)>(3*length(FIRs.Coeffs_BVP_smaller))))
        data_struct{j,i}.BINDI.Recovery.raw.bvp_filt = ...
          filtfilt(FIRs.Coeffs_BVP_smaller,1,data_struct{j,i}.BINDI.Recovery.raw.bvp);
      else
        %Not filtering provided
        data_struct{j,i}.BINDI.Recovery.raw.bvp_filt = smooth(data_struct{j,i}.BINDI.Recovery.raw.bvp,Fs/2);
      end
      
      data_struct{j,i}.BINDI.Recovery.raw.bvp_filt = ...
          data_struct{j,i}.BINDI.Recovery.raw.bvp_filt - ...
          BVP_removebaselinewander_signal(data_struct{j,i}.BINDI.Recovery.raw.bvp_filt,Fs); 
      
      %AGC second try
      iterations = 2;
      for k=1:iterations
      data_struct{j,i}.BINDI.Neutro.raw.bvp_filt = ...
          BVP_enhancePeaks_signal(data_struct{j,i}.BINDI.Neutro.raw.bvp_filt);
      data_struct{j,i}.BINDI.Video.raw.bvp_filt = ...
          BVP_enhancePeaks_signal(data_struct{j,i}.BINDI.Video.raw.bvp_filt);
      data_struct{j,i}.BINDI.Labels.raw.bvp_filt = ...
          BVP_enhancePeaks_signal(data_struct{j,i}.BINDI.Labels.raw.bvp_filt);
      data_struct{j,i}.BINDI.Recovery.raw.bvp_filt = ...
          BVP_enhancePeaks_signal(data_struct{j,i}.BINDI.Recovery.raw.bvp_filt);
      end
      
      %Apply adaptative filters with accelerometer data based on CPC Filter
      % This process is based on a Developed SQI based on the mean, mode
      % and median of the N samples within the W seconds
      % If the signal is clean, the distribution within a "small" temporal
      % window should be a normal distribution with the same values for the
      % mean, median and mode. Thus, '3' is the maximum value.
%       T = 3; %T seconds processing window
%       W = T*Fs;
%       %Neutro
%       ppgt = (data_struct{j,i}.BINDI.Neutro.raw.bvp_filt);
%       ppgt = round(max(abs(ppgt)) + ppgt,2);
%       len_ppg = length(ppgt);
%       start = 1;
%       stop  = W;
%       while stop<=len_ppg
%         %Check based on SQI form by Mode, Mean and Median
%         ppg = ppgt(start:stop);
%         sqi = mode(ppg)/mean(ppg) + median(ppg)/mode(ppg) + mean(ppg)/median(ppg);
%         if sqi<(0.8*3) || sqi>(1.2*3)
%           warning('Poor SQI: V%d VIDEO%d Neutro', j,i);
%           ppg = data_struct{j,i}.BINDI.Neutro.raw.bvp_filt(start:stop);
%           acc1=(data_struct{j,i}.EH.Neutro.raw.acc1_filt);
%           acc2=(data_struct{j,i}.EH.Neutro.raw.acc2_filt);
%           acc3=(data_struct{j,i}.EH.Neutro.raw.acc3_filt);
%           acc_v = [acc1 acc2 acc3]';
%           len_acc = length(acc1);
%           min_len = min([len_ppg len_acc]);
%           [clean_signal,~,~] = CPCFilter_v2(zscore(ppg(1:min_len)')',...
%         								zscore(acc_v(:,start:min_len)')',0);
%           clean_signal = round(max(abs(clean_signal)) + clean_signal);
%           sqi_new = mode(clean_signal)/mean(clean_signal) + ...
%         	  median(clean_signal)/mode(clean_signal) + ...
%         	  mean(clean_signal)/median(clean_signal);   
%         if sqi_new<(0.8*3) && sqi_new>(1.2*3) && abs(3-sqi)<abs(3-sqi_new)
%           data_struct{j,i}.BINDI.Neutro.raw.bvp_filt = (clean_signal);
%         end
%         end
%         %Update counters
%         start = stop;
%         stop  = stop + W;
%       end
%       
%       %Video
%       ppgt = (data_struct{j,i}.BINDI.Video.raw.bvp_filt);
%       ppgt = round(max(abs(ppgt)) + ppgt,2);
%       len_ppg = length(ppgt);
%       start = 1;
%       stop  = W;
%       while stop<=len_ppg
%         %Check based on SQI form by Mode, Mean and Median
%         ppg = ppgt(start:stop);
%         sqi = mode(ppg)/mean(ppg) + median(ppg)/mode(ppg) + mean(ppg)/median(ppg);
%         if sqi<(0.8*3) || sqi>(1.2*3)
%           warning('Poor SQI: V%d VIDEO%d Video', j,i);
%           ppg = data_struct{j,i}.BINDI.Video.raw.bvp_filt(start:stop);
%           acc1=(data_struct{j,i}.EH.Video.raw.acc1_filt);
%           acc2=(data_struct{j,i}.EH.Video.raw.acc2_filt);
%           acc3=(data_struct{j,i}.EH.Video.raw.acc3_filt);
%           acc_v = [acc1 acc2 acc3]';
%           len_acc = length(acc1);
%           min_len = min([len_ppg len_acc]);
%           [clean_signal,~,~] = CPCFilter_v2(zscore(ppg(1:min_len)')',...
%         								zscore(acc_v(:,start:min_len)')',0);
%           clean_signal = round(max(abs(clean_signal)) + clean_signal);
%           sqi_new = mode(clean_signal)/mean(clean_signal) + ...
%         	  median(clean_signal)/mode(clean_signal) + ...
%         	  mean(clean_signal)/median(clean_signal);   
%         if sqi_new<(0.8*3) && sqi_new>(1.2*3) && abs(3-sqi)<abs(3-sqi_new)
%           data_struct{j,i}.BINDI.Video.raw.bvp_filt = (clean_signal);
%         end
%         end
%         %Update counters
%         start = stop;
%         stop  = stop + W;
%       end
%       
%       %Labels
%       ppgt = (data_struct{j,i}.BINDI.Labels.raw.bvp_filt);
%       ppgt = round(max(abs(ppgt)) + ppgt,2);
%       len_ppg = length(ppgt);
%       start = 1;
%       stop  = len_ppg;
%       while stop<=len_ppg
%         %Check based on SQI form by Mode, Mean and Median
%         ppg = ppgt(start:stop);
%         sqi = mode(ppg)/mean(ppg) + median(ppg)/mode(ppg) + mean(ppg)/median(ppg);
%         if sqi<(0.8*3) || sqi>(1.2*3)
%           warning('Poor SQI: V%d VIDEO%d Labels', j,i);
%           ppg = data_struct{j,i}.BINDI.Labels.raw.bvp_filt(start:stop);
%           acc1=(data_struct{j,i}.EH.Labels.raw.acc1_filt);
%           acc2=(data_struct{j,i}.EH.Labels.raw.acc2_filt);
%           acc3=(data_struct{j,i}.EH.Labels.raw.acc3_filt);
%           acc_v = [acc1 acc2 acc3]';
%           len_acc = length(acc1);
%           min_len = min([len_ppg len_acc]);
%           [clean_signal,~,~] = CPCFilter_v2(zscore(ppg(1:min_len)')',...
%         								zscore(acc_v(:,start:min_len)')',0);
%           clean_signal = round(max(abs(clean_signal)) + clean_signal);
%           sqi_new = mode(clean_signal)/mean(clean_signal) + ...
%         	  median(clean_signal)/mode(clean_signal) + ...
%         	  mean(clean_signal)/median(clean_signal);   
%         if sqi_new>(0.8*3) || sqi_new<(1.2*3) %&& abs(3-sqi)<abs(3-sqi_new)
%           data_struct{j,i}.BINDI.Labels.raw.bvp_filt = (clean_signal);
%         end
%         end
%         %Update counters
%         start = stop;
%         stop  = stop + W;
%       end
%       
%       %Recovery
%       ppgt = (data_struct{j,i}.BINDI.Recovery.raw.bvp_filt);
%       ppgt = round(max(abs(ppgt)) + ppgt,2);
%       len_ppgt = length(ppgt);
%       start = 1;
%       stop  = len_ppgt;
%       temp = [];
%       while stop<=len_ppgt
%         %Check based on SQI form by Mode, Mean and Median
%         ppg = ppgt(start:stop);
%         sqi = mode(ppg)/mean(ppg) + median(ppg)/mode(ppg) + mean(ppg)/median(ppg);
%         %if sqi<(0.8*3) || sqi>(1.2*3)
%           warning('Poor SQI: V%d VIDEO%d Recovery', j,i);
%           ppg = data_struct{j,i}.BINDI.Recovery.raw.bvp_filt(start:stop);
%           len_ppg = length(ppg);
%           acc1=(data_struct{j,i}.EH.Recovery.raw.acc1_filt(start:stop));
%           acc2=(data_struct{j,i}.EH.Recovery.raw.acc2_filt(start:stop));
%           acc3=(data_struct{j,i}.EH.Recovery.raw.acc3_filt(start:stop));
%           acc_v = [acc1 acc2 acc3]';
%           len_acc = length(acc1);
%           min_len = min([len_ppg len_acc]);
%           [clean_signal,~,~] = CPCFilter_v2(zscore(ppg(1:min_len)')',...
%         								zscore(acc_v(:,1:min_len)')',0);
%           clean_signal = round(max(abs(clean_signal)) + clean_signal,2);
%           sqi_new = mode(clean_signal)/mean(clean_signal) + ...
%         	  median(clean_signal)/mode(clean_signal) + ...
%         	  mean(clean_signal)/median(clean_signal);   
%         if (sqi_new>(0.8*3) && sqi_new<(1.2*3)) %&& abs(3-sqi)<abs(3-sqi_new)
%           temp = [temp;(clean_signal)];
%         else
%           temp = [temp; zscore(ppg(1:min_len)')' ];
%         end
%         %end
%         %Update counters
%         start = stop;
%         stop  = stop + W;
%       end
%       data_struct{j,i}.BINDI.Recovery.raw.bvp_filt = temp;
%       
%       f = figure;
%       f.Name = "patient " + j +  " / Trial" + i;
%       subplot(4,1,1);
%       len_ppg = length(data_struct{j,i}.BINDI.Neutro.raw.bvp_filt);
%       t = linspace(0,len_ppg/Fs,len_ppg);
%       plot(t,data_struct{j,i}.BINDI.Neutro.raw.bvp_filt);
%       ylabel('a.u.')
%       title("patient " + j +  " / Trial" + i + " Neutro");
%       subplot(4,1,2);
%       len_ppg = length(data_struct{j,i}.BINDI.Video.raw.bvp_filt);
%       t = linspace(0,len_ppg/Fs,len_ppg);
%       plot(t,data_struct{j,i}.BINDI.Video.raw.bvp_filt);
%       ylabel('a.u.')
%       title("patient " + j +  " / Trial" + i + " Video");
%       subplot(4,1,3);
%       len_ppg = length(data_struct{j,i}.BINDI.Labels.raw.bvp_filt);
%       t = linspace(0,len_ppg/Fs,len_ppg);
%       plot(t,data_struct{j,i}.BINDI.Labels.raw.bvp_filt);
%       ylabel('a.u.')
%       title("patient " + j +  " / Trial" + i + " Labels");
%       subplot(4,1,4);
%       len_ppg = length(data_struct{j,i}.BINDI.Recovery.raw.bvp_filt);
%       t = linspace(0,len_ppg/Fs,len_ppg);
%       plot(t,data_struct{j,i}.BINDI.Recovery.raw.bvp_filt);
%       ylabel('a.u.')
%       title("patient " + j +  " / Trial" + i + " Recovery");
      
      %SKT adjust length
      %Neutro
%       data_struct{j,i}.BINDI.Neutro.raw.skt = downsample(,);
%       data_struct{j,i}.BINDI.Neutro.raw.skt2 = downsample(,);
      %Video
%       data_struct{j,i}.BINDI.Video.raw.skt = downsample(,);
%       data_struct{j,i}.BINDI.Video.raw.skt2 = downsample(,);
      %Labels
%       data_struct{j,i}.BINDI.Labels.raw.skt = downsample(,);
%       data_struct{j,i}.BINDI.Labels.raw.skt2 = downsample(,);
      %Recovery
%       data_struct{j,i}.BINDI.Recovery.raw.skt = downsample(,);
%       data_struct{j,i}.BINDI.Recovery.raw.skt2 = downsample(,);
      
      %Setting pre-processing Flag
      data_struct{j,i}.Filtered = 1;
    end
  end
  
  out = data_struct;
end

%Applying signal preprocessing on GSR signals
function out = empatia_preprocess_gsignals(data_struct)
[patients, videos] = size(data_struct);
  FIRs = load('FIRs.mat');
  for j = 1:patients
    for i = 1:videos
        
      %GSR - Fs 4Hz - filtering - 0-0.5Hz(tonic) 0.5-1.5Hz(phasic) Low Pass 16 Taps
	  % In this case the sensor units are Ohms directly, no conversion is needed
      %Neutro
      data_struct{j,i}.GSR.Neutro.raw.gsr_real_filt = ...
          filter(FIRs.Coeffs_GSR_AD,1,data_struct{j,i}.GSR.Neutro.raw.gsr_real);
      %data_struct{j,i}.GSR.Neutro.raw.gsr_real_filt = ...
      %                            data_struct{j,i}.GSR.Neutro.raw.gsr_real_filt(16:end);
	  data_struct{j,i}.GSR.Neutro.raw.gsr_real_filt(1:15) = [];%NaN;
      data_struct{j,i}.GSR.Neutro.raw.gsr_tonic = ... 
          movmedian(data_struct{j,i}.GSR.Neutro.raw.gsr_real_filt,[16 16]);
      data_struct{j,i}.GSR.Neutro.raw.gsr_phasic = ...
          data_struct{j,i}.GSR.Neutro.raw.gsr_real_filt - ...
                 data_struct{j,i}.GSR.Neutro.raw.gsr_tonic;
				 
      data_struct{j,i}.GSR.Neutro.raw.gsr_real_filt_s = 1./data_struct{j,i}.GSR.Neutro.raw.gsr_real;
      data_struct{j,i}.GSR.Neutro.raw.gsr_real_filt_s = ...
          filter(FIRs.Coeffs_GSR_AD,1,data_struct{j,i}.GSR.Neutro.raw.gsr_real_filt_s);
      data_struct{j,i}.GSR.Neutro.raw.gsr_real_filt_s(1:15) = [];%NaN;
      data_struct{j,i}.GSR.Neutro.raw.gsr_tonic_s = ... 
          movmedian(data_struct{j,i}.GSR.Neutro.raw.gsr_real_filt_s,[16 16]);
      data_struct{j,i}.GSR.Neutro.raw.gsr_phasic_s = ...
          data_struct{j,i}.GSR.Neutro.raw.gsr_real_filt_s - ...
                 data_struct{j,i}.GSR.Neutro.raw.gsr_tonic_s;
				 
      %Video
      data_struct{j,i}.GSR.Video.raw.gsr_real_filt = ...
          filter(FIRs.Coeffs_GSR_AD,1,data_struct{j,i}.GSR.Video.raw.gsr_real);
      %data_struct{j,i}.GSR.Video.raw.gsr_real_filt = ...
      %                            data_struct{j,i}.GSR.Video.raw.gsr_real_filt(16:end);
	  data_struct{j,i}.GSR.Video.raw.gsr_real_filt(1:15) = [];%NaN;
      data_struct{j,i}.GSR.Video.raw.gsr_tonic = ... 
          movmedian(data_struct{j,i}.GSR.Video.raw.gsr_real_filt,[16 16]);
      data_struct{j,i}.GSR.Video.raw.gsr_phasic = ...
          data_struct{j,i}.GSR.Video.raw.gsr_real_filt - ...
                 data_struct{j,i}.GSR.Video.raw.gsr_tonic;
				 
      data_struct{j,i}.GSR.Video.raw.gsr_real_filt_s = 1./data_struct{j,i}.GSR.Video.raw.gsr_real;
      data_struct{j,i}.GSR.Video.raw.gsr_real_filt_s = ...
          filter(FIRs.Coeffs_GSR_AD,1,data_struct{j,i}.GSR.Video.raw.gsr_real_filt_s);
      data_struct{j,i}.GSR.Video.raw.gsr_real_filt_s(1:15) = [];%NaN;
      data_struct{j,i}.GSR.Video.raw.gsr_tonic_s = ... 
          movmedian(data_struct{j,i}.GSR.Video.raw.gsr_real_filt_s,[16 16]);
      data_struct{j,i}.GSR.Video.raw.gsr_phasic_s = ...
          data_struct{j,i}.GSR.Video.raw.gsr_real_filt_s - ...
                 data_struct{j,i}.GSR.Video.raw.gsr_tonic_s;
				 
      %Labels
      data_struct{j,i}.GSR.Labels.raw.gsr_real_filt = ...
          filter(FIRs.Coeffs_GSR_AD,1,data_struct{j,i}.GSR.Labels.raw.gsr_real);
      %data_struct{j,i}.GSR.Labels.raw.gsr_real_filt = ...
      %                            data_struct{j,i}.GSR.Labels.raw.gsr_real_filt(16:end);
	  data_struct{j,i}.GSR.Labels.raw.gsr_real_filt(1:15) = [];%NaN;
      data_struct{j,i}.GSR.Labels.raw.gsr_tonic = ... 
          movmedian(data_struct{j,i}.GSR.Labels.raw.gsr_real_filt,[16 16]);
      data_struct{j,i}.GSR.Labels.raw.gsr_phasic = ...
          data_struct{j,i}.GSR.Labels.raw.gsr_real_filt - ...
                 data_struct{j,i}.GSR.Labels.raw.gsr_tonic;
				 
      data_struct{j,i}.GSR.Labels.raw.gsr_real_filt_s = 1./data_struct{j,i}.GSR.Labels.raw.gsr_real;
      data_struct{j,i}.GSR.Labels.raw.gsr_real_filt_s = ...
          filter(FIRs.Coeffs_GSR_AD,1,data_struct{j,i}.GSR.Labels.raw.gsr_real_filt_s);
      data_struct{j,i}.GSR.Labels.raw.gsr_real_filt_s(1:15) = [];%NaN;
      data_struct{j,i}.GSR.Labels.raw.gsr_tonic_s = ... 
          movmedian(data_struct{j,i}.GSR.Labels.raw.gsr_real_filt_s,[16 16]);
      data_struct{j,i}.GSR.Labels.raw.gsr_phasic_s = ...
          data_struct{j,i}.GSR.Labels.raw.gsr_real_filt_s - ...
                 data_struct{j,i}.GSR.Labels.raw.gsr_tonic_s;
				 
      %Recovery
      data_struct{j,i}.GSR.Recovery.raw.gsr_real_filt = ...
          filter(FIRs.Coeffs_GSR_AD,1,data_struct{j,i}.GSR.Recovery.raw.gsr_real);
      %data_struct{j,i}.GSR.Recovery.raw.gsr_real_filt = ...
      %                            data_struct{j,i}.GSR.Recovery.raw.gsr_real_filt(16:end);
	  data_struct{j,i}.GSR.Recovery.raw.gsr_real_filt(1:15) = [];%NaN;
      data_struct{j,i}.GSR.Recovery.raw.gsr_tonic = ... 
          movmedian(data_struct{j,i}.GSR.Recovery.raw.gsr_real_filt,[16 16]);
      data_struct{j,i}.GSR.Recovery.raw.gsr_phasic = ...
          data_struct{j,i}.GSR.Recovery.raw.gsr_real_filt - ...
                 data_struct{j,i}.GSR.Recovery.raw.gsr_tonic;
				 
      data_struct{j,i}.GSR.Recovery.raw.gsr_real_filt_s = 1./data_struct{j,i}.GSR.Recovery.raw.gsr_real;
      data_struct{j,i}.GSR.Recovery.raw.gsr_real_filt_s = ...
          filter(FIRs.Coeffs_GSR_AD,1,data_struct{j,i}.GSR.Recovery.raw.gsr_real_filt_s);
      data_struct{j,i}.GSR.Recovery.raw.gsr_real_filt_s(1:15) = [];%NaN;
      data_struct{j,i}.GSR.Recovery.raw.gsr_tonic_s = ... 
          movmedian(data_struct{j,i}.GSR.Recovery.raw.gsr_real_filt_s,[16 16]);
      data_struct{j,i}.GSR.Recovery.raw.gsr_phasic_s = ...
          data_struct{j,i}.GSR.Recovery.raw.gsr_real_filt_s - ...
                 data_struct{j,i}.GSR.Recovery.raw.gsr_tonic_s;
				 				 
      %Setting pre-processing Flag
      data_struct{j,i}.Filtered = 1;
    end
  end
  
  out = data_struct;
end

%Applying signal preprocessing on New GSR signals
function out = empatia_preprocess_gsignalsNew(data_struct)
  %Get patients and videos number
  [patients, videos] = size(data_struct);
  %Load filter coeffs
  FIRs = load('FIRs.mat');
  %Set sampling frequency and processing window
  Fs = 200;
  window_gsr     = 4;
  downsample_gsr = 20; % Fs' = 200/20 = 10Hz
  for j = 1:patients
    for i = 1:videos-1
        
      %Neutro
      data_struct{j,i}.GSR.Neutro.raw.gsr_uS_filtered = ...
          filtfilt(FIRs.Coeffs_GSR,1,data_struct{j,i}.GSR.Neutro.raw.gsr_uS);
	  data_struct{j,i}.GSR.Neutro.raw.gsr_uS_filtered_dn = ...
          downsample(data_struct{j,i}.GSR.Neutro.raw.gsr_uS_filtered,downsample_gsr);
      data_struct{j,i}.GSR.Neutro.raw.gsr_uS_filtered_dn_sm = ...
          movmedian(movmean(data_struct{j,i}.GSR.Neutro.raw.gsr_uS_filtered_dn,...
                           (Fs/downsample_gsr)),(Fs/downsample_gsr)/2);
%       data_struct{j,i}.GSR.Neutro.raw.gsr_uS_filtered_tonic = ... 
%           movmedian(data_struct{j,i}.GSR.Neutro.raw.gsr_uS_filtered,[Fs*window_gsr Fs*window_gsr]);
%       data_struct{j,i}.GSR.Neutro.raw.gsr_uS_filtered_phasic = ...
%           data_struct{j,i}.GSR.Neutro.raw.gsr_uS_filtered - ...
%                  data_struct{j,i}.GSR.Neutro.raw.gsr_uS_filtered_tonic;
%       data_struct{j,i}.GSR.Neutro.raw.gsr_uS_filtered_tonic_dn = ... 
%           movmedian(data_struct{j,i}.GSR.Neutro.raw.gsr_uS_filtered_dn,... 
%           [Fs*window_gsr/downsample_gsr Fs*window_gsr/downsample_gsr]);
%       data_struct{j,i}.GSR.Neutro.raw.gsr_uS_filtered_phasic_dn = ...
%           data_struct{j,i}.GSR.Neutro.raw.gsr_uS_filtered_dn - ...
%                  data_struct{j,i}.GSR.Neutro.raw.gsr_uS_filtered_tonic_dn;
				 
      %Video
      data_struct{j,i}.GSR.Video.raw.gsr_uS_filtered = ...
          filtfilt(FIRs.Coeffs_GSR,1,data_struct{j,i}.GSR.Video.raw.gsr_uS);
	  data_struct{j,i}.GSR.Video.raw.gsr_uS_filtered_dn = ...
          downsample(data_struct{j,i}.GSR.Video.raw.gsr_uS_filtered,downsample_gsr);
	  data_struct{j,i}.GSR.Video.raw.gsr_uS_filtered_dn_sm = ...
          movmedian(movmean(data_struct{j,i}.GSR.Video.raw.gsr_uS_filtered_dn,...
                            (Fs/downsample_gsr)),(Fs/downsample_gsr)/2);
%       data_struct{j,i}.GSR.Video.raw.gsr_uS_filtered_tonic = ... 
%           movmedian(data_struct{j,i}.GSR.Video.raw.gsr_uS_filtered,[Fs*window_gsr Fs*window_gsr]);
%       data_struct{j,i}.GSR.Video.raw.gsr_uS_filtered_phasic = ...
%           data_struct{j,i}.GSR.Video.raw.gsr_uS_filtered - ...
%                  data_struct{j,i}.GSR.Video.raw.gsr_uS_filtered_tonic;
%       data_struct{j,i}.GSR.Video.raw.gsr_uS_filtered_tonic_dn = ... 
%           movmedian(data_struct{j,i}.GSR.Video.raw.gsr_uS_filtered_dn,...
%           [Fs*window_gsr/downsample_gsr Fs*window_gsr/downsample_gsr]);
%       data_struct{j,i}.GSR.Video.raw.gsr_uS_filtered_phasic_dn = ...
%           data_struct{j,i}.GSR.Video.raw.gsr_uS_filtered_dn - ...
%                  data_struct{j,i}.GSR.Video.raw.gsr_uS_filtered_tonic_dn;
				 
      %Labels
      data_struct{j,i}.GSR.Labels.raw.gsr_uS_filtered = ...
          filtfilt(FIRs.Coeffs_GSR,1,data_struct{j,i}.GSR.Labels.raw.gsr_uS);
	  data_struct{j,i}.GSR.Labels.raw.gsr_uS_filtered_dn = ...
          downsample(data_struct{j,i}.GSR.Labels.raw.gsr_uS_filtered,downsample_gsr);
      data_struct{j,i}.GSR.Labels.raw.gsr_uS_filtered_dn_sm = ...
          movmedian(movmean(data_struct{j,i}.GSR.Labels.raw.gsr_uS_filtered_dn,...
                           (Fs/downsample_gsr)),(Fs/downsample_gsr)/2);
%       data_struct{j,i}.GSR.Labels.raw.gsr_uS_filtered_tonic = ... 
%           movmedian(data_struct{j,i}.GSR.Labels.raw.gsr_uS_filtered,[Fs*window_gsr Fs*window_gsr]);
%       data_struct{j,i}.GSR.Labels.raw.gsr_uS_filtered_phasic = ...
%           data_struct{j,i}.GSR.Labels.raw.gsr_uS_filtered - ...
%                  data_struct{j,i}.GSR.Labels.raw.gsr_uS_filtered_tonic;
%       data_struct{j,i}.GSR.Labels.raw.gsr_uS_filtered_tonic_dn = ... 
%           movmedian(data_struct{j,i}.GSR.Labels.raw.gsr_uS_filtered_dn,...
%           [Fs*window_gsr/downsample_gsr Fs*window_gsr/downsample_gsr]);
%       data_struct{j,i}.GSR.Labels.raw.gsr_uS_filtered_phasic_dn = ...
%           data_struct{j,i}.GSR.Labels.raw.gsr_uS_filtered_dn - ...
%                  data_struct{j,i}.GSR.Labels.raw.gsr_uS_filtered_tonic_dn;
				 
      %Recovery
      if(length(data_struct{j,i}.GSR.Recovery.raw.gsr_uS)>(3*length(FIRs.Coeffs_GSR)))
      data_struct{j,i}.GSR.Recovery.raw.gsr_uS_filtered = ...
          filtfilt(FIRs.Coeffs_GSR,1,data_struct{j,i}.GSR.Recovery.raw.gsr_uS);
      elseif(length(data_struct{j,i}.GSR.Recovery.raw.gsr_uS)>(3*length(FIRs.Coeffs_GSR_smaller)))
      data_struct{j,i}.GSR.Recovery.raw.gsr_uS_filtered = ...
          filtfilt(FIRs.Coeffs_GSR_smaller,1,data_struct{j,i}.GSR.Recovery.raw.gsr_uS);
      else
        %Not filtering provided
      end      
	  data_struct{j,i}.GSR.Recovery.raw.gsr_uS_filtered_dn = ...
          downsample(data_struct{j,i}.GSR.Recovery.raw.gsr_uS_filtered,downsample_gsr);
      data_struct{j,i}.GSR.Recovery.raw.gsr_uS_filtered_dn_sm = ...
          movmedian(movmean(data_struct{j,i}.GSR.Recovery.raw.gsr_uS_filtered_dn,...
                           (Fs/downsample_gsr)),(Fs/downsample_gsr)/2);
%       data_struct{j,i}.GSR.Recovery.raw.gsr_uS_filtered_tonic = ... 
%           movmedian(data_struct{j,i}.GSR.Recovery.raw.gsr_uS_filtered,[Fs*window_gsr Fs*window_gsr]);
%       data_struct{j,i}.GSR.Recovery.raw.gsr_uS_filtered_phasic = ...
%           data_struct{j,i}.GSR.Recovery.raw.gsr_uS_filtered - ...
%                  data_struct{j,i}.GSR.Recovery.raw.gsr_uS_filtered_tonic;
%       data_struct{j,i}.GSR.Recovery.raw.gsr_uS_filtered_tonic_dn = ... 
%           movmedian(data_struct{j,i}.GSR.Recovery.raw.gsr_uS_filtered_dn,...
%           [Fs*window_gsr/downsample_gsr Fs*window_gsr/downsample_gsr]);
%       data_struct{j,i}.GSR.Recovery.raw.gsr_uS_filtered_phasic_dn = ...
%           data_struct{j,i}.GSR.Recovery.raw.gsr_uS_filtered_dn - ...
%                  data_struct{j,i}.GSR.Recovery.raw.gsr_uS_filtered_tonic_dn;
				  
      %Setting pre-processing Flag
      data_struct{j,i}.Filtered = 1;
    end
  end
  
  out = data_struct;
end

%Applying signal preprocessing on EH signals
function out = empatia_preprocess_esignals(data_struct)
  %Get patients and videos number
  [patients, videos] = size(data_struct);
  %Load filter coeffs
  FIRs = load('FIRs.mat');
  %Set sampling frequency and processing window
  Fs = 200;
  window_gsr     = 4;
  downsample_gsr = 20; % Fs' = 200/20 = 10Hz
  for j = 1:patients
    for i = 1:videos-1
      fprintf('Patient %d, Video %d filtering...\n',j, i);
      %Neutro
%       data_struct{j,i}.EH.Neutro.raw.gsr_uS_filtered = ...
%           filtfilt(FIRs.Coeffs_GSR,1,data_struct{j,i}.EH.Neutro.raw.gsr);
% 	  data_struct{j,i}.EH.Neutro.raw.gsr_uS_filtered_dn = ...
%           downsample(data_struct{j,i}.EH.Neutro.raw.gsr_uS_filtered,downsample_gsr);
%       data_struct{j,i}.EH.Neutro.raw.gsr_uS_filtered_dn_sm = ...
%           movmedian(movmean(data_struct{j,i}.EH.Neutro.raw.gsr_uS_filtered_dn,...
%                            (Fs/downsample_gsr)),(Fs/downsample_gsr)/2);
%       data_struct{j,i}.EH.Neutro.raw.gsr_uS_filtered_tonic = ... 
%           movmedian(data_struct{j,i}.EH.Neutro.raw.gsr_uS_filtered,[Fs*window_gsr Fs*window_gsr]);
%       data_struct{j,i}.EH.Neutro.raw.gsr_uS_filtered_phasic = ...
%           data_struct{j,i}.EH.Neutro.raw.gsr_uS_filtered - ...
%                  data_struct{j,i}.EH.Neutro.raw.gsr_uS_filtered_tonic;
%       data_struct{j,i}.EH.Neutro.raw.gsr_uS_filtered_tonic_dn = ... 
%           movmedian(data_struct{j,i}.EH.Neutro.raw.gsr_uS_filtered_dn,... 
%           [Fs*window_gsr/downsample_gsr Fs*window_gsr/downsample_gsr]);
%       data_struct{j,i}.EH.Neutro.raw.gsr_uS_filtered_phasic_dn = ...
%           data_struct{j,i}.EH.Neutro.raw.gsr_uS_filtered_dn - ...
%                  data_struct{j,i}.EH.Neutro.raw.gsr_uS_filtered_tonic_dn;
				 
      %Video
      data_struct{j,i}.EH.Video.raw.gsr_uS_filtered = ...
          filtfilt(FIRs.Coeffs_GSR,1,data_struct{j,i}.EH.Video.raw.gsr);
	  data_struct{j,i}.EH.Video.raw.gsr_uS_filtered_dn = ...
          downsample(data_struct{j,i}.EH.Video.raw.gsr_uS_filtered,downsample_gsr);
      data_struct{j,i}.EH.Video.raw.gsr_uS_filtered_dn_sm = ...
          movmedian(movmean(data_struct{j,i}.EH.Video.raw.gsr_uS_filtered_dn,...
                           (Fs/downsample_gsr)),(Fs/downsample_gsr)/2);
%       data_struct{j,i}.EH.Video.raw.gsr_uS_filtered_tonic = ... 
%           movmedian(data_struct{j,i}.EH.Video.raw.gsr_uS_filtered,[Fs*window_gsr Fs*window_gsr]);
%       data_struct{j,i}.EH.Video.raw.gsr_uS_filtered_phasic = ...
%           data_struct{j,i}.EH.Video.raw.gsr_uS_filtered - ...
%                  data_struct{j,i}.EH.Video.raw.gsr_uS_filtered_tonic;
%       data_struct{j,i}.EH.Video.raw.gsr_uS_filtered_tonic_dn = ... 
%           movmedian(data_struct{j,i}.EH.Video.raw.gsr_uS_filtered_dn,...
%           [Fs*window_gsr/downsample_gsr Fs*window_gsr/downsample_gsr]);
%       data_struct{j,i}.EH.Video.raw.gsr_uS_filtered_phasic_dn = ...
%           data_struct{j,i}.EH.Video.raw.gsr_uS_filtered_dn - ...
%                  data_struct{j,i}.EH.Video.raw.gsr_uS_filtered_tonic_dn;
				 
      %Labels
      data_struct{j,i}.EH.Labels.raw.gsr_uS_filtered = ...
          filtfilt(FIRs.Coeffs_GSR,1,data_struct{j,i}.EH.Labels.raw.gsr);
	  data_struct{j,i}.EH.Labels.raw.gsr_uS_filtered_dn = ...
          downsample(data_struct{j,i}.EH.Labels.raw.gsr_uS_filtered,downsample_gsr);
      data_struct{j,i}.EH.Labels.raw.gsr_uS_filtered_dn_sm = ...
          movmedian(movmean(data_struct{j,i}.EH.Labels.raw.gsr_uS_filtered_dn,...
                           (Fs/downsample_gsr)),(Fs/downsample_gsr)/2);      
%       data_struct{j,i}.EH.Labels.raw.gsr_uS_filtered_tonic = ... 
%           movmedian(data_struct{j,i}.EH.Labels.raw.gsr_uS_filtered,[Fs*window_gsr Fs*window_gsr]);
%       data_struct{j,i}.EH.Labels.raw.gsr_uS_filtered_phasic = ...
%           data_struct{j,i}.EH.Labels.raw.gsr_uS_filtered - ...
%                  data_struct{j,i}.EH.Labels.raw.gsr_uS_filtered_tonic;
%       data_struct{j,i}.EH.Labels.raw.gsr_uS_filtered_tonic_dn = ... 
%           movmedian(data_struct{j,i}.EH.Labels.raw.gsr_uS_filtered_dn,...
%           [Fs*window_gsr/downsample_gsr Fs*window_gsr/downsample_gsr]);
%       data_struct{j,i}.EH.Labels.raw.gsr_uS_filtered_phasic_dn = ...
%           data_struct{j,i}.EH.Labels.raw.gsr_uS_filtered_dn - ...
%                  data_struct{j,i}.EH.Labels.raw.gsr_uS_filtered_tonic_dn;
				 
      %Recovery
      if(length(data_struct{j,i}.EH.Recovery.raw.gsr)>(3*length(FIRs.Coeffs_GSR)))
      data_struct{j,i}.EH.Recovery.raw.gsr_uS_filtered = ...
          filtfilt(FIRs.Coeffs_GSR,1,data_struct{j,i}.EH.Recovery.raw.gsr);
      elseif(length(data_struct{j,i}.EH.Recovery.raw.gsr)>(3*length(FIRs.Coeffs_GSR_smaller)))
      data_struct{j,i}.EH.Recovery.raw.gsr_uS_filtered = ...
          filtfilt(FIRs.Coeffs_GSR_smaller,1,data_struct{j,i}.EH.Recovery.raw.gsr);
      else
        %Not filtering provided
      end   
	  data_struct{j,i}.EH.Recovery.raw.gsr_uS_filtered_dn = ...
          downsample(data_struct{j,i}.EH.Recovery.raw.gsr_uS_filtered,downsample_gsr);
      data_struct{j,i}.EH.Recovery.raw.gsr_uS_filtered_dn_sm = ...
          movmedian(movmean(data_struct{j,i}.EH.Recovery.raw.gsr_uS_filtered_dn,...
                           (Fs/downsample_gsr)),(Fs/downsample_gsr)/2); 
                       
%       data_struct{j,i}.EH.Recovery.raw.gsr_uS_filtered_tonic = ... 
%           movmedian(data_struct{j,i}.EH.Recovery.raw.gsr_uS_filtered,[Fs*window_gsr Fs*window_gsr]);
%       data_struct{j,i}.EH.Recovery.raw.gsr_uS_filtered_phasic = ...
%           data_struct{j,i}.EH.Recovery.raw.gsr_uS_filtered - ...
%                  data_struct{j,i}.EH.Recovery.raw.gsr_uS_filtered_tonic;
%       data_struct{j,i}.EH.Recovery.raw.gsr_uS_filtered_tonic_dn = ... 
%           movmedian(data_struct{j,i}.EH.Recovery.raw.gsr_uS_filtered_dn,...
%           [Fs*window_gsr/downsample_gsr Fs*window_gsr/downsample_gsr]);
%       data_struct{j,i}.EH.Recovery.raw.gsr_uS_filtered_phasic_dn = ...
%           data_struct{j,i}.EH.Recovery.raw.gsr_uS_filtered_dn - ...
%                  data_struct{j,i}.EH.Recovery.raw.gsr_uS_filtered_tonic_dn;
				  
      %BVP 
      
%       %Neutro
%       [data_struct{j,i}.EH.Neutro.raw.hr,data_struct{j,i}.EH.Neutro.raw.bvp_filt] = ...
%           getHeartRate_eh(data_struct{j,i}.EH.Neutro.raw.bvp,0);
%       data_struct{j,i}.EH.Neutro.raw.hrv = diff(data_struct{j,i}.EH.Neutro.raw.hr);
%       %Video
%       [data_struct{j,i}.EH.Video.raw.hr,data_struct{j,i}.EH.Video.raw.bvp_filt] = ...
%           getHeartRate_eh(data_struct{j,i}.EH.Video.raw.bvp,0);
%       data_struct{j,i}.EH.Video.raw.hrv = diff(data_struct{j,i}.EH.Video.raw.hr);
%       %Labels
%       [data_struct{j,i}.EH.Labels.raw.hr,data_struct{j,i}.EH.Labels.raw.bvp_filt] = ...
%           getHeartRate_eh(data_struct{j,i}.EH.Labels.raw.bvp,0);
%       data_struct{j,i}.EH.Labels.raw.hrv = diff(data_struct{j,i}.EH.Labels.raw.hr);
%       %Recovery
%       [data_struct{j,i}.EH.Recovery.raw.hr,data_struct{j,i}.EH.Recovery.raw.bvp_filt] = ...
%           getHeartRate_eh(data_struct{j,i}.EH.Recovery.raw.bvp,1);
%       data_struct{j,i}.EH.Recovery.raw.hrv = diff(data_struct{j,i}.EH.Recovery.raw.hr);
      
%       data_struct{j,i}.EH.Neutro.raw.bvp_filt = ...
%           filtfilt(FIRs.Coeffs_BVP,1,data_struct{j,i}.EH.Neutro.raw.bvp);
%       data_struct{j,i}.EH.Neutro.raw.bvp_filt = ...
%           data_struct{j,i}.EH.Neutro.raw.bvp_filt - ...
%           BVP_removebaselinewander_signal(data_struct{j,i}.EH.Neutro.raw.bvp_filt,Fs);
      data_struct{j,i}.EH.Video.raw.bvp_filt = ...
          filtfilt(FIRs.Coeffs_BVP,1,data_struct{j,i}.EH.Video.raw.bvp);
      data_struct{j,i}.EH.Video.raw.bvp_filt = ...
          data_struct{j,i}.EH.Video.raw.bvp_filt - ...
          BVP_removebaselinewander_signal(data_struct{j,i}.EH.Video.raw.bvp_filt,Fs);
      data_struct{j,i}.EH.Labels.raw.bvp_filt = ...
          filtfilt(FIRs.Coeffs_BVP,1,data_struct{j,i}.EH.Labels.raw.bvp);
      data_struct{j,i}.EH.Labels.raw.bvp_filt = ...
          data_struct{j,i}.EH.Labels.raw.bvp_filt - ...
          BVP_removebaselinewander_signal(data_struct{j,i}.EH.Labels.raw.bvp_filt,Fs);
      
      if(length(data_struct{j,i}.EH.Recovery.raw.bvp)>(3*length(FIRs.Coeffs_BVP)))
        data_struct{j,i}.EH.Recovery.raw.bvp_filt = ...
          filtfilt(FIRs.Coeffs_BVP,1,data_struct{j,i}.EH.Recovery.raw.bvp);
      elseif((length(data_struct{j,i}.EH.Recovery.raw.bvp)>(3*length(FIRs.Coeffs_BVP_smaller))))
        data_struct{j,i}.EH.Recovery.raw.bvp_filt = ...
          filtfilt(FIRs.Coeffs_BVP_smaller,1,data_struct{j,i}.EH.Recovery.raw.bvp);
      else
        %Not filtering provided
        data_struct{j,i}.EH.Recovery.raw.bvp_filt = smooth(data_struct{j,i}.EH.Recovery.raw.bvp,Fs/2);
      end
      
      data_struct{j,i}.EH.Recovery.raw.bvp_filt = ...
          data_struct{j,i}.EH.Recovery.raw.bvp_filt - ...
          BVP_removebaselinewander_signal(data_struct{j,i}.EH.Recovery.raw.bvp_filt,Fs); 
        
        %AGC
%       iterations = 2;
%       for k=1:iterations
%       data_struct{j,i}.EH.Neutro.raw.bvp = ...
%           BVP_enhancePeaks_signal(data_struct{j,i}.EH.Neutro.raw.bvp);
%       data_struct{j,i}.EH.Video.raw.bvp = ...
%           BVP_enhancePeaks_signal(data_struct{j,i}.EH.Video.raw.bvp);
%       data_struct{j,i}.EH.Labels.raw.bvp = ...
%           BVP_enhancePeaks_signal(data_struct{j,i}.EH.Labels.raw.bvp);
%       data_struct{j,i}.EH.Recovery.raw.bvp = ...
%           BVP_enhancePeaks_signal(data_struct{j,i}.EH.Recovery.raw.bvp);
%       end

      %ACC 
%       data_struct{j,i}.EH.Neutro.raw.acc1_filt = ...
%           filtfilt(FIRs.Coeffs_BVP,1,data_struct{j,i}.EH.Neutro.raw.acc1);
%       data_struct{j,i}.EH.Neutro.raw.acc1_filt = ...
%           data_struct{j,i}.EH.Neutro.raw.acc1_filt - ...
%           BVP_removebaselinewander_signal(data_struct{j,i}.EH.Neutro.raw.acc1_filt,Fs);
%       data_struct{j,i}.EH.Neutro.raw.acc2_filt = ...
%           filtfilt(FIRs.Coeffs_BVP,1,data_struct{j,i}.EH.Neutro.raw.acc2);
%       data_struct{j,i}.EH.Neutro.raw.acc2_filt = ...
%           data_struct{j,i}.EH.Neutro.raw.acc2_filt - ...
%           BVP_removebaselinewander_signal(data_struct{j,i}.EH.Neutro.raw.acc2_filt,Fs);
%       data_struct{j,i}.EH.Neutro.raw.acc3_filt = ...
%           filtfilt(FIRs.Coeffs_BVP,1,data_struct{j,i}.EH.Neutro.raw.acc3);
%       data_struct{j,i}.EH.Neutro.raw.acc3_filt = ...
%           data_struct{j,i}.EH.Neutro.raw.acc3_filt - ...
%           BVP_removebaselinewander_signal(data_struct{j,i}.EH.Neutro.raw.acc3_filt,Fs);
%       
%       
%       data_struct{j,i}.EH.Video.raw.acc1_filt = ...
%           filtfilt(FIRs.Coeffs_BVP,1,data_struct{j,i}.EH.Video.raw.acc1);
%       data_struct{j,i}.EH.Video.raw.acc1_filt = ...
%           data_struct{j,i}.EH.Video.raw.acc1_filt - ...
%           BVP_removebaselinewander_signal(data_struct{j,i}.EH.Video.raw.acc1_filt,Fs);
%       data_struct{j,i}.EH.Video.raw.acc2_filt = ...
%           filtfilt(FIRs.Coeffs_BVP,1,data_struct{j,i}.EH.Video.raw.acc2);
%       data_struct{j,i}.EH.Video.raw.acc2_filt = ...
%           data_struct{j,i}.EH.Video.raw.acc2_filt - ...
%           BVP_removebaselinewander_signal(data_struct{j,i}.EH.Video.raw.acc2_filt,Fs);
%       data_struct{j,i}.EH.Video.raw.acc3_filt = ...
%           filtfilt(FIRs.Coeffs_BVP,1,data_struct{j,i}.EH.Video.raw.acc3);
%       data_struct{j,i}.EH.Video.raw.acc3_filt = ...
%           data_struct{j,i}.EH.Video.raw.acc3_filt - ...
%           BVP_removebaselinewander_signal(data_struct{j,i}.EH.Video.raw.acc3_filt,Fs);
%       
% 
%        data_struct{j,i}.EH.Labels.raw.acc1_filt = ...
%           filtfilt(FIRs.Coeffs_BVP,1,data_struct{j,i}.EH.Labels.raw.acc1);
%       data_struct{j,i}.EH.Labels.raw.acc1_filt = ...
%           data_struct{j,i}.EH.Labels.raw.acc1_filt - ...
%           BVP_removebaselinewander_signal(data_struct{j,i}.EH.Labels.raw.acc1_filt,Fs);
%       data_struct{j,i}.EH.Labels.raw.acc2_filt = ...
%           filtfilt(FIRs.Coeffs_BVP,1,data_struct{j,i}.EH.Labels.raw.acc2);
%       data_struct{j,i}.EH.Labels.raw.acc2_filt = ...
%           data_struct{j,i}.EH.Labels.raw.acc2_filt - ...
%           BVP_removebaselinewander_signal(data_struct{j,i}.EH.Labels.raw.acc2_filt,Fs);
%       data_struct{j,i}.EH.Labels.raw.acc3_filt = ...
%           filtfilt(FIRs.Coeffs_BVP,1,data_struct{j,i}.EH.Labels.raw.acc3);
%       data_struct{j,i}.EH.Labels.raw.acc3_filt = ...
%           data_struct{j,i}.EH.Labels.raw.acc3_filt - ...
%           BVP_removebaselinewander_signal(data_struct{j,i}.EH.Labels.raw.acc3_filt,Fs);     
%       
%       
%       if(length(data_struct{j,i}.EH.Recovery.raw.acc1)>(3*length(FIRs.Coeffs_BVP)))
%         data_struct{j,i}.EH.Recovery.raw.acc1_filt = ...
%           filtfilt(FIRs.Coeffs_BVP,1,data_struct{j,i}.EH.Recovery.raw.acc1);
%         data_struct{j,i}.EH.Recovery.raw.acc2_filt = ...
%           filtfilt(FIRs.Coeffs_BVP,1,data_struct{j,i}.EH.Recovery.raw.acc2);
%         data_struct{j,i}.EH.Recovery.raw.acc3_filt = ...
%           filtfilt(FIRs.Coeffs_BVP,1,data_struct{j,i}.EH.Recovery.raw.acc3);
%       elseif((length(data_struct{j,i}.EH.Recovery.raw.bvp)>(3*length(FIRs.Coeffs_BVP_smaller))))
%         data_struct{j,i}.EH.Recovery.raw.acc1_filt = ...
%           filtfilt(FIRs.Coeffs_BVP_smaller,1,data_struct{j,i}.EH.Recovery.raw.acc1);
%         data_struct{j,i}.EH.Recovery.raw.acc2_filt = ...
%           filtfilt(FIRs.Coeffs_BVP_smaller,1,data_struct{j,i}.EH.Recovery.raw.acc2);
%         data_struct{j,i}.EH.Recovery.raw.acc3_filt = ...
%           filtfilt(FIRs.Coeffs_BVP_smaller,1,data_struct{j,i}.EH.Recovery.raw.acc3);
%       else
%         %Not filtering provided
%         data_struct{j,i}.EH.Recovery.raw.acc1_filt = smooth(data_struct{j,i}.EH.Recovery.raw.acc1,Fs/2);
%         data_struct{j,i}.EH.Recovery.raw.acc2_filt = smooth(data_struct{j,i}.EH.Recovery.raw.acc2,Fs/2);
%         data_struct{j,i}.EH.Recovery.raw.acc3_filt = smooth(data_struct{j,i}.EH.Recovery.raw.acc3,Fs/2);
%       end
%       
%       data_struct{j,i}.EH.Recovery.raw.acc1_filt = ...
%           data_struct{j,i}.EH.Recovery.raw.acc1_filt - ...
%           BVP_removebaselinewander_signal(data_struct{j,i}.EH.Recovery.raw.acc1_filt,Fs);
%       data_struct{j,i}.EH.Recovery.raw.acc2_filt = ...
%           data_struct{j,i}.EH.Recovery.raw.acc2_filt - ...
%           BVP_removebaselinewander_signal(data_struct{j,i}.EH.Recovery.raw.acc2_filt,Fs);
%       data_struct{j,i}.EH.Recovery.raw.acc3_filt = ...
%           data_struct{j,i}.EH.Recovery.raw.acc3_filt - ...
%           BVP_removebaselinewander_signal(data_struct{j,i}.EH.Recovery.raw.acc3_filt,Fs);
      
      %SKT 
      %%Neutro
%       data_struct{j,i}.EH.Neutro.raw.skt_filt = filtfilt(FIRs.Coeffs_GSR,1,data_struct{j,i}.EH.Neutro.raw.skt);
%       data_struct{j,i}.EH.Neutro.raw.skt_filt_dn = ...
%           downsample(data_struct{j,i}.EH.Neutro.raw.skt_filt,downsample_gsr);
%       data_struct{j,i}.EH.Neutro.raw.skt_filt_dn_sm = ...
%           movmedian(movmean(data_struct{j,i}.EH.Neutro.raw.skt_filt_dn,...
%                            (Fs/downsample_gsr)),(Fs/downsample_gsr)/2); 
      %%Video
      data_struct{j,i}.EH.Video.raw.skt_filt = filtfilt(FIRs.Coeffs_GSR,1,data_struct{j,i}.EH.Video.raw.skt);
      data_struct{j,i}.EH.Video.raw.skt_filt_dn = ...
          downsample(data_struct{j,i}.EH.Video.raw.skt_filt,downsample_gsr);
      data_struct{j,i}.EH.Video.raw.skt_filt_dn_sm = ...
          movmedian(movmean(data_struct{j,i}.EH.Video.raw.skt_filt_dn,...
                           (Fs/downsample_gsr)),(Fs/downsample_gsr)/2); 
      %%Labels
      data_struct{j,i}.EH.Labels.raw.skt_filt = filtfilt(FIRs.Coeffs_GSR,1,data_struct{j,i}.EH.Labels.raw.skt);
      data_struct{j,i}.EH.Labels.raw.skt_filt_dn = ...
          downsample(data_struct{j,i}.EH.Labels.raw.skt_filt,downsample_gsr);
      data_struct{j,i}.EH.Labels.raw.skt_filt_dn_sm = ...
          movmedian(movmean(data_struct{j,i}.EH.Labels.raw.skt_filt_dn,...
                           (Fs/downsample_gsr)),(Fs/downsample_gsr)/2); 
      %%Recovery
      data_struct{j,i}.EH.Recovery.raw.skt_filt = filtfilt(FIRs.Coeffs_GSR,1,data_struct{j,i}.EH.Recovery.raw.skt);
      data_struct{j,i}.EH.Recovery.raw.skt_filt_dn = ...
          downsample(data_struct{j,i}.EH.Recovery.raw.skt_filt,downsample_gsr);
      
      %EMG adjust length
      %%Neutro
%       data_struct{j,i}.EH.Neutro.raw.emg_filt = filtfilt(FIRs.Coeffs_GSR,1,data_struct{j,i}.EH.Neutro.raw.emg);
%       data_struct{j,i}.EH.Neutro.raw.emg_filt_dn = ...
%           downsample(data_struct{j,i}.EH.Neutro.raw.emg_filt,downsample_gsr);
%       %%Video
%       data_struct{j,i}.EH.Video.raw.emg_filt = filtfilt(FIRs.Coeffs_GSR,1,data_struct{j,i}.EH.Video.raw.emg);
%       data_struct{j,i}.EH.Video.raw.emg_filt_dn = ...
%           downsample(data_struct{j,i}.EH.Video.raw.emg_filt,downsample_gsr);
%       %%Labels
%       data_struct{j,i}.EH.Labels.raw.emg_filt = filtfilt(FIRs.Coeffs_GSR,1,data_struct{j,i}.EH.Labels.raw.emg);
%       data_struct{j,i}.EH.Labels.raw.emg_filt_dn = ...
%           downsample(data_struct{j,i}.EH.Labels.raw.emg_filt,downsample_gsr);
      %%Recovery
%       data_struct{j,i}.EH.Recovery.raw.emg_filt = filtfilt(FIRs.Coeffs_GSR,1,data_struct{j,i}.EH.Recovery.raw.emg);
%       data_struct{j,i}.EH.Recovery.raw.emg_filt_dn = ...
%           downsample(data_struct{j,i}.EH.Recovery.raw.emg_filt,downsample_gsr);
      
%       
%       f = figure;
%       set(gcf, 'Units', 'Normalized', 'OuterPosition', [0 0 1 1]);
%       f.Name = "patient " + j +  " / Trial" + i;
%       subplot(3,1,1);
% %       len_ppg = length(data_struct{j,i}.EH.Neutro.raw.bvp_filt);
% %       t = linspace(0,len_ppg/Fs,len_ppg);
% %       plot(t,data_struct{j,i}.EH.Neutro.raw.bvp_filt);
% %       ylabel('a.u.')
% %       title("patient " + j +  " / Trial" + i + " Neutro");
% %       subplot(4,1,2);
%       len_ppg = length(data_struct{j,i}.EH.Video.raw.bvp_filt);
%       t = linspace(0,len_ppg/Fs,len_ppg);
%       plot(t,data_struct{j,i}.EH.Video.raw.bvp_filt);
%       ylabel('a.u.')
%       title("patient " + j +  " / Trial" + i + " Video");
% %       subplot(4,1,3);
% %       len_ppg = length(data_struct{j,i}.EH.Labels.raw.bvp_filt);
% %       t = linspace(0,len_ppg/Fs,len_ppg);
% %       plot(t,data_struct{j,i}.EH.Labels.raw.bvp_filt);
% %       ylabel('a.u.')
% %       title("patient " + j +  " / Trial" + i + " Labels");
% %       subplot(4,1,4);
% %       len_ppg = length(data_struct{j,i}.EH.Recovery.raw.bvp_filt);
% %       t = linspace(0,len_ppg/Fs,len_ppg);
% %       plot(t,data_struct{j,i}.EH.Recovery.raw.bvp_filt);
% %       ylabel('a.u.')
% %       title("patient " + j +  " / Trial" + i + " Recovery");
%       
% %       f = figure;
% %       f.Name = "GSR patient " + j +  " / Trial" + i;
% %       subplot(4,1,1);
% %       len_ppg = length(data_struct{j,i}.EH.Neutro.raw.gsr_uS_filtered);
% %       t = linspace(0,len_ppg/Fs,len_ppg);
% %       plot(t,data_struct{j,i}.EH.Neutro.raw.gsr_uS_filtered);
% %       ylabel('uSiemens.')
% %       title("patient " + j +  " / Trial" + i + " Neutro");
%       subplot(3,1,2);
%       len_ppg = length(data_struct{j,i}.EH.Video.raw.gsr_uS_filtered);
%       t = linspace(0,len_ppg/Fs,len_ppg);
%       plot(downsample(t,downsample_gsr),data_struct{j,i}.EH.Video.raw.gsr_uS_filtered_dn);
%       ylabel('uSiemens')
%       title("patient " + j +  " / Trial" + i + " Video");
% %       subplot(4,1,3);
% %       len_ppg = length(data_struct{j,i}.EH.Labels.raw.gsr_uS_filtered);
% %       t = linspace(0,len_ppg/Fs,len_ppg);
% %       plot(t,data_struct{j,i}.EH.Labels.raw.gsr_uS_filtered);
% %       ylabel('uSiemens')
% %       title("patient " + j +  " / Trial" + i + " Labels");
% %       subplot(4,1,4);
% %       len_ppg = length(data_struct{j,i}.EH.Recovery.raw.gsr_uS_filtered);
% %       t = linspace(0,len_ppg/Fs,len_ppg);
% %       plot(t,data_struct{j,i}.EH.Recovery.raw.gsr_uS_filtered);
% %       ylabel('uSiemens')
% %       title("patient " + j +  " / Trial" + i + " Recovery");
%       
%       
% %       f = figure;
% %       f.Name = "SKT patient " + j +  " / Trial" + i;
% %       subplot(4,1,1);
% %       len_ppg = length(data_struct{j,i}.EH.Neutro.raw.skt);
% %       t = linspace(0,len_ppg/Fs,len_ppg);
% %       plot(t,data_struct{j,i}.EH.Neutro.raw.skt);
% %       ylabel('ºC')
% %       title("patient " + j +  " / Trial" + i + " Neutro");
%       subplot(3,1,3);
%       len_ppg = length(data_struct{j,i}.EH.Video.raw.skt_filt);
%       t = linspace(0,len_ppg/Fs,len_ppg);
%       plot(downsample(t,downsample_gsr),data_struct{j,i}.EH.Video.raw.skt_filt_dn);
%       ylabel('ºC')
%       title("patient " + j +  " / Trial" + i + " Video");
% %       subplot(4,1,3);
% %       len_ppg = length(data_struct{j,i}.EH.Labels.raw.skt);
% %       t = linspace(0,len_ppg/Fs,len_ppg);
% %       plot(t,data_struct{j,i}.EH.Labels.raw.skt);
% %       ylabel('ºC')
% %       title("patient " + j +  " / Trial" + i + " Labels");
% %       subplot(4,1,4);
% %       len_ppg = length(data_struct{j,i}.EH.Recovery.raw.skt);
% %       t = linspace(0,len_ppg/Fs,len_ppg);
% %       plot(t,data_struct{j,i}.EH.Recovery.raw.skt);
% %       ylabel('ºC')
% %       title("patient " + j +  " / Trial" + i + " Recovery");

      %Setting pre-processing Flag
      data_struct{j,i}.Filtered = 1;
    end
  end
  
  out = data_struct;
end

%% UTILs FUNCTIONS
%Autocorrelation function
function signal_corr  = autocorrelation(signal)
 R = zeros(1,length(signal));
 Z = size(signal, 2);
 for k=1:Z
   for j=1:length(signal)
     temp=0;
     for n=1:length(signal)
         if((n-j)>0)
         temp=temp + signal(n)*signal(n-j);
         end
     end
     R(j)=temp;
   end
   signal_corr(:,k)=R';
 end
end

%CPC Filter using NLMS and RLS Adaptative filters
function [ clean_signal, c1, c2 ] = CPCFilter_v2(signal,acc_data,plotg)
  %CPC --> y[n] = lambda * y1[n] + (1 ? lambda)y2[n]
  %        y1[n] comes from NLMS and y2[n] comes from RLS adaptative
  %        filters
  %acc signal must contain the three acc signals
  [rows,~] = size(acc_data);
  if rows ~= 3
      error('You do not have three ACC signals, X, Y, Z');
  end
  
  %Iterations
  origSignal = signal;
  cpcIterations = 1;
  
  for k=1:cpcIterations
      
    %First Cascade with NLMS
    temp = signal;
    for i = 1:rows
      x = acc_data(i,:);
      d = temp;
      N = 64;
      mu = 0.005;
      alpha = 0.999;
      it = 1;
      [~,e] = nlms1(x,d,N,mu,alpha,it);
      temp = e;
    end
    clean_signal_c1 = temp;
  
    %Second Cascade with RLS
    temp = signal;
    for i=1:rows
      x = acc_data(i,:);
      d = temp;
      N = 74;
      delta = 1;
      lambda = 0.999;
      it = 1;
      [~,e] = rls1(x,d,N,delta,lambda,it);
      temp = e;
    end
    clean_signal_c2 = temp;
  
    % Add based on CPC and Lambda y[n] = lambda * y1[n] + (1 ? lambda)y2[n];
    lambda = 0.5;
    clean_signal = lambda .*  clean_signal_c1 + (1 - lambda).*clean_signal_c2;
    c1 = clean_signal_c1;
    c2 = clean_signal_c2;
    % Calculate SNR improvement
%     SNRi_c1    = 10*log10(var(signal)/var(c1));
%     disp([num2str(SNRi_c1) 'dB SNR Improvement'])
%     SNRi_c2    = 10*log10(var(signal)/var(c2));
%     disp([num2str(SNRi_c2) 'dB SNR Improvement'])
%     SNRi_ct    = 10*log10(var(signal)/var(clean_signal));
%     disp([num2str(SNRi_ct) 'dB SNR Improvement'])
%     snr = [SNRi_c1 SNRi_c2 SNRi_ct];
%     [~, c] = max(snr);
%     cleans = [c1 c2 clean_signal];
%     clean_signal = cleans(:,c);
    clean_signal = max(abs(clean_signal)) + clean_signal;
    %AGC 
    iterations = 1;
    for j=1:iterations
      clean_signal = ...
      BVP_enhancePeaks_signal(clean_signal);
    end
    clean_signal = zscore(clean_signal);
  end
  
  if plotg 
    figure;
    plot(origSignal);
    hold on;
    plot(clean_signal);
    title('Result of CPC Filter')
    xlabel('Samples');
    legend('Reference', 'Filtered', 'Location', 'NorthEast');
    title('Comparison of Filtered Signal to Reference Input');
  end  
end

function [W,e] = nlms1(x,d,N,mu,alpha,I,Wini,Xini)
%x-reference input, here the reference to noise, 'n1'
%d-desired or primary input, here the signal plus noise, 's+no'
%N-no. of taps i.e., filter length or order
%mu-step-size or convergence parameter usually 
%(i) 0<mu<1/lambdam where lambdam is the largest diagonal value of eignvalue matrix of autocorrelation matrix of x or 
%(ii) 0<mu<(1/N*Sxm) where Sxm-maximum of PSD of x or
%(iii) 0<mu<(1/N*Px),where Px-signal power of x or approximately 
%(iv) 0<mu<1;
%lower the mu value, better the noise removal but slower the speed of
%convergence and VICE VERSA. Try changing dynamically mu according to (i)
%or (ii) or (iii) for every iteration. Add a small positive value < 0.1 to
%denominator of (ii) and (iii) in order to avoid division-by-zero in case of zero signal power
%alpha-small positive real value approximately 0<alpha<1, closer to unity
%I-no. of iterations
%Wini-initial weight vector
%Xini-initial state vector i.e., initial values of reference input
%W-final weight vector
%e-error signal e=d-W*x, this is the signal recovered
%Example code: load('ecg.mat'); [W,e]=nlms2(ol,x,d,N,mu,alpha,Wini,Xini)
%Please refer to (1) Adaptive Filter Theory by Simon Haykin (2) PDF file
%attached to this and (3) Adaptive Signal Processing by Widrow and Stearns.
Lx = length(x);
[m,n] = size(x);
if (n>m)
   x = x.';
end
if (~exist('I'))
    itr = 1;
else
    itr = I;
end
if (~exist('Wini'))
   W = zeros(N,1);
else
   if (length(Wini)~=N)
      error('Weight initialization does not match filter length');
   end
   W = Wini;
end
if (~exist('Xini'))
   x = [zeros(N-1,1); x];
else
   if (length(Xini)~=(N-1))
      error('State initialization does not match filter length minus one');
   end
   x = [Xini; x];
end
for i = 1:itr
    for k = 1:Lx
       X = x(k+N-1:-1:k);
       y = W'*X;
       e(k,1) = d(k,1) - y;
       p = alpha + X'*X;
       W = W + ((2*mu*e(k,1))/p)*X;
    end
end
end

function [W,e]=rls1(x,d,N,delta,lambda,I,Wini,Pini,Xini)
%ol-original signal, 's'
%x-reference input, here the reference to noise, 'n1'
%d-desired or primary input, here the signal plus noise, 's+no'
%N-no. of taps i.e., filter length or order
%delta-inverse of estimated signal power, typically, 0<delta<1
%lambda-small positive real value approximately 0<lambda<1, closer to unity
%Wini-initial weight vector
%Xini-initial state vector i.e., initial values of reference input
%W-final weight vector
%e-error signal e=d-W*x, this is the signal recovered
%Example code: load('ecg.mat'); [W,e]=rls1(ecg,no,ecgn,4,0.1,0.9);
if (~exist('I','var')||isempty(I))
   itr = 1;
else
   itr = I;
end
if (~exist('Wini','var')||isempty(Wini))
   W = zeros(N,1);
else
   if (length(Wini)~=N)
      error('Weight initialization must match filter length');
   end
   W = Wini;
end
if (~exist('Pini','var')||isempty(Pini))
   P = diag((ones(N,1)/delta));
else
   if ((size(Pini,1)~=N) || (size(Pini,2)~=N))
      error('Initial inverse must me square NxN');
   end
   P = Pini; 
end
		
Lx = length(x);
[m,n] = size(x);
if (n>m)
   x = x.';
end
if (~exist('Xini','var')||isempty(Xini))
   x = [zeros(N-1,1); x];
else
   if (length(Xini)~=(N-1))
      error('State initialization must match filter length minus one');
   end
   x = [Xini; x];
end
for j=1:itr
    for i = 2:Lx
       X = x(i+N-1:-1:i); %reference noise
       Pi = P*X;                     %1
       k = Pi/(lambda + X'*Pi);      %2
       y(i,1) = W'*X;                %3
       e(i,1) = d(i,1) - y(i,1);     %4
       W = W + k*e(i,1);             %5
       P = (P - (k*(X')*P))/lambda;  %6
    end
end
end

%Enhance peaks BVP - Automatic Gain Controller
function Signal = BVP_enhancePeaks_signal(raw) 
  
  %Init values
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
  
  Signal = raw;
end

%Mapfun function - traslation from C
function output = mapfun(value,fromLow,fromHigh,toLow,toHigh)
  narginchk(5,5)
  nargoutchk(0,1)
  output = (value - fromLow) .* (toHigh - toLow) ./ (fromHigh - fromLow) + toLow;
end

%Remove baseline wander with fast-forward IIR
function Signal = BVP_removebaselinewander_signal(raw,fs) 
  
%   %Get iir notch parameters
%   w0 = 0.005;
%   Q   = 0.05;
%   w0 = 2*w0/fs;
%   
%   %Checks if w0 is within the range
%   if w0 > 1 || w0 < 0
%     warning("w0 should be such that 0 < w0 < 1");
%   end
%     
%   %Get bandwidth
%   bw = w0/Q;
%   
%   %Normalize inputs
%   bw = bw*pi;
%   w0 = w0*pi;
%    
%  %Compute -3dB atenuation
%  gb = 1/sqrt(2);
%    
%  %Compute beta
%  beta = (sqrt(1-gb^2)/gb)*tan(bw/2.0);
%   
%   %Compute gain
%   gain = 1/(1+beta);
%  
%   %Compute numerator b and denominator a
%   b = gain*([1, -2*cos(w0), 1]);
%   a = ([1, -2*gain*cos(w0), (2*gain-1.0)]);

  Wc = (2*0.5)/fs; 
  [b,a] = butter(3,Wc);
  %view magnitude response
  %fvtool(B,A,'Fs',200)
   
  %Filter the signal
  raw = filtfilt(b,a,raw);
%   raw = abs(raw);
  raw = max(abs(raw)) + raw;
%   raw = fliplr( raw );
%   raw = filtfilt(b,a,raw);
%   raw = fliplr( raw );
  
  Signal = raw;
  
end    

%Plotting BVP-features related correlations
function empatia_preprocess_bvpCorrelation(data_struct)
AAEHR = [];
AEPHR = [];
%data = struct([]);
 
[patients, videos] = size(data_struct);

  for j = 1:patients
    for i = 1:videos
        AAEHR(j,i) = abs((mean(data_struct{j,i}.BINDI.Video.raw.hr)-mean(data_struct{j,i}.EH.Video.raw.hr)));
        AEPHR(j,i) =(abs((mean(data_struct{j,i}.BINDI.Video.raw.hr)-mean(data_struct{j,i}.EH.Video.raw.hr)))/mean(data_struct{j,i}.EH.Video.raw.hr))*100;
    end
   %AAE & AEP Study
   f = figure;
   f.Name = "patient " + j +  " AAE & AEP study Video" + i;
   subplot(2,1,1);
   plot(AAEHR(j,:));
   ylabel('AAE (BPM)')
   title("AAE BINDI vs EH(golden)");
   subplot(2,1,2);
   plot(AEPHR(j,:));
   ylabel('AEP(%BPM)')
   title("AEP BINDI vs EH(golden)");
  end

end

%% GRAPHICAL PLOTs FUNCTIONS
%Acquire all data in one array for three sensors: gsr, bvp, skt
function out_s = empatia_plot_allrawGsr(data_struct, splot_all, splot_video)

out = struct([]);
%data = struct([]);
 
[patients, videos] = size(data_struct);

  for j = 1:patients

    out{j,1}.BINDI.bvp = [];
      
    out{j,1}.GSR.gsr=[];
    out{j,1}.GSR.recon=[];
    out{j,1}.EH.gsr =[];
	
    data.BINDI.bvp = [];
    data.GSR.gsr=[];
    data.GSR.recon=[];
    data.EH.gsr =[];
	
    for i = 1:videos-1
        
      %BINDI process
      out{j,1}.BINDI.bvp = [out{j,1}.BINDI.bvp
               data_struct{j,i}.BINDI.Neutro.raw.bvp_filt
               data_struct{j,i}.BINDI.Video.raw.bvp_filt
               data_struct{j,i}.BINDI.Labels.raw.bvp_filt
               data_struct{j,i}.BINDI.Recovery.raw.bvp_filt];
      data.BINDI.bvp=[data_struct{j,i}.BINDI.Neutro.raw.bvp_filt
               data_struct{j,i}.BINDI.Video.raw.bvp_filt
               data_struct{j,i}.BINDI.Labels.raw.bvp_filt
               data_struct{j,i}.BINDI.Recovery.raw.bvp_filt];   
           
      %GSR process
      out{j,1}.GSR.gsr = [out{j,1}.GSR.gsr
               data_struct{j,i}.GSR.Neutro.raw.gsr_uS_filtered_dn
               data_struct{j,i}.GSR.Video.raw.gsr_uS_filtered_dn
               data_struct{j,i}.GSR.Labels.raw.gsr_uS_filtered_dn
               data_struct{j,i}.GSR.Recovery.raw.gsr_uS_filtered_dn];
      data.GSR.gsr=[data_struct{j,i}.GSR.Neutro.raw.gsr_uS_filtered_dn
               data_struct{j,i}.GSR.Video.raw.gsr_uS_filtered_dn
               data_struct{j,i}.GSR.Labels.raw.gsr_uS_filtered_dn
               data_struct{j,i}.GSR.Recovery.raw.gsr_uS_filtered_dn];
      out{j,1}.GSR.recon = [out{j,1}.GSR.recon
               data_struct{j,i}.GSR.Neutro.raw.recon
               data_struct{j,i}.GSR.Video.raw.recon
               data_struct{j,i}.GSR.Labels.raw.recon
               data_struct{j,i}.GSR.Recovery.raw.recon];
      data.GSR.recon=[data_struct{j,i}.GSR.Neutro.raw.recon
               data_struct{j,i}.GSR.Video.raw.recon
               data_struct{j,i}.GSR.Labels.raw.recon
               data_struct{j,i}.GSR.Recovery.raw.recon];
           
      %EH process
      out{j,1}.EH.gsr = [out{j,1}.EH.gsr 
               data_struct{j,i}.EH.Neutro.raw.gsr_uS_filtered_dn
               data_struct{j,i}.EH.Video.raw.gsr_uS_filtered_dn
               data_struct{j,i}.EH.Labels.raw.gsr_uS_filtered_dn
               data_struct{j,i}.EH.Recovery.raw.gsr_uS_filtered_dn];
      data.EH.gsr =[data_struct{j,i}.EH.Neutro.raw.gsr_uS_filtered_dn
               data_struct{j,i}.EH.Video.raw.gsr_uS_filtered_dn
               data_struct{j,i}.EH.Labels.raw.gsr_uS_filtered_dn
               data_struct{j,i}.EH.Recovery.raw.gsr_uS_filtered_dn];
			   
      %If plot has been selected, perform subplot display
      if splot_video==1
        
        %GSR Study
        f = figure;
        f.Name = "patient " + j +  " GSR Siemens study Video" + i;

        %GSR      
        plot(data.GSR.gsr);
        %EH
        hold on;
        plot(data.EH.gsr);
        ylabel('uSiemens')
        title("GSR VIDEO");
        
        %recon
%         plot(data.GSR.recon);
        
        %BVP Study
        f2 = figure;
        f2.Name = "patient " + j +  " BVP study Video" + i;
        
        %BINDI
        plot(data.BINDI.bvp);
        
      end
    end
    
    %If plot has been selected, perform subplot display
    if splot_all==1

        %GSR Study
        f = figure;
        f.Name = "patient " + j +  " GSR study Siemems ALL";
        %GSR
        plot(out{j,1}.GSR.gsr);
        %EH
        hold on;
        plot(out{j,1}.EH.gsr);
        ylabel('uSiemes')
        title("GSR ALL");
        
        %recon
%         plot(out{j,1}.GSR.recon);
        
        %BVP Study
        f2 = figure;
        f2.Name = "patient " + j +  " BVP study Video ALL";
        
        %BINDI
        plot(out{j,1}.BINDI.bvp);
        
    end
  end
  
  out_s = [data_struct, out];

end

function out_s = empatia_preprocess_allraw(data_struct, splot_all, splot_video)

out = struct([]);
%data = struct([]);
 
[patients, videos] = size(data_struct);

  for j = 1:patients
      
    out{j,1}.BINDI.gsr =[];
    out{j,1}.BINDI.gsr_phasic =[];
    out{j,1}.BINDI.gsr_tonic =[];
    out{j,1}.BINDI.gsr_s =[];
    out{j,1}.BINDI.gsr_phasic_s =[];
    out{j,1}.BINDI.gsr_tonic_s =[];
    out{j,1}.BINDI.bvp=[];
    out{j,1}.BINDI.skt=[];
    out{j,1}.BINDI.skt2=[];
    out{j,1}.BINDI.hr=[];
    out{j,1}.BINDI.hrv=[];
    out{j,1}.GSR.gsr=[];
    out{j,1}.GSR.gsr_phasic=[];
    out{j,1}.GSR.gsr_tonic=[];
    out{j,1}.GSR.gsr_s =[];
    out{j,1}.GSR.gsr_phasic_s =[];
    out{j,1}.GSR.gsr_tonic_s =[];
    out{j,1}.EH.gsr =[];
    out{j,1}.EH.gsr_phasic =[];
    out{j,1}.EH.gsr_tonic =[];
    out{j,1}.EH.gsr_s =[];
    out{j,1}.EH.gsr_phasic_s =[];
    out{j,1}.EH.gsr_tonic_s =[];
    out{j,1}.EH.bvp=[];
    out{j,1}.EH.skt=[];
    out{j,1}.EH.hr=[];
    out{j,1}.EH.hrv=[];
	
	data.BINDI.gsr =[];
    data.BINDI.gsr_phasic =[];
    data.BINDI.gsr_tonic =[];
    data.BINDI.gsr_s =[];
    data.BINDI.gsr_phasic_s =[];
    data.BINDI.gsr_tonic_s =[];
    data.BINDI.bvp=[];
    data.BINDI.skt=[];
    data.BINDI.skt2=[];
    data.BINDI.hr=[];
    data.BINDI.hrv=[];
    data.GSR.gsr=[];
    data.GSR.gsr_phasic=[];
    data.GSR.gsr_tonic=[];
    data.GSR.gsr_s =[];
    data.GSR.gsr_phasic_s =[];
    data.GSR.gsr_tonic_s =[];
    data.EH.gsr =[];
    data.EH.gsr_phasic =[];
    data.EH.gsr_tonic =[];
    data.EH.gsr_s =[];
    data.EH.gsr_phasic_s =[];
    data.EH.gsr_tonic_s =[];
    data.EH.bvp=[];
    data.EH.skt=[];
    data.EH.hr=[];
    data.EH.hrv=[];
	
    for i = 1:videos
        
      %BINDI process
      out{j,1}.BINDI.gsr = [out{j,1}.BINDI.gsr
               data_struct{j,i}.BINDI.Neutro.raw.gsr_adc
               data_struct{j,i}.BINDI.Video.raw.gsr_adc
               data_struct{j,i}.BINDI.Labels.raw.gsr_adc
               data_struct{j,i}.BINDI.Recovery.raw.gsr_adc];
      data.BINDI.gsr =[data_struct{j,i}.BINDI.Neutro.raw.gsr_adc
               data_struct{j,i}.BINDI.Video.raw.gsr_adc
               data_struct{j,i}.BINDI.Labels.raw.gsr_adc
               data_struct{j,i}.BINDI.Recovery.raw.gsr_adc];
      out{j,1}.BINDI.gsr_phasic =[ out{j,1}.BINDI.gsr_phasic
               data_struct{j,i}.BINDI.Neutro.raw.gsr_adc_phasic
               data_struct{j,i}.BINDI.Video.raw.gsr_adc_phasic
               data_struct{j,i}.BINDI.Labels.raw.gsr_adc_phasic
               data_struct{j,i}.BINDI.Recovery.raw.gsr_adc_phasic];
      data.BINDI.gsr_phasic =[data_struct{j,i}.BINDI.Neutro.raw.gsr_adc_phasic
               data_struct{j,i}.BINDI.Video.raw.gsr_adc_phasic
               data_struct{j,i}.BINDI.Labels.raw.gsr_adc_phasic
               data_struct{j,i}.BINDI.Recovery.raw.gsr_adc_phasic];
      out{j,1}.BINDI.gsr_tonic =[ out{j,1}.BINDI.gsr_tonic
               data_struct{j,i}.BINDI.Neutro.raw.gsr_adc_tonic
               data_struct{j,i}.BINDI.Video.raw.gsr_adc_tonic
               data_struct{j,i}.BINDI.Labels.raw.gsr_adc_tonic
               data_struct{j,i}.BINDI.Recovery.raw.gsr_adc_tonic];
      data.BINDI.gsr_tonic =[data_struct{j,i}.BINDI.Neutro.raw.gsr_adc_tonic
               data_struct{j,i}.BINDI.Video.raw.gsr_adc_tonic
               data_struct{j,i}.BINDI.Labels.raw.gsr_adc_tonic
               data_struct{j,i}.BINDI.Recovery.raw.gsr_adc_tonic];
      out{j,1}.BINDI.gsr_s = [out{j,1}.BINDI.gsr_s
               data_struct{j,i}.BINDI.Neutro.raw.gsr_adc_inv
               data_struct{j,i}.BINDI.Video.raw.gsr_adc_inv
               data_struct{j,i}.BINDI.Labels.raw.gsr_adc_inv
               data_struct{j,i}.BINDI.Recovery.raw.gsr_adc_inv];
      data.BINDI.gsr_s =[data_struct{j,i}.BINDI.Neutro.raw.gsr_adc_inv
               data_struct{j,i}.BINDI.Video.raw.gsr_adc_inv
               data_struct{j,i}.BINDI.Labels.raw.gsr_adc_inv
               data_struct{j,i}.BINDI.Recovery.raw.gsr_adc_inv];
      out{j,1}.BINDI.gsr_phasic_s =[ out{j,1}.BINDI.gsr_phasic_s
               data_struct{j,i}.BINDI.Neutro.raw.gsr_adc_phasic_inv
               data_struct{j,i}.BINDI.Video.raw.gsr_adc_phasic_inv
               data_struct{j,i}.BINDI.Labels.raw.gsr_adc_phasic_inv
               data_struct{j,i}.BINDI.Recovery.raw.gsr_adc_phasic_inv];
      data.BINDI.gsr_phasic_s =[data_struct{j,i}.BINDI.Neutro.raw.gsr_adc_phasic_inv
               data_struct{j,i}.BINDI.Video.raw.gsr_adc_phasic_inv
               data_struct{j,i}.BINDI.Labels.raw.gsr_adc_phasic_inv
               data_struct{j,i}.BINDI.Recovery.raw.gsr_adc_phasic_inv];
      out{j,1}.BINDI.gsr_tonic_s =[ out{j,1}.BINDI.gsr_tonic_s
               data_struct{j,i}.BINDI.Neutro.raw.gsr_adc_tonic_inv
               data_struct{j,i}.BINDI.Video.raw.gsr_adc_tonic_inv
               data_struct{j,i}.BINDI.Labels.raw.gsr_adc_tonic_inv
               data_struct{j,i}.BINDI.Recovery.raw.gsr_adc_tonic_inv];
      data.BINDI.gsr_tonic_s = [data_struct{j,i}.BINDI.Neutro.raw.gsr_adc_tonic_inv
               data_struct{j,i}.BINDI.Video.raw.gsr_adc_tonic_inv
               data_struct{j,i}.BINDI.Labels.raw.gsr_adc_tonic_inv
               data_struct{j,i}.BINDI.Recovery.raw.gsr_adc_tonic_inv];
      out{j,1}.BINDI.bvp = [out{j,1}.BINDI.bvp
               data_struct{j,i}.BINDI.Neutro.raw.bvp_filt
               data_struct{j,i}.BINDI.Video.raw.bvp_filt
               data_struct{j,i}.BINDI.Labels.raw.bvp_filt
               data_struct{j,i}.BINDI.Recovery.raw.bvp_filt];
	  data.BINDI.bvp=[data_struct{j,i}.BINDI.Neutro.raw.bvp_filt
               data_struct{j,i}.BINDI.Video.raw.bvp_filt
               data_struct{j,i}.BINDI.Labels.raw.bvp_filt
               data_struct{j,i}.BINDI.Recovery.raw.bvp_filt];
      out{j,1}.BINDI.skt = [out{j,1}.BINDI.skt
               data_struct{j,i}.BINDI.Neutro.raw.skt
               data_struct{j,i}.BINDI.Video.raw.skt
               data_struct{j,i}.BINDI.Labels.raw.skt
               data_struct{j,i}.BINDI.Recovery.raw.skt];
	  data.BINDI.skt=[data_struct{j,i}.BINDI.Neutro.raw.skt
               data_struct{j,i}.BINDI.Video.raw.skt
               data_struct{j,i}.BINDI.Labels.raw.skt
               data_struct{j,i}.BINDI.Recovery.raw.skt];
      out{j,1}.BINDI.skt2 = [out{j,1}.BINDI.skt2 
               data_struct{j,i}.BINDI.Neutro.raw.skt2
               data_struct{j,i}.BINDI.Video.raw.skt2
               data_struct{j,i}.BINDI.Labels.raw.skt2
               data_struct{j,i}.BINDI.Recovery.raw.skt2];
	  data.BINDI.skt2=[data_struct{j,i}.BINDI.Neutro.raw.skt2
               data_struct{j,i}.BINDI.Video.raw.skt2
               data_struct{j,i}.BINDI.Labels.raw.skt2
               data_struct{j,i}.BINDI.Recovery.raw.skt2];
      out{j,1}.BINDI.hr = [out{j,1}.BINDI.hr 
               data_struct{j,i}.BINDI.Neutro.raw.hr
               data_struct{j,i}.BINDI.Video.raw.hr
               data_struct{j,i}.BINDI.Labels.raw.hr
               data_struct{j,i}.BINDI.Recovery.raw.hr];
      data.BINDI.hr=[data_struct{j,i}.BINDI.Neutro.raw.hr
               data_struct{j,i}.BINDI.Video.raw.hr
               data_struct{j,i}.BINDI.Labels.raw.hr
               data_struct{j,i}.BINDI.Recovery.raw.hr];
      out{j,1}.BINDI.hrv = [out{j,1}.BINDI.hrv 
               data_struct{j,i}.BINDI.Neutro.raw.hrv
               data_struct{j,i}.BINDI.Video.raw.hrv
               data_struct{j,i}.BINDI.Labels.raw.hrv
               data_struct{j,i}.BINDI.Recovery.raw.hrv];
      data.BINDI.hrv=[data_struct{j,i}.BINDI.Neutro.raw.hrv
               data_struct{j,i}.BINDI.Video.raw.hrv
               data_struct{j,i}.BINDI.Labels.raw.hrv
               data_struct{j,i}.BINDI.Recovery.raw.hrv];
           
      %GSR_AD process
      out{j,1}.GSR.gsr = [out{j,1}.GSR.gsr
               data_struct{j,i}.GSR.Neutro.raw.gsr_real_filt
               data_struct{j,i}.GSR.Video.raw.gsr_real_filt
               data_struct{j,i}.GSR.Labels.raw.gsr_real_filt
               data_struct{j,i}.GSR.Recovery.raw.gsr_real_filt];
      data.GSR.gsr=[data_struct{j,i}.GSR.Neutro.raw.gsr_real_filt
               data_struct{j,i}.GSR.Video.raw.gsr_real_filt
               data_struct{j,i}.GSR.Labels.raw.gsr_real_filt
               data_struct{j,i}.GSR.Recovery.raw.gsr_real_filt];
      out{j,1}.GSR.gsr_tonic =[ out{j,1}.GSR.gsr_tonic
               data_struct{j,i}.GSR.Neutro.raw.gsr_tonic
               data_struct{j,i}.GSR.Video.raw.gsr_tonic
               data_struct{j,i}.GSR.Labels.raw.gsr_tonic
               data_struct{j,i}.GSR.Recovery.raw.gsr_tonic];
      data.GSR.gsr_phasic=[data_struct{j,i}.GSR.Neutro.raw.gsr_phasic
               data_struct{j,i}.GSR.Video.raw.gsr_phasic
               data_struct{j,i}.GSR.Labels.raw.gsr_phasic
               data_struct{j,i}.GSR.Recovery.raw.gsr_phasic];
      out{j,1}.GSR.gsr_phasic =[ out{j,1}.GSR.gsr_phasic
               data_struct{j,i}.GSR.Neutro.raw.gsr_phasic
               data_struct{j,i}.GSR.Video.raw.gsr_phasic
               data_struct{j,i}.GSR.Labels.raw.gsr_phasic
               data_struct{j,i}.GSR.Recovery.raw.gsr_phasic];
      data.GSR.gsr_tonic=[data_struct{j,i}.GSR.Neutro.raw.gsr_tonic
               data_struct{j,i}.GSR.Video.raw.gsr_tonic
               data_struct{j,i}.GSR.Labels.raw.gsr_tonic
               data_struct{j,i}.GSR.Recovery.raw.gsr_tonic];
      out{j,1}.GSR.gsr_s = [out{j,1}.GSR.gsr_s
               data_struct{j,i}.GSR.Neutro.raw.gsr_real_filt_s
               data_struct{j,i}.GSR.Video.raw.gsr_real_filt_s
               data_struct{j,i}.GSR.Labels.raw.gsr_real_filt_s
               data_struct{j,i}.GSR.Recovery.raw.gsr_real_filt_s];
      data.GSR.gsr_s =[data_struct{j,i}.GSR.Neutro.raw.gsr_real_filt_s
               data_struct{j,i}.GSR.Video.raw.gsr_real_filt_s
               data_struct{j,i}.GSR.Labels.raw.gsr_real_filt_s
               data_struct{j,i}.GSR.Recovery.raw.gsr_real_filt_s];
      out{j,1}.GSR.gsr_tonic_s =[ out{j,1}.GSR.gsr_tonic_s
               data_struct{j,i}.GSR.Neutro.raw.gsr_tonic_s
               data_struct{j,i}.GSR.Video.raw.gsr_tonic_s
               data_struct{j,i}.GSR.Labels.raw.gsr_tonic_s
               data_struct{j,i}.GSR.Recovery.raw.gsr_tonic_s];
      data.GSR.gsr_tonic_s =[data_struct{j,i}.GSR.Neutro.raw.gsr_tonic_s
               data_struct{j,i}.GSR.Video.raw.gsr_tonic_s
               data_struct{j,i}.GSR.Labels.raw.gsr_tonic_s
               data_struct{j,i}.GSR.Recovery.raw.gsr_tonic_s];
      out{j,1}.GSR.gsr_phasic_s =[ out{j,1}.GSR.gsr_phasic_s
               data_struct{j,i}.GSR.Neutro.raw.gsr_phasic_s
               data_struct{j,i}.GSR.Video.raw.gsr_phasic_s
               data_struct{j,i}.GSR.Labels.raw.gsr_phasic_s
               data_struct{j,i}.GSR.Recovery.raw.gsr_phasic_s];
	  data.GSR.gsr_phasic_s =[data_struct{j,i}.GSR.Neutro.raw.gsr_phasic_s
               data_struct{j,i}.GSR.Video.raw.gsr_phasic_s
               data_struct{j,i}.GSR.Labels.raw.gsr_phasic_s
               data_struct{j,i}.GSR.Recovery.raw.gsr_phasic_s];
           
      %EH process
      out{j,1}.EH.gsr = [out{j,1}.EH.gsr 
               data_struct{j,i}.EH.Neutro.raw.gsr_filt
               data_struct{j,i}.EH.Video.raw.gsr_filt
               data_struct{j,i}.EH.Labels.raw.gsr_filt
               data_struct{j,i}.EH.Recovery.raw.gsr_filt];
      data.EH.gsr =[data_struct{j,i}.EH.Neutro.raw.gsr_filt
               data_struct{j,i}.EH.Video.raw.gsr_filt
               data_struct{j,i}.EH.Labels.raw.gsr_filt
               data_struct{j,i}.EH.Recovery.raw.gsr_filt];
      out{j,1}.EH.gsr_tonic =[ out{j,1}.EH.gsr_tonic
               data_struct{j,i}.EH.Neutro.raw.gsr_tonic
               data_struct{j,i}.EH.Video.raw.gsr_tonic
               data_struct{j,i}.EH.Labels.raw.gsr_tonic
               data_struct{j,i}.EH.Recovery.raw.gsr_tonic];
	  data.EH.gsr_tonic =[data_struct{j,i}.EH.Neutro.raw.gsr_tonic
               data_struct{j,i}.EH.Video.raw.gsr_tonic
               data_struct{j,i}.EH.Labels.raw.gsr_tonic
               data_struct{j,i}.EH.Recovery.raw.gsr_tonic];
      out{j,1}.EH.gsr_phasic =[ out{j,1}.EH.gsr_phasic
               data_struct{j,i}.EH.Neutro.raw.gsr_phasic
               data_struct{j,i}.EH.Video.raw.gsr_phasic
               data_struct{j,i}.EH.Labels.raw.gsr_phasic
               data_struct{j,i}.EH.Recovery.raw.gsr_phasic];
      data.EH.gsr_phasic =[data_struct{j,i}.EH.Neutro.raw.gsr_phasic
               data_struct{j,i}.EH.Video.raw.gsr_phasic
               data_struct{j,i}.EH.Labels.raw.gsr_phasic
               data_struct{j,i}.EH.Recovery.raw.gsr_phasic];
      out{j,1}.EH.gsr_s = [out{j,1}.EH.gsr_s 
               data_struct{j,i}.EH.Neutro.raw.gsr_filt_s
               data_struct{j,i}.EH.Video.raw.gsr_filt_s
               data_struct{j,i}.EH.Labels.raw.gsr_filt_s
               data_struct{j,i}.EH.Recovery.raw.gsr_filt_s];
	  data.EH.gsr_s =[data_struct{j,i}.EH.Neutro.raw.gsr_filt_s
               data_struct{j,i}.EH.Video.raw.gsr_filt_s
               data_struct{j,i}.EH.Labels.raw.gsr_filt_s
               data_struct{j,i}.EH.Recovery.raw.gsr_filt_s];
      out{j,1}.EH.gsr_tonic_s =[ out{j,1}.EH.gsr_tonic_s
               data_struct{j,i}.EH.Neutro.raw.gsr_tonic_s
               data_struct{j,i}.EH.Video.raw.gsr_tonic_s
               data_struct{j,i}.EH.Labels.raw.gsr_tonic_s
               data_struct{j,i}.EH.Recovery.raw.gsr_tonic_s];
      data.EH.gsr_tonic_s =[data_struct{j,i}.EH.Neutro.raw.gsr_tonic_s
               data_struct{j,i}.EH.Video.raw.gsr_tonic_s
               data_struct{j,i}.EH.Labels.raw.gsr_tonic_s
               data_struct{j,i}.EH.Recovery.raw.gsr_tonic_s];
      out{j,1}.EH.gsr_phasic_s =[ out{j,1}.EH.gsr_phasic_s
               data_struct{j,i}.EH.Neutro.raw.gsr_phasic_s
               data_struct{j,i}.EH.Video.raw.gsr_phasic_s
               data_struct{j,i}.EH.Labels.raw.gsr_phasic_s
               data_struct{j,i}.EH.Recovery.raw.gsr_phasic_s];
      data.EH.gsr_phasic_s =[data_struct{j,i}.EH.Neutro.raw.gsr_phasic_s
               data_struct{j,i}.EH.Video.raw.gsr_phasic_s
               data_struct{j,i}.EH.Labels.raw.gsr_phasic_s
               data_struct{j,i}.EH.Recovery.raw.gsr_phasic_s];
			   
      out{j,1}.EH.bvp = [out{j,1}.EH.bvp
               data_struct{j,i}.EH.Neutro.raw.bvp_filt
               data_struct{j,i}.EH.Video.raw.bvp_filt
               data_struct{j,i}.EH.Labels.raw.bvp_filt
               data_struct{j,i}.EH.Recovery.raw.bvp_filt];
	  data.EH.bvp=[data_struct{j,i}.EH.Neutro.raw.bvp_filt
               data_struct{j,i}.EH.Video.raw.bvp_filt
               data_struct{j,i}.EH.Labels.raw.bvp_filt
               data_struct{j,i}.EH.Recovery.raw.bvp_filt];
      out{j,1}.EH.skt = [out{j,1}.EH.skt 
               data_struct{j,i}.EH.Neutro.raw.skt
               data_struct{j,i}.EH.Video.raw.skt
               data_struct{j,i}.EH.Labels.raw.skt
               data_struct{j,i}.EH.Recovery.raw.skt];
	  data.EH.skt=[data_struct{j,i}.EH.Neutro.raw.skt
               data_struct{j,i}.EH.Video.raw.skt
               data_struct{j,i}.EH.Labels.raw.skt
               data_struct{j,i}.EH.Recovery.raw.skt];
      out{j,1}.EH.hr = [out{j,1}.EH.hr 
               data_struct{j,i}.EH.Neutro.raw.hr
               data_struct{j,i}.EH.Video.raw.hr
               data_struct{j,i}.EH.Labels.raw.hr
               data_struct{j,i}.EH.Recovery.raw.hr];
	  data.EH.hr=[data_struct{j,i}.EH.Neutro.raw.hr
               data_struct{j,i}.EH.Video.raw.hr
               data_struct{j,i}.EH.Labels.raw.hr
               data_struct{j,i}.EH.Recovery.raw.hr];
      out{j,1}.EH.hrv = [out{j,1}.EH.hrv 
               data_struct{j,i}.EH.Neutro.raw.hrv
               data_struct{j,i}.EH.Video.raw.hrv
               data_struct{j,i}.EH.Labels.raw.hrv
               data_struct{j,i}.EH.Recovery.raw.hrv];
      data.EH.hrv=[data_struct{j,i}.EH.Neutro.raw.hrv
               data_struct{j,i}.EH.Video.raw.hrv
               data_struct{j,i}.EH.Labels.raw.hrv
               data_struct{j,i}.EH.Recovery.raw.hrv];
			   
      %If plot has been selected, perform subplot display
      if splot_video==1

        %GSR Study
        f = figure;
        f.Name = "patient " + j +  " GSR Ohm study Video" + i;
         
        %BINDI
        subplot(3,3,1);
        plot(data.BINDI.gsr);
        ylabel('ADC count')
        title("B gsr");
        subplot(3,3,2);
        plot(data.BINDI.gsr_tonic);
        ylabel('ADC count')
        title("B tonic gsr");
        subplot(3,3,3);
        plot(data.BINDI.gsr_phasic);
        ylabel('ADC count')
        title("B phasic gsr");
        %GSR
        subplot(3,3,4);
        plot(data.GSR.gsr);
        ylabel('Ohm')
        title("G gsr");
        subplot(3,3,5);
        plot(data.GSR.gsr_tonic);
        ylabel('Ohm')
        title("G tonic gsr");
        subplot(3,3,6);
        plot(data.GSR.gsr_phasic);
        ylabel('Ohm')
        title("G phasic gsr");
         %EH
        subplot(3,3,7);
        plot(data.EH.gsr_s);
        ylabel('MOhm')
        title("EH gsr");
        subplot(3,3,8);
        plot(data.EH.gsr_tonic_s);
        ylabel('MOhm')
        title("EH tonic gsr");
        subplot(3,3,9);
        plot(data.EH.gsr_phasic_s);
        ylabel('MOhm')
        title("EH phasic gsr");
        
        %GSR Study
        f = figure;
        f.Name = "patient " + j +  " GSR Siemens study Video" + i;
        %BINDI
        subplot(3,3,1);
        plot(data.BINDI.gsr_s);
        ylabel('1./ADC count')
        title("B gsr");
        subplot(3,3,2);
        plot(data.BINDI.gsr_tonic_s);
        ylabel('1./ADC count')
        title("B tonic gsr");
        subplot(3,3,3);
        plot(data.BINDI.gsr_phasic_s);
        ylabel('1./ADC count')
        title("B phasic gsr");
        %GSR      
        subplot(3,3,4);
        plot(data.GSR.gsr_s);
        ylabel('Siemens')
        title("G gsr");
        subplot(3,3,5);
        plot(data.GSR.gsr_tonic_s);
        ylabel('Siemens')
        title("G tonic gsr");
        subplot(3,3,6);
        plot(data.GSR.gsr_phasic_s);
        ylabel('Siemens')
        title("G phasic gsr");
        %EH
        subplot(3,3,7);
        plot(data.EH.gsr);
        ylabel('uSiemes')
        title("EH gsr");
        subplot(3,3,8);
        plot(data.EH.gsr_tonic);
        ylabel('uSiemes')
        title("EH tonic gsr");
        subplot(3,3,9);
        plot(data.EH.gsr_phasic);
        ylabel('uSiemes')
        title("EH phasic gsr");
        
        %BVP Study
        f = figure;
        f.Name = "patient " + j +  " BVP study Video" + i;
         
        %BINDI
        subplot(2,3,1);
        plot(data.BINDI.bvp);
        ylabel('ADC count')
        title("B bvp");
        subplot(2,3,2);
        plot(data.BINDI.hr);
        ylabel('BPM')
        title("B HR");
        subplot(2,3,3);
        %out{j,1}.BINDI.hrv(out{j,1}.BINDI.hrv==0)=[];
        plot(data.BINDI.hrv);
        ylabel('RMSSD')
        title("B HRV");
        
        %EH
        subplot(2,3,4);
        plot(data.EH.bvp);
        ylabel('rel. int.')
        title("EH bvp");
        subplot(2,3,5);
        plot(data.EH.hr);
        ylabel('BPM')
        title("EH HR");
        subplot(2,3,6);
        %out{j,1}.EH.hrv(out{j,1}.EH.hrv==0)=[];
        plot(data.EH.hrv);
        ylabel('RMSSD')
        title("EH HRV");
        
        %SKT Study
        f = figure;
        f.Name = "patient " + j +  " SKT study Video" + i;
         
        %BINDI
        subplot(2,2,1);
        hold on;
        plot(data.BINDI.skt);
        plot(data.BINDI.skt2);
        hold off;
        ylabel('ºC')
        title("B skts");
        legend('old','new');
        subplot(2,2,2);
        hold on;
        temp = diff(data.BINDI.skt)./(1/200);
        %temp(temp==0)=[];
        plot(smooth(temp));
        temp = diff(data.BINDI.skt2)./(1/200);
        %temp(temp==0)=[];
        plot(smooth(temp));
        hold off;
        ylabel('ºC')
        title("B skts slopes");
        legend('old','new');
        
        %EH
        subplot(2,2,3);
        plot(data.EH.skt);
        ylabel('ºC')
        title("EH skt");
        subplot(2,2,4);
        temp = diff(data.EH.skt)./(1/200);
        %temp(temp==0)=[];
        plot(smooth(temp));
        ylabel('ºC')
        title("EH skt slope");
        
      end
    end
    
    %If plot has been selected, perform subplot display
    if splot_all==1

         %GSR Study
         f = figure;
         f.Name = "patient " + j +  " GSR study Ohm ALL";
         
         %BINDI
        subplot(3,3,1);
        plot(out{j,1}.BINDI.gsr);
        ylabel('ADC count')
        title("B gsr");
        subplot(3,3,2);
        plot(out{j,1}.BINDI.gsr_tonic);
        ylabel('ADC count')
        title("B tonic gsr");
        subplot(3,3,3);
        plot(out{j,1}.BINDI.gsr_phasic);
        ylabel('ADC count')
        title("B phasic gsr");
        %GSR
        subplot(3,3,4);
        plot(out{j,1}.GSR.gsr);
        ylabel('Ohm')
        title("G gsr filtered");
        subplot(3,3,5);
        plot(out{j,1}.GSR.gsr_tonic);
        ylabel('Ohm')
        title("G tonic gsr");
        subplot(3,3,6);
        plot(out{j,1}.GSR.gsr_phasic);
        ylabel('Ohm')
        title("G phasic gsr");
        %EH
        subplot(3,3,7);
        plot(out{j,1}.EH.gsr_s);
        ylabel('MOhm')
        title("EH gsr");
        subplot(3,3,8);
        plot(out{j,1}.EH.gsr_tonic_s);
        ylabel('MOhm')
        title("EH tonic gsr");
        subplot(3,3,9);
        plot(out{j,1}.EH.gsr_phasic_s);
        ylabel('MOhm')
        title("EH phasic gsr");

         %GSR Study
         f = figure;
         f.Name = "patient " + j +  " GSR study Siemems ALL";
        subplot(3,3,1);
        plot(out{j,1}.BINDI.gsr_s);
        ylabel('1./ADC count')
        title("B gsr");
        subplot(3,3,2);
        plot(out{j,1}.BINDI.gsr_tonic_s);
        ylabel('1./ADC count')
        title("B tonic gsr");
        subplot(3,3,3);
        plot(out{j,1}.BINDI.gsr_phasic_s);
        ylabel('1./ADC count')
        title("B phasic gsr");
        %GSR
        subplot(3,3,4);
        plot(out{j,1}.GSR.gsr_s);
        ylabel('Siemens')
        title("G gsr");
        subplot(3,3,5);
        plot(out{j,1}.GSR.gsr_tonic_s);
        ylabel('Siemens')
        title("G tonic gsr");
        subplot(3,3,6);
        plot(out{j,1}.GSR.gsr_phasic_s);
        ylabel('Siemens')
        title("G phasic gsr");
        %EH
        subplot(3,3,7);
        plot(out{j,1}.EH.gsr);
        ylabel('uSiemes')
        title("EH gsr");
        subplot(3,3,8);
        plot(out{j,1}.EH.gsr_tonic);
        ylabel('uSiemes')
        title("EH tonic gsr");
        subplot(3,3,9);
        plot(out{j,1}.EH.gsr_phasic);
        ylabel('uSiemes')
        title("EH phasic gsr");
        
        %BVP Study
        f = figure;
        f.Name = "patient " + j +  " BVP study ALL";
         
        %BINDI
        subplot(2,3,1);
        plot(out{j,1}.BINDI.bvp);
        ylabel('ADC count')
        title("B bvp");
        subplot(2,3,2);
        plot(out{j,1}.BINDI.hr);
        ylabel('BPM')
        title("B HR");
        subplot(2,3,3);
        %out{j,1}.BINDI.hrv(out{j,1}.BINDI.hrv==0)=[];
        plot(smooth(out{j,1}.BINDI.hrv));
        ylabel('RMSSD')
        title("B HRV");
        
        %EH
        subplot(2,3,4);
        plot(out{j,1}.EH.bvp);
        ylabel('rel. int.')
        title("EH bvp");
        subplot(2,3,5);
        plot(out{j,1}.EH.hr);
        ylabel('BPM')
        title("EH HR");
        subplot(2,3,6);
        %out{j,1}.EH.hrv(out{j,1}.EH.hrv==0)=[];
        plot(smooth(out{j,1}.EH.hrv));
        ylabel('RMSSD')
        title("EH HRV");
        
        %SKT Study
        f = figure;
        f.Name = "patient " + j +  " SKT study ALL";
         
        %BINDI
        subplot(2,2,1);
        hold on;
        plot(out{j,1}.BINDI.skt);
        plot(out{j,1}.BINDI.skt2);
        hold off;
        ylabel('ºC')
        title("B skts");
        legend('old','new')
        subplot(2,2,2);
        hold on;
        temp = diff(out{j,1}.BINDI.skt)./(1/200);
        %temp(temp==0)=[];
        plot(smooth(temp));
        temp = diff(out{j,1}.BINDI.skt2)./(1/200);
        %temp(temp==0)=[];
        plot(smooth(temp));
        hold off;
        ylabel('ºC')
        legend('old','new')
        title("B skts slopes");
        
        %EH
        subplot(2,2,3);
        plot(out{j,1}.EH.skt);
        ylabel('ºC')
        title("EH skt");
        subplot(2,2,4);
        temp = diff(out{j,1}.EH.skt)./(1/200);
        %temp(temp==0)=[];
        plot(smooth(temp));
        ylabel('ºC')
        title("EH skt slope");
        
    end
  end
  
  out_s = [data_struct, out];

end
