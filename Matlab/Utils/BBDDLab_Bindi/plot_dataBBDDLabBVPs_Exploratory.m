function [data_features]=plot_dataBBDDLabBVPs_Exploratory(s,va,vb)

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
    temp_ibi_all         = [];
    temp_ibi_data_fear   = [];
    temp_ibi_data_nofear = [];
    plot_poincare        = 0;
    plot_lfhf            = 1;

    %Main loop based on #volunteers
    for i=2:2%length(vol)
      bvp_acc{i}.EH.data =[];
      temp = [];
      
      if plot_poincare
      %figure('WindowState','maximized','Color',[1 1 1]);
      f2=figure('Color',[1 1 1]);
      f2.Name = "Volunteer " + s{vol(i),1}.ParticipantNum +  " // Poincare Plot ";
      xy2=subplot(1,2,1);
      xlim([0.5 1.5])
      ylim([0.5 1.5])
      %xy2 = axes;
      % Create ylabel
      ylabel('RR_{n+1}');
      % Create xlabel
      xlabel('RR_{n}');
      set(xy2,'FontName','Times New Roman','FontSize',18);
      %f=figure('Color',[1 1 1]);
      %f.Name = "Volunteer " + s{vol(i),1}.ParticipantNum +  " // Poincare Plot per stimulus ";
      xy =subplot(1,2,2);
      xlim([0.5 1.5])
      ylim([0.5 1.5])
      %xy = axes;
      % Create ylabel
      ylabel('RR_{n+1}');
      % Create xlabel
      xlabel('RR_{n}');
      set(xy,'FontName','Times New Roman','FontSize',18);
      end
      
      temp_ibi_all = [];
      for j=va:vb
		
		%Features are extracted based on the whole signal (no window-split)
        fprintf("Volunter %d / Video %d \n",i,j);
        bvp_acc{i}.EH.data=[bvp_acc{i}.EH.data; (s{vol(i),j}.EH.Video.raw.bvp_filt)];
        
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
          if plot_lfhf
            temp = [temp smooth(data_features{i,j}.EH.Video.BVP_feats(window_num,11),10)];
            bar(temp,1)
           
            pause(0.02)
          end
          
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
        timelocations =[];
        for k=1:window_num-1
		 temp_ibi = [temp_ibi; data_features{i, j}.EH.IBI{k}.raw'];
         %plot(temp_ibi(1:end-1),temp_ibi(2:end),'*-');
         timelocations = [timelocations;...
                  (round(data_features{i, j}.EH.IBI{k}.timelocations(1)));...
                 diff(round(data_features{i, j}.EH.IBI{k}.timelocations))'];
        end
        
        %Plot Poincares + video
        if plot_poincare
        axes(xy);
        hold on
        for q=3:length(temp_ibi)
          if mod(q,10)==0
              hold off
          else
              hold on
          end
          if ismember(j,videos_t1_fear)
            plot(xy,temp_ibi(q-2:q-1),temp_ibi(q-1:q),'r*-','MarkerSize',10);
            xlim([0.5 1.5])
            ylim([0.5 1.5])
            %xy = axes;
            % Create ylabel
            ylabel('RR_{n+1}');
            % Create xlabel
            xlabel('RR_{n}');
            set(xy,'FontName','Times New Roman','FontSize',18);
            hold on
          else
            plot(xy,temp_ibi(q-2:q-1),temp_ibi(q-1:q),'k*-','MarkerSize',10);
            xlim([0.5 1.5])
            ylim([0.5 1.5])
            %xy = axes;
            % Create ylabel
            ylabel('RR_{n+1}');
            % Create xlabel
            xlabel('RR_{n}');
            set(xy,'FontName','Times New Roman','FontSize',18);
            hold on
          end
          pause(timelocations(q)/100000)
        end
        timelocations =[];
        temp_ibi_all = [temp_ibi; NaN];
        axes(xy2);
        hold on
        if ismember(j,videos_t1_fear)
            plot(xy2,temp_ibi_all(1:end-1),temp_ibi_all(2:end),'r*','MarkerSize',10);
            xlim([0.5 1.5])
            ylim([0.5 1.5])
            hold on
        else
            plot(xy2,temp_ibi_all(1:end-1),temp_ibi_all(2:end),'k*','MarkerSize',10);
            xlim([0.5 1.5])
            ylim([0.5 1.5])
            hold on
        end
        end
        temp_ibi = [];
      
      end
      
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

%       if plot_lfhf
%       f=figure;
%       f.Name = "Volunteer " + s{vol(i),1}.ParticipantNum +  " // EH mean IBI ";
%       axes1 = axes;
%       hold(axes1,'on');
%       b=bar([mean(mean(feat_t1_fear_ibi_eh'))]);
%       set(b,'DisplayName','BioSignal',...
%       'FaceColor',[0.901960784313726 0.901960784313726 0.901960784313726]);
%       hold on;b=bar(2,[mean(mean(feat_t1_nofear_ibi_eh'))]);
%       set(b,'DisplayName','Proposed',...
%       'FaceColor',[0.501960784313725 0.501960784313725 0.501960784313725]);
%       errorbar(1,[mean(mean(feat_t1_fear_ibi_eh'))],[mad(mean(feat_t1_fear_ibi_eh'))/2],[mad(mean(feat_t1_fear_ibi_eh'))/2]);
%       errorbar(2,[mean(mean(feat_t1_nofear_ibi_eh'))],[mad(mean(feat_t1_nofear_ibi_eh'))/2],[mad(mean(feat_t1_nofear_ibi_eh'))/2]);
%       ylabel({'_meanIBI'});
%       set(axes1,'FontSize',14,'XTick',[1.5 4.5],'XTickLabel',{'Fear','No Fear'},...
%       'YGrid','on');
%       end
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