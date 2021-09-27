function out_feat=fix_order_features(feat_in)


out_feat=feat_in;



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
order_array = readtable(file,opts);
order_array=order_array.order;


for loop1=2:size(order_array,1)

    if order_array(loop1)==2

        out_feat.features{loop1,2}=feat_in.features{loop1,4};
        out_feat.features{loop1,4}=feat_in.features{loop1,2};

    end


end



end