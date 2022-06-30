
function [out_label_t,out_data_t,date_array]=load_data_BBDD_life(data_path)


%--------------------------------------------%
%Getting the raw data from trial's csv files
out_struct = struct([]);

%Getting the path directory for each wanted folder
% and checking its existence

if ~exist(data_path)
  error("No existe el directorio");
end

%Getting actual directories
directory_data = dir(data_path);
temp=struct2table(directory_data);
temp = sortrows(temp,1);
directory_data =table2struct(temp);
%Taking the total number of patients based on the 
% number of subfolders within any of the main subfolders
[num_file,~]=size(directory_data);


%The first two positions are the previous and the previous 
% of the previous folders
init_directory = 1;

out_label_t=table();
field_pulsera=0;
field_colgante=0;
vol_name=0;
first_file=1;
out_timestamp=[];
index_file=0;
for j = init_directory:num_file
    
    if(not(directory_data(j).isdir))
        index_file=index_file+1;
        overlap=0;
        splited_name=split(directory_data(j).name,'_');
        
%       Calculo de las fechas de inicio y fin del fichero
        temp_init_date= datenum(splited_name(2),'yyyy-mm-ddTHH-MM-SS');
        temp_end_date= datenum(splited_name(4),'yyyy-mm-ddTHH-MM-SS');
        date_array(index_file,1)=datetime(temp_init_date,'ConvertFrom','datenum');
        date_array(index_file,2)=datetime(temp_end_date,'ConvertFrom','datenum'); 

        load(strcat(directory_data(j).folder,'\',directory_data(j).name))
        
        if(first_file)
            first_file=0;
            vol_name=splited_name{1};            
            [field_pulsera,field_colgante]=getDevicesFields(out_data);
            out_data_t=out_data;
            out_data_t.idVoluntaria=vol_name;
%             out_data_t.(field_pulsera).idDevice=field_pulsera;
%             out_data_t.(field_colgante).idDevice=field_colgante;
            out_label_t=out_labels;
            
            fprintf('Voluntaria: %s\nPulsera: %s Colgante %s\n',vol_name,field_pulsera,field_colgante)
        else
            if(vol_name~=splited_name{1})
                error('Archivos de diferentes voluntarias')
            end
            
            [temp_field_pulsera,temp_field_colgante]=getDevicesFields(out_data);
            
            if(field_pulsera~=temp_field_pulsera)
                error('Diferente pulseras detectadas')
            end
            if(field_colgante~=temp_field_colgante)
                error('Diferente colgantes detectadas')
            end
            
            if( date_array(index_file-1,2)<date_array(index_file,1) )
                warning('Faltan datos')
            end
            
            if( date_array(index_file-1,2)>date_array(index_file,1) )
                overlap=1;
                disp('Los archivos solapan')
            end
            
            out_label_t=[out_label_t;out_labels];
            out_label_t=unique(out_label_t);


            if(overlap)
                out_data_t=concatPhyData(out_data,out_data_t,field_pulsera,date_array(index_file-1,2),0);
                out_data_t=concatPendantData(out_data,out_data_t,field_colgante,date_array(index_file-1,2),0);
            else            
                out_data_t=concatPhyData(out_data,out_data_t,field_pulsera,0,0);
                out_data_t=concatPendantData(out_data,out_data_t,field_colgante,0,0);

            end 
             
             
             
        end
        

        
        

        
        
%         if(out_data.(field_pulsera).SKT.timestamp(1)>out_timestamp(end))
%             index=find(out_data.FC20BA58EA12.SKT.timestamp==out_timestamp(end));
%             out_timestamp=[out_timestamp,out_data.(field_pulsera).SKT.timestamp(index(1))];
%         else
%             out_timestamp=[out_timestamp,out_data.(field_pulsera).SKT.timestamp];
%         end
    end
    
end


end


function out_struct=concatData(origin_struct,dest_struct,device,field,subfield,initDate,endDate)
    
    if(strcmp(subfield,''))
        subfield=lower(field);
    end
    if(initDate==0)
        indice_inicio=1;
    else      
        indice_inicio=find(origin_struct.(device).(field).timestamp<=initDate);
        indice_inicio=indice_inicio(1);
    end
    
    if(endDate==0)
        indice_fin=length(origin_struct.(device).(field).timestamp);
    else
        indice_fin=find(origin_struct.(device).(field).timestamp>=endDate);
        indice_fin=indice_fin(end);
    end
    
    
    out_struct=dest_struct;
    out_struct.(device).(field).(subfield)=[out_struct.(device).(field).(subfield); origin_struct.(device).(field).(subfield)(indice_inicio:indice_fin)];
    out_struct.(device).(field).timestamp=[out_struct.(device).(field).timestamp; origin_struct.(device).(field).timestamp(indice_inicio:indice_fin)];

end

function out_struct=concatPhyData(origin_struct,dest_struct,device,initDate,endDate)

    out_struct=dest_struct;
    out_struct=concatData(origin_struct,out_struct,device,'SKT','',initDate,endDate);
    out_struct=concatData(origin_struct,out_struct,device,'GSR','',initDate,endDate);
    out_struct=concatData(origin_struct,out_struct,device,'HR','',initDate,endDate);
    out_struct=concatData(origin_struct,out_struct,device,'COUNT','',initDate,endDate);
    out_struct=concatData(origin_struct,out_struct,device,'LOGS','',initDate,endDate);
    out_struct=concatData(origin_struct,out_struct,device,'BATT','',initDate,endDate);
    out_struct=concatData(origin_struct,out_struct,device,'ACC','ACCX',initDate,endDate);
    out_struct=concatData(origin_struct,out_struct,device,'ACC','ACCY',initDate,endDate);
    out_struct=concatData(origin_struct,out_struct,device,'ACC','ACCZ',initDate,endDate);
    
end

function out_struct=concatPendantData(origin_struct,dest_struct,device,initDate,endDate)

    out_struct=dest_struct;
    out_struct=concatData(origin_struct,out_struct,device,'AUDIO','',initDate,endDate);
    out_struct=concatData(origin_struct,out_struct,device,'LOGS','',initDate,endDate);
    out_struct=concatData(origin_struct,out_struct,device,'BATT','',initDate,endDate);

    
end

















