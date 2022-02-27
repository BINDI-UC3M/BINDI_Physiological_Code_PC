function feat_out=prepare_feats(feat_in)

feat_select= heart_features_selections(feat_in);
n_voluntarias=21;
n_videos=4;
exclude_vec=[12];
index=1;
for k=1:n_voluntarias
    if (~ (sum(k==exclude_vec)>0))  
        
      temp_feat.features{index,:}=feat_in.features{k,:}
            
      index=index+1;
    end
    
    
end

for k=1:n_voluntarias-length(exclude_vec)
    for j=1:n_videos
        if j==1
           
            feat_out.data_in.features_windows{k,1}.BVP_features=temp_feat.features{k,j}
        else
        end
    end
end




end