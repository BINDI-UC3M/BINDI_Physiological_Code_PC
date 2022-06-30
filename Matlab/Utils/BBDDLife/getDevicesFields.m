function [field_pulsera,field_colgante]=getDevicesFields(in_struct)
    
       fields=fieldnames(in_struct);
       if(isfield(in_struct.(fields{1}),'AUDIO')) 
           field_colgante=fields{1};
       elseif (isfield(in_struct.(fields{2}),'AUDIO')) 
           field_colgante=fields{2};
       elseif (isfield(in_struct.(fields{3}),'AUDIO')) 
           field_colgante=fields{3};
       end

       if(isfield(in_struct.(fields{1}),'SKT')) 
           field_pulsera=fields{1};
       elseif (isfield(in_struct.(fields{2}),'SKT')) 
           field_pulsera=fields{2};
       elseif (isfield(in_struct.(fields{3}),'SKT')) 
           field_pulsera=fields{3};
       end

end