
function Plots_physio_features(features_s)
features_s=features_gsr;

% Plots gsr
for voluntaria=1:length(features_s)
    
    temp_sig=[ features_s.features{voluntaria,1}.EH.Video.GSR_feats(:,1), ...
        features_s.features{voluntaria,1}.EH.Video.GSR_feats(:,1)...
        
    figure
    
    
    
end




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