function [out_struct, allraw] = load_data_artemisa()

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
directory_data_eh = dir('V*');
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
videos_total = 4;
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
        allraw{j-init_directory+1}.skt =[allraw{j-init_directory+1}.skt ; out_struct{j-init_directory+1,i}.EH.allraw.skt];
        allraw{j-init_directory+1}.bvp =[allraw{j-init_directory+1}.bvp ; out_struct{j-init_directory+1,i}.EH.allraw.bvp];
        allraw{j-init_directory+1}.resp =[allraw{j-init_directory+1}.resp ; out_struct{j-init_directory+1,i}.EH.allraw.resp];
        allraw{j-init_directory+1}.emg =[allraw{j-init_directory+1}.emg ; out_struct{j-init_directory+1,i}.EH.allraw.emg];
        allraw{j-init_directory+1}.date =[allraw{j-init_directory+1}.date ; out_struct{j-init_directory+1,i}.EH.allraw.date];
        %Check if the voluntier has ecg signal
        if(isfield(out_struct{j-init_directory+1,i}.EH.allraw,'ecg'))
            allraw{j-init_directory+1}.ecg =[allraw{j-init_directory+1}.ecg ; out_struct{j-init_directory+1,i}.EH.allraw.ecg];
        end
        %Concatenate scene change index
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
 [out_struct,allraw] = empatia_preprocess_esignals(out_struct,allraw);
 
 file="orden.csv";
% Setup the Import Options and import the data
variables_num = 1; %number of columns
voluntarias_num=21;
% filetypes_str = {'V','E','D'};
% filetypes_num = size(filetypes_str,2);

% "time", "packet_id", "skt", "bvp", "gsr", "resp", "emg"
% units: ºC ,rel.int., uS,    %   ,   mV
opts = delimitedTextImportOptions("NumVariables", variables_num);
% Specify range and delimiter
opts.DataLines = [1, voluntarias_num]; %it starts in the third line
opts.Delimiter = ";";
% Specify column names and types
opts.VariableNames = ["order"];
opts.VariableTypes = ["double"];
% Specify file level properties
opts.ExtraColumnsRule = "ignore";
opts.EmptyLineRule = "read";
% time_format= 'HH.mm.ss.SSS';
% Specify variable properties
% opts = setvaropts(opts, "time", "InputFormat", "HH:mm:ss:xxxxxx");


load('tabla_recortes_fisio.mat')
out_struct=remove_bad_BVP_ECG_physio_data(out_struct, tabla_recortes_physio);

data = readtable(file,opts);
out_struct= reorder_physio_data(out_struct, data.order);
 
 
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
variables_num = 8; %number of columns
filetypes_str = {'V','E','D'};
filetypes_num = size(filetypes_str,2);

% "time", "packet_id", "skt", "bvp", "gsr", "resp", "emg"
% units: ºC ,rel.int., uS,    %   ,   mV
opts = delimitedTextImportOptions("NumVariables", variables_num);
% Specify range and delimiter
opts.DataLines = [3, Inf]; %it starts in the third line
opts.Delimiter = ";";
% Specify column names and types
opts.VariableNames = ["time", "packet_id", "skt", "bvp", "gsr","emg","resp","ecg"];
opts.VariableTypes = ["char", "double", "double", "double", "double", "double", "double","double"];
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
%       % A MATLAB file
%       disp("File is in the expected extension\n");
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
            out_s.allraw.index(1,1)=length(out_s.Video.raw.gsr);
            
            
%       %Etiquetas (E)
       case 2
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
            
            out_s.allraw.index(2,1)=length(out_s.Labels.raw.gsr)+out_s.allraw.index(1,1);
            
%       %Descanso/Recovery (D)
       case 3
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
            
            out_s.allraw.index(3,1)=length(out_s.Recovery.raw.gsr)+out_s.allraw.index(2,1);
            
      otherwise % Under all circumstances SWITCH gets an OTHERWISE!
             error('Unexpected file type\n');
   end
   
end

% % Step 4: Store feedback into struct
%Not applicable for this sensor - File is in Bindi's Subfolder

% Step 5: Setting pre-processing Flag
out_s.Filtered = 0;

end

function out_s= remove_bad_BVP_ECG_physio_data(in_s, remove_table)
%     [voluntaria, vid] = size(in_s);
    out_s=in_s;
    items=height(remove_table);
 for j = 1:items

     voluntaria=remove_table.voluntaria(j);
     video=remove_table.video(j);
     inicio=remove_table.inicio(j);
     fin=cellstr(remove_table.final(j)); 


    if (remove_table.sig(j)=='bvp')
        if strcmp(fin,'end')
            out_s{voluntaria,video}.EH.Video.raw.bvp_filt=in_s{voluntaria,video}.EH.Video.raw.bvp_filt(inicio:end);
        else
            temp=cellstr(fin);
            temp=str2num(temp{1});
            out_s{voluntaria,video}.EH.Video.raw.bvp_filt=in_s{voluntaria,video}.EH.Video.raw.bvp_filt(inicio:double(fin));
        end

    elseif remove_table.sig(j)=='ecg' 

        if strcmp(fin,'end')
            out_s{voluntaria,video}.EH.Video.raw.ecg_filt=in_s{voluntaria,video}.EH.Video.raw.ecg_filt(inicio:end);
        else
            temp=cellstr(fin);
            temp=str2num(temp{1});
            out_s{voluntaria,video}.EH.Video.raw.ecg_filt=in_s{voluntaria,video}.EH.Video.raw.ecg_filt(inicio:temp);
        end
    end



end


end
function out_s= reorder_physio_data(in_s, order_array)

    out_s=in_s;

    for loop1=1:size(order_array,1)
    
        if order_array(loop1)==2
      
            out_s{loop1,2}=in_s{loop1,4};
            out_s{loop1,4}=in_s{loop1,2};
  
        end
    
    
    end
end

%Applying signal preprocessing on EH signals
function  [out ,allraw]= empatia_preprocess_esignals(data_struct,allraw_in)
  %Get patients and videos number
  [patients, videos] = size(data_struct);
  %Load filter coeffs
  FIRs = load('FIRs_manu.mat');
  allraw=allraw_in;
  %Set sampling frequency and processing window
  Fs = 200;
  window_gsr     = 4;
  downsample_gsr = 20; % Fs' = 200/20 = 10Hz
  for j = 1:patients
    for i = 1:videos
      fprintf('Patient %d, Video %d filtering...\n',j, i);
%       GSR

      %Video
      data_struct{j,i}.EH.Video.raw.gsr_uS_filtered = ...
          filtfilt(FIRs.Coeffs_GSR,1,data_struct{j,i}.EH.Video.raw.gsr);
	  data_struct{j,i}.EH.Video.raw.gsr_uS_filtered_dn = ...
          downsample(data_struct{j,i}.EH.Video.raw.gsr_uS_filtered,downsample_gsr);
      data_struct{j,i}.EH.Video.raw.gsr_uS_filtered_dn_sm = ...
          movmedian(movmean(data_struct{j,i}.EH.Video.raw.gsr_uS_filtered_dn,...
                           (Fs/downsample_gsr)),(Fs/downsample_gsr)/2);
				 
      %Labels
      data_struct{j,i}.EH.Labels.raw.gsr_uS_filtered = ...
          filtfilt(FIRs.Coeffs_GSR,1,data_struct{j,i}.EH.Labels.raw.gsr);
	  data_struct{j,i}.EH.Labels.raw.gsr_uS_filtered_dn = ...
          downsample(data_struct{j,i}.EH.Labels.raw.gsr_uS_filtered,downsample_gsr);
      data_struct{j,i}.EH.Labels.raw.gsr_uS_filtered_dn_sm = ...
          movmedian(movmean(data_struct{j,i}.EH.Labels.raw.gsr_uS_filtered_dn,...
                           (Fs/downsample_gsr)),(Fs/downsample_gsr)/2);      
				 
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
        
        
      %Complete raw signals
        allraw{j}.gsr_uS_filtered = ...
          filtfilt(FIRs.Coeffs_GSR,1,allraw{j}.gsr_uS);
       allraw{j}.gsr_uS_filtered_dn = ...
          downsample(allraw{j}.gsr_uS_filtered,downsample_gsr);
      allraw{j}.gsr_uS_filtered_dn_sm = ...
          movmedian(movmean(allraw{j}.gsr_uS_filtered_dn,...
                           (Fs/downsample_gsr)),(Fs/downsample_gsr)/2); 
                       
				  
      %BVP
      
      %Video
      data_struct{j,i}.EH.Video.raw.bvp_filt = ...
          filtfilt(FIRs.Coeffs_BVP,1,data_struct{j,i}.EH.Video.raw.bvp);
      bvp_temp    = BVP_create_signal(data_struct{j,i}.EH.Video.raw.bvp_filt, 200);
      data_struct{j,i}.EH.Video.raw.bvp_filt = ...
          Signal__get_raw(BVP_removebaselinewander_signal(bvp_temp,Fs));
      
      %Labels
      data_struct{j,i}.EH.Labels.raw.bvp_filt = ...
          filtfilt(FIRs.Coeffs_BVP,1,data_struct{j,i}.EH.Labels.raw.bvp);
      bvp_temp    = BVP_create_signal(data_struct{j,i}.EH.Labels.raw.bvp_filt, 200);
      data_struct{j,i}.EH.Labels.raw.bvp_filt = ...
          Signal__get_raw(BVP_removebaselinewander_signal(bvp_temp,Fs));
      
      %Recovery
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
      
      bvp_temp    = BVP_create_signal(data_struct{j,i}.EH.Recovery.raw.bvp_filt, 200);
      data_struct{j,i}.EH.Recovery.raw.bvp_filt = ...
         Signal__get_raw( BVP_removebaselinewander_signal(bvp_temp,Fs));
     
     %Complete raw signals
     allraw{j}.bvp_filt=filtfilt(FIRs.Coeffs_BVP,1,allraw{j}.bvp);
     
     
         %ECG
       if(isfield(data_struct{j,i}.EH.Video.raw,'ecg'))
           
               data_struct{j,i}.EH.Video.raw.ecg_filt = ...
              filtfilt(FIRs.Coeffs_ECG_LP_V2,1,data_struct{j,i}.EH.Video.raw.ecg);
          
               data_struct{j,i}.EH.Video.raw.ecg_filt = ...
              filtfilt(FIRs.Coeffs_ECG_HP,1,data_struct{j,i}.EH.Video.raw.ecg_filt);
    %       ecg_temp    = BVP_create_signal(data_struct{j,i}.EH.Video.raw.ecg_filt, 200);
    %       data_struct{j,i}.EH.Video.raw.ecg_filt = ...
    %           Signal__get_raw(BVP_removebaselinewander_signal(ecg_temp,Fs));
               data_struct{j,i}.EH.Labels.raw.ecg_filt = ...
              filtfilt(FIRs.Coeffs_ECG_LP_V2,1,data_struct{j,i}.EH.Video.raw.ecg);
          
               data_struct{j,i}.EH.Labels.raw.ecg_filt = ...
              filtfilt(FIRs.Coeffs_ECG_HP,1,data_struct{j,i}.EH.Labels.raw.ecg_filt);
    %       ecg_temp    = BVP_create_signal(data_struct{j,i}.EH.Labels.raw.ecg_filt, 200);
    %       data_struct{j,i}.EH.Labels.raw.ecg_filt = ...
    %           Signal__get_raw(BVP_removebaselinewander_signal(ecg_temp,Fs));

          if(length(data_struct{j,i}.EH.Recovery.raw.ecg)>(3*length(FIRs.Coeffs_ECG_HP)))
               data_struct{j,i}.EH.Recovery.raw.ecg_filt = ...
              filtfilt(FIRs.Coeffs_ECG_LP_V2,1,data_struct{j,i}.EH.Recovery.raw.ecg);
          
               data_struct{j,i}.EH.Recovery.raw.ecg_filt = ...
              filtfilt(FIRs.Coeffs_ECG_HP,1,data_struct{j,i}.EH.Recovery.raw.ecg_filt);
%           elseif((length(data_struct{j,i}.EH.Recovery.raw.ecg)>(3*length(FIRs.Coeffs_BVP_smaller))))
%             data_struct{j,i}.EH.Recovery.raw.ecg_filt = ...
%               filtfilt(FIRs.Coeffs_BVP_smaller,1,data_struct{j,i}.EH.Recovery.raw.ecg);
          else
            %Not filtering provided
            data_struct{j,i}.EH.Recovery.raw.ecg_filt = smooth(data_struct{j,i}.EH.Recovery.raw.ecg,Fs/2);
          end
          
          
         if isfield(allraw{1,j},'ecg') && ~isempty(allraw{j}.ecg)
           
               allraw{j}.ecg_filt = ...
              filtfilt(FIRs.Coeffs_ECG_LP_V2,1,allraw{j}.ecg);
          
               allraw{j}.ecg_filt = ...
              filtfilt(FIRs.Coeffs_ECG_HP,1,allraw{j}.ecg_filt);
             
         end
           

          
%              figure
%              plot(data_struct{j,i}.EH.Video.raw.ecg)
%              hold on 
%              plot(data_struct{j,i}.EH.Video.raw.ecg_filt)
          
       end
      
%       ecg_temp    = BVP_create_signal(data_struct{j,i}.EH.Recovery.raw.ecg_filt, 200);
%       data_struct{j,i}.EH.Recovery.raw.ecg_filt = ...
%          Signal__get_raw( BVP_removebaselinewander_signal(ecg_temp,Fs));
     
     
      %RES
%     One second window size (from TEAP)
      windowSize = round(Fs/16);
      filtAvgEls = ones(1, windowSize)/windowSize;
      %Video
      data_struct{j,i}.EH.Video.raw.resp_filt = ...
          filtfilt(filtAvgEls,1,data_struct{j,i}.EH.Video.raw.resp);
           
      %Labels
      data_struct{j,i}.EH.Labels.raw.resp_filt = ...
          filtfilt(filtAvgEls,1,data_struct{j,i}.EH.Labels.raw.resp);
      
      %Recovery
      data_struct{j,i}.EH.Recovery.raw.resp_filt = ...
          filtfilt(filtAvgEls,1,data_struct{j,i}.EH.Recovery.raw.resp);
     
     %Complete raw signals
      allraw{j}.resp_filt = ...
          filtfilt(filtAvgEls,1,allraw{j}.resp);
      
      
      
      
            %RES
%     One second window size (from TEAP)

      %Video
      data_struct{j,i}.EH.Video.raw.resp_filt2 = ...
          filtfilt(FIRs.Coeffs_RES,1,data_struct{j,i}.EH.Video.raw.resp);
           
      %Labels
      data_struct{j,i}.EH.Labels.raw.resp_filt2 = ...
          filtfilt(FIRs.Coeffs_RES,1,data_struct{j,i}.EH.Labels.raw.resp);
      
      %Recovery
      data_struct{j,i}.EH.Recovery.raw.resp_filt2 = ...
          filtfilt(FIRs.Coeffs_RES,1,data_struct{j,i}.EH.Recovery.raw.resp);
     
     %Complete raw signals
      allraw{j}.resp_filt2 = ...
          filtfilt(FIRs.Coeffs_RES,1,allraw{j}.resp);
     
     
  
     
     
     
     
        
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
      if(length(data_struct{j,i}.EH.Recovery.raw.skt)>(3*length(FIRs.Coeffs_GSR)))
      data_struct{j,i}.EH.Recovery.raw.skt_filt = ...
          filtfilt(FIRs.Coeffs_GSR,1,data_struct{j,i}.EH.Recovery.raw.skt);
      elseif(length(data_struct{j,i}.EH.Recovery.raw.skt)>(3*length(FIRs.Coeffs_GSR_smaller)))
      data_struct{j,i}.EH.Recovery.raw.skt_filt = ...
          filtfilt(FIRs.Coeffs_GSR_smaller,1,data_struct{j,i}.EH.Recovery.raw.skt);
      else
        %Not filtering provided
      end   
	  data_struct{j,i}.EH.Recovery.raw.skt_filt_dn = ...
          downsample(data_struct{j,i}.EH.Recovery.raw.skt_filt,downsample_gsr);
      data_struct{j,i}.EH.Recovery.raw.skt_filt_dn_sm = ...
          movmedian(movmean(data_struct{j,i}.EH.Recovery.raw.skt_filt_dn,...
                           (Fs/downsample_gsr)),(Fs/downsample_gsr)/2); 
      
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


