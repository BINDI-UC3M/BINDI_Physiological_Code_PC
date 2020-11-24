%we assume the pre-processed physilogical signals in mat file from  MAHNOB data is being used
%this script loads the MAHNOB data and converts it to the EEGLAB format that
%is readable by TEAP
%I assume the data is in MAHNOB_path
%I added minimally required fields to the structure
%Mohammad Soleymani June 2015 mohammad.soleymani@unige.ch
%Takes the path physio_files_path and writes the mat files in eeglab format
%acceptable by TEAP
%for ECG we take the ECG2-ECG3 as the lead
clc
clear
close all
%replace thee following line by the location where you saved the mat files
%Females
MAHNOB_path = 'G:/Mi unidad/JOSE_PHD_THESIS/PhD_Jose/Root/TEAP-master/TEAP-master/src/tests/mahnob_mat/';
%Males
%MAHNOB_path = 'G:/Mi unidad/JOSE_PHD_THESIS/PhD_Jose/Root/5_SystemThesis/MAHNOB/originalData/TEAP_Format_Male/';
cntr = 0;
files_physio = dir([MAHNOB_path '*_eeglab.mat']);
dEmotion = {'disgust','anger','amusement','disgust','amusement','joy','amusement','joy','fear','joy','fear','sadness','fear','sadness','neutral','sadness','neutral','joy','neutral','joy'};
arousalNumMapped = {'1','3','2','1','2','2','2','2','3','2','3','1','3','1','1','1','1','2','1','2'};
valenceNumMapped = {'1','1','3','1','3','3','3','3','1','3','1','1','1','1','2','1','2','3','2','3'};
arovalNumMapped = {'1','2','3','1','3','3','3','3','2','3','2','1','2','1','4','1','4','3','4','3'};
%there is only one epoch
epoch = 1;
ctr_3w = 1;
ctr_2w = 1;
ctr_1w = 1;
ctr_05w = 1;
ctr_02w = 1;
window_hist = [];
for i = 1:length(files_physio)
    fprintf('loading file %s\n',files_physio(i).name);
    s = strsplit(files_physio(i).name ,'_');
    subj_id = str2double(s{1}(2:3));
    trial_id = str2double(s{2}(2:3));    
    eeglab_file = sprintf('%s%s',MAHNOB_path,files_physio(i).name);
    %loading the file
    bulk = Bulk_load(eeglab_file);
    bulk_cpy = bulk;
    %loading feedbacks
    feedback_file = strrep(eeglab_file, 'eeglab', 'feedback');
    load(feedback_file);
    if feedback.felt_arousal>=5 && feedback.felt_valence<5
     label=2;
    elseif feedback.felt_arousal<5 && feedback.felt_valence<5
     label=3;
    elseif feedback.felt_arousal<5 && feedback.felt_valence>=5
     label=4;
    else
     label=1;
    end
    
    %fear system 1
    if feedback.felt_arousal>=5 && feedback.felt_valence<=5 && feedback.felt_control<5
     label_fear1=1;
    else
     label_fear1=0;
    end
    
    %fear system 2
    if feedback.felt_arousal>=7 && feedback.felt_valence<3 && feedback.felt_control<3
     label_fear2=3;
    elseif (feedback.felt_arousal>=5 && feedback.felt_arousal<7) && (feedback.felt_valence>=3 && feedback.felt_valence<5) && (feedback.felt_control>=3 && feedback.felt_control<5)
     label_fear2=2;
    elseif (feedback.felt_arousal>=3 && feedback.felt_arousal<5) && (feedback.felt_valence>=5 && feedback.felt_valence<7) && (feedback.felt_control>=5 && feedback.felt_control<7)
     label_fear2=1;
    else
     label_fear2=0;
    end
    
    %fear "online" system 3
%     if arousalNumMapped(trial_id)==3 && valenceNumMapped(trial_id)==1 && feedback.felt_control<5
%      label_fear_online=3;
%     elseif arousalNumMapped(trial_id)==3 && valenceNumMapped(trial_id)==1 && (feedback.felt_control>=3 && feedback.felt_control<5)
%      label_fear_online=2;
%     elseif arousalNumMapped(trial_id)==3 && valenceNumMapped(trial_id)==1 && (feedback.felt_control>=5 && feedback.felt_control<7)
%      label_fear_online=1;
%     else
%      label_fear_online=0;
%     end
    
     window_max = 3;
     overlap_per = 0.5;
     %defining window...
     total_time = fix(length(bulk(epoch).GSR.raw)/bulk(epoch).GSR.samprate);
     window_time = total_time/window_max;
     window_total = window_max/overlap_per - 1/overlap_per + 1;
     total_size = length(bulk(epoch).GSR.raw);
     partial_size = round(total_size/window_max);
     overlap_window_size= round(partial_size*(1-overlap_per));
     window_hist(i,subj_id) = window_total;
     for window = 1:window_total
        fprintf('extracting all the features for window %d subject %d epoch %d\n',window,subj_id, trial_id);
        if window == 1
          start = (((window-1)*partial_size)+1);
          stop  = (partial_size*window);
        else
          start = (((window-1)*partial_size)+1) - overlap_window_size*(window-1)-1;
          stop  = (partial_size*window) - overlap_window_size*(window-1)-1;
        end
        bulk_cpy(epoch).GSR.raw=bulk(epoch).GSR.raw(start:stop);
        bulk_cpy(epoch).ECG.raw=bulk(epoch).ECG.raw(start:stop);
        bulk_cpy(epoch).HST.raw=bulk(epoch).HST.raw(start:stop);
%         bulk_cpy(epoch).GSR.samprate = 128;
%         bulk_cpy(epoch).ECG.samprate = 128;
%         bulk_cpy(epoch).HST.samprate = 128;
        
        features(window,subj_id,trial_id).feedback = feedback;
        %extracting ECG features
        [features(window,subj_id,trial_id).ECG_feats, features(window,subj_id,trial_id).ECG_feats_names] = ...
            ECG_feat_extr(bulk_cpy(epoch));
        %extracting EEG features
        %average re-referencing 
        %EEGSignal = EEG_reference_mean(bulk(epoch));
        %[features(subj_id,trial_id).EEG_feats, features(subj_id,trial_id).EEG_feats_names] = ...
         %   EEG_feat_extr(EEGSignal);
        %extracting GSR features
        [features(window,subj_id,trial_id).GSR_feats, features(window,subj_id,trial_id).GSR_feats_names] = ...
            GSR_feat_extr(bulk_cpy(epoch));
        %extracting skin temperature features
        [features(window,subj_id,trial_id).HST_feats, features(window,subj_id,trial_id).HST_feats_names] = ...
            HST_feat_extr(bulk_cpy(epoch));
        %extracting respiration features
        %[features(subj_id,trial_id).RES_feats, features(subj_id,trial_id).RES_feats_names] = ...
         %   RES_feat_extr(bulk(epoch));

          periph_feats_3window(ctr_3w,:,subj_id) =  [features(window,subj_id,trial_id).GSR_feats...
                                             features(window,subj_id,trial_id).ECG_feats...
                                             features(window,subj_id,trial_id).HST_feats];
          
          labels_3w(ctr_3w,1,subj_id) = label;
          labels_3w_fear1(ctr_3w,1,subj_id) = label_fear1;
          labels_3w_fear2(ctr_3w,1,subj_id) = label_fear2;
          labels_3w_online_dEmotion(ctr_3w,1,subj_id) = dEmotion(trial_id);
          labels_3w_online_aro(ctr_3w,1,subj_id) = arousalNumMapped(trial_id);
          labels_3w_online_val(ctr_3w,1,subj_id) = valenceNumMapped(trial_id);
          labels_3w_online_aroval(ctr_3w,1,subj_id) = arovalNumMapped(trial_id);
          ctr_3w = ctr_3w+1;

          if window>1
            periph_feats_2window(ctr_2w,:,subj_id) = [features(window,subj_id,trial_id).GSR_feats...
                                            features(window,subj_id,trial_id).ECG_feats...
                                             features(window,subj_id,trial_id).HST_feats];
            labels_2w(ctr_2w,1,subj_id) = label;
            labels_2w_fear1(ctr_2w,1,subj_id) = label_fear1;
            labels_2w_fear2(ctr_2w,1,subj_id) = label_fear2;
            labels_2w_online_dEmotion(ctr_2w,1,subj_id) = dEmotion(trial_id);
            labels_2w_online_aro(ctr_2w,1,subj_id) = arousalNumMapped(trial_id);
            labels_2w_online_val(ctr_2w,1,subj_id) = valenceNumMapped(trial_id);
            labels_2w_online_aroval(ctr_2w,1,subj_id) = arovalNumMapped(trial_id);
            ctr_2w = ctr_2w+1;
          end

          if window>2
            periph_feats_1window(ctr_1w,:,subj_id) =  [features(window,subj_id,trial_id).GSR_feats ...
                                            features(window,subj_id,trial_id).ECG_feats...
                                             features(window,subj_id,trial_id).HST_feats];
            labels_1w(ctr_1w,1,subj_id) = label;
            labels_1w_fear1(ctr_1w,1,subj_id) = label_fear1;
            labels_1w_fear2(ctr_1w,1,subj_id) = label_fear2;
            labels_1w_online_dEmotion(ctr_1w,1,subj_id) = dEmotion(trial_id);
            labels_1w_online_aro(ctr_1w,1,subj_id) = arousalNumMapped(trial_id);
            labels_1w_online_val(ctr_1w,1,subj_id) = valenceNumMapped(trial_id);
            labels_1w_online_aroval(ctr_1w,1,subj_id) = arovalNumMapped(trial_id);
            ctr_1w = ctr_1w+1;
          end
          
          if window>3
            periph_feats_05window(ctr_05w,:,subj_id) =  [features(window,subj_id,trial_id).GSR_feats ...
                                            features(window,subj_id,trial_id).ECG_feats...
                                             features(window,subj_id,trial_id).HST_feats];
            labels_05w(ctr_05w,1,subj_id) = label;
            labels_05w_fear1(ctr_05w,1,subj_id) = label_fear1;
            labels_05w_fear2(ctr_05w,1,subj_id) = label_fear2;
            labels_05w_online_dEmotion(ctr_05w,1,subj_id) = dEmotion(trial_id);
            labels_05w_online_aro(ctr_05w,1,subj_id) = arousalNumMapped(trial_id);
            labels_05w_online_val(ctr_05w,1,subj_id) = valenceNumMapped(trial_id);
            labels_05w_online_aroval(ctr_05w,1,subj_id) = arovalNumMapped(trial_id);
            ctr_05w = ctr_05w+1;
          end
          
          if window>4
            periph_feats_02window(ctr_02w,:,subj_id) =  [features(window,subj_id,trial_id).GSR_feats ...
                                            features(window,subj_id,trial_id).ECG_feats...
                                             features(window,subj_id,trial_id).HST_feats];
            labels_02w(ctr_02w,1,subj_id) = label;
            labels_02w_fear1(ctr_02w,1,subj_id) = label_fear1;
            labels_02w_fear2(ctr_02w,1,subj_id) = label_fear2;
            labels_02w_online_dEmotion(ctr_02w,1,subj_id) = dEmotion(trial_id);
            labels_02w_online_aro(ctr_02w,1,subj_id) = arousalNumMapped(trial_id);
            labels_02w_online_val(ctr_02w,1,subj_id) = valenceNumMapped(trial_id);
            labels_02w_online_aroval(ctr_02w,1,subj_id) = arovalNumMapped(trial_id);
            ctr_02w = ctr_02w+1;
          end

     end
    fprintf('extracted all the features for subject %d trial %d\n',subj_id, trial_id);
    if trial_id == 20
      fprintf('------------------------------------------------\n');
      fprintf('extracted all the features for subject %d\n',subj_id);
      fprintf('------------------------------------------------\n');
      ctr_3w = 1;
      ctr_2w = 1;
      ctr_1w = 1;
      ctr_05w = 1;
      ctr_02w = 1;
    end
    
end
%correct the following path to where you want your features to be saved
save('mahnob_features.mat','features');


fprintf('Done! Successfully extracted the feaures\n');
