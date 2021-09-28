function [out_struct, allraw] = load_data_lucia()

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
curr_path_eh = strcat(selpath,'\EH\');
if ~exist(curr_path_eh, 'dir')
  error("One of the following subfolders is missing: Bindi, GSR, EH");
end

%Getting actual directories
current_path=pwd;
cd(curr_path_eh);
directory_data_eh = dir('Lucia*');
cd(current_path);
% directory_data_eh = dir(curr_path_eh);
%Taking the total number of patients based on the 
% number of subfolders within any of the main subfolders


[patients_total,~]=size(directory_data_eh);
% patients_total=6;
%WTD: check if all subfolders have the same number of patients

%The first two positions are the previous and the previous 
% of the previous folders
init_directory = 1;

%There must be a total of 4 videos for each patient
videos_total = 13;
%Create empty fileds to store all the data  
for loop1=1:patients_total-init_directory+1
    
  allraw{loop1}.gsr_uS = [];
  allraw{loop1}.packet_id = [];
  allraw{loop1}.skt = [];
  allraw{loop1}.bvp = [];
  allraw{loop1}.resp = [];
  allraw{loop1}.emg = [];
  allraw{loop1}.date = [];
  allraw{loop1}.index= [];
  allraw{loop1}.ecg= [];
  
end
for j = init_directory:patients_total
    
%     out_struct{j-init_directory+1,videos_total+1}.BINDI.trial = [];
%     out_struct{j-init_directory+1,videos_total+1}.BINDI.samplesLostfile = [];
%     out_struct{j-init_directory+1,videos_total+1}.BINDI.samplesLostnum = [];
%     out_struct{j-init_directory+1,videos_total+1}.BINDI.samplesLostRow = [];
%     out_struct{j-init_directory+1,videos_total+1}.BINDI.allRaw = [];
%     
%     out_struct{j-init_directory+1,videos_total+1}.GSR.trial = [];
%     out_struct{j-init_directory+1,videos_total+1}.GSR.samplesLostfile = [];
%     out_struct{j-init_directory+1,videos_total+1}.GSR.samplesLostnum = [];
%     out_struct{j-init_directory+1,videos_total+1}.GSR.samplesLostRow = [];
%     out_struct{j-init_directory+1,videos_total+1}.GSR.allRaw = [];
    
    %Apply parser for EH files
%     str_folder_eh = strcat(curr_path_eh, directory_data_eh(j).name);
%     cd(str_folder_eh);
%     python = strcat('python',{' '},selpath,'\autoParser_v2.py');
%     system(string(python));  
%     cd(selpath);
    
    for i = 1:videos_total
        
        str_file_e = strcat(curr_path_eh,...
		        directory_data_eh(j).name,'\',directory_data_eh(j).name);
      
        %%%%%%%%%%%%%%%%%%%%%%%%%%% EH %%%%%%%%%%%%%%%%%%%%%%%%%%%
        out_struct{j-init_directory+1,i}.EH = empatia_preprocess_efile(str_file_e,i);
        
        %Concatenate all data in a vector
        allraw{j-init_directory+1}.gsr_uS =[allraw{j-init_directory+1}.gsr_uS ; out_struct{j-init_directory+1,i}.EH.allraw.gsr_uS];
        allraw{j-init_directory+1}.packet_id =[allraw{j-init_directory+1}.packet_id ; out_struct{j-init_directory+1,i}.EH.allraw.packet_id];
%         allraw{j-init_directory+1}.skt =[allraw{j-init_directory+1}.skt ; out_struct{j-init_directory+1,i}.EH.allraw.skt];
%         allraw{j-init_directory+1}.bvp =[allraw{j-init_directory+1}.bvp ; out_struct{j-init_directory+1,i}.EH.allraw.bvp];
%         allraw{j-init_directory+1}.resp =[allraw{j-init_directory+1}.resp ; out_struct{j-init_directory+1,i}.EH.allraw.resp];
%         allraw{j-init_directory+1}.emg =[allraw{j-init_directory+1}.emg ; out_struct{j-init_directory+1,i}.EH.allraw.emg];
%         allraw{j-init_directory+1}.date =[allraw{j-init_directory+1}.date ; out_struct{j-init_directory+1,i}.EH.allraw.date];
%         %Check if the voluntier has ecg signal
%         if(isfield(out_struct{j-init_directory+1,i}.EH.allraw,'ecg'))
%             allraw{j-init_directory+1}.ecg =[allraw{j-init_directory+1}.ecg ; out_struct{j-init_directory+1,i}.EH.allraw.ecg];
%         end
%         %Concatenate scene change index
        if(isempty(allraw{j-init_directory+1}.index))
            allraw{j-init_directory+1}.index=[allraw{j-init_directory+1}.index; out_struct{j-init_directory+1,i}.EH.allraw.index(1:end)]; 
        else
            allraw{j-init_directory+1}.index=[allraw{j-init_directory+1}.index; out_struct{j-init_directory+1,i}.EH.allraw.index(1:end)+allraw{j-init_directory+1}.index(end)];
        end
      
      
      %WTD

%         fprintf('Patient %s, Video %d data extracted\n',directory_data_bindi(j).name, i);
    end
     allraw{j-init_directory+1}.errors=sum(diff(allraw{j-init_directory+1}.packet_id)~=1);
    fprintf('Patient %s extracted, num errors= %i\n',directory_data_eh(j).name, allraw{j-init_directory+1}.errors);
end
%--------------------------------------------%

%Applying signal preprocessing 
% out_struct = empatia_preprocess_bsignals(out_struct);
% out_struct = empatia_preprocess_gsignalsNew(out_struct);
% out_struct = empatia_preprocess_esignals(out_struct);

%Plotting the raw data
% out_struct = empatia_plot_allrawGsr(out_struct,1,1);
% empatia_preprocess_allraw(out_struct,1,1);

%Plotting BVP-features related correlations
%empatia_preprocess_bvpCorrelation(out_struct);

end


%Getting the raw data from EH's csv files
function out_s = empatia_preprocess_efile(file,video)

%All csv files are loaded as if contains ecg signal

% Step 0: Prepare the reading for the four file types

% Setup the Import Options and import the data
variables_num = 10; %number of columns
filetypes_str = {'N','V','E','D'};
filetypes_num = size(filetypes_str,2);

% "time", "packet_id", "skt", "bvp", "gsr", "resp", "emg"
% units: ºC ,rel.int., uS,    %   ,   mV
opts = delimitedTextImportOptions("NumVariables", variables_num);
% Specify range and delimiter
opts.DataLines = [3, Inf]; %it starts in the third line
opts.Delimiter = ";";
% Specify column names and types
opts.VariableNames = ["time", "packet_id", "skt", "bvp", "gsr","emg","resp","ecg","acc1","acc2"];
opts.VariableTypes = ["char", "double", "double", "double", "double", "double", "double","double", "double","double"];
% Specify file level properties
opts.ExtraColumnsRule = "ignore";
opts.EmptyLineRule = "read";
time_format= 'HH.mm.ss.SSS';
% Specify variable properties
% opts = setvaropts(opts, "time", "InputFormat", "HH:mm:ss:xxxxxx");
 
%Declare all raw array for storing all experiment for current video
  out_s.allraw.gsr_uS = [];
  out_s.allraw.packet_id = [];
  out_s.allraw.skt = [];
  out_s.allraw.bvp = [];
  out_s.allraw.resp = [];
  out_s.allraw.emg = [];
  out_s.allraw.date = [];
  
  
% Import the data
for i = 1:filetypes_num
    
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
      disp("File is in the expected extension\n");
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
  pkt_id_diff = diff(data.packet_id(1:end));
  rows = find(pkt_id_diff~=1);
  if ~isempty(rows)
      [fails] = length(rows);
      for k=1:fails
        warning('Data column error: %s // Error: %d', string(str_file),data.packet_id(rows(k)));
      end
  end

% 
%"time", "packet_id", "skt", "bvp", "gsr", "resp", "emg"
% Step 3: Store data into struct
   switch i
    %   %Video (V)
     case 1
%             out_s.Video.raw.date = datetime(data.time(1:end),'InputFormat',time_format);
            out_s.Neutro.raw.date = data.time(1:end);
            %isnan not allowed for datetime type
            out_s.allraw.date = [out_s.allraw.date  ;  out_s.Neutro.raw.date];
            
            out_s.Neutro.raw.packet_id = data.packet_id(1:end);
            out_s.Neutro.raw.packet_id(isnan(out_s.Neutro.raw.packet_id))=[];
            out_s.allraw.packet_id = [out_s.allraw.packet_id  ;  out_s.Neutro.raw.packet_id];
            
            out_s.Neutro.raw.skt = data.skt(1:end);
            out_s.Neutro.raw.skt(isnan(out_s.Neutro.raw.skt))=[];
            out_s.allraw.skt = [out_s.allraw.skt  ;  out_s.Neutro.raw.skt];
            
            out_s.Neutro.raw.bvp = data.bvp(1:end);
            out_s.Neutro.raw.bvp(isnan(out_s.Neutro.raw.bvp))=[];
            out_s.allraw.bvp = [out_s.allraw.bvp  ;  out_s.Neutro.raw.bvp];
            
            out_s.Neutro.raw.gsr = data.gsr(1:end);
            out_s.Neutro.raw.gsr(isnan(out_s.Neutro.raw.gsr))=[];
            out_s.allraw.gsr_uS = [out_s.allraw.gsr_uS  ;  out_s.Neutro.raw.gsr];
            
            out_s.Neutro.raw.resp = data.resp(1:end);
            out_s.Neutro.raw.resp(isnan(out_s.Neutro.raw.resp))=[];
            out_s.allraw.resp = [out_s.allraw.resp  ;  out_s.Neutro.raw.resp];
            
            out_s.Neutro.raw.emg = data.emg(1:end);
            out_s.Neutro.raw.emg(isnan(out_s.Neutro.raw.emg))=[];
            out_s.allraw.emg = [out_s.allraw.emg  ;  out_s.Neutro.raw.emg];
            
            if(~isnan(data.ecg(6)))            
                out_s.Neutro.raw.ecg = data.ecg(1:end);
                out_s.Neutro.raw.ecg(isnan(out_s.Neutro.raw.ecg))=[];
                out_s.allraw.ecg = [];
                out_s.allraw.ecg = [out_s.allraw.ecg  ;  out_s.Neutro.raw.ecg];
            end
            out_s.allraw.index(1,1)=length(out_s.Neutro.raw.gsr);
            
        case 2
%             out_s.Video.raw.date = datetime(data.time(1:end),'InputFormat',time_format);
            out_s.Video.raw.date = data.time(1:end);
            %isnan not allowed for datetime type
            out_s.allraw.date = [out_s.allraw.date  ;  out_s.Video.raw.date];
            
            out_s.Video.raw.packet_id = data.packet_id(1:end);
            out_s.Video.raw.packet_id(isnan(out_s.Video.raw.packet_id))=[];
            out_s.allraw.packet_id = [out_s.allraw.packet_id  ;  out_s.Video.raw.packet_id];
            
            out_s.Video.raw.skt = data.skt(1:end);
            out_s.Video.raw.skt(isnan(out_s.Video.raw.skt))=[];
            out_s.allraw.skt = [out_s.allraw.skt  ;  out_s.Video.raw.skt];
            
            out_s.Video.raw.bvp = data.bvp(1:end);
            out_s.Video.raw.bvp(isnan(out_s.Video.raw.bvp))=[];
            out_s.allraw.bvp = [out_s.allraw.bvp  ;  out_s.Video.raw.bvp];
            
            out_s.Video.raw.gsr = data.gsr(1:end);
            out_s.Video.raw.gsr(isnan(out_s.Video.raw.gsr))=[];
            out_s.allraw.gsr_uS = [out_s.allraw.gsr_uS  ;  out_s.Video.raw.gsr];
            
            out_s.Video.raw.resp = data.resp(1:end);
            out_s.Video.raw.resp(isnan(out_s.Video.raw.resp))=[];
            out_s.allraw.resp = [out_s.allraw.resp  ;  out_s.Video.raw.resp];
            
            out_s.Video.raw.emg = data.emg(1:end);
            out_s.Video.raw.emg(isnan(out_s.Video.raw.emg))=[];
            out_s.allraw.emg = [out_s.allraw.emg  ;  out_s.Video.raw.emg];
            
            if(~isnan(data.ecg(6)))            
                out_s.Video.raw.ecg = data.ecg(1:end);
                out_s.Video.raw.ecg(isnan(out_s.Video.raw.ecg))=[];
                out_s.allraw.ecg = [];
                out_s.allraw.ecg = [out_s.allraw.ecg  ;  out_s.Video.raw.ecg];
            end
            out_s.allraw.index(2,1)=(length(out_s.Video.raw.gsr) +out_s.allraw.index(1,1));
            
            
%       %Etiquetas (E)
       case 3
            out_s.Labels.raw.date = data.time(1:end);
            %isnan not allowed for datetime type
            out_s.allraw.date = [out_s.allraw.date  ;  out_s.Labels.raw.date];
            
            out_s.Labels.raw.packet_id = data.packet_id(1:end);
            out_s.Labels.raw.packet_id(isnan(out_s.Labels.raw.packet_id))=[];
            out_s.allraw.packet_id = [out_s.allraw.packet_id  ;  out_s.Labels.raw.packet_id];
            
            out_s.Labels.raw.skt = data.skt(1:end);
            out_s.Labels.raw.skt(isnan(out_s.Labels.raw.skt))=[];
            out_s.allraw.skt = [out_s.allraw.skt  ;  out_s.Labels.raw.skt];

            out_s.Labels.raw.bvp = data.bvp(1:end);
            out_s.Labels.raw.bvp(isnan(out_s.Labels.raw.bvp))=[];
            out_s.allraw.bvp = [out_s.allraw.bvp  ;  out_s.Labels.raw.bvp];
            
            out_s.Labels.raw.gsr = data.gsr(1:end);
            out_s.Labels.raw.gsr(isnan(out_s.Labels.raw.gsr))=[];
            out_s.allraw.gsr_uS = [out_s.allraw.gsr_uS  ;  out_s.Labels.raw.gsr];
            
            out_s.Labels.raw.resp = data.resp(1:end);
            out_s.Labels.raw.resp(isnan(out_s.Labels.raw.resp))=[];
            out_s.allraw.resp = [out_s.allraw.resp  ;  out_s.Labels.raw.resp];
            
            out_s.Labels.raw.emg = data.emg(1:end);
            out_s.Labels.raw.emg(isnan(out_s.Labels.raw.emg))=[];
            out_s.allraw.emg = [out_s.allraw.emg  ;  out_s.Labels.raw.emg];
            
            if(~isnan(data.ecg(6)))            
                out_s.Labels.raw.ecg = data.ecg(1:end);
                out_s.Labels.raw.ecg(isnan(out_s.Labels.raw.ecg))=[];
                out_s.allraw.ecg = [out_s.allraw.ecg  ;  out_s.Labels.raw.ecg];
            end
            
            out_s.allraw.index(3,1)=length(out_s.Labels.raw.gsr)+out_s.allraw.index(2,1);
            
%       %Descanso/Recovery (D)
       case 4
            out_s.Recovery.raw.date = data.time(1:end);
            %isnan not allowed for datetime type
            out_s.allraw.date = [out_s.allraw.date  ;  out_s.Recovery.raw.date];
            
            out_s.Recovery.raw.packet_id = data.packet_id(1:end);
            out_s.Recovery.raw.packet_id(isnan(out_s.Recovery.raw.packet_id))=[];
            out_s.allraw.packet_id = [out_s.allraw.packet_id  ;  out_s.Recovery.raw.packet_id];
            
            out_s.Recovery.raw.skt = data.skt(1:end);
            out_s.Recovery.raw.skt(isnan(out_s.Recovery.raw.skt))=[];
            out_s.allraw.skt = [out_s.allraw.skt  ;  out_s.Recovery.raw.skt];

            out_s.Recovery.raw.bvp = data.bvp(1:end);
            out_s.Recovery.raw.bvp(isnan(out_s.Recovery.raw.bvp))=[];
            out_s.allraw.bvp = [out_s.allraw.bvp  ;  out_s.Recovery.raw.bvp];
            
            out_s.Recovery.raw.gsr = data.gsr(1:end);	
            out_s.Recovery.raw.gsr(isnan(out_s.Recovery.raw.gsr))=[];
            out_s.allraw.gsr_uS = [out_s.allraw.gsr_uS  ;  out_s.Recovery.raw.gsr];
            
            out_s.Recovery.raw.resp = data.resp(1:end);
            out_s.Recovery.raw.resp(isnan(out_s.Recovery.raw.resp))=[];
            out_s.allraw.resp = [out_s.allraw.resp  ;  out_s.Recovery.raw.resp];
            
            out_s.Recovery.raw.emg = data.emg(1:end);
            out_s.Recovery.raw.emg(isnan(out_s.Recovery.raw.emg))=[];
            out_s.allraw.emg = [out_s.allraw.emg  ;  out_s.Recovery.raw.emg];
            
            if(~isnan(data.ecg(6)))            
                out_s.Recovery.raw.ecg = data.ecg(1:end);
                out_s.Recovery.raw.ecg(isnan(out_s.Recovery.raw.ecg))=[];
                out_s.allraw.ecg = [out_s.allraw.ecg  ;  out_s.Recovery.raw.ecg];
            end
            
            out_s.allraw.index(4,1)=length(out_s.Recovery.raw.gsr)+out_s.allraw.index(3,1);
            
      otherwise % Under all circumstances SWITCH gets an OTHERWISE!
             error('Unexpected file type\n');
   end
   
end

% % Step 4: Store feedback into struct
%Not applicable for this sensor - File is in Bindi's Subfolder

% Step 5: Setting pre-processing Flag
out_s.Filtered = 0;

end

function out_s= reorder_physio_data(in_s, order_array)

    out_s=in_s;

    for loop=1:size(order_array,2)
    
        if order_array==2
      
            out_s{2,loop1}=in_s{4,loop1};
            out_s{4,loop1}=in_s{2,loop1};
  
        end
    
    
    end
end

