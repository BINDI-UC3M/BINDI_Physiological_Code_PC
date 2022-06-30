


data_path='G:\Mi unidad\Investigacion\Empatia\Objetivo_3\test';

[out_label_t,out_data_t,date_array]=load_data_BBDD_life(data_path);

result = BBDD_live_timeline(out_data_t,out_label_t);
%Getting actual directories
% directory_data = dir(data_path);
% temp=struct2table(directory_data);
% temp = sortrows(temp,1);
% directory_data =table2struct(temp);
% %Taking the total number of patients based on the 
% % number of subfolders within any of the main subfolders
% [num_file,~]=size(directory_data);
% 
% 
% %The first two positions are the previous and the previous 
% % of the previous folders
% init_directory = 1;

% out_label_t=table();
% field_pulsera=0;
% field_colgante=0;
% vol_name=0;
% first_file=1;
% out_timestamp=[];
% index_file=0;
% for j = init_directory:num_file
%     
%     [out_label_t,out_data_t,date_array]=load_data_BBDD_life(data_path);
%     
% end