function [data_features]=plot_dataBBDDLabGSRs_Exploratory(s,va,vb)

    data_features={};
    gsr_acc = {};
    %vol = [1:9,13,15:27];
    vol  = [1:5];
    for i=1:length(vol)
      gsr_acc{i}.EH.data =[];
      gsr_acc{i}.GSR.data = [];
      samprate_bbddlab = 200;
      for j=va:vb
	    
		%In case you want to plot each signal...
        %f = figure('units','normalized','outerposition',[0 0 1 1]);
        %f.Name = "Volunteer " + s{vol(i),1}.ParticipantNum +  " //Trial " + j;
        %plot(zscore(s{vol(i),j}.EH.Video.raw.gsr_uS_filtered_dn_sm))
        %hold on
        %plot(zscore(s{vol(i),j}.GSR.Video.raw.gsr_uS_filtered_dn_sm))
        %gsr_eh_s = GSR_create_signal(zscore(s{vol(i),j}.EH.Video.raw.gsr_uS_filtered_dn_sm), samprate_bbddlab);
        %gsr_new_s = GSR_create_signal(zscore(s{vol(i),j}.GSR.Video.raw.gsr_uS_filtered_dn_sm), samprate_bbddlab);
		
		%Features are extracted based on the whole signal (no window-split)
        fprintf("Volunter %d / Video %d \n",i,j);
        gsr_acc{i}.EH.data=[gsr_acc{i}.EH.data; (s{vol(i),j}.EH.Video.raw.gsr_uS_filtered_sm)];
        gsr_acc{i}.GSR.data=[gsr_acc{i}.GSR.data; (s{vol(i),j}.GSR.Video.raw.gsr_uS_filtered_sm)];
        
        %In case the samprate is 10Hz
        samprate_bbddlab = 10;
        %In case we just run again the features
        %gsr_eh_s = GSR_create_signal(downsample((s{vol(i),j}.EH.Video.raw.gsr_uS_filtered_sm),20)', samprate_bbddlab);
        %gsr_new_s = GSR_create_signal(downsample((s{vol(i),j}.GSR.Video.raw.gsr_uS_filtered_sm),20)', samprate_bbddlab);
        gsr_eh_s = GSR_create_signal((s{vol(i),j}.EH.Video.raw.gsr_uS_filtered_sm)', samprate_bbddlab);
        gsr_new_s = GSR_create_signal((s{vol(i),j}.GSR.Video.raw.gsr_uS_filtered_sm)', samprate_bbddlab);
        
        %In case the samprate is 200Hz
        %gsr_eh_s = GSR_create_signal((s{vol(i),j}.EH.Video.raw.gsr_uS_filtered_sm)', samprate_bbddlab);
        %gsr_new_s = GSR_create_signal((s{vol(i),j}.GSR.Video.raw.gsr_uS_filtered_sm)', samprate_bbddlab);
        
        %Extract features
        [data_features{i}.EH.GSR_feats(j,:), data_features{i}.EH.GSR_feats_names] = ...
            GSR_features_extr(gsr_eh_s); 
        [data_features{i}.GSR.GSR_feats(j,:), data_features{i}.GSR.GSR_feats_names] = ...
            GSR_features_extr(gsr_new_s); 
      end
	  
      %EH
      feat_t1_fear_npeaks_eh(:,i)  =data_features{i}.EH.GSR_feats([2,5,8,10,12,14],1);
      feat_t1_nofear_npeaks_eh(:,i)=data_features{i}.EH.GSR_feats([1,3,4,6,7,9,11,13],1);
      feat_t1_fear_amp_eh(:,i)  =data_features{i}.EH.GSR_feats([2,5,8,10,12,14],2);
      feat_t1_nofear_amp_eh(:,i)=data_features{i}.EH.GSR_feats([1,3,4,6,7,9,11,13],2);
      feat_t1_fear_recov_eh(:,i)  =data_features{i}.EH.GSR_feats([2,5,8,10,12,14],4);
      feat_t1_nofear_recov_eh(:,i)=data_features{i}.EH.GSR_feats([1,3,4,6,7,9,11,13],4);     
	  
      %GSR
      feat_t1_fear_npeaks(:,i)  =data_features{i}.GSR.GSR_feats([2,5,8,10,12,14],1);
      feat_t1_nofear_npeaks(:,i)=data_features{i}.GSR.GSR_feats([1,3,4,6,7,9,11,13],1);
      feat_t1_fear_amp(:,i)  =data_features{i}.GSR.GSR_feats([2,5,8,10,12,14],2);
      feat_t1_nofear_amp(:,i)=data_features{i}.GSR.GSR_feats([1,3,4,6,7,9,11,13],2);
      feat_t1_fear_recov(:,i)  =data_features{i}.GSR.GSR_feats([2,5,8,10,12,14],4);
      feat_t1_nofear_recov(:,i)=data_features{i}.GSR.GSR_feats([1,3,4,6,7,9,11,13],4);     

    end

      f=figure;
      f.Name = "Volunteer " + s{vol(i),1}.ParticipantNum +  " // EH-GSR_{ours} NPeaks ";
      axes1 = axes;
      hold(axes1,'on');
      b=bar([mean(mean(feat_t1_fear_npeaks_eh'))]);
      set(b,'DisplayName','BioSignal',...
      'FaceColor',[0.901960784313726 0.901960784313726 0.901960784313726]);
      hold on;b=bar(2,[mean(mean(feat_t1_fear_npeaks'))]);
      set(b,'DisplayName','Proposed',...
      'FaceColor',[0.501960784313725 0.501960784313725 0.501960784313725]);
      b=bar(4,[mean(mean(feat_t1_nofear_npeaks_eh'))]);
      set(b,...
      'FaceColor',[0.901960784313726 0.901960784313726 0.901960784313726]);
      b=bar(5,[mean(mean(feat_t1_nofear_npeaks'))]);
      set(b,...
      'FaceColor',[0.501960784313725 0.501960784313725 0.501960784313725]);
      errorbar(1,[mean(mean(feat_t1_fear_npeaks_eh'))],[mad(mean(feat_t1_fear_npeaks_eh'))/2],[mad(mean(feat_t1_fear_npeaks_eh'))/2]);
      errorbar(2,[mean(mean(feat_t1_fear_npeaks'))],[mad(mean(feat_t1_fear_npeaks'))/2],[mad(mean(feat_t1_fear_npeaks'))/2]);
      errorbar(4,[mean(mean(feat_t1_nofear_npeaks_eh'))],[mad(mean(feat_t1_nofear_npeaks_eh'))/2],[mad(mean(feat_t1_nofear_npeaks_eh'))/2]);
      errorbar(5,[mean(mean(feat_t1_nofear_npeaks'))],[mad(mean(feat_t1_nofear_npeaks'))/2],[mad(mean(feat_t1_nofear_npeaks'))/2]);
      ylabel({'# peaks detected'});
      set(axes1,'FontSize',14,'XTick',[1.5 4.5],'XTickLabel',{'Fear','No Fear'},...
      'YGrid','on');
      %legend(axes1,'show');

      f=figure;
      f.Name = "Volunteer " + s{vol(i),1}.ParticipantNum +  " // EH-GSR_{ours} Amp ";
      b=bar([mean(mean(feat_t1_fear_amp_eh'))]);
      set(b,'DisplayName','BioSignal',...
      'FaceColor',[0.901960784313726 0.901960784313726 0.901960784313726]);
      hold on;b=bar(2,[mean(mean(feat_t1_fear_amp'))]);
      set(b,'DisplayName','Proposed',...
      'FaceColor',[0.501960784313725 0.501960784313725 0.501960784313725]);
      b=bar(4,[mean(mean(feat_t1_nofear_amp_eh'))]);
      set(b,...
      'FaceColor',[0.901960784313726 0.901960784313726 0.901960784313726]);
      b=bar(5,[mean(mean(feat_t1_nofear_amp'))]);
      set(b,...
      'FaceColor',[0.501960784313725 0.501960784313725 0.501960784313725]);
      errorbar(1,[mean(mean(feat_t1_fear_amp_eh'))],[mad(mean(feat_t1_fear_amp_eh'))/2],[mad(mean(feat_t1_fear_amp_eh'))/2]);
      errorbar(2,[mean(mean(feat_t1_fear_amp'))],[mad(mean(feat_t1_fear_amp'))/2],[mad(mean(feat_t1_fear_amp'))/2]);
      errorbar(4,[mean(mean(feat_t1_nofear_amp_eh'))],[mad(mean(feat_t1_nofear_amp_eh'))/2],[mad(mean(feat_t1_nofear_amp_eh'))/2]);
      errorbar(5,[mean(mean(feat_t1_nofear_amp'))],[mad(mean(feat_t1_nofear_amp'))/2],[mad(mean(feat_t1_nofear_amp'))/2]);
      ylabel({'Relative Peaks Amplitude'});
      set(axes1,'FontSize',14,'XTick',[1.5 4.5],'XTickLabel',{'Fear','No Fear'},...
      'YGrid','on');
      
      f=figure;
      f.Name = "Volunteer " + s{vol(i),1}.ParticipantNum +  " // EH-GSR_{ours} Recov ";
      b=bar([mean(mean(feat_t1_fear_recov_eh'))]);
      set(b,'DisplayName','BioSignal',...
      'FaceColor',[0.901960784313726 0.901960784313726 0.901960784313726]);
      hold on;b=bar(2,[mean(mean(feat_t1_fear_recov'))]);
      set(b,'DisplayName','Proposed',...
      'FaceColor',[0.501960784313725 0.501960784313725 0.501960784313725]);
      b=bar(4,[mean(mean(feat_t1_nofear_recov_eh'))]);
      set(b,...
      'FaceColor',[0.901960784313726 0.901960784313726 0.901960784313726]);
      b=bar(5,[mean(mean(feat_t1_nofear_recov'))]);
      set(b,...
      'FaceColor',[0.501960784313725 0.501960784313725 0.501960784313725]);
      errorbar(1,[mean(mean(feat_t1_fear_recov_eh'))],[mad(mean(feat_t1_fear_recov_eh'))/2],[mad(mean(feat_t1_fear_recov_eh'))/2]);
      errorbar(2,[mean(mean(feat_t1_fear_recov'))],[mad(mean(feat_t1_fear_recov'))/2],[mad(mean(feat_t1_fear_recov'))/2]);
      errorbar(4,[mean(mean(feat_t1_nofear_recov_eh'))],[mad(mean(feat_t1_nofear_recov_eh'))/2],[mad(mean(feat_t1_nofear_recov_eh'))/2]);
      errorbar(5,[mean(mean(feat_t1_nofear_recov'))],[mad(mean(feat_t1_nofear_recov'))/2],[mad(mean(feat_t1_nofear_recov'))/2]);
      ylabel({'Peaks Recovery Time'});
      set(axes1,'FontSize',14,'XTick',[1.5 4.5],'XTickLabel',{'Fear','No Fear'},...
      'YGrid','on'); 

end