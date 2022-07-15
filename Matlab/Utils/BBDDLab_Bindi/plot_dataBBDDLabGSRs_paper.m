function [data_features]=plot_dataBBDDLabGSRs_paper(s,va,vb)

    data_features={};
    gsr_acc = {};
    %vol = [1:9,13,15:27];
    vol = 1:47;
    t1_fear = [2,5,8,10,12,14];
    t1_nofear = [1,3,4,6,7,9,11,13];
    t2_fear = [1,3,5,8,10,12,14];
    t2_nofear = [2,4,6,7,9,11,13];
    load('VoluntariasTandasNumeration.mat');
    count_t1 = 1;
    count_t2 = 1;
    count_vols = 1;
    count_totalduration = 0;
    
    %hipophasic = [10,13,20,23,25,41,46,51,70,83,108];
    hipophasic = [0,0,0];
    
    for i=1:length(vol)
      gsr_acc{i}.EH.data =[];
      gsr_acc{i}.GSR.data = [];
      correlation_vector = [];
      correlation_ph_vector = [];
      RMSE =[];
      %vol = [1,3,12,22,34,39];
      samprate_bbddlab = 10;
      
      newStr = split(string(s{i, 1}.ParticipantNum),"V");
      vol_num = str2double(newStr(2));
      
      if ~ismember(vol_num,hipophasic)
      
          row = find(VoluntariasnoGBV.Renum==vol_num);

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
            fprintf("Volunter %d / Video %d \n",vol_num,j);
            %gsr_acc{i}.EH.data=[gsr_acc{i}.EH.data; (s{vol(i),j}.EH.Video.raw.gsr_uS_filtered)];
            %gsr_acc{i}.GSR.data=[gsr_acc{i}.GSR.data; (s{vol(i),j}.GSR.Video.raw.gsr_uS_filtered)];
            gsr_eh_s = GSR_create_signal((s{vol(i),j}.EH.Video.raw.gsr_uS_filtered_dn_sm)', samprate_bbddlab);
            gsr_new_s = GSR_create_signal((s{vol(i),j}.GSR.Video.raw.gsr_uS_filtered_dn_sm)', samprate_bbddlab);
            [data_features{i}.EH.GSR_feats(j,:), data_features{i}.EH.GSR_feats_names] = ...
                GSR_features_extr(gsr_eh_s); 
            [data_features{i}.GSR.GSR_feats(j,:), data_features{i}.GSR.GSR_feats_names] = ...
                GSR_features_extr(gsr_new_s); 

            %Correlation study
            a = zscore((movmean(s{vol(i),j}.EH.Video.raw.gsr_uS_filtered_dn_sm,[samprate_bbddlab*20 samprate_bbddlab*20])));
            b = zscore((movmean(s{vol(i),j}.GSR.Video.raw.gsr_uS_filtered_dn_sm,[samprate_bbddlab*20 samprate_bbddlab*20])));
            %a = zscore((s{vol(i),j}.EH.Video.raw.gsr_uS_filtered_dn_sm));
            %b = zscore((s{vol(i),j}.GSR.Video.raw.gsr_uS_filtered_dn_sm));
            len = min([length(a) length(b)]);
            [r,ph] = corr(a(1:len),b(1:len),'Type','Pearson');
            correlation_vector(j,1) = r; 
            correlation_ph_vector(j,1)= ph;

            RMSE(j,1) = sqrt(mean((a(1:len) - b(1:len)).^2));
            
            count_totalduration = count_totalduration + length(a)/10;
          end
          
          correlation_ph_vector_total(count_vols,1) = mean(abs(correlation_ph_vector));
          correlation_vector_total(count_vols,1) = mean(abs(correlation_vector));
          correlation_vector_total(count_vols,2) = median(abs(correlation_vector));
          correlation_vector_total(count_vols,3) = mad(abs(correlation_vector));
          correlation_vector_total(count_vols,4) = std(abs(correlation_vector));
          RMSE_total(count_vols,1) = mean(RMSE);

          count_vols = count_vols + 1;

          if VoluntariasnoGBV.Tanda(row) == 1

              %EH - T1
              feat_t1_fear_npeaks_eh(:,count_t1)  =data_features{i}.EH.GSR_feats(t1_fear,1);
              feat_t1_nofear_npeaks_eh(:,count_t1)=data_features{i}.EH.GSR_feats(t1_nofear,1);
              feat_t1_fear_amp_eh(:,count_t1)  =data_features{i}.EH.GSR_feats(t1_fear,2);
              feat_t1_nofear_amp_eh(:,count_t1)=data_features{i}.EH.GSR_feats(t1_nofear,2);
              feat_t1_fear_recov_eh(:,count_t1)  =data_features{i}.EH.GSR_feats(t1_fear,4);
              feat_t1_nofear_recov_eh(:,count_t1)=data_features{i}.EH.GSR_feats(t1_nofear,4);     

              %GSR - T1
              feat_t1_fear_npeaks(:,count_t1)  =data_features{i}.GSR.GSR_feats(t1_fear,1);
              feat_t1_nofear_npeaks(:,count_t1)=data_features{i}.GSR.GSR_feats(t1_nofear,1);
              feat_t1_fear_amp(:,count_t1)  =data_features{i}.GSR.GSR_feats(t1_fear,2);
              feat_t1_nofear_amp(:,count_t1)=data_features{i}.GSR.GSR_feats(t1_nofear,2);
              feat_t1_fear_recov(:,count_t1)  =data_features{i}.GSR.GSR_feats(t1_fear,4);
              feat_t1_nofear_recov(:,count_t1)=data_features{i}.GSR.GSR_feats(t1_nofear,4);

              count_t1 = count_t1 + 1;

          elseif VoluntariasnoGBV.Tanda(row) == 2

              %EH - T2
              feat_t2_fear_npeaks_eh(:,count_t2)  =data_features{i}.EH.GSR_feats(t2_fear,1);
              feat_t2_nofear_npeaks_eh(:,count_t2)=data_features{i}.EH.GSR_feats(t2_nofear,1);
              feat_t2_fear_amp_eh(:,count_t2)  =data_features{i}.EH.GSR_feats(t2_fear,2);
              feat_t2_nofear_amp_eh(:,count_t2)=data_features{i}.EH.GSR_feats(t2_nofear,2);
              feat_t2_fear_recov_eh(:,count_t2)  =data_features{i}.EH.GSR_feats(t2_fear,4);
              feat_t2_nofear_recov_eh(:,count_t2)=data_features{i}.EH.GSR_feats(t2_nofear,4);     

              %GSR - T2
              feat_t2_fear_npeaks(:,count_t2)  =data_features{i}.GSR.GSR_feats(t2_fear,1);
              feat_t2_nofear_npeaks(:,count_t2)=data_features{i}.GSR.GSR_feats(t2_nofear,1);
              feat_t2_fear_amp(:,count_t2)  =data_features{i}.GSR.GSR_feats(t2_fear,2);
              feat_t2_nofear_amp(:,count_t2)=data_features{i}.GSR.GSR_feats(t2_nofear,2);
              feat_t2_fear_recov(:,count_t2)  =data_features{i}.GSR.GSR_feats(t2_fear,4);
              feat_t2_nofear_recov(:,count_t2)=data_features{i}.GSR.GSR_feats(t2_nofear,4);

              count_t2 = count_t2 + 1;

          else
            error('Cannot happen');
          end
      end
	  
% 	  bar([mean(mean(feat_t1_fear_npeaks_eh'))])
%       hold on;bar(2,[mean(mean(feat_t1_fear_npeaks'))])
%       bar(4,[mean(mean(feat_t1_nofear_npeaks_eh'))])
%       bar(5,[mean(mean(feat_t1_nofear_npeaks'))])
%       errorbar(1,[mean(mean(feat_t1_fear_npeaks_eh'))],[mad(mean(feat_t1_fear_npeaks_eh'))/2],[mad(mean(feat_t1_fear_npeaks_eh'))/2]);
%       errorbar(2,[mean(mean(feat_t1_fear_npeaks'))],[mad(mean(feat_t1_fear_npeaks'))/2],[mad(mean(feat_t1_fear_npeaks'))/2]);
%       errorbar(4,[mean(mean(feat_t1_nofear_npeaks_eh'))],[mad(mean(feat_t1_nofear_npeaks_eh'))/2],[mad(mean(feat_t1_nofear_npeaks_eh'))/2]);
%       errorbar(5,[mean(mean(feat_t1_nofear_npeaks'))],[mad(mean(feat_t1_nofear_npeaks'))/2],[mad(mean(feat_t1_nofear_npeaks'))/2]);
    end
    
    feat_t1_fear_npeaks_eh =[mean(feat_t1_fear_npeaks_eh) mean(feat_t2_fear_npeaks_eh)];
    feat_t1_nofear_npeaks_eh =[mean(feat_t1_nofear_npeaks_eh) mean(feat_t2_nofear_npeaks_eh)];
    feat_t1_fear_amp_eh =[mean(feat_t1_fear_amp_eh) mean(feat_t2_fear_amp_eh)];
    feat_t1_nofear_amp_eh =[mean(feat_t1_nofear_amp_eh) mean(feat_t2_nofear_amp_eh)];
    feat_t1_fear_recov_eh =[mean(feat_t1_fear_recov_eh) mean(feat_t2_fear_recov_eh)];
    feat_t1_nofear_recov_eh =[mean(feat_t1_nofear_recov_eh) mean(feat_t2_nofear_recov_eh)];
    
    feat_t1_fear_npeaks =[mean(feat_t1_fear_npeaks) mean(feat_t2_fear_npeaks)];
    feat_t1_nofear_npeaks =[mean(feat_t1_nofear_npeaks) mean(feat_t2_nofear_npeaks)];
    feat_t1_fear_amp =[mean(feat_t1_fear_amp) mean(feat_t2_fear_amp)];
    feat_t1_nofear_amp =[mean(feat_t1_nofear_amp) mean(feat_t2_nofear_amp)];
    feat_t1_fear_recov =[mean(feat_t1_fear_recov) mean(feat_t2_fear_recov)];
    feat_t2_nofear_recov =[mean(feat_t1_nofear_recov) mean(feat_t2_nofear_recov)];

end