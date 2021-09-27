
dbstop if error

feat= feat_2_sec_overlap;
 feat_select= heart_features_selections(feat);
% 
%   features_norm=norm_features_GSR_per_subject(feat,'zscore','GSR');
% Plots_physio_features_boxplot(features_norm,'GSR',1,'N picos ','Picos',labels_reordered);
% 
% Plots_physio_features_boxplot(features_norm,'GSR',6,'Media ','uS',labels_reordered);


  features_norm=norm_features_GSR_per_subject(feat_select,'zscore','HR');
% % % 
 Plots_physio_features_boxplot(features_norm,'HR',4,'Media IBI','',labels_reordered);


Plots_physio_features_boxplot(features_norm,'HR',3,'HRV rmssd','',labels_reordered);


Plots_physio_features_boxplot(features_norm,'HR',5,'LF ','',labels_reordered);

Plots_physio_features_boxplot(features_norm,'HR',6,'HF','',labels_reordered);

Plots_physio_features_boxplot(features_norm,'HR',17,'Sd1','',labels_reordered);

Plots_physio_features_boxplot(features_norm,'HR',18,'Sd2','',labels_reordered);
% % 

% 
% Plots_physio_features_boxplot(feat_select,'HR',4,'Media IBI','',labels_reordered);
% 
% Plots_physio_features_boxplot(feat_select,'HR',3,'HRV rmssd','',labels_reordered);
% 
% Plots_physio_features_boxplot(feat_select,'HR',5,'LF ','',labels_reordered);
% 
% Plots_physio_features_boxplot(feat_select,'HR',6,'HF','',labels_reordered);
% 
% Plots_physio_features_boxplot(feat_select,'HR',17,'Sd1','',labels_reordered);
% 
% Plots_physio_features_boxplot(feat_select,'HR',18,'Sd2','',labels_reordered);



function features_norm=norm_features_GSR_per_subject(features_in,type,physio_sig)
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
              temp_features=vertcat(temp_features,features_in.features{voluntaria,loop}.EH.Video.(field_s));
              

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

function Plots_physio_features_boxplot(features_s,physio_sig,n_feat,feat_name,plot_units,labels_s)


field_s=sprintf('%s_feats',physio_sig);
% Plots gsr
% voluntaria=1
% features_in=features_gsr_cvx;
% features_in=feat_gsr_sparsEDA_sin_ventanas;

%  features_s=features_norm;
% features_s=features_in;
for voluntaria=1:21
    
    if(~ isempty(features_s.features{voluntaria,1}.EH.Video.(field_s)))
        
        temp_sig=[ features_s.features{voluntaria,1}.EH.Video.(field_s)(:,n_feat)', ...
        features_s.features{voluntaria,2}.EH.Video.(field_s)(:,n_feat)',...
        features_s.features{voluntaria,3}.EH.Video.(field_s)(:,n_feat)',...
        features_s.features{voluntaria,4}.EH.Video.(field_s)(:,n_feat)'];    
    
        
        pos_v1=length(features_s.features{voluntaria,1}.EH.Video.(field_s)(:,n_feat));
        pos_v2=length(features_s.features{voluntaria,2}.EH.Video.(field_s)(:,n_feat))+pos_v1;
        pos_v3=length(features_s.features{voluntaria,3}.EH.Video.(field_s)(:,n_feat))+pos_v2;
        pos_v4=length(features_s.features{voluntaria,4}.EH.Video.(field_s)(:,n_feat))+pos_v3;
        
        temp_video_index=cell(size(temp_sig));
        temp_video_index(1:pos_v1)={['Relax - ' labels_s{voluntaria}.emotions{2}]};
        temp_video_index(pos_v1+1:pos_v2)={['VG - ' labels_s{voluntaria}.emotions{3}]};
        temp_video_index(pos_v2+1:pos_v3)={['Alegria - ' labels_s{voluntaria}.emotions{4}]};
        temp_video_index(pos_v3+1:pos_v4)={['Miedo - ' labels_s{voluntaria}.emotions{5}]};
        
        
        temp_video_index_2=cell(size(temp_sig));
        temp_video_index_2(1:pos_v1)={'Relax'};
        temp_video_index_2(pos_v1+1:pos_v2)={'VG'};
        temp_video_index_2(pos_v2+1:pos_v3)={'Alegria'};
        temp_video_index_2(pos_v3+1:pos_v4)={'Miedo'};
        
%                 temp_video_index(pos_v1+1:pos_v2)={'Miedo VG'};
%         temp_video_index(pos_v2+1:pos_v3)={'Alegria'};
%         temp_video_index(pos_v3+1:pos_v4)={'Miedo no VG'}
%        temp_sig=1./temp_sig*60;
%        h(voluntaria)=figure;
%        boxplot(temp_sig,temp_video_index);
%        title(sprintf('Voluntaria:%i %s',voluntaria,feat_name));
%        xlabel('Video')
%        ylabel(sprintf('%s',plot_units))
       
       if voluntaria==1 
            temp_sig_total=temp_sig;
            temp_video_index_total=temp_video_index_2;
            
            temp_sig_total_v1=features_s.features{voluntaria,1}.EH.Video.(field_s)(:,n_feat)';
            temp_sig_total_v2=features_s.features{voluntaria,2}.EH.Video.(field_s)(:,n_feat)';
            temp_sig_total_v3=features_s.features{voluntaria,3}.EH.Video.(field_s)(:,n_feat)';
            temp_sig_total_v4=features_s.features{voluntaria,4}.EH.Video.(field_s)(:,n_feat)';
       else
           temp_sig_total=horzcat(temp_sig_total,temp_sig);
           temp_video_index_total=horzcat(temp_video_index_total,temp_video_index_2);
           
           temp_sig_total_v1=horzcat(temp_sig_total_v1,features_s.features{voluntaria,1}.EH.Video.(field_s)(:,n_feat)');
           temp_sig_total_v2=horzcat(temp_sig_total_v2,features_s.features{voluntaria,2}.EH.Video.(field_s)(:,n_feat)');
           temp_sig_total_v3=horzcat(temp_sig_total_v3,features_s.features{voluntaria,3}.EH.Video.(field_s)(:,n_feat)');
           temp_sig_total_v4=horzcat(temp_sig_total_v4,features_s.features{voluntaria,4}.EH.Video.(field_s)(:,n_feat)');
       end
    
    end
end

    figure
    boxplot(temp_sig_total,temp_video_index_total);
    title(sprintf('Todas las voluntarias %s',feat_name));
    xlabel('Video')
    ylabel(sprintf('%s',plot_units))
    grid on
    mean(temp_sig_total_v1)
    mean(temp_sig_total_v2)
    mean(temp_sig_total_v3)
    mean(temp_sig_total_v4)
    
    figure
    ax(1)=subplot(4,1,1)
    histogram(temp_sig_total_v1,10)
    hold on
    ax(2)=subplot(4,1,2)
    histogram(temp_sig_total_v2,10)
    ax(3)=subplot(4,1,3)
    histogram(temp_sig_total_v3,10)
    ax(4)=subplot(4,1,4)
    histogram(temp_sig_total_v4,10)
    
    linkaxes(ax,'x')
    
    
%    savefig(h,sprintf('Figuras_n_%s_voluntarias.fig',feat_name))

   
   
   
   
% %    features_s=features_norm;
%   features_s=features_in;
%    for voluntaria=1:21
%     
%         
%         temp_sig=[ features_s.features{voluntaria,1}.EH.Video.GSR_feats(:,6)' ...
%         features_s.features{voluntaria,2}.EH.Video.GSR_feats(:,6)'...
%         features_s.features{voluntaria,3}.EH.Video.GSR_feats(:,6)'...
%         features_s.features{voluntaria,4}.EH.Video.GSR_feats(:,6)'];
%         
%         pos_v1=length(features_s.features{voluntaria,1}.EH.Video.GSR_feats(:,6));
%         pos_v2=length(features_s.features{voluntaria,2}.EH.Video.GSR_feats(:,6))+pos_v1;
%         pos_v3=length(features_s.features{voluntaria,3}.EH.Video.GSR_feats(:,6))+pos_v2;
%         pos_v4=length(features_s.features{voluntaria,4}.EH.Video.GSR_feats(:,6))+pos_v3;
%         
% %         temp_video_index=cell(size(temp_sig));
% %         temp_video_index(1:pos_v1)={'Tranquilidad'};
% %         temp_video_index(pos_v1+1:pos_v2)={'Miedo VG'};
% %         temp_video_index(pos_v2+1:pos_v3)={'Alegria'};
% %         temp_video_index(pos_v3+1:pos_v4)={'Miedo no VG'};
%         temp_video_index=cell(size(temp_sig));
%         temp_video_index(1:pos_v1)={['Relax - ' labels_reordered{voluntaria}.emotions{2}]};
%         temp_video_index(pos_v1+1:pos_v2)={['VG - ' labels_reordered{voluntaria}.emotions{3}]};
%         temp_video_index(pos_v2+1:pos_v3)={['Alegria - ' labels_reordered{voluntaria}.emotions{4}]};
%         temp_video_index(pos_v3+1:pos_v4)={['Miedo - ' labels_reordered{voluntaria}.emotions{5}]};
%     
%        h(voluntaria)=figure
%        boxplot(temp_sig,temp_video_index);
%        title(sprintf('Voluntaria:%i Media del GSR',voluntaria));
%        xlabel('Video')
%        ylabel('Conductividad[uS]')
%        
%        if voluntaria==1 
%             temp_sig_total=temp_sig;
%             temp_video_index_total=temp_video_index;
%        else
%            temp_sig_total=horzcat(temp_sig_total,temp_sig);
%            temp_video_index_total=horzcat(temp_video_index_total,temp_video_index);
%        end
%     
%     
%     end
% 
%     figure
%     boxplot(temp_sig_total,temp_video_index_total);
%     title(sprintf('Todas las voluntarias Media del GSR'));
%     xlabel('Video')
%     ylabel('Conductividad[uS]')    
%     
%    savefig(h,'Figuras_media_GSR_todas_voluntarias.fig')
   
   
   
% for voluntaria=1:21
%     
%         
%         temp_sig=[ features_s.features{voluntaria,1}.EH.Video.GSR_feats(:,1)' ...
%             features_s.features{voluntaria,1}.EH.Labels.GSR_feats(:,1)' ...
%             features_s.features{voluntaria,1}.EH.Recovery.GSR_feats(:,1)' ...
%         features_s.features{voluntaria,2}.EH.Video.GSR_feats(:,1)'...
%         features_s.features{voluntaria,2}.EH.Labels.GSR_feats(:,1)' ...
%         features_s.features{voluntaria,2}.EH.Recovery.GSR_feats(:,1)' ...
%         features_s.features{voluntaria,3}.EH.Video.GSR_feats(:,1)'...
%         features_s.features{voluntaria,3}.EH.Labels.GSR_feats(:,1)' ...
%         features_s.features{voluntaria,3}.EH.Recovery.GSR_feats(:,1)' ...
%         features_s.features{voluntaria,4}.EH.Video.GSR_feats(:,1)' ...
%         features_s.features{voluntaria,4}.EH.Labels.GSR_feats(:,1)' ...
%             features_s.features{voluntaria,4}.EH.Recovery.GSR_feats(:,1)' ]
%         
%         pos_v1=length(features_s.features{voluntaria,1}.EH.Video.GSR_feats(:,6));
%         pos_v2=length(features_s.features{voluntaria,2}.EH.Video.GSR_feats(:,6))+pos_v1;
%         pos_v3=length(features_s.features{voluntaria,3}.EH.Video.GSR_feats(:,6))+pos_v2;
%         pos_v4=length(features_s.features{voluntaria,4}.EH.Video.GSR_feats(:,6))+pos_v3;
%         
% %         temp_video_index=[length(features_s.features{voluntaria,1}.EH.Video.GSR_feats(:,1)) ...
% %             length(features_s.features{voluntaria,1}.EH.Labels.GSR_feats(:,1)) ...
% %             length(features_s.features{voluntaria,1}.EH.Recovery.GSR_feats(:,1)) ...
% %         length(features_s.features{voluntaria,2}.EH.Video.GSR_feats(:,1))...
% %         length(features_s.features{voluntaria,2}.EH.Labels.GSR_feats(:,1)) ...
% %             length(features_s.features{voluntaria,2}.EH.Recovery.GSR_feats(:,1)) ...
% %         length(features_s.features{voluntaria,3}.EH.Video.GSR_feats(:,1))...
% %         length(features_s.features{voluntaria,3}.EH.Labels.GSR_feats(:,1)) ...
% %             length(features_s.features{voluntaria,3}.EH.Recovery.GSR_feats(:,1)) ...
% %         length(features_s.features{voluntaria,4}.EH.Video.GSR_feats(:,1))...
% %         length(features_s.features{voluntaria,4}.EH.Labels.GSR_feats(:,1)) ...
% %             length(features_s.features{voluntaria,4}.EH.Recovery.GSR_feats(:,1))];
%         
% %         temp_video_index=cell(size(temp_sig));
% %         temp_video_index(1:pos_v1)={'Tranquilidad'};
% %         temp_video_index(pos_v1+1:pos_v2)={'Miedo VG'};
% %         temp_video_index(pos_v2+1:pos_v3)={'Alegria'};
% %         temp_video_index(pos_v3+1:pos_v4)={'Miedo no VG'};
%     
%        h(voluntaria)=figure
%        plot(temp_sig);
%        hold on
%        plot(temp_video_index,temp_sig(temp_video_index),'r*')
%        title(sprintf('Voluntaria:%i Evolucion del numero de picos del GSR',voluntaria));
%        xlabel('Numero de muestra')
%        ylabel('Picos por segundo')
%        
%        if voluntaria==1 
%             temp_sig_total=temp_sig;
%             temp_video_index_total=temp_video_index;
%        else
%            temp_sig_total=horzcat(temp_sig_total,temp_sig);
%            temp_video_index_total=horzcat(temp_video_index_total,temp_video_index);
%        end
%     
%     
% end
% 
%     figure
%     boxplot(temp_sig_total,temp_video_index_total);
%     title(sprintf('Todas las voluntarias Numero de picos de GSR'));
%     xlabel('Video')
%     ylabel('Picos por segundo')
%     
%    savefig(h,'Figuras_n_picos_GSR_todas_voluntarias.fig')

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



% for voluntaria=1:21
%     
%         
%         temp_sig=[ features_s.features{voluntaria,1}.EH.Video.GSR_feats(:,1)' ...
%         features_s.features{voluntaria,2}.EH.Video.GSR_feats(:,1)'...
%         features_s.features{voluntaria,3}.EH.Video.GSR_feats(:,1)'...
%         features_s.features{voluntaria,4}.EH.Video.GSR_feats(:,1)'];
%         
%         pos_v1=length(features_s.features{voluntaria,1}.EH.Video.GSR_feats(:,1));
%         pos_v2=length(features_s.features{voluntaria,2}.EH.Video.GSR_feats(:,1))+pos_v1;
%         pos_v3=length(features_s.features{voluntaria,3}.EH.Video.GSR_feats(:,1))+pos_v2;
%         pos_v4=length(features_s.features{voluntaria,4}.EH.Video.GSR_feats(:,1))+pos_v3;
%         
%         temp_video_index=cell(size(temp_sig));
%         temp_video_index(1:pos_v1)={['Relax - ' labels_reordered{voluntaria}.emotions{2}]};
%         temp_video_index(pos_v1+1:pos_v2)={['VG - ' labels_reordered{voluntaria}.emotions{3}]};
%         temp_video_index(pos_v2+1:pos_v3)={['Alegria - ' labels_reordered{voluntaria}.emotions{4}]};
%         temp_video_index(pos_v3+1:pos_v4)={['Miedo - ' labels_reordered{voluntaria}.emotions{5}]};
%         
% %                 temp_video_index(pos_v1+1:pos_v2)={'Miedo VG'};
% %         temp_video_index(pos_v2+1:pos_v3)={'Alegria'};
% %         temp_video_index(pos_v3+1:pos_v4)={'Miedo no VG'}
%     
%        h(voluntaria)=figure
%        boxplot(temp_sig,temp_video_index);
%        title(sprintf('Voluntaria:%i Numero de picos de GSR',voluntaria));
%        xlabel('Video')
%        ylabel('Picos por segundo')
%        
%        if voluntaria==1 
%             temp_sig_total=temp_sig;
%             temp_video_index_total=temp_video_index;
%        else
%            temp_sig_total=horzcat(temp_sig_total,temp_sig);
%            temp_video_index_total=horzcat(temp_video_index_total,temp_video_index);
%        end
%     
%     
% end
% 
%     figure
%     boxplot(temp_sig_total,temp_video_index_total);
%     title(sprintf('Todas las voluntarias Numero de picos de GSR'));
%     xlabel('Video')
%     ylabel('Picos por segundo')






end

function Plots_physio_features_evolution(features_s,physio_sig,n_feat,feat_name,plot_units,labels_s)


field_s=sprintf('%s_feats',physio_sig);
% Plots gsr
% voluntaria=1
% features_in=features_gsr_cvx;
% features_in=feat_gsr_sparsEDA_sin_ventanas;

%  features_s=features_norm;
% features_s=features_in;
for voluntaria=1:10
    
        
        temp_sig=[ features_s.features{voluntaria,1}.EH.Video.(field_s)(:,n_feat)', ...
        features_s.features{voluntaria,2}.EH.Video.(field_s)(:,n_feat)',...
        features_s.features{voluntaria,3}.EH.Video.(field_s)(:,n_feat)',...
        features_s.features{voluntaria,4}.EH.Video.(field_s)(:,n_feat)'];    
    
        
        pos_v1=length(features_s.features{voluntaria,1}.EH.Video.(field_s)(:,n_feat));
        pos_v2=length(features_s.features{voluntaria,2}.EH.Video.(field_s)(:,n_feat))+pos_v1;
        pos_v3=length(features_s.features{voluntaria,3}.EH.Video.(field_s)(:,n_feat))+pos_v2;
        pos_v4=length(features_s.features{voluntaria,4}.EH.Video.(field_s)(:,n_feat))+pos_v3;
        
        temp_video_index=cell(size(temp_sig));
        temp_video_index(1:pos_v1)={['Relax - ' labels_s{voluntaria}.emotions{2}]};
        temp_video_index(pos_v1+1:pos_v2)={['VG - ' labels_s{voluntaria}.emotions{3}]};
        temp_video_index(pos_v2+1:pos_v3)={['Alegria - ' labels_s{voluntaria}.emotions{4}]};
        temp_video_index(pos_v3+1:pos_v4)={['Miedo - ' labels_s{voluntaria}.emotions{5}]};
        
        
        temp_video_index_2=cell(size(temp_sig));
        temp_video_index_2(1:pos_v1)={'Relax'};
        temp_video_index_2(pos_v1+1:pos_v2)={'VG'};
        temp_video_index_2(pos_v2+1:pos_v3)={'Alegria'};
        temp_video_index_2(pos_v3+1:pos_v4)={'Miedo'};
        
%                 temp_video_index(pos_v1+1:pos_v2)={'Miedo VG'};
%         temp_video_index(pos_v2+1:pos_v3)={'Alegria'};
%         temp_video_index(pos_v3+1:pos_v4)={'Miedo no VG'}
       temp_sig=1./temp_sig*60;
       h(voluntaria)=figure
       boxplot(temp_sig,temp_video_index);
       title(sprintf('Voluntaria:%i %s',voluntaria,feat_name));
       xlabel('Video')
       ylabel(sprintf('%s',plot_units))
       
       if voluntaria==1 
            temp_sig_total=temp_sig;
            temp_video_index_total=temp_video_index_2;
            
            temp_sig_total_v1=features_s.features{voluntaria,1}.EH.Video.(field_s)(:,n_feat)';
            temp_sig_total_v2=features_s.features{voluntaria,2}.EH.Video.(field_s)(:,n_feat)';
            temp_sig_total_v3=features_s.features{voluntaria,3}.EH.Video.(field_s)(:,n_feat)';
            temp_sig_total_v4=features_s.features{voluntaria,4}.EH.Video.(field_s)(:,n_feat)';
       else
           temp_sig_total=horzcat(temp_sig_total,temp_sig);
           temp_video_index_total=horzcat(temp_video_index_total,temp_video_index_2);
           
           temp_sig_total_v1=horzcat(temp_sig_total_v1,features_s.features{voluntaria,1}.EH.Video.(field_s)(:,n_feat)');
           temp_sig_total_v2=horzcat(temp_sig_total_v2,features_s.features{voluntaria,2}.EH.Video.(field_s)(:,n_feat)');
           temp_sig_total_v3=horzcat(temp_sig_total_v3,features_s.features{voluntaria,3}.EH.Video.(field_s)(:,n_feat)');
           temp_sig_total_v4=horzcat(temp_sig_total_v4,features_s.features{voluntaria,4}.EH.Video.(field_s)(:,n_feat)');
       end
    
    
end

    figure
    boxplot(temp_sig_total,temp_video_index_total);
    title(sprintf('Todas las voluntarias %s',feat_name));
    xlabel('Video')
    ylabel(sprintf('%s',plot_units))
    
    mean(temp_sig_total_v1)
    mean(temp_sig_total_v2)
    mean(temp_sig_total_v3)
    mean(temp_sig_total_v4)
    
    figure
    ax(1)=subplot(4,1,1)
    histogram(temp_sig_total_v1,10)
    hold on
    ax(2)=subplot(4,1,2)
    histogram(temp_sig_total_v2,10)
    ax(3)=subplot(4,1,3)
    histogram(temp_sig_total_v3,10)
    ax(4)=subplot(4,1,4)
    histogram(temp_sig_total_v4,10)
    
    linkaxes(ax,'x')








end