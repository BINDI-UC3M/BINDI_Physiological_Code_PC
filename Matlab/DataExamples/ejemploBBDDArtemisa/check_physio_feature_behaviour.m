
function out_vec = check_physio_feature_behaviour(features_in)

%  field_s=sprintf('%s_feats',physio_sig);
%  field_s_names=sprintf('%s_feats_names',physio_sig);

field_s='HR_feats';
n_feat=4;



[n_voluntarias, n_videos]=size(features_in.features);
n_correct=0;
n_correct2=0;
n_correct3=0;

    for voluntaria=1:n_voluntarias
        if(~ isempty(features_in.features{voluntaria,1}.EH.Video.(field_s)))
            v1_value=median(features_in.features{voluntaria,1}.EH.Video.(field_s)(:,n_feat));
            v2_value=median(features_in.features{voluntaria,2}.EH.Video.(field_s)(:,n_feat));
            v3_value=median(features_in.features{voluntaria,3}.EH.Video.(field_s)(:,n_feat));
            v4_value=median(features_in.features{voluntaria,4}.EH.Video.(field_s)(:,n_feat));
%             disp(voluntaria)
            if v1_value>v2_value && v1_value>v4_value && ...
                    v3_value>v2_value && v3_value>v4_value
                    n_correct=n_correct+1;
                out_vec(n_correct)=voluntaria;            
            end
            
            if v1_value>v2_value && v1_value>v4_value
                   
                   n_correct2=n_correct2+1;
                out_vec_v1(n_correct2)=voluntaria;            
            end   
            
            if v3_value>v2_value && v3_value>v4_value
                n_correct3=n_correct3+1;
                out_vec_v3(n_correct3)=voluntaria;            
            end
        end
        
    end



end