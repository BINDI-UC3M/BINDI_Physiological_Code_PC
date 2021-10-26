function [feat_mat,vec_video,vec_emo_binaria,indexs]=features2MatV2(in)

    n=1;
    n_vol=0;
    n_vol_past=1;
%     clear temp;
    feat_mat=[];
    exclude_vec=[1 3];
    inicio=5;
    
    [n_voluntarias,n_videos]=size(in.features);
    for voluntarias=1:n_voluntarias
        if (voluntarias~=12)&&(~ (sum(voluntarias==exclude_vec)>0))  
        for video=1:n_videos
            if(isfield(in.features{voluntarias, video},'EH'))
                indexs(voluntarias,video)=n;        
                n2=size(in.features{voluntarias, video}.EH.Video.HR_feats,1);
                vec_video(n:n2+n-1)=video;
                temp=[];
                 temp(1:n2-inicio+1,1:22)=in.features{voluntarias, video}.EH.Video.HR_feats(inicio:n2,2:23);
                 temp(1:n2-inicio+1,23:29)=in.features{voluntarias, video}.EH.Video.GSR_feats(inicio:n2,:);
                 temp(1:n2-inicio+1,30:35)=in.features{voluntarias, video}.EH.Video.SKT_feats(inicio:n2,:);
                 temp(1:n2-inicio+1,36:47)=in.features{voluntarias, video}.EH.Video.RESP_feats(inicio:n2,:);
                 feat_mat=vertcat(feat_mat,temp);
                 n=n+n2;
                 n_vol=n_vol+n2-inicio+1;

                 clear temp;
            end

        end
%             feat_mat(n_vol_past:n_vol+n_vol_past-1,:)=zscore(feat_mat(n_vol_past:n_vol+n_vol_past-1,:));
%               temp_vec_mean(,:)=mean(feat_mat(n_vol_past:n_vol+n_vol_past-1,:));
%               temp_vec_mean=zeros(n_vol,44);
              feat_mat(n_vol_past:n_vol+n_vol_past-1,:)=normalize(feat_mat(n_vol_past:n_vol+n_vol_past-1,:)); 
% %               ,'center','mean' ,'scale','std'
%              feat_mat(n_vol_past:n_vol+n_vol_past-1,:)=(feat_mat(n_vol_past:n_vol+n_vol_past-1,:)-mean(feat_mat(n_vol_past:n_vol+n_vol_past-1,:)))./mean(feat_mat(n_vol_past:n_vol+n_vol_past-1,:));
            n_vol_past=n_vol_past+n_vol;
            n_vol=0;
            
        end
    end

    for loop=1:length(vec_video)
        if vec_video(loop)==2 || vec_video(loop)==4
            vec_emo_binaria(loop)=1;
%             vec_emo_binaria_cel{loop}='Miedo';
        else
            vec_emo_binaria(loop)=0;
%             vec_emo_binaria_cel{loop}='No miedo';
        end
    end

end