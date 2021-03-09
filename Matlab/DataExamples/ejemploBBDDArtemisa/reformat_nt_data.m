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

for loop1=1:size(data.order)
    
   if data.order==2
      
       resultados_nt_reordered(1,loop1).da=resultados_nt{1,loop1}(1,1);
       resultados_nt_reordered(2,loop1).da=resultados_nt{1,loop1}(12:16,1);
       resultados_nt_reordered(3,loop1).da=resultados_nt{1,loop1}(7:11,1);
       resultados_nt_reordered(4,loop1).da=resultados_nt{1,loop1}(2:6,1);
       
       resultados_nt_reordered(1,loop1).na=resultados_nt{1,loop1}(1,2);
       resultados_nt_reordered(2,loop1).na=resultados_nt{1,loop1}(12:16,2);
       resultados_nt_reordered(3,loop1).na=resultados_nt{1,loop1}(7:11,2);
       resultados_nt_reordered(4,loop1).na=resultados_nt{1,loop1}(2:6,2);
       
       resultados_nt_reordered(1,loop1).a=resultados_nt{1,loop1}(1,3);
       resultados_nt_reordered(2,loop1).a=resultados_nt{1,loop1}(12:16,3);
       resultados_nt_reordered(3,loop1).a=resultados_nt{1,loop1}(7:11,3);
       resultados_nt_reordered(4,loop1).a=resultados_nt{1,loop1}(2:6,3);
       
       resultados_nt_reordered(1,loop1).hemolizado=resultados_nt{1,loop1}(1,4);
       resultados_nt_reordered(2,loop1).hemolizado=resultados_nt{1,loop1}(12:16,4);
       resultados_nt_reordered(3,loop1).hemolizado=resultados_nt{1,loop1}(7:11,4);
       resultados_nt_reordered(4,loop1).hemolizado=resultados_nt{1,loop1}(2:6,4);
       
   else
       
       resultados_nt_reordered(1,loop1).da=resultados_nt{1,loop1}(1,1);
       resultados_nt_reordered(2,loop1).da=resultados_nt{1,loop1}(2:6,1);
       resultados_nt_reordered(3,loop1).da=resultados_nt{1,loop1}(7:11,1);
       resultados_nt_reordered(4,loop1).da=resultados_nt{1,loop1}(12:16,1);
       
       resultados_nt_reordered(1,loop1).na=resultados_nt{1,loop1}(1,2);
       resultados_nt_reordered(2,loop1).na=resultados_nt{1,loop1}(2:6,2);
       resultados_nt_reordered(3,loop1).na=resultados_nt{1,loop1}(7:11,2);
       resultados_nt_reordered(4,loop1).na=resultados_nt{1,loop1}(12:16,2);
       
       resultados_nt_reordered(1,loop1).a=resultados_nt{1,loop1}(1,3);
       resultados_nt_reordered(2,loop1).a=resultados_nt{1,loop1}(2:6,3);
       resultados_nt_reordered(3,loop1).a=resultados_nt{1,loop1}(7:11,3);
       resultados_nt_reordered(4,loop1).a=resultados_nt{1,loop1}(12:16,3);
       
       resultados_nt_reordered(1,loop1).hemolizado=resultados_nt{1,loop1}(1,4);
       resultados_nt_reordered(2,loop1).hemolizado=resultados_nt{1,loop1}(2:6,4);
       resultados_nt_reordered(3,loop1).hemolizado=resultados_nt{1,loop1}(7:11,4);
       resultados_nt_reordered(4,loop1).hemolizado=resultados_nt{1,loop1}(12:16,4);
       
   end
    
    
end