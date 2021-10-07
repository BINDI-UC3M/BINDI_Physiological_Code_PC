function feat_out= heart_features_selections(feat_in)

 s=load('mat_selecion_var_pulso.mat');
 s=s.mat_seleccion_var_pulso;
 [n_voluntarias,n_videos]=size(feat_in.features);
 
 for loop1= 1 : n_voluntarias
     for loop2= 1 : n_videos
         
            feat_out.features{loop1,loop2}=feat_in.features{loop1,loop2};
%             feat_out.features{loop1,loop2}.EH.Video.GSR_feats_names=feat_in.features{loop1,loop2}.EH.Video.GSR_feats_names;
         if(strcmp(s{loop2,loop1},'bvp'))
            feat_out.features{loop1,loop2}.EH.Video.HR_feats_names=feat_in.features{loop1,loop2}.EH.Video.BVP_feats_names;
            feat_out.features{loop1,loop2}.EH.Video.HR_feats=feat_in.features{loop1,loop2}.EH.Video.BVP_feats;
              feat_out.features{loop1,loop2}.EH.Video.HR_feats_source={'bvp'};
              feat_out.features{loop1,loop2}.EH.Video.IBI=feat_out.features{loop1,loop2}.EH.Video.BVP_IBI;
            
         elseif (strcmp(s{loop2,loop1},'ecg'))
             
            feat_out.features{loop1,loop2}.EH.Video.HR_feats_names=feat_in.features{loop1,loop2}.EH.Video.ECG_feats_names;
            feat_out.features{loop1,loop2}.EH.Video.HR_feats=feat_in.features{loop1,loop2}.EH.Video.ECG_feats;
              feat_out.features{loop1,loop2}.EH.Video.HR_feats_source={'ecg'};
              feat_out.features{loop1,loop2}.EH.Video.IBI=feat_out.features{loop1,loop2}.EH.Video.ECG_IBI;
         else
              feat_out.features{loop1,loop2}.EH.Video.HR_feats_names=[];
            feat_out.features{loop1,loop2}.EH.Video.HR_feats=[];
         
         end

     end
 end
 
 
end