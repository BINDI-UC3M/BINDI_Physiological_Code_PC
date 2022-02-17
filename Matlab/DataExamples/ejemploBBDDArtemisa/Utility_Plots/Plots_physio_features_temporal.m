function Plots_physio_features_temporal(features_s,physio_sig,n_feat,feat_name,plot_units,exclude_vec)


field_s=sprintf('%s_feats',physio_sig);
% Plots gsr
% voluntaria=1
% features_in=features_gsr_cvx;
% features_in=feat_gsr_sparsEDA_sin_ventanas;

%  features_s=features_norm;
% features_s=features_in;

init=1;
num_vol=0;

num_windows_v1=0;
num_windows_v2=0;
num_windows_v3=0;
num_windows_v4=0;

for voluntaria=1:21
  
if (~ (sum(voluntaria==exclude_vec)>0))    
    if(~ (isempty(features_s.features{voluntaria,1}.EH.Video.(field_s))))
        
        num_windows_v1=max([num_windows_v1 , length(features_s.features{voluntaria,1}.EH.Video.(field_s)(:,n_feat))]);
        num_windows_v2=max([num_windows_v2 , length(features_s.features{voluntaria,2}.EH.Video.(field_s)(:,n_feat))]);
        num_windows_v3=max([num_windows_v3 , length(features_s.features{voluntaria,3}.EH.Video.(field_s)(:,n_feat))]);
        num_windows_v4=max([num_windows_v4 , length(features_s.features{voluntaria,4}.EH.Video.(field_s)(:,n_feat))]);
        num_vol=num_vol+1;
        
    end
end
end

mat_v1=zeros(num_windows_v1,num_vol);
mat_v2=zeros(num_windows_v2,num_vol);
mat_v3=zeros(num_windows_v3,num_vol);
mat_v4=zeros(num_windows_v4,num_vol);

mat_v1(:,:)=NaN;
mat_v2(:,:)=NaN;
mat_v3(:,:)=NaN;
mat_v4(:,:)=NaN;

cont=0;
for voluntaria=1:21
    
if (~ (sum(voluntaria==exclude_vec)>0))    
    if(~ (isempty(features_s.features{voluntaria,1}.EH.Video.(field_s))))
        cont=cont+1;
        
        n1=length(features_s.features{voluntaria,1}.EH.Video.(field_s)(:,n_feat));
        n2=length(features_s.features{voluntaria,2}.EH.Video.(field_s)(:,n_feat));
        n3=length(features_s.features{voluntaria,3}.EH.Video.(field_s)(:,n_feat));
        n4=length(features_s.features{voluntaria,4}.EH.Video.(field_s)(:,n_feat));
        
        
        mat_v1(1:n1,cont)=features_s.features{voluntaria,1}.EH.Video.(field_s)(:,n_feat);
        mat_v2(1:n2,cont)=features_s.features{voluntaria,2}.EH.Video.(field_s)(:,n_feat);
        mat_v3(1:n3,cont)=features_s.features{voluntaria,3}.EH.Video.(field_s)(:,n_feat);
        mat_v4(1:n4,cont)=features_s.features{voluntaria,4}.EH.Video.(field_s)(:,n_feat);
        
        temp_plot=[mat_v1(:,cont)', 0 ,mat_v2(:,cont)', 0 ,mat_v3(:,cont)', 0 ,mat_v4(:,cont)'];
        
%         h(cont)=figure;
%         bar(temp_plot)
%         title(sprintf('Voluntaria:%i %s',voluntaria,feat_name));
%         xlabel('Video')
%         ylabel(sprintf('%s',plot_units))
        
%         temp_sig=[ features_s.features{voluntaria,1}.EH.Video.(field_s)(:,n_feat)', ...
%         features_s.features{voluntaria,2}.EH.Video.(field_s)(:,n_feat)',...
%         features_s.features{voluntaria,3}.EH.Video.(field_s)(:,n_feat)',...
%         features_s.features{voluntaria,4}.EH.Video.(field_s)(:,n_feat)'];    
%     
%         
%         pos_v1=length(features_s.features{voluntaria,1}.EH.Video.(field_s)(:,n_feat));
%         pos_v2=length(features_s.features{voluntaria,2}.EH.Video.(field_s)(:,n_feat))+pos_v1;
%         pos_v3=length(features_s.features{voluntaria,3}.EH.Video.(field_s)(:,n_feat))+pos_v2;
%         pos_v4=length(features_s.features{voluntaria,4}.EH.Video.(field_s)(:,n_feat))+pos_v3;
%         
%         temp_video_index=cell(size(temp_sig));
%         temp_video_index(1:pos_v1)={['Relax - ' labels_s{voluntaria}.emotions{2}]};
%         temp_video_index(pos_v1+1:pos_v2)={['VG - ' labels_s{voluntaria}.emotions{3}]};
%         temp_video_index(pos_v2+1:pos_v3)={['Alegria - ' labels_s{voluntaria}.emotions{4}]};
%         temp_video_index(pos_v3+1:pos_v4)={['Miedo - ' labels_s{voluntaria}.emotions{5}]};
%         
%         
%         temp_video_index_2=cell(size(temp_sig));
%         temp_video_index_2(1:pos_v1)={'Relax'};
%         temp_video_index_2(pos_v1+1:pos_v2)={'VG'};
%         temp_video_index_2(pos_v2+1:pos_v3)={'Alegria'};
%         temp_video_index_2(pos_v3+1:pos_v4)={'Miedo'};
        
%                 temp_video_index(pos_v1+1:pos_v2)={'Miedo VG'};
%         temp_video_index(pos_v2+1:pos_v3)={'Alegria'};
%         temp_video_index(pos_v3+1:pos_v4)={'Miedo no VG'}
%        temp_sig=1./temp_sig*60;
%        h(voluntaria)=figure;
%        boxplot(temp_sig,temp_video_index);
%        title(sprintf('Voluntaria:%i %s',voluntaria,feat_name));
%        xlabel('Video')
%        ylabel(sprintf('%s',plot_units))
       
%        if init==1 
%             temp_sig_total=temp_sig;
%             temp_video_index_total=temp_video_index_2;
%             
%             temp_sig_total_v1=features_s.features{voluntaria,1}.EH.Video.(field_s)(:,n_feat)';
%             temp_sig_total_v2=features_s.features{voluntaria,2}.EH.Video.(field_s)(:,n_feat)';
%             temp_sig_total_v3=features_s.features{voluntaria,3}.EH.Video.(field_s)(:,n_feat)';
%             temp_sig_total_v4=features_s.features{voluntaria,4}.EH.Video.(field_s)(:,n_feat)';
%             init=2;
%        else
%            temp_sig_total=horzcat(temp_sig_total,temp_sig);
%            temp_video_index_total=horzcat(temp_video_index_total,temp_video_index_2);
%            
%            temp_sig_total_v1=horzcat(temp_sig_total_v1,features_s.features{voluntaria,1}.EH.Video.(field_s)(:,n_feat)');
%            temp_sig_total_v2=horzcat(temp_sig_total_v2,features_s.features{voluntaria,2}.EH.Video.(field_s)(:,n_feat)');
%            temp_sig_total_v3=horzcat(temp_sig_total_v3,features_s.features{voluntaria,3}.EH.Video.(field_s)(:,n_feat)');
%            temp_sig_total_v4=horzcat(temp_sig_total_v4,features_s.features{voluntaria,4}.EH.Video.(field_s)(:,n_feat)');
%        end
    
    end
    
end
end



figure
 temp_plot_std=[ std(mat_v1','omitnan') 0 std(mat_v2','omitnan') 0 std(mat_v3','omitnan') 0 std(mat_v4','omitnan') 0];
 temp_plot=[ mean(mat_v1','omitnan') 0 mean(mat_v2','omitnan') 0 mean(mat_v3','omitnan') 0 mean(mat_v4','omitnan') 0];
 errorbar(temp_plot,temp_plot_std)
 hold on 
%  plot(temp_plot_std)
 title(sprintf('Todas las voluntarias %s',feat_name));
 xlabel('Ventanas')
 ylabel(sprintf('%s',plot_units))

 
 figure
%  temp_plot_std=[ std(mat_v1','omitnan') 0 std(mat_v2','omitnan') 0 std(mat_v3','omitnan') 0 std(mat_v4','omitnan') 0];
%  temp_plot=[ mean(mat_v1','omitnan') 0 mean(mat_v2','omitnan') 0 mean(mat_v3','omitnan') 0 mean(mat_v4','omitnan') 0];
 bar(temp_plot)
 hold on 
%  plot(temp_plot_std)
 title(sprintf('Todas las voluntarias %s',feat_name));
 xlabel('Ventanas')
 ylabel(sprintf('%s',plot_units))
 
 
figure
plot(temp_plot)
hold on
plot(temp_plot+temp_plot_std)
plot(temp_plot-temp_plot_std)
%     figure
%     boxplot(temp_sig_total,temp_video_index_total);
%     title(sprintf('Todas las voluntarias %s',feat_name));
%     xlabel('Video')
%     ylabel(sprintf('%s',plot_units))
%     grid on
%     mean(temp_sig_total_v1)
%     mean(temp_sig_total_v2)
%     mean(temp_sig_total_v3)
%     mean(temp_sig_total_v4)
%     
%     figure
%     ax(1)=subplot(4,1,1)
%     title('Video 1') 
%     histogram(temp_sig_total_v1,10)
%     hold on
%     ax(2)=subplot(4,1,2)
%     title('Video 2') 
%     histogram(temp_sig_total_v2,10)
%     ax(3)=subplot(4,1,3)
%     title('Video 3') 
%     histogram(temp_sig_total_v3,10)
%     ax(4)=subplot(4,1,4)
%     title('Video 4') 
%     histogram(temp_sig_total_v4,10)
%     
%     linkaxes(ax,'x')
%     sgtitle(sprintf('Histograma: %s. Todas las voluntarias',feat_name))
    
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