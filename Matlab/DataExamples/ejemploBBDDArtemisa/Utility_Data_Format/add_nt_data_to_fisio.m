

n_videos=4;
n_subjects=11;
n_sample_per_video=5;
for i=1:n_subjects
    
    for j=1:n_videos
        if(j==1)
            out_struct{i,j}.NT.da=resultados_nt_temp{i}(1,1);
            out_struct{i,j}.NT.na=resultados_nt_temp{i}(1,2);
            out_struct{i,j}.NT.a=resultados_nt_temp{i}(1,3);
        else
%             for loop3=1:n_sample_per_video
                n_sample_per_video*(j-2)+2
                n_sample_per_video*(j-1)+1
                out_struct{i,j}.NT.da=resultados_nt_temp{i}(n_sample_per_video*(j-2)+2:n_sample_per_video*(j-1)+1,1);
                out_struct{i,j}.NT.na=resultados_nt_temp{i}(n_sample_per_video*(j-2)+2:n_sample_per_video*(j-1)+1,2);
                out_struct{i,j}.NT.a=resultados_nt_temp{i}(n_sample_per_video*(j-2)+2:n_sample_per_video*(j-1)+1,3);
%             end
        end
    end

end

