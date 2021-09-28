n=1;
clear temp;
for voluntarias=1:21
    for video=1:4
        if(isfield(features.features{voluntarias, video},'EH'))
            indexs(voluntarias,video)=n;        
            n2=size(features.features{voluntarias, video}.EH.Video.BVP_feats,1);
            temp(1:n2,1:24)=features.features{voluntarias, video}.EH.Video.BVP_feats;
            temp(1:n2,25:44)=features.features{voluntarias, video}.EH.Video.GSR_feats;
            feat_mat=vertcat(feat_mat,temp);
             n=n+n2;
            indexs_gsr(voluntarias,video)=n;
%             n3=size(features.features{voluntarias, video}.EH.Video.GSR_feats,1);
%             feat_mat(n:n2,25:44)=features.features{voluntarias, video}.EH.Video.GSR_feats;
%             n=n+n3;
            clear temp;
        end
    end
end