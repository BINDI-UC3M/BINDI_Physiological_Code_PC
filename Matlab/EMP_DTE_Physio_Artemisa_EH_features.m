%% Function to handle the data coming from BBDDLab_Bindi
function Results = EMP_DTE_Physio_Artemisa_EH_features(data_in)

  %% data_in is a struct based of volunteers (rows) and trials (columns)
  [volunteers, trials] = size(data_in);
  %sampling rate is 200Hz for BVP, and 10Hz for GSR and SKT
  samprate_bbddlab_bvp = 200;
  samprate_bbddlab_gsr = 10;
  %create data to store features
  %data_features = struct();
  
  for i=1:volunteers
    for k=1:trials
        
     %Display some info
     fprintf('Volunteer %d, Trial %d, extracting...\n',i,k);
        
      %Create the BVP signals
%       bvp_sig_neutro   = BVP_create_signal(data_in{i,k}.EH.Neutro.raw.bvp_filt, samprate_bbddlab_bvp);
      bvp_sig_video    = BVP_create_signal(data_in{i,k}.EH.Video.raw.bvp_filt, samprate_bbddlab_bvp);
      bvp_sig_labels   = BVP_create_signal(data_in{i,k}.EH.Labels.raw.bvp_filt, samprate_bbddlab_bvp);
      bvp_sig_recovery = BVP_create_signal(data_in{i,k}.EH.Recovery.raw.bvp_filt, samprate_bbddlab_bvp);
      
      %Create the GSR signals
%       gsr_sig_neutro   = GSR_create_signal(data_in{i,k}.GSR.Neutro.raw.gsr_uS_filtered_dn_sm, samprate_bbddlab_gsr);
      gsr_sig_video    = GSR_create_signal(data_in{i,k}.EH.Video.raw.gsr_uS_filtered_dn_sm, samprate_bbddlab_gsr);
      gsr_sig_labels   = GSR_create_signal(data_in{i,k}.EH.Labels.raw.gsr_uS_filtered_dn_sm, samprate_bbddlab_gsr);
      gsr_sig_recovery = GSR_create_signal(data_in{i,k}.EH.Recovery.raw.gsr_uS_filtered_dn_sm, samprate_bbddlab_gsr);
      
      
       % 1.4: BVP advanced data processing: Wavelet Synchrosqueezed Transform
     time=0:1/samprate_biospeech:...
          (length(bvp_sig.raw)/samprate_biospeech - 1/samprate_biospeech);
     iterations = 2;
     for w=1:iterations
%        figure;
%        plot(time,bvp_sig.raw)
%        hold on;
       imfs = emd(bvp_sig.raw,'Display',0);
       z =bvp_sig.raw';
       [~,b] = size(imfs);
       for j=3:b
         z = z - imfs(:,j);
       end
       [sst,F] = wsst(z,samprate_biospeech);
       t=find(F>0.8 & F<3.5);
       [fridge,iridge] = wsstridge(sst(t,:),2,F(1,t),'NumRifges',1);
       xrec = iwsst(sst(t,:),iridge);
       bvp_sig.raw = xrec(:,1) ;%+ xrec(:,2);
       %plot(time,bvp_sig.raw);
       bvp_sig.raw=bvp_sig.raw';
       
       %Draw result:
%        figure;
%        plot(time,fridge,'k--','linewidth',4);
%        hold on;
%        contour(time,F(1,t),abs(sst(t,:)));
%        ylim([0.5 3.5]);
     end
      
      
      %% Stage 2: Extracting Features %%
      % Deal with window and overlapping
      operational_window = 20; %seconds
      overlapin_window   = 10;  %seconds
      
      %Video
      start_bvp   = 1;
      stop_bvp    = operational_window*samprate_bbddlab_bvp;
      start_gsr   = 1;
      stop_gsr    = operational_window*samprate_bbddlab_gsr;
      overlap_bvp = overlapin_window*samprate_bbddlab_bvp;
      overlap_gsr = overlapin_window*samprate_bbddlab_gsr;      
      window_num  = 1;
      bvp_sig_cpy = bvp_sig_video;
      gsr_sig_cpy = gsr_sig_video;
      while(stop_bvp<length(bvp_sig_video.raw) && ...
            stop_gsr<length(gsr_sig_video.raw))
        %BVP processing
        %To measure the time taken for each physio-processing uncomment the
        %tic-toc commands
        %tic
        bvp_sig_cpy.raw = bvp_sig_video.raw(start_bvp:stop_bvp);
        [data_features{i,k}.EH.Video.BVP_feats(window_num,:), ...
         data_features{i,k}.EH.Video.BVP_feats_names] = ...
            BVP_features_extr(bvp_sig_cpy);
        %toc
        %GSR processing
        gsr_sig_cpy.raw = gsr_sig_video.raw(start_gsr:stop_gsr);
        [data_features{i,k}.EH.Video.GSR_feats(window_num,:), ...
         data_features{i,k}.EH.Video.GSR_feats_names] = ...
            GSR_features_extr(gsr_sig_cpy);       
        start_bvp = start_bvp + overlap_bvp;
        stop_bvp  = stop_bvp  + overlap_bvp;
        start_gsr = start_gsr + overlap_gsr;
        stop_gsr  = stop_gsr  + overlap_gsr;
        window_num = window_num + 1;
      end
      
%       %Labels
%       start_bvp   = 1;
%       stop_bvp    = operational_window*samprate_bbddlab_bvp;
%       start_gsr   = 1;
%       stop_gsr    = operational_window*samprate_bbddlab_gsr;
%       overlap_bvp = overlapin_window*samprate_bbddlab_bvp;
%       overlap_gsr = overlapin_window*samprate_bbddlab_gsr;      
%       window_num  = 1;
%       bvp_sig_cpy = bvp_sig_labels;
%       gsr_sig_cpy = gsr_sig_labels;
%       while(stop_bvp<length(bvp_sig_labels.raw) && ...
%             stop_gsr<length(gsr_sig_labels.raw))
%         %BVP processing
%         %To measure the time taken for each physio-processing uncomment the
%         %tic-toc commands
%         %tic
%         bvp_sig_cpy.raw = bvp_sig_labels.raw(start_bvp:stop_bvp);
%         [data_features{i,k}.EH.Labels.BVP_feats(window_num,:), ...
%          data_features{i,k}.EH.Labels.BVP_feats_names] = ...
%             BVP_features_extr(bvp_sig_cpy);
%         %toc
%         %GSR processing
%         gsr_sig_cpy.raw = gsr_sig_labels.raw(start_gsr:stop_gsr);
%         [data_features{i,k}.EH.Labels.GSR_feats(window_num,:), ...
%          data_features{i,k}.EH.Labels.GSR_feats_names] = ...
%             GSR_features_extr(gsr_sig_cpy);       
%         start_bvp = start_bvp + overlap_bvp;
%         stop_bvp  = stop_bvp  + overlap_bvp;
%         start_gsr = start_gsr + overlap_gsr;
%         stop_gsr  = stop_gsr  + overlap_gsr;
%         window_num = window_num + 1;
%       end
      
%       %Recovery
%       start_bvp   = 1;
%       stop_bvp    = operational_window*samprate_bbddlab_bvp;
%       start_gsr   = 1;
%       stop_gsr    = operational_window*samprate_bbddlab_gsr;
%       overlap_bvp = overlapin_window*samprate_bbddlab_bvp;
%       overlap_gsr = overlapin_window*samprate_bbddlab_gsr;      
%       window_num  = 1;
%       bvp_sig_cpy = bvp_sig_recovery;
%       gsr_sig_cpy = gsr_sig_recovery;
%       while(stop_bvp<length(bvp_sig_recovery.raw) && ...
%             stop_gsr<length(gsr_sig_recovery.raw))
%         %BVP processing
%         %To measure the time taken for each physio-processing uncomment the
%         %tic-toc commands
%         %tic
%         bvp_sig_cpy.raw = bvp_sig_recovery.raw(start_bvp:stop_bvp);
%         [data_features{i,k}.EH.Recovery.BVP_feats(window_num,:), ...
%          data_features{i,k}.EH.Recovery.BVP_feats_names] = ...
%             BVP_features_extr(bvp_sig_cpy);
%         %toc
%         %GSR processing
%         gsr_sig_cpy.raw = gsr_sig_recovery.raw(start_gsr:stop_gsr);
%         [data_features{i,k}.EH.Recovery.GSR_feats(window_num,:), ...
%          data_features{i,k}.EH.Recovery.GSR_feats_names] = ...
%             GSR_features_extr(gsr_sig_cpy);       
%         start_bvp = start_bvp + overlap_bvp;
%         stop_bvp  = stop_bvp  + overlap_bvp;
%         start_gsr = start_gsr + overlap_gsr;
%         stop_gsr  = stop_gsr  + overlap_gsr;
%         window_num = window_num + 1;
%       end
%       
%       %Check in case recovery is smaller than operational_window
%       %NOTE!!! --> if this is the case, just use the recovery to normalize
%       %data for intra-differences within the subject or for analytical
%       %purposes
%       if window_num == 1
%         %BVP processing
%         %To measure the time taken for each physio-processing uncomment the
%         %tic-toc commands
%         %tic
%         bvp_sig_cpy.raw = bvp_sig_recovery.raw;
%         [data_features{i,k}.EH.Recovery.BVP_feats(window_num,:), ...
%          data_features{i,k}.EH.Recovery.BVP_feats_names] = ...
%             BVP_features_extr(bvp_sig_cpy);
%         %toc
%         %GSR processing
%         gsr_sig_cpy.raw = gsr_sig_recovery.raw;
%         [data_features{i,k}.EH.Recovery.GSR_feats(window_num,:), ...
%          data_features{i,k}.EH.Recovery.GSR_feats_names] = ...
%             GSR_features_extr(gsr_sig_cpy); 
%       end
      
    end 
  end
    
  %% Stage 3: Trainning the model - Validation
  %...TBD
  
  %% Stage 4: Testing the model - testing with unseen samples
  %...TBD
  
  %% Stage 5: Give back results
  Results_BBDDLab_EH.features = data_features;
  Results_BBDDLab_EH.operational_window = operational_window;
  Results_BBDDLab_EH.overlapin_window = overlapin_window;
  %...TBD
  
  %% Stage 6: Perform EDA (exploratory data analysis)
  %...TBD
end