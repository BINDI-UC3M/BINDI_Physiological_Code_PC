function Results_BioSpeech = EMP_DTE_Physio_Artemisa_JustTrain(info,labels_in)


dbstop if error
% Input: data_in --> (info.data_in)this is an array of tables
  %        each table corresponds to BVP and GSR extracted features
  %        In case of having a need to normalize there would be two fields,
  %        data_in.Baseline and data_in.Experiment, the first can be taken
  %        for performing the normalization procedure
  %        response_in --> (info.response_in)labels for training and testing.
  %        info --> configuration parameters
  
  %Get Data and Labels
%   data_in     = info.features;
%   response_in = info.response_in;
  
  %Get the number of volunteers and trials
  %Max Volunteers are 47 and max trial are 14

  %check values
%   if volunteers > 47 || trials > 14
%     error('Number of volunteers or trials exceed the maximun allowed');
%   end
     
  %% Stage 3: Assign labels
%   peri   = {};
%   labels = {}; 
%   if ~isempty(response_in)
    %Get the volunteers number ID
%     volunts = unique(response_in.Voluntaria,'rows');
%     volunts = sort(volunts);
 exclude_vec=[12];
% voluntarias_grupo_2 =[ 1,  3,  6 ,7, 8 , 9,  12 , 16, 18 ,19, 21];
% voluntarias_grupo_2 =[ 1,  3,  6 ,7, 8 , 9 , 16, 18 ,19, 21];
% voluntarias_grupo_1 = [2,4,5,10,11,13,14,15,17,20];
% voluntarias_grupo_1_exc = [2,4,5,10,11,12,13,14,15,17,20];
% exclude_vec=voluntarias_grupo_1_exc;
index=1;
for k=1:21
    
    if (~ (sum(k==exclude_vec)>0))  
        for j=1:4
              data_in{index,j}=info.features{k,j};
              
        end
        temp_labels(1,index)=labels_in(1,k);
      index=index+1;
    end
  
    
    
end

labels_in=temp_labels;


  [volunteers, trials] = size(data_in);
  
%   for i=1:volunteers
%      if() 
%       
%       
%   end
  
  

volunteers=index-1;
% n_samples_2  = 10;
% n_samples_4  = 20;
% n_samples    = 1;

% n_samples_2  = 10;
% n_samples_4  = 20;
% n_samples    = 1;


n_samples_2  = 1;
n_samples_4  = 1;
n_samples    = 1;
% rngSeed'shuffle'
    for i=1:volunteers
      k = 1;
       n_samples=1;
      win_num=length(data_in{i,k}.EH.Video.HR_feats(:,1));
      temp = [(data_in{i,k}.EH.Video.HR_feats(n_samples:win_num,2:23)) ...
                       (data_in{i,k}.EH.Video.GSR_feats(n_samples:win_num,:))...
                       (data_in{i,k}.EH.Video.SKT_feats(n_samples:win_num,:))...
                       (data_in{i,k}.EH.Video.RESP_feats(n_samples:win_num,:))];
      peri_loto{i,k} = temp;
      peri{:,:,i}    = temp;
%       [win, ~] = size(peri{:,:,i});
%       t = 1:1:win;
      %t(:) = response_in.PAD(response_in.Voluntaria==volunts(i) & response_in.Video==1);
%       t(:) = response_in.EmocionReportada(response_in.Voluntaria==volunts(i) & response_in.Video==1);     
      t=[];
      t(1:win_num-n_samples+1)=0;
%         if strcmp(labels_in{1,i}.emotions(k+1),'Miedo')
%             t(1:win_num-n_samples+1)=1;
%         else
%             t(1:win_num-n_samples+1)=0;
%         end
      labels_loto{i,k} = t(:);
      labels{:,:,i} = t(:); 
      
      for k=2:trials
          if(k==2 )
              n_samples=n_samples_2;
          elseif(k==4 )
              n_samples=n_samples_4;
          else
              n_samples=1;
          end
          win_num=length(data_in{i,k}.EH.Video.HR_feats(:,1));
        temp = [(data_in{i,k}.EH.Video.HR_feats(n_samples:win_num,2:23)) ...
                         (data_in{i,k}.EH.Video.GSR_feats(n_samples:win_num,:))...
                         (data_in{i,k}.EH.Video.SKT_feats(n_samples:win_num,:))...
                         (data_in{i,k}.EH.Video.RESP_feats(n_samples:win_num,:))];
        peri_loto{i,k} = temp;
        peri{:,:,i}   =[ peri{:,:,i}; temp];
%         [win, ~] = size(temp);
%         t = 1:1:win;
        %t(:) = response_in.PAD(response_in.Voluntaria==volunts(i) & response_in.Video==k);
%         t(:) = response_in.EmocionReportada(response_in.Voluntaria==volunts(i) & response_in.Video==k);
        t=[];
%         if strcmp(labels_in{1,i}.emotions(k+1),'Miedo')
%             t(1:win_num-n_samples+1)=1;
%         else
%             t(1:win_num-n_samples+1)=0;
%         end
        if k==3
            t(1:win_num-n_samples+1)=0;
%             n_no_miedo=n_no_miedo+win_num-n_samples+1;
%            index_no_miedo
%             cuenta_i_no_miedo=cuenta_i_no_miedo+1;
        else
            t(1:win_num-n_samples+1)=1;
        end
        labels_loto{i,k} = t(:);
        labels{:,:,i} = [labels{:,:,i}; t(:)]; 
      end
    end
%   end
  %% Stage 3.1: Option to normalize data with baseline:
%   % This step is optional and should be subjected to application neeeds
%   normalizeBybaseline = info.normalizeBybaseline;  
%   if normalizeBybaseline
%     %%TBD
%   end
%  peri_temp = [];
%       label_temp = [];
%       for i=1:20
%         %identify possible inf values
%         p_temp = peri(:,:,i);
%         l_temp = labels(:,:,i);
%         [r,~] = find(isinf(cell2mat(p_temp(:,:))));
%         if r>0
%           p_temp(r,:) = [];
%           l_temp(r,:,:)= [];
%         end
%         
%         %In case of normalizing the set of features per volunteer
%         peri_temp  = [peri_temp ; zscore(cell2mat(p_temp))];
%         
%         %In case of NOT normalizing the set of features per volunteer
%         %peri_temp  = [peri_temp ; (cell2mat(p_temp))];
%         
%         label_temp = [label_temp ; cell2mat(l_temp)];
%       end
%    parameters.featSelection = 'mrmr';
%    [fs,~,~] = feature_sel_module(peri_temp,peri_temp, label, parameters);

 %% Stage 4.1: Get the balance for the dataset. Just for checking purposes.
  %Get the balance dataset
  balance = [];
%   if ~isempty(response_in)
    for i=1:volunteers
      class1 = numel(find(labels{:,:,i}==0));
      class2 = numel(find(labels{:,:,i}==1));
      balance = [balance; class1 class2];
    end
    balance_total = balance(1:volunteers/2,:) + ...
                    balance((volunteers/2 + 1):volunteers,:);
%   end
  

%% Stage 4.2 Under sample to balance the dataset
% rng('shuffle')
% s = rng
% Results_BioSpeech.seed=s.Seed;
%    for i=1:volunteers
%        vect_fear=find(labels{:,:,i}==1);
%        n_diff =balance(i,2)-balance(i,1);
%        n_t_samples=balance(i,2)+balance(i,1);
%        sample_removed_index=randperm(length(vect_fear),n_diff);
%        sample_remove=vect_fear(sample_removed_index);
%        index_1=1;
%        caca=peri{:,:,i};
%        caca2=[];
%        caca3=labels{:,:,i};
%        caca4=[];
%        for j=1:n_t_samples
%            if(~sum(sample_remove==j))
%                caca2(index_1,:)=caca(j,:);
%                caca4(index_1,1)=caca3(j,1);
% %                peri_n{:,:,i}(index_1)=peri{:,:,i}(j);
% %                labels_n{:,:,i}(index_1)=labels{:,:,i}(j);
%                index_1=index_1+1;
%            end
%        end
%        peri{:,:,i}=caca2;
%        labels{:,:,i}=caca4;
%    end

  %% Stage 5 & 6: Trainning and testing.
%   volunteers
  if true
    for i=1:volunteers
      
      %Display some info
      fprintf('Running %d, Trainning and Testing...\n',i);
      
      %Create name file to store data
      fname = strcat('ResultsArtemisa_V',num2str(i));
%       fname = strcat('ResultsArtemisa_V',num2str(voluntarias_grupo_2(i)));
      fid = fopen([fname '.mat'],'w');
      fclose(fid); 
      
      %% Stage 5: Trainning the model - Validation
      
      %% Stage 5.1: Configuring the volunteers to be trained and tested
      peri_temp = peri;
      labels_temp = labels;
%       peri_temp_base = peribase;
%       labels_temp_base = labelsbase;
    
     
%       fullLOSO = info.fullLOSO; 
%       doubleHybrid = info.doubleHybrid; 
%       l2so = info.l2so;
%       l10so = info.l10so;
%       l2hso = info.l2hso;
      fullLOSO = 1; 
      doubleHybrid = 0; 
      l2so = 0;
      l10so = 0;
      l2hso = 0;
      
      if fullLOSO
%         peri_temp(:,:,[i (i+volunteers/2)])   = [];
%         labels_temp(:,:,[i (i+volunteers/2)]) = [];
        peri_temp(:,:,i)   = [];
        labels_temp(:,:,i) = [];
      elseif doubleHybrid
        peri_temp(:,:,[i (i+volunteers/2+1)])   = [];
        labels_temp(:,:,[i (i+volunteers/2+1)]) = [];
      elseif l2so
        %select two random volunteers
        vs = [1,2];
        class1_v1 = 0;
        class2_v1 = 0;
        class1_v2 = 0;
        class2_v2 = 0;
        while (class1_v1 + class1_v2)==0 || (class2_v1 + class2_v2)==0 ...
               || vs(1,1)==vs(1,2)
          vs = randi([1 volunteers/2],1,2);
          class1_v1 = balance_total(vs(1,1),1);
          class2_v1 = balance_total(vs(1,1),2);
          class1_v2 = balance_total(vs(1,2),1);
          class2_v2 = balance_total(vs(1,2),2);
        end
        
        vs =info.vTests{i};
          class1_v1 = balance_total(vs(1,1),1);
          class2_v1 = balance_total(vs(1,1),2);
          class1_v2 = balance_total(vs(1,2),1);
          class2_v2 = balance_total(vs(1,2),2);
        
        fprintf('Volunteers: %d(%d,%d) & %d(%d,%d)\n',vs(1,1),class1_v1,...
                                             class2_v1,vs(1,2),class1_v2,...
                                             class2_v2);
        peri_temp(:,:,[vs(1,1) vs(1,1)+volunteers/2 vs(1,2) vs(1,2)+volunteers/2])   = [];
        labels_temp(:,:,[vs(1,1) vs(1,1)+volunteers/2 vs(1,2) vs(1,2)+volunteers/2]) = [];
        peri_temp_base(:,:,[vs(1,1) vs(1,2)])   = [];
        labels_temp_base(:,:,[vs(1,1) vs(1,2)]) = [];
      elseif l2hso
        %select two random volunteers
        vs = [1,2];
        class1_v1 = 0;
        class2_v1 = 0;
        class1_v2 = 0;
        class2_v2 = 0;
        while (class1_v1 + class1_v2)==0 || (class2_v1 + class2_v2)==0 ...
               || vs(1,1)==vs(1,2)
          vs = randi([1 volunteers/2],1,2);
          class1_v1 = balance(vs(1,1),1);
          class2_v1 = balance(vs(1,1),2);
          class1_v2 = balance(vs(1,2),1);
          class2_v2 = balance(vs(1,2),2);
        end
        %vs = [35,2];
        fprintf('Volunteers: %d(%d,%d) & %d(%d,%d)\n',vs(1,1),class1_v1,...
                                             class2_v1,vs(1,2),class1_v2,...
                                             class2_v2);
        peri_temp(:,:,[vs(1,1)+volunteers/2 vs(1,2)+volunteers/2])   = [];
        labels_temp(:,:,[vs(1,1)+volunteers/2 vs(1,2)+volunteers/2]) = [];
        peri_temp_base(:,:,[vs(1,1) vs(1,2)])   = [];
        labels_temp_base(:,:,[vs(1,1) vs(1,2)]) = [];
      elseif l10so
        %select ten random volunteers
        vs = randperm(volunteers/2,10);
        peri_temp_base(:,:,vs)   = [];
        labels_temp_base(:,:,vs)   = [];
        vs = [vs vs+volunteers/2];
        fprintf('L10SO\n');
        peri_test = peri_temp(:,:,vs);
        peri_temp(:,:,vs)   = [];
        labels_test = labels_temp(:,:,vs);
        labels_temp(:,:,vs) = [];
        peri_test = squeeze(peri_test);
        peri_test = {cat(1, peri_test{:})};
        peri_test = peri_test{1,1};
        labels_test = squeeze(labels_test);
        labels_test = {cat(1, labels_test{:})};
        labels_test = labels_test{1,1};
      else
        %Add when wanting to test with EN experiments  
        peri_temp(:,:,i)   = [];
        labels_temp(:,:,i) = [];
        %Add when wanting to test with DE experiments
        %peri_temp(:,:,i+volunteers/2)   = [];
        %labels_temp(:,:,i+volunteers/2) = [];
      end      
      
      % Add this line to take just peri experiments
      %[result_train{i}] = trainModels_tvt_misscost(peri_temp, labels_temp, 'database',4,'model',1);
      [result_train{i}] = trainModels_tvt_v2(peri_temp, labels_temp, 'database',4,'model',1);
      
      % Add this line to take peri and peribaseline
      %[result_train{i}] = trainModels_tvt(cat(3,peri_temp, peri_temp_base), cat(3,labels_temp,labels_temp_base), 'database',4,'model',1);
      
      % Add this line when having L2SO
%       result_train{i}.vsTest=vs;
      kmax=5;

            %% Stage 6: Testing the model - Test
      % SVM Testing for the five (5-kfold) surrogate models
      fs=result_train{i}.svm_simulation.sfs;
        if(isfield(result_train{i}.svm_simulation,'sfs'))
            fs=result_train{i}.svm_simulation.sfs;
            feat_t=[ zscore(peri{:,:,(i)})];
            feat_t=feat_t(:,fs);
        else
            feat_t=[ zscore(peri{:,:,(i)})];
        end
      for k = 1:kmax
        %% In case of performing normalization by features as well:
        % 1. For FULL LOSO
%         feat_t=[ zscore(peri{:,:,(i)})];
%         feat_t=feat_t(:,fs);

        [tPredictions, tScores] = predict(result_train{i}.svm_simulation.Classifier.Trained{k},feat_t);
        confuM_t = confusionmat([string(num2cell(labels{:,:,(i)}+1))], string(tPredictions),'order',{'1','2'});
        
        [gl,pl]=size(confuM_t);
        if gl==1 && pl==1
          sent = 0;
          spet = 0;
        else
          sent   = confuM_t(2,2)/(confuM_t(2,2)+confuM_t(2,1));
          spet   = confuM_t(1,1)/(confuM_t(1,1)+confuM_t(1,2));
        end
        gmeant(k) =sqrt(sent *spet);
        confuM{k} =confuM_t;
%         result_train{i}.svm_test.tScores{k} = tScores;
%         result_train{i}.svm_test.tmulti{k} =[[string(num2cell(labels{:,:,i}+1)) ; string(num2cell(labels{:,:,i}+1));...
%                                  string(num2cell(labels{:,:,i}+1)) ; string(num2cell(labels{:,:,i}+1))],tPredictions];
          result_train{i}.svm_test.tmulti{k} =[[string(num2cell(labels{:,:,i}+1))],tPredictions];
%         result_train{i}.svm_test.tScores{k} = tScores;
%         result_train{i}.svm_test.tmulti{k} =[[string(num2cell(labels{:,:,vs(1,1)}+1)) ; string(num2cell(labels{:,:,vs(1,1)+volunteers/2}+1));...
%                                  string(num2cell(labels{:,:,vs(1,2)}+1)) ; string(num2cell(labels{:,:,vs(1,2)+volunteers/2}+1))],tPredictions];
        %result_train{i}.svm_test.tmulti{k} =[[string(num2cell(labels{:,:,vs(1,1)+volunteers/2}+1));...
        %                          string(num2cell(labels{:,:,vs(1,2)+volunteers/2}+1))],tPredictions];
        %result_train{i}.svm_test.tmulti{k} =[string(num2cell(labels_test+1)),tPredictions];
      end
      
      %SVM testing for the "complete-data" model
      %% In case of performing normalization by features as well:
      % 1. For FULL LOSO
         fs=result_train{i}.svm_simulation.sfs;
        if(isfield(result_train{i}.svm_simulation,'sfs'))
            fs=result_train{i}.svm_simulation.sfs;
            feat_t=[ zscore(peri{:,:,(i)})];
            feat_t=feat_t(:,fs);
        else
            feat_t=[ zscore(peri{:,:,(i)})];
        end      
        
      [tPredictions, tScores] = predict(result_train{i}.svm_simulation.ClassifierAll,feat_t);
      confuM_t = confusionmat([ string(num2cell(labels{:,:,(i)}+1))], string(tPredictions),'order',{'1','2'});
      
      [gl,pl]=size(confuM_t);
      if gl==1 && pl==1
        sent = 0;
        spet = 0;
      else
        sent   = confuM_t(2,2)/(confuM_t(2,2)+confuM_t(2,1));
        spet   = confuM_t(1,1)/(confuM_t(1,1)+confuM_t(1,2));
      end
      gmeant(k+1) =sqrt(sent *spet);
      confuM{k+1} =confuM_t;
      result_train{i}.svm_test.gmean = gmeant;
      result_train{i}.svm_test.confu = confuM;
      
      %result_train{i}.svm_simulation.ClassifierAll = [];
      %result_train{i}.svm_simulation.Classifier    = [];
%       result_train{i}.svm_test.tScores{k+1} = tScores;
%       result_train{i}.svm_test.tmulti{k+1} =[[string(num2cell(labels{:,:,vs(1,1)}+1)) ; string(num2cell(labels{:,:,vs(1,1)}+1));...
%                                  string(num2cell(labels{:,:,vs(1,2)}+1)) ; string(num2cell(labels{:,:,vs(1,2)}+1))],tPredictions];
%       result_train{i}.svm_test.tmulti{k} =[[string(num2cell(labels{:,:,i}+1)) ; string(num2cell(labels{:,:,i}+1));...
%                                  string(num2cell(labels{:,:,i}+1)) ; string(num2cell(labels{:,:,i}+1))],tPredictions];
      result_train{i}.svm_test.tmulti{k} =[[string(num2cell(labels{:,:,i}+1))],tPredictions];
      %result_train{i}.svm_test.tmulti{k+1} =[[string(num2cell(labels{:,:,vs(1,1)+volunteers/2}+1));...
      %                                        string(num2cell(labels{:,:,vs(1,2)+volunteers/2}+1))],tPredictions];
      %result_train{i}.svm_test.tmulti{k+1} =[string(num2cell(labels_test+1)),tPredictions];

%       KNN Testing for the five (5-kfold) surrogate models
       fs=result_train{i}.knn_simulation.sfs;
        if(isfield(result_train{i}.knn_simulation,'sfs'))
            fs=result_train{i}.knn_simulation.sfs;
            feat_t=[ zscore(peri{:,:,(i)})];
            feat_t=feat_t(:,fs);
        else
            feat_t=[ zscore(peri{:,:,(i)})];
        end
      for k = 1:kmax

        %% In case of performing normalization by features as well:
        % 1. For FULL LOSO
%         feat_t=[ zscore(peri{:,:,(i)})];
%         feat_t=feat_t(:,fs);
        
        
        [tPredictions, tScores] = predict(result_train{i}.knn_simulation.Classifier.Trained{k},feat_t);
        confuM_t = confusionmat([string(num2cell(labels{:,:,i}+1)) ], string(tPredictions),'order',{'1','2'});
        
        [gl,pl]=size(confuM_t);
        if gl==1 && pl==1
          sent = 0;
          spet = 0;
        else
          sent   = confuM_t(2,2)/(confuM_t(2,2)+confuM_t(2,1));
          spet   = confuM_t(1,1)/(confuM_t(1,1)+confuM_t(1,2));
        end
        gmeant(k) =sqrt(sent *spet);
        confuM{k} =confuM_t;
        result_train{i}.knn_test.tScores{k} = tScores;
%         result_train{i}.knn_test.tmulti{k} =[[string(num2cell(labels{:,:,vs(1,1)}+1)) ; string(num2cell(labels{:,:,vs(1,1)+volunteers/2}+1));...
%                                  string(num2cell(labels{:,:,vs(1,2)}+1)) ; string(num2cell(labels{:,:,vs(1,2)+volunteers/2}+1))],tPredictions];
        result_train{i}.knn_test.tmulti{k} =[[string(num2cell(labels{:,:,i}+1))],tPredictions];
        %result_train{i}.knn_test.tmulti{k} =[[string(num2cell(labels{:,:,vs(1,1)+volunteers/2}+1));...
        %                                      string(num2cell(labels{:,:,vs(1,2)+volunteers/2}+1))],tPredictions];
        %result_train{i}.knn_test.tmulti{k} =[string(num2cell(labels_test+1)),tPredictions];
      end

      %KNN testing for the "complete-data" model
      %% In case of performing normalization by features as well:
      % 1. For FULL LOSO
        if(isfield(result_train{i}.knn_simulation,'sfs'))
            fs=result_train{i}.knn_simulation.sfs;
            feat_t=[ zscore(peri{:,:,(i)})];
            feat_t=feat_t(:,fs);
        else
            feat_t=[ zscore(peri{:,:,(i)})];
        end
        
       
      [tPredictions, tScores] = predict(result_train{i}.knn_simulation.ClassifierAll,feat_t);
      confuM_t = confusionmat([string(num2cell(labels{:,:,i}+1))], string(tPredictions),'order',{'1','2'});

      [gl,pl]=size(confuM_t);
      if gl==1 && pl==1
        sent = 0;
        spet = 0;
      else
        sent   = confuM_t(2,2)/(confuM_t(2,2)+confuM_t(2,1));
        spet   = confuM_t(1,1)/(confuM_t(1,1)+confuM_t(1,2));
      end
      gmeant(k+1) =sqrt(sent *spet);
      confuM{k+1} =confuM_t;
      result_train{i}.knn_test.gmean = gmeant;
      result_train{i}.knn_test.confu = confuM;
            
      %result_train{i}.knn_simulation.ClassifierAll = [];
      %result_train{i}.knn_simulation.Classifier    = [];
%       result_train{i}.knn_test.tScores{k+1} = tScores;
%       result_train{i}.knn_test.tmulti{k+1} =[[string(num2cell(labels{:,:,vs(1,1)}+1)) ; string(num2cell(labels{:,:,vs(1,1)+volunteers/2}+1));...
%                                  string(num2cell(labels{:,:,vs(1,2)}+1)) ; string(num2cell(labels{:,:,vs(1,2)+volunteers/2}+1))],tPredictions];
      result_train{i}.knn_test.tmulti{k} =[[string(num2cell(labels{:,:,i}+1))],tPredictions];
      %result_train{i}.knn_test.tmulti{k+1} =[[string(num2cell(labels{:,:,vs(1,1)+volunteers/2}+1));...
      %                                        string(num2cell(labels{:,:,vs(1,2)+volunteers/2}+1))],tPredictions];
      %result_train{i}.knn_test.tmulti{k+1} =[string(num2cell(labels_test+1)),tPredictions];
      
      %ENS
       fs=result_train{i}.ens_simulation.sfs;
        if(isfield(result_train{i}.ens_simulation,'sfs'))
            fs=result_train{i}.ens_simulation.sfs;
            feat_t=[ zscore(peri{:,:,(i)})];
            feat_t=feat_t(:,fs);
        else
            feat_t=[ zscore(peri{:,:,(i)})];
        end
      for k = 1:kmax

        %% In case of performing normalization by features as well:
        % 1. For FULL LOS        
%         feat_t=[ zscore(peri{:,:,(i)})];
%         feat_t=feat_t(:,fs);
        
        
        [tPredictions, tScores] = predict(result_train{i}.ens_simulation.Classifier.Trained{k},feat_t);
        confuM_t = confusionmat([ string(num2cell(labels{:,:,(i)}+1))], string(tPredictions),'order',{'1','2'});

        
        [gl,pl]=size(confuM_t);
        if gl==1 && pl==1
          sent = 0;
          spet = 0;
        else
          sent   = confuM_t(2,2)/(confuM_t(2,2)+confuM_t(2,1));
          spet   = confuM_t(1,1)/(confuM_t(1,1)+confuM_t(1,2));
        end
        gmeant(k) =sqrt(sent *spet);
        confuM{k} =confuM_t;
        result_train{i}.ens_test.tScores{k} = tScores;
%         result_train{i}.ens_test.tmulti{k} =[[string(num2cell(labels{:,:,vs(1,1)}+1)) ; string(num2cell(labels{:,:,vs(1,1)+volunteers/2}+1));...
%                                  string(num2cell(labels{:,:,vs(1,2)}+1)) ; string(num2cell(labels{:,:,vs(1,2)+volunteers/2}+1))],tPredictions];
        result_train{i}.ens_test.tmulti{k} =[[string(num2cell(labels{:,:,i}+1))],tPredictions];
        %result_train{i}.ens_test.tmulti{k} =[[string(num2cell(labels{:,:,vs(1,1)+volunteers/2}+1));...
        %                                      string(num2cell(labels{:,:,vs(1,2)+volunteers/2}+1))],tPredictions];
        %result_train{i}.ens_test.tmulti{k} =[string(num2cell(labels_test+1)),tPredictions];
      end

      %ENS testing for the "complete-data" model
      %% In case of performing normalization by features as well:
      % 1. For FULL LOSO
        feat_t=[ zscore(peri{:,:,(i)})];
        feat_t=feat_t(:,fs);
        if(isfield(result_train{i}.ens_simulation,'sfs'))
            fs=result_train{i}.ens_simulation.sfs;
            feat_t=[ zscore(peri{:,:,(i)})];
            feat_t=feat_t(:,fs);
        else
            feat_t=[ zscore(peri{:,:,(i)})];
        end
        
        
      [tPredictions, tScores] = predict(result_train{i}.ens_simulation.ClassifierAll,feat_t);
      confuM_t = confusionmat([string(num2cell(labels{:,:,(i)}+1))], string(tPredictions),'order',{'1','2'});
      
      [gl,pl]=size(confuM_t);
      if gl==1 && pl==1
        sent = 0;
        spet = 0;
      else
        sent   = confuM_t(2,2)/(confuM_t(2,2)+confuM_t(2,1));
        spet   = confuM_t(1,1)/(confuM_t(1,1)+confuM_t(1,2));
      end
      gmeant(k+1) =sqrt(sent *spet);
      confuM{k+1} =confuM_t;
      result_train{i}.ens_test.gmean = gmeant;
      result_train{i}.ens_test.confu = confuM;
            
      %result_train{i}.ens_simulation.ClassifierAll = [];
      %result_train{i}.ens_simulation.Classifier    = [];
%       result_train{i}.ens_test.tScores{k+1} = tScores;
%       result_train{i}.ens_test.tmulti{k+1} =[[string(num2cell(labels{:,:,vs(1,1)}+1)) ; string(num2cell(labels{:,:,vs(1,1)}+1));...
%                                  string(num2cell(labels{:,:,vs(1,2)}+1)) ; string(num2cell(labels{:,:,vs(1,2)}+1))],tPredictions];
%        result_train{i}.svm_test.tmulti{k} =[[string(num2cell(labels{:,:,i}+1)) ; string(num2cell(labels{:,:,i}+1));...
%                                  string(num2cell(labels{:,:,i}+1)) ; string(num2cell(labels{:,:,i}+1))],tPredictions];
      result_train{i}.ens_test.tmulti{k} =[[string(num2cell(labels{:,:,i}+1))],tPredictions];
      %result_train{i}.ens_test.tmulti{k+1} =[[ string(num2cell(labels{:,:,vs(1,1)+volunteers/2}+1));...
      %                                         string(num2cell(labels{:,:,vs(1,2)+volunteers/2}+1))],tPredictions];
      %result_train{i}.ens_test.tmulti{k+1} =[string(num2cell(labels_test+1)),tPredictions];
      
      %% Display some result info for Hybrid approach
      %fprintf('Rows: Ground truth for test volunteer %d:\n',i);
      %fprintf('----------\n')
      %fprintf('| %d   0  |\n',balance(i,1));
      %fprintf('|  0  %d  |\n',balance(i,2));
      %fprintf('----------\n')
      
      %% Save intermediate results
      % Back up file
      %copyfile([fname '.mat'], [fname '.bak'], 'f') 
      % Overwrite file with updated result_train 
      [value,index]=max(result_train{i}.ens_test.gmean);
      tpr = (result_train{i}.ens_test.confu{index}(2,2)/((result_train{i}.ens_test.confu{index}(2,2) + (result_train{i}.ens_test.confu{index}(2,1)))));
      tnr = (result_train{i}.ens_test.confu{index}(1,1)/((result_train{i}.ens_test.confu{index}(1,2) + (result_train{i}.ens_test.confu{index}(1,1)))));
      fprintf('TPR: %4.2f \n',tpr*100);
      fprintf('TNR: %4.2f \n',tnr*100);
      precision = (result_train{i}.ens_test.confu{index}(2,2)/((result_train{i}.ens_test.confu{index}(2,2) + (result_train{i}.ens_test.confu{index}(1,2)))));
      recall = (result_train{i}.ens_test.confu{index}(2,2)/((result_train{i}.ens_test.confu{index}(2,2) + (result_train{i}.ens_test.confu{index}(2,1)))));
      f1=2*((precision*recall)/(precision+recall));
      fprintf('F1: %4.2f \n',f1*100);
      save(fname, 'result_train') 
      result_train{i} = [];
    end
  end
Results_BioSpeech.results_windows  = result_train;

end