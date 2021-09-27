function [data_features]=plot_dataBBDDLabBVPs_Exploratory(s,va,vb)
dbstop if error
    %Declaration local variables
    data_features        = {};
    bvp_acc              = {};
    %vol                  = [1:9,13,15:27];
    vol                  = [1:3];
    videos_t1_fear       = [2,5,8,10,12,14]; %FEAR T1 Videos
    videos_t1_nofear     = [1,3,4,6,7,9,11,13]; %NO_FEAR T1 Videos
    samprate_bbddlab     = 200;
    feat_t1_fear_ibi_eh  = [];    
    feat_t1_nofear_ibi_eh= [];    
    feat_t1_fear_rlf_eh  = [];    
    feat_t1_nofear_rlf_eh= [];    
    feat_t1_fear_rr_eh   = [];
    feat_t1_nofear_rr_eh = [];
    temp_fear_ibi        = [];
    temp_nofear_ibi      = [];
    temp_fear_rlf        = [];
    temp_nofear_rlf      = [];
    temp_fear_rr         = [];
    temp_nofear_rr       = [];
    temp_ibi             = [];
    temp_ibi_data_fear   = [];
    temp_ibi_data_nofear = [];

    %vMain loop based on #volunteers
    for i=1:length(vol)
      bvp_acc{i}.EH.data =[];
      figure;
      temp = [];
      for j=va:vb
		
		%Features are extracted based on the whole signal (no window-split)
        fprintf("Volunter %d / Video %d \n",i,j);
        bvp_acc{i}.EH.data=[bvp_acc{i}.EH.data, (s{vol(i),j}.EH.Video.raw.bvp_filt)];
        
        %In case the samprate is 200Hz
        bvp_eh_s = BVP_create_signal((s{vol(i),j}.EH.Video.raw.bvp_filt)', samprate_bbddlab);
        
        %Extracting Features %
        %Deal with window and overlapping
        operational_window = 20; %seconds
        overlapin_window   = 2;  %seconds
        %Video
        start_bvp   = 1;
        stop_bvp    = operational_window*samprate_bbddlab;
        overlap_bvp = overlapin_window*samprate_bbddlab;
        window_num  = 1;
        bvp_sig_cpy = bvp_eh_s;
        temp = [temp NaN];
        while(stop_bvp<length(bvp_eh_s.raw))
          %BVP processing
          %To measure the time taken for each physio-processing uncomment the
          %tic-toc commands
          tic
          bvp_sig_cpy.raw = bvp_eh_s.raw(start_bvp:stop_bvp);
          [data_features{i,j}.EH.Video.BVP_feats(window_num,:), ...
           data_features{i,j}.EH.Video.BVP_feats_names, data_features{i,j}.EH.IBI{window_num}] = ...
              BVP_features_extr(bvp_sig_cpy);
          toc
          
          start_bvp  = start_bvp + overlap_bvp;
          stop_bvp   = stop_bvp  + overlap_bvp;
          
          %Plot LF/HF plot
          temp = [temp data_features{i,j}.EH.Video.BVP_feats(window_num,11)];
          bar(temp,1)
          pause(0.02)
          
          window_num = window_num + 1;
        end
        
        %Saving and agrupping temporal data
        if ismember(j,videos_t1_fear)
          temp_fear_ibi = [temp_fear_ibi; ...
                           data_features{i,j}.EH.Video.BVP_feats(:,4)];
          temp_fear_rlf = [temp_fear_rlf; ...
                           data_features{i,j}.EH.Video.BVP_feats(:,11)];
          %temp_fear_rr  = [temp_fear_rr; ...
          %                 data_features{i,j}.EH.Video.BVP_feats(:,25)];
          %temp_ibi_data_fear = [temp_ibi_data_fear 
          %                      data_features{i, j}.EH.IBI.raw'];
        elseif ismember(j,videos_t1_nofear)
          temp_nofear_ibi = [temp_nofear_ibi; ...
                             data_features{i,j}.EH.Video.BVP_feats(:,4)];
          temp_nofear_rlf = [temp_nofear_rlf; ...
                             data_features{i,j}.EH.Video.BVP_feats(:,11)];
          %temp_nofear_rr = [temp_nofear_rr; ...
          %                  data_features{i,j}.EH.Video.BVP_feats(:,25)];
          %temp_ibi_data_nofear = [temp_ibi_data_nofear 
          %                      data_features{i, j}.EH.IBI.raw'];
        else
          error('Scheisse!');
        end
		
		%Store to Plot IBI - Poincare Plot - Let's Mambo Jambo!
        for k=1:window_num-1
		  temp_ibi = [temp_ibi; data_features{i, j}.EH.IBI{k}.raw'];
        end
        temp_ibi = [temp_ibi; 0];
      
      end
%       
%         figure
%         xlim([0 25])
%         ylim([-1.1 1.1])
%         hold on
%         for i = 1:n
%             plot(x(1:i),y(1:i))
%             pause(0.05)
%         end
%         plot(temp_ibi(1:end-1),temp_ibi(2:end),'*k');
      
      %Saving and agrupping data for the entire volunteer
      feat_t1_fear_ibi_eh(:,i)   = temp_fear_ibi;
      feat_t1_fear_rlf_eh(:,i)   = temp_fear_rlf;
      %feat_t1_fear_rr_eh(:,i)    = temp_fear_rr;
      feat_t1_nofear_ibi_eh(:,i) = temp_nofear_ibi;
      feat_t1_nofear_rlf_eh(:,i) = temp_nofear_rlf;
      %feat_t1_nofear_rr_eh(:,i)  = temp_nofear_rr;
      temp_fear_ibi        = [];
      temp_nofear_ibi      = [];
      temp_fear_rlf        = [];
      temp_nofear_rlf      = [];
      temp_fear_rr         = [];
      temp_nofear_rr       = [];
      temp_ibi             = [];
      temp_ibi_data_fear   = [];
      temp_ibi_data_nofear = [];

    end

      f=figure;
      f.Name = "Volunteer " + s{vol(i),1}.ParticipantNum +  " // EH mean IBI ";
      axes1 = axes;
      hold(axes1,'on');
      b=bar([mean(mean(feat_t1_fear_ibi_eh'))]);
      set(b,'DisplayName','BioSignal',...
      'FaceColor',[0.901960784313726 0.901960784313726 0.901960784313726]);
      hold on;b=bar(2,[mean(mean(feat_t1_nofear_ibi_eh'))]);
      set(b,'DisplayName','Proposed',...
      'FaceColor',[0.501960784313725 0.501960784313725 0.501960784313725]);
      errorbar(1,[mean(mean(feat_t1_fear_ibi_eh'))],[mad(mean(feat_t1_fear_ibi_eh'))/2],[mad(mean(feat_t1_fear_ibi_eh'))/2]);
      errorbar(2,[mean(mean(feat_t1_nofear_ibi_eh'))],[mad(mean(feat_t1_nofear_ibi_eh'))/2],[mad(mean(feat_t1_nofear_ibi_eh'))/2]);
      ylabel({'_meanIBI'});
      set(axes1,'FontSize',14,'XTick',[1.5 4.5],'XTickLabel',{'Fear','No Fear'},...
      'YGrid','on');
      %legend(axes1,'show');

%       f=figure;
%       f.Name = "Volunteer " + s{vol(i),1}.ParticipantNum +  " // EH Ratio LF/HF ";
%       axes1 = axes;
%       hold(axes1,'on');
%       b=bar([mean(mean(feat_t1_fear_rlf_eh'))]);
%       set(b,'DisplayName','BioSignal',...
%       'FaceColor',[0.901960784313726 0.901960784313726 0.901960784313726]);
%       hold on;b=bar(2,[mean(mean(feat_t1_nofear_rlf_eh'))]);
%       set(b,'DisplayName','Proposed',...
%       'FaceColor',[0.501960784313725 0.501960784313725 0.501960784313725]);
%       errorbar(1,[mean(mean(feat_t1_fear_rlf_eh'))],[mad(mean(feat_t1_fear_rlf_eh'))/2],[mad(mean(feat_t1_fear_rlf_eh'))/2]);
%       errorbar(2,[mean(mean(feat_t1_nofear_rlf_eh'))],[mad(mean(feat_t1_nofear_rlf_eh'))/2],[mad(mean(feat_t1_nofear_rlf_eh'))/2]);
%       ylabel({'ratio LF/HF'});
%       set(axes1,'FontSize',14,'XTick',[1.5 4.5],'XTickLabel',{'Fear','No Fear'},...
%       'YGrid','on');
%       %legend(axes1,'show');
%       
%       f=figure;
%       f.Name = "Volunteer " + s{vol(i),1}.ParticipantNum +  " // EH Ratio LF/HF ";
%       axes1 = axes;
%       hold(axes1,'on');
%       b=bar([mean(mean(feat_t1_fear_rlf_eh'))]);
%       set(b,'DisplayName','BioSignal',...
%       'FaceColor',[0.901960784313726 0.901960784313726 0.901960784313726]);
%       hold on;b=bar(2,[mean(mean(feat_t1_nofear_rlf_eh'))]);
%       set(b,'DisplayName','Proposed',...
%       'FaceColor',[0.501960784313725 0.501960784313725 0.501960784313725]);
%       errorbar(1,[mean(mean(feat_t1_fear_rlf_eh'))],[mad(mean(feat_t1_fear_rlf_eh'))/2],[mad(mean(feat_t1_fear_rlf_eh'))/2]);
%       errorbar(2,[mean(mean(feat_t1_nofear_rlf_eh'))],[mad(mean(feat_t1_nofear_rlf_eh'))/2],[mad(mean(feat_t1_nofear_rlf_eh'))/2]);
%       ylabel({'ratio LF/HF'});
%       set(axes1,'FontSize',14,'XTick',[1.5 4.5],'XTickLabel',{'Fear','No Fear'},...
%       'YGrid','on');
%       %legend(axes1,'show');

end