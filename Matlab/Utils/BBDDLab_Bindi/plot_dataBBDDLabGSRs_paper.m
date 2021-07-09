function [data_features]=plot_dataBBDDLabGSRs_paper(s,va,vb)

    data_features={};
    gsr_acc = {};
    vol = [1:9,13,15:27];
    for i=1:length(vol)
      gsr_acc{i}.EH.data =[];
      gsr_acc{i}.GSR.data = [];
%     f = figure('units','normalized','outerposition',[0 0 1 1]);
%     f.Name = "Volunteer " + s{i,1}.ParticipantNum +  " Complete Experiment";
%     tb1=0;
%     tgn1=0;
%     teh1=0;
%     tb2=0;
%     tgn2=0;
%     teh2=0;
      %vol = [1,3,12,22,34,39];
      samprate_bbddlab = 10;
      for j=va:vb
%         f = figure('units','normalized','outerposition',[0 0 1 1]);
%         f.Name = "Volunteer " + s{vol(i),1}.ParticipantNum +  " //Trial " + j;
%         plot(zscore(s{vol(i),j}.EH.Video.raw.gsr_uS_filtered_dn_sm))
%         hold on
%         plot(zscore(s{vol(i),j}.GSR.Video.raw.gsr_uS_filtered_dn_sm))
%         gsr_eh_s = GSR_create_signal(zscore(s{vol(i),j}.EH.Video.raw.gsr_uS_filtered_dn_sm), samprate_bbddlab);
%         gsr_new_s = GSR_create_signal(zscore(s{vol(i),j}.GSR.Video.raw.gsr_uS_filtered_dn_sm), samprate_bbddlab);
        gsr_acc{i}.EH.data=[gsr_acc{i}.EH.data; (s{vol(i),j}.EH.Video.raw.gsr_uS_filtered_dn_sm)];
        gsr_acc{i}.GSR.data=[gsr_acc{i}.GSR.data; (s{vol(i),j}.GSR.Video.raw.gsr_uS_filtered_dn_sm)];
        gsr_eh_s = GSR_create_signal((s{vol(i),j}.EH.Video.raw.gsr_uS_filtered_dn_sm)', samprate_bbddlab);
        gsr_new_s = GSR_create_signal((s{vol(i),j}.GSR.Video.raw.gsr_uS_filtered_dn_sm)', samprate_bbddlab);
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

end