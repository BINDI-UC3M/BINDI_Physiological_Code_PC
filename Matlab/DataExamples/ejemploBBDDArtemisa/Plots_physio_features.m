
function Plots_physio_features(features_in)

% Plots gsr
voluntaria=1
features_in=features_gsr_cvx;

for voluntaria=1:21
    
    pos_v1=length(features_in.features{voluntaria,1}.EH.Video.GSR_feats(:,1)');
    pos_v2=length(features_in.features{voluntaria,2}.EH.Video.GSR_feats(:,1)')+pos_v1;
    pos_v3=length(features_in.features{voluntaria,3}.EH.Video.GSR_feats(:,1)')+pos_v2;
    pos_v4=length(features_in.features{voluntaria,4}.EH.Video.GSR_feats(:,1)')+pos_v3;
    
    temp_features=[features_in.features{voluntaria,1}.EH.Video.GSR_feats; ...
         features_in.features{voluntaria,2}.EH.Video.GSR_feats;...
         features_in.features{voluntaria,3}.EH.Video.GSR_feats;...
         features_in.features{voluntaria,4}.EH.Video.GSR_feats];
     
    temp_features_norm=zscore(temp_features);
    
    features_norm.features{voluntaria,1}.EH.Video.GSR_feats=temp_features_norm(1:pos_v1,:);
    features_norm.features{voluntaria,2}.EH.Video.GSR_feats=temp_features_norm(pos_v1+1:pos_v2,:);
    features_norm.features{voluntaria,3}.EH.Video.GSR_feats=temp_features_norm(pos_v2+1:pos_v3,:);
    features_norm.features{voluntaria,4}.EH.Video.GSR_feats=temp_features_norm(pos_v3+1:pos_v4,:);
     

end
% features_s=features_norm;
features_s=features_in;
for voluntaria=1:21
    
        
        temp_sig=[ features_s.features{voluntaria,1}.EH.Video.GSR_feats(:,1)' ...
        features_s.features{voluntaria,2}.EH.Video.GSR_feats(:,1)'...
        features_s.features{voluntaria,3}.EH.Video.GSR_feats(:,1)'...
        features_s.features{voluntaria,4}.EH.Video.GSR_feats(:,1)'];
        
        pos_v1=length(features_s.features{voluntaria,1}.EH.Video.GSR_feats(:,1));
        pos_v2=length(features_s.features{voluntaria,2}.EH.Video.GSR_feats(:,1))+pos_v1;
        pos_v3=length(features_s.features{voluntaria,3}.EH.Video.GSR_feats(:,1))+pos_v2;
        pos_v4=length(features_s.features{voluntaria,4}.EH.Video.GSR_feats(:,1))+pos_v3;
        
        temp_video_index=cell(size(temp_sig));
        temp_video_index(1:pos_v1)={['Relax - ' labels_reordered{voluntaria}.emotions{2}]};
        temp_video_index(pos_v1+1:pos_v2)={['VG - ' labels_reordered{voluntaria}.emotions{3}]};
        temp_video_index(pos_v2+1:pos_v3)={['Alegria - ' labels_reordered{voluntaria}.emotions{4}]};
        temp_video_index(pos_v3+1:pos_v4)={['Miedo - ' labels_reordered{voluntaria}.emotions{5}]};
        
%                 temp_video_index(pos_v1+1:pos_v2)={'Miedo VG'};
%         temp_video_index(pos_v2+1:pos_v3)={'Alegria'};
%         temp_video_index(pos_v3+1:pos_v4)={'Miedo no VG'}
    
       h(voluntaria)=figure
       boxplot(temp_sig,temp_video_index);
       title(sprintf('Voluntaria:%i Numero de picos de GSR',voluntaria));
       xlabel('Video')
       ylabel('Picos por segundo')
       
       if voluntaria==1 
            temp_sig_total=temp_sig;
            temp_video_index_total=temp_video_index;
       else
           temp_sig_total=horzcat(temp_sig_total,temp_sig);
           temp_video_index_total=horzcat(temp_video_index_total,temp_video_index);
       end
    
    
end

    figure
    boxplot(temp_sig_total,temp_video_index_total);
    title(sprintf('Todas las voluntarias Numero de picos de GSR'));
    xlabel('Video')
    ylabel('Picos por segundo')
    
   savefig(h,'Figuras_n_picos_GSR_todas_voluntarias.fig')

   
   
   
   
%    features_s=features_norm;
  features_s=features_in;
   for voluntaria=1:21
    
        
        temp_sig=[ features_s.features{voluntaria,1}.EH.Video.GSR_feats(:,6)' ...
        features_s.features{voluntaria,2}.EH.Video.GSR_feats(:,6)'...
        features_s.features{voluntaria,3}.EH.Video.GSR_feats(:,6)'...
        features_s.features{voluntaria,4}.EH.Video.GSR_feats(:,6)'];
        
        pos_v1=length(features_s.features{voluntaria,1}.EH.Video.GSR_feats(:,6));
        pos_v2=length(features_s.features{voluntaria,2}.EH.Video.GSR_feats(:,6))+pos_v1;
        pos_v3=length(features_s.features{voluntaria,3}.EH.Video.GSR_feats(:,6))+pos_v2;
        pos_v4=length(features_s.features{voluntaria,4}.EH.Video.GSR_feats(:,6))+pos_v3;
        
%         temp_video_index=cell(size(temp_sig));
%         temp_video_index(1:pos_v1)={'Tranquilidad'};
%         temp_video_index(pos_v1+1:pos_v2)={'Miedo VG'};
%         temp_video_index(pos_v2+1:pos_v3)={'Alegria'};
%         temp_video_index(pos_v3+1:pos_v4)={'Miedo no VG'};
        temp_video_index=cell(size(temp_sig));
        temp_video_index(1:pos_v1)={['Relax - ' labels_reordered{voluntaria}.emotions{2}]};
        temp_video_index(pos_v1+1:pos_v2)={['VG - ' labels_reordered{voluntaria}.emotions{3}]};
        temp_video_index(pos_v2+1:pos_v3)={['Alegria - ' labels_reordered{voluntaria}.emotions{4}]};
        temp_video_index(pos_v3+1:pos_v4)={['Miedo - ' labels_reordered{voluntaria}.emotions{5}]};
    
       h(voluntaria)=figure
       boxplot(temp_sig,temp_video_index);
       title(sprintf('Voluntaria:%i Media del GSR',voluntaria));
       xlabel('Video')
       ylabel('Conductividad[uS]')
       
       if voluntaria==1 
            temp_sig_total=temp_sig;
            temp_video_index_total=temp_video_index;
       else
           temp_sig_total=horzcat(temp_sig_total,temp_sig);
           temp_video_index_total=horzcat(temp_video_index_total,temp_video_index);
       end
    
    
    end

    figure
    boxplot(temp_sig_total,temp_video_index_total);
    title(sprintf('Todas las voluntarias Media del GSR'));
    xlabel('Video')
    ylabel('Conductividad[uS]')
    
   savefig(h,'Figuras_media_GSR_todas_voluntarias.fig')
   
   
   
for voluntaria=1:21
    
        
        temp_sig=[ features_s.features{voluntaria,1}.EH.Video.GSR_feats(:,1)' ...
            features_s.features{voluntaria,1}.EH.Labels.GSR_feats(:,1)' ...
            features_s.features{voluntaria,1}.EH.Recovery.GSR_feats(:,1)' ...
        features_s.features{voluntaria,2}.EH.Video.GSR_feats(:,1)'...
        features_s.features{voluntaria,2}.EH.Labels.GSR_feats(:,1)' ...
        features_s.features{voluntaria,2}.EH.Recovery.GSR_feats(:,1)' ...
        features_s.features{voluntaria,3}.EH.Video.GSR_feats(:,1)'...
        features_s.features{voluntaria,3}.EH.Labels.GSR_feats(:,1)' ...
        features_s.features{voluntaria,3}.EH.Recovery.GSR_feats(:,1)' ...
        features_s.features{voluntaria,4}.EH.Video.GSR_feats(:,1)' ...
        features_s.features{voluntaria,4}.EH.Labels.GSR_feats(:,1)' ...
            features_s.features{voluntaria,4}.EH.Recovery.GSR_feats(:,1)' ]
        
        pos_v1=length(features_s.features{voluntaria,1}.EH.Video.GSR_feats(:,6));
        pos_v2=length(features_s.features{voluntaria,2}.EH.Video.GSR_feats(:,6))+pos_v1;
        pos_v3=length(features_s.features{voluntaria,3}.EH.Video.GSR_feats(:,6))+pos_v2;
        pos_v4=length(features_s.features{voluntaria,4}.EH.Video.GSR_feats(:,6))+pos_v3;
        
%         temp_video_index=[length(features_s.features{voluntaria,1}.EH.Video.GSR_feats(:,1)) ...
%             length(features_s.features{voluntaria,1}.EH.Labels.GSR_feats(:,1)) ...
%             length(features_s.features{voluntaria,1}.EH.Recovery.GSR_feats(:,1)) ...
%         length(features_s.features{voluntaria,2}.EH.Video.GSR_feats(:,1))...
%         length(features_s.features{voluntaria,2}.EH.Labels.GSR_feats(:,1)) ...
%             length(features_s.features{voluntaria,2}.EH.Recovery.GSR_feats(:,1)) ...
%         length(features_s.features{voluntaria,3}.EH.Video.GSR_feats(:,1))...
%         length(features_s.features{voluntaria,3}.EH.Labels.GSR_feats(:,1)) ...
%             length(features_s.features{voluntaria,3}.EH.Recovery.GSR_feats(:,1)) ...
%         length(features_s.features{voluntaria,4}.EH.Video.GSR_feats(:,1))...
%         length(features_s.features{voluntaria,4}.EH.Labels.GSR_feats(:,1)) ...
%             length(features_s.features{voluntaria,4}.EH.Recovery.GSR_feats(:,1))];
        
%         temp_video_index=cell(size(temp_sig));
%         temp_video_index(1:pos_v1)={'Tranquilidad'};
%         temp_video_index(pos_v1+1:pos_v2)={'Miedo VG'};
%         temp_video_index(pos_v2+1:pos_v3)={'Alegria'};
%         temp_video_index(pos_v3+1:pos_v4)={'Miedo no VG'};
    
       h(voluntaria)=figure
       plot(temp_sig);
       hold on
       plot(temp_video_index,temp_sig(temp_video_index),'r*')
       title(sprintf('Voluntaria:%i Evolucion del numero de picos del GSR',voluntaria));
       xlabel('Numero de muestra')
       ylabel('Picos por segundo')
       
       if voluntaria==1 
            temp_sig_total=temp_sig;
            temp_video_index_total=temp_video_index;
       else
           temp_sig_total=horzcat(temp_sig_total,temp_sig);
           temp_video_index_total=horzcat(temp_video_index_total,temp_video_index);
       end
    
    
end

    figure
    boxplot(temp_sig_total,temp_video_index_total);
    title(sprintf('Todas las voluntarias Numero de picos de GSR'));
    xlabel('Video')
    ylabel('Picos por segundo')
    
   savefig(h,'Figuras_n_picos_GSR_todas_voluntarias.fig')

% for voluntaria=1:length(features_gsr)
% 
%     if isfield(allraw{1,voluntaria},'ecg') && ~isempty(allraw{1,voluntaria}.ecg)
%         num_var=6;
%     else
%         num_var=5;
%     end
%     ax=0;
%     figure
%     ax(1)=subplot(num_var,1,1);
%     plot(allraw{1,voluntaria}.gsr_uS)
%     hold on
%     plot(allraw{1,voluntaria}.index,allraw{1,voluntaria}.gsr_uS(allraw{1,voluntaria}.index),'*r')
%     
%     ax(2)=subplot(num_var,1,2);
%     plot(allraw{1,voluntaria}.resp)
%      hold on
%     plot(allraw{1,voluntaria}.index,allraw{1,voluntaria}.resp(allraw{1,voluntaria}.index),'*r')
%     
%     
%     ax(3)=subplot(num_var,1,3);
%     plot(allraw{1,voluntaria}.emg)
%      hold on
%     plot(allraw{1,voluntaria}.index,allraw{1,voluntaria}.emg(allraw{1,voluntaria}.index),'*r')
%     
%     
%     ax(4)=subplot(num_var,1,4);
%     plot(allraw{1,voluntaria}.skt)
%      hold on
%     plot(allraw{1,voluntaria}.index,allraw{1,voluntaria}.skt(allraw{1,voluntaria}.index),'*r')
%     
%     
%     ax(5)=subplot(num_var,1,5);
%     plot(allraw{1,voluntaria}.bvp)
%      hold on
%     plot(allraw{1,voluntaria}.index,allraw{1,voluntaria}.bvp(allraw{1,voluntaria}.index),'*r')
%     
%     
%     if isfield(allraw{1,voluntaria},'ecg') && ~isempty(allraw{1,voluntaria}.ecg)
%         ax(6)=subplot(num_var,1,6)
%         plot(allraw{1,voluntaria}.ecg)
%          hold on
%     plot(allraw{1,voluntaria}.index,allraw{1,voluntaria}.ecg(allraw{1,voluntaria}.index),'*r')
%     
%     end
%     
%     linkaxes(ax,'x');
% end
end