




[max_val , max_index]=max(resultados_nt{i}(2+5*(k-2):1+5*(k-1),1));
[min_val , min_index]=min(resultados_nt{i}(2+5*(k-2):1+5*(k-1),1));
n_trails=4;
for i=1:21
    for k=2:n_trails
        
        [max_val , max_index]=max(resultados_nt{i}(2+5*(k-2):1+5*(k-1),1));
        [min_val , min_index]=min(resultados_nt{i}(2+5*(k-2):1+5*(k-1),1));
        
        if(min_index<max_index)
            feat_catecolaminas(i,k,1)=max_val-min_val;
        else        
            feat_catecolaminas(i,k,1)=-1*(max_val-min_val);
        end
        
         [max_val , max_index]=max(resultados_nt{i}(2+5*(k-2):1+5*(k-1),2));
        [min_val , min_index]=min(resultados_nt{i}(2+5*(k-2):1+5*(k-1),2));
        
        if(min_index<max_index)
            feat_catecolaminas(i,k,2)=max_val-min_val;
        else        
            feat_catecolaminas(i,k,2)=-1*(max_val-min_val);
        end
        
        [max_val , max_index]=max(resultados_nt{i}(2+5*(k-2):1+5*(k-1),3));
        [min_val , min_index]=min(resultados_nt{i}(2+5*(k-2):1+5*(k-1),3));
        
        if(min_index<max_index)
            feat_catecolaminas(i,k,3)=max_val-min_val;
        else        
            feat_catecolaminas(i,k,3)=-1*(max_val-min_val);
        end

    end

end
    temp_cat_1=max(resultados_nt{i}(2+5*(k-2):1+5*(k-1),3))-min(resultados_nt{i}(2+5*(k-2):1+5*(k-1),1));
          temp_cat_2=max(resultados_nt{i}(2+5*(k-2):1+5*(k-1),3))-min(resultados_nt{i}(2+5*(k-2):1+5*(k-1),2));
          temp_cat_3=max(resultados_nt{i}(2+5*(k-2):1+5*(k-1),3))-min(resultados_nt{i}(2+5*(k-2):1+5*(k-1),3));