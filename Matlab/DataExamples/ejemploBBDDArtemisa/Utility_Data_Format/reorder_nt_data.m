%%Reorder NTs data

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
resultados_nt_reordered_v1=resultados_nt;
for loop1=1:size(data.order)
    
   if data.order(loop1)==2
      
       
       resultados_nt_reordered_v1{1,loop1}(2:6,:)=resultados_nt{1,loop1}(12:16,:);       
       resultados_nt_reordered_v1{1,loop1}(12:16,:)=resultados_nt{1,loop1}(2:6,:);

       
   end
    
    
end

clear loop1 data opts variables_num voluntarias_num file