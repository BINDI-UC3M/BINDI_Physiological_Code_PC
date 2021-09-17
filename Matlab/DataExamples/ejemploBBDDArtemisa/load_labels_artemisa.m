function result =load_labels_artemisa()


selpath = uigetdir(cd,'Script Root Folder - Select Data Folder for labels');
if selpath==0
  error("A valid folder must be specified");
end

%--------------------------------------------%
%Getting the raw data from trial's csv files
result = struct([]);


%Getting actual directories
directory_data_labels = dir(selpath);

%Taking the total number of patients based on the 
% number of subfolders within any of the main subfolders
[patients_total,~]=size(directory_data_labels);
% patients_total=6;
%WTD: check if all subfolders have the same number of patients

%The first two positions are the previous and the previous 
% of the previous folders
init_directory = 3;

%There must be a total of 4 videos for each patient
videos_total = 4;
% Setup the Import Options and import the data
variables_num = 11; %number of columns
% filetypes_str = {'V','E','D'};
% filetypes_num = size(filetypes_str,2);

% "time", "packet_id", "skt", "bvp", "gsr", "resp", "emg"
% units: ºC ,rel.int., uS,    %   ,   mV
opts = delimitedTextImportOptions("NumVariables", variables_num);
% Specify range and delimiter
opts.DataLines = [2, Inf]; %it starts in the third line
opts.Delimiter = ";";
% Specify column names and types
opts.VariableNames = ["legend", "arousal", "valence", "dominace", "liking","fam_emo","fam_situ","fam_video","emotions","intensity","recovery_time"];
opts.VariableTypes = ["char", "double", "double", "double", "char", "double", "double","char","char","double","char"];
% Specify file level properties
opts.ExtraColumnsRule = "ignore";
opts.EmptyLineRule = "read";
time_format= 'HH.mm.ss.SSS';
% Specify variable properties    
    
    for j = init_directory:patients_total-1
      

        try 
            data = readtable(strcat(directory_data_labels(j).folder,'\',directory_data_labels(j).name),opts);
        catch
            result = [];
            return;
        end
        
        result{j-init_directory+1}=data;
  
    end
%     Reorder_videos
    result=reorder_labels(result);

end


function labels_reordered= reorder_labels(in)

    %%Reorder labels

    file="orden.csv";

    %All csv files are loaded as if contains ecg signal

    % Step 0: Prepare the reading for the four file types

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

    data = readtable(file,opts);

    for loop1=1:size(data.order)

       if data.order(loop1)==2
           labels_reordered{1,loop1}=in{1,loop1};
           labels_reordered{1,loop1}(3,:)=in{1,loop1}(5,:);
           labels_reordered{1,loop1}(5,:)=in{1,loop1}(3,:);       
       else
           labels_reordered{1,loop1}=in{1,loop1};

       end


    end

end
