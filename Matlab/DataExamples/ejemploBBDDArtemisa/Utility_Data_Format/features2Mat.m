function [feat_mat,vec_video,vec_emo_binaria,indexs]=features2Mat(in)

    n=1;
    n_vol=0;
    n_vol_past=1;
%     clear temp;
    feat_mat=[];
    
    [n_voluntarias,n_videos]=size(in.features);
    for voluntarias=1:n_voluntarias
        for video=1:n_videos
            if(isfield(in.features{voluntarias, video},'EH'))
                indexs(voluntarias,video)=n;        
                n2=size(in.features{voluntarias, video}.EH.Video.BVP_feats,1);
                vec_video(n:n2+n-1)=video;
                 temp(1:n2,1:24)=in.features{voluntarias, video}.EH.Video.BVP_feats;
                 temp(1:n2,25:44)=in.features{voluntarias, video}.EH.Video.GSR_feats;
                 feat_mat=vertcat(feat_mat,temp);
                 n=n+n2;
                 n_vol=n_vol+n2;

                 clear temp;
            end

        end
%             feat_mat(n_vol_past:n_vol+n_vol_past-1,:)=zscore(feat_mat(n_vol_past:n_vol+n_vol_past-1,:));
%               temp_vec_mean(,:)=mean(feat_mat(n_vol_past:n_vol+n_vol_past-1,:));
              temp_vec_mean=zeros(n_vol,44);
              feat_mat(n_vol_past:n_vol+n_vol_past-1,:)=normalize(feat_mat(n_vol_past:n_vol+n_vol_past-1,:)); 
%               ,'center','mean' ,'scale','std'
%              feat_mat(n_vol_past:n_vol+n_vol_past-1,:)=(feat_mat(n_vol_past:n_vol+n_vol_past-1,:)-mean(feat_mat(n_vol_past:n_vol+n_vol_past-1,:)))./mean(feat_mat(n_vol_past:n_vol+n_vol_past-1,:));
            n_vol_past=n_vol_past+n_vol;
            n_vol=0;
    end

    for loop=1:length(vec_video)
        if vec_video(loop)==2 || vec_video(loop)==4
            vec_emo_binaria(loop)=1;
%             vec_emo_binaria_cel{loop}='Miedo';
        else
            vec_emo_binaria(loop)=1;
%             vec_emo_binaria_cel{loop}='No miedo';
        end
    end

end