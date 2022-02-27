function features_norm=norm_phy_features(features_in,type,physio_sig)
field_s=sprintf('%s_feats',physio_sig);
field_s_names=sprintf('%s_feats_names',physio_sig);
[n_voluntarias, n_videos]=size(features_in.features);


    for voluntaria=1:n_voluntarias
    pos_v(1:5)=0;
%     pos_v(1)=1;
    n_data=1;
    pos_v_prev=0;
    temp_features=[];
    vec_videos=[];
        for loop=1:n_videos
            
              features_norm.features{voluntaria,loop}.EH.Video.(field_s_names)= ...
              features_in.features{voluntaria,loop}.EH.Video.(field_s_names);
          
            if(~ isempty(features_in.features{voluntaria,loop}.EH.Video.(field_s)))
              pos_v(n_data+1)=length(features_in.features{voluntaria,loop}.EH.Video.(field_s)(:,1)')+pos_v_prev;
              pos_v_prev=pos_v(n_data+1);                
              vec_videos(n_data)=loop;
              n_data=n_data+1;
              temp_features=vertcat(temp_features,features_in.features{voluntaria,loop}.EH.Video.(field_s)(:,1:23));
%               temp_features=vertcat(temp_features,features_in.features{voluntaria,loop}.EH.Video.(field_s)(:,:));
              

%             pos_v1=length(features_in.features{voluntaria,1}.EH.Video.(field_s)(:,1)');
%             pos_v2=length(features_in.features{voluntaria,2}.EH.Video.(field_s)(:,1)')+pos_v1;
%             pos_v3=length(features_in.features{voluntaria,3}.EH.Video.(field_s)(:,1)')+pos_v2;
%             pos_v4=length(features_in.features{voluntaria,4}.EH.Video.(field_s)(:,1)')+pos_v3;
            else
              features_norm.features{voluntaria,loop}.EH.Video.(field_s)= [];
              
          

            end
%             temp_features=vertcat(temp_features,features_in.features{voluntaria,1}.EH.Video.(field_s), ...
%                  features_in.features{voluntaria,2}.EH.Video.(field_s), ...
%                  features_in.features{voluntaria,3}.EH.Video.(field_s), ...
%                  features_in.features{voluntaria,4}.EH.Video.(field_s));
%             end
             
        end
        
        if strcmp(type,'zscore')
            temp_features_norm=zscore(temp_features);
        elseif strcmp(type,'mean')
            mean_vec=mean(temp_features);
            temp_features_norm=(temp_features-mean_vec)./mean_vec;
        end
        for loop2=1:n_data-1    
            features_norm.features{voluntaria,vec_videos(loop2)}.EH.Video.(field_s)=temp_features_norm(pos_v(loop2)+1:pos_v(loop2+1),:);
%             features_norm.features{voluntaria,1}.EH.Video.(field_s)=temp_features_norm(1:pos_v1,:);
%             features_norm.features{voluntaria,2}.EH.Video.(field_s)=temp_features_norm(pos_v1+1:pos_v2,:);
%             features_norm.features{voluntaria,3}.EH.Video.(field_s)=temp_features_norm(pos_v2+1:pos_v3,:);
%             features_norm.features{voluntaria,4}.EH.Video.(field_s)=temp_features_norm(pos_v3+1:pos_v4,:);
        end

    end
end