%%..........
% features is a tridimensional matrix SxFxP. Must be double type
% - S: Sample number (The samples come from different or the same window)
% - F: Feature number
% - P: Patient number
% labels is a tridimensional matrix Sx1xP. Must be cell type
% - S: Sample number (The samples come from different or the same window)
% - 1: One column
% - P: Patient number
% Samples and patients must be the same amount
% varargin...
% - database : it specifies the open data based used. Number of patients,
%              trials differ form each other.
%              - 1: DEAP
%              - 2: MAHNOB
%              - 3: WESAD
%              - 4: BioSpeech

function  [result] = trainModels_tvt_v2(features, labels, varargin)

  %warning('off','all')
  %warning;

  %check if there are two arguments at least
  if nargin<2
    error('At least two arguments must be provided');
  end
  
  %check if features and labels have the rigth dimensions
  if length(size(features))~=3 || length(size(labels))~=3
    error('Provided arguments should have 3 dimensions');
  else
    [f1,~,~]=size(features);
    [l1,~,~]=size(labels);
    if f1~=l1
      error('Provided arguments should have the same sameples (rows)');
    end
  end
  
  %check if there is varargin and handle them
  if length(varargin)>4
    error('This version does not support that many variable arguments')
  end
  variables = inputParser;
  database = 0xFF;
  model    = 0x00;
  addOptional(variables,'database',database);
  addOptional(variables,'model',model);
  parse(variables,{features,labels},varargin{:});
  
  %check database option
  database = variables.Results.database;
  switch database
      case 1
        disp('DEAP Open BBDD simulation running');
        patients_open = [1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,...
                         18,19,20,21,22,23,24,25,26,27,28,29,30,31,32];
        patients = 32;
        trials   = 40;
      case 2
        disp('MAHNOB Open BBDD simulation running');                
        %only females
        patients_open  = [4,5,7,14,19,20,21,22,23,24,28,29];
        %patients_open = [4,5,7,14,19,20,21,22,23,24,29];
        %patients_open = [4,20,24];
        %only males
        %patients_open = [1,2,8,10,13,17,18,27,30];
        patients = 29;
        trials   = 20;
      case 3
        disp('WESAD Open BBDD simulation running');
        patients_open = [1,2,3,4,5];
        patients = 15;
        trials   = 5;     
      case 4
        disp('BioSpeech Open BBDD simulation running');
        
        patients_open = [1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,...
                         18,19,20,21,22,23,24,25,26,27,28,29,30,31,32,...
                         33,34,35,36,37,38,39,40,41];
                     
        %Add this line if you want single Hybrid simulation
        %patients_open = [patients_open 42];
        
        %Add this line if you want to include EN and DE experiments
        %patients_open = [patients_open patients_open+41];
        
        %Add this line if you want L2SO simulation
        %patients_open = [patients_open (patients_open(end)+1:1:patients_open(end)+39)];
        
        %Add this line if you want L10SO simulation
        %patients_open = [patients_open (patients_open(end)+1:1:patients_open(end)+23)];       
        
        %Add this line if you want norm data into trainning
        %patients_open = [patients_open (patients_open(end)+1:1:patients_open(end)+42)];
        
        patients_open = 1:1:length(features);
        
        patients = 41;
        trials   = 1; 
      otherwise
        %patients_open = [1];
        patients_open = 1:1:length(features);
        patients = 1;
        trials   = 1; 
  end

  %check model option
  model = variables.Results.model;
  if model == 0x00
      %Extract the peri info per patient and run the different models
      disp('Toward the subject-dependent simulations');  
      %result = struct([]);
      %start simulation for subject dependent models
      for i=1:length(patients_open)
        peri_temp  = features(:,:,patients_open(i));
        label_temp = labels(:,:,patients_open(i));

        %convert from '0' to +1
        if numel(label_temp(strcmp(label_temp,'0'),1))>0
          label_temp = double(label_temp);
          label_temp = label_temp + 1;
          label_temp = string(label_temp);
        end

        %identify possible inf values
        [r,~] = find(isinf(peri_temp(:,:)));
        if r>0
          peri_temp(r,:) = [];
          label_temp(r,:,:)= [];
        end

        %check if the model is multiclass or not
        if numel(label_temp(strcmp(label_temp,'3'),1))>0 ...
           || numel(label_temp(strcmp(label_temp,'4'),1))>0

          if numel(label_temp(strcmp(label_temp,'4'),1))>0 ... 
             && numel(label_temp(strcmp(label_temp,'3'),1))>0 ...
             && numel(label_temp(strcmp(label_temp,'2'),1))>0 ...
             && numel(label_temp(strcmp(label_temp,'1'),1))>0
            %running 4-class optimized models: svm, knn, ens
            result(i)=fourClassModels(peri_temp, label_temp);
            fprintf('------------------------------------------------------\n');
            fprintf('P%d   ',patients_open(i));
            fprintf('|   %1.2f (%1.2f,%1.2f,%1.2f,%1.2f)   ',...
            result(i).svm_simulation.vAccuracy,...
            result(i).svm_simulation.roc_1.auc,...
            result(i).svm_simulation.roc_2.auc,...
            result(i).svm_simulation.roc_3.auc,...
            result(i).svm_simulation.roc_4.auc);
            fprintf('|   %1.2f (%1.2f,%1.2f,%1.2f,%1.2f)   ',...
            result(i).knn_simulation.vAccuracy,...
            result(i).knn_simulation.roc_1.auc,...
            result(i).knn_simulation.roc_2.auc,...
            result(i).knn_simulation.roc_3.auc,...
            result(i).knn_simulation.roc_4.auc);
            fprintf('|   %1.2f (%1.2f,%1.2f,%1.2f,%1.2f)|',...
            result(i).ens_simulation.vAccuracy,...
            result(i).ens_simulation.roc_1.auc,...
            result(i).ens_simulation.roc_2.auc,...
            result(i).ens_simulation.roc_3.auc,...
            result(i).ens_simulation.roc_4.auc);
            fprintf('\n');
          else
            %running 3-class optimized models: svm, knn, ens
            result(i)=threeClassModels(peri_temp, label_temp);
            fprintf('------------------------------------------------------\n');
            fprintf('P%d   ',patients_open(i));
            fprintf('|   %1.2f (%1.2f,%1.2f,%1.2f)   ',...
            result(i).svm_simulation.vAccuracy,...
            result(i).svm_simulation.roc_1.auc,...
            result(i).svm_simulation.roc_2.auc,...
            result(i).svm_simulation.roc_3.auc);
            fprintf('|   %1.2f (%1.2f,%1.2f,%1.2f)   ',...
            result(i).knn_simulation.vAccuracy,...
            result(i).knn_simulation.roc_1.auc,...
            result(i).knn_simulation.roc_2.auc,...
            result(i).knn_simulation.roc_3.auc);
            fprintf('|   %1.2f (%1.2f,%1.2f,%1.2f)|',...
            result(i).ens_simulation.vAccuracy,...
            result(i).ens_simulation.roc_1.auc,...
            result(i).ens_simulation.roc_2.auc,...
            result(i).ens_simulation.roc_3.auc);
            fprintf('\n');
          end

        else
            %running binary optimized models: svm, knn, ens
            result(i)=binaryModels(peri_temp, label_temp);
            fprintf('------------------------------------------------------\n');
            fprintf('P%d   ',patients_open(i));
            fprintf('|   %1.2f (%1.2f,%1.2f)   ',...
            result(i).svm_simulation.vAccuracy,...
            result(i).svm_simulation.roc_1.auc,...
            result(i).svm_simulation.roc_2.auc);
            fprintf('|   %1.2f (%1.2f,%1.2f)   ',...
            result(i).knn_simulation.vAccuracy,...
            result(i).knn_simulation.roc_1.auc,...
            result(i).knn_simulation.roc_2.auc);
            fprintf('|   %1.2f (%1.2f,%1.2f)|',...
            result(i).ens_simulation.vAccuracy,...
            result(i).ens_simulation.roc_1.auc,...
            result(i).ens_simulation.roc_2.auc);
            fprintf('\n');
        end
      end
  else
     %Extract the peri info for all patients and run the different models
      disp('Toward the subject-independent simulations');  
      %result = struct([]);
      %start simulation for subject independent models
      peri_temp = [];
      label_temp = [];
      for i=1:length(patients_open)
        %identify possible inf values
        p_temp = features(:,:,patients_open(i));
        l_temp = labels(:,:,patients_open(i));
        [r,~] = find(isinf(cell2mat(p_temp(:,:))));
        if r>0
          p_temp(r,:) = [];
          l_temp(r,:,:)= [];
        end
        
        %In case of normalizing the set of features per volunteer
        peri_temp  = [peri_temp ; zscore(cell2mat(p_temp))];
        
        %In case of NOT normalizing the set of features per volunteer
        %peri_temp  = [peri_temp ; (cell2mat(p_temp))];
        
        label_temp = [label_temp ; cell2mat(l_temp)];
      end
      i = 1;

        %convert from '0' to +1
        if numel(label_temp(strcmp(string(label_temp),'0'),1))>0
          label_temp = double(label_temp);
          label_temp = label_temp + 1;
          label_temp = string(label_temp);
        end

        %check if the model is multiclass or not
        if numel(label_temp(strcmp(label_temp,'3'),1))>0 ...
           || numel(label_temp(strcmp(label_temp,'4'),1))>0

          if numel(label_temp(strcmp(label_temp,'4'),1))>0 ... 
             && numel(label_temp(strcmp(label_temp,'3'),1))>0 ...
             && numel(label_temp(strcmp(label_temp,'2'),1))>0 ...
             && numel(label_temp(strcmp(label_temp,'1'),1))>0
            %running 4-class optimized models: svm, knn, ens
            result(i)=fourClassModels(peri_temp, label_temp);
            fprintf('------------------------------------------------------\n');
            fprintf('P%d   ',patients_open(i));
            fprintf('|   %1.2f (%1.2f,%1.2f,%1.2f,%1.2f)   ',...
            result(i).svm_simulation.vAccuracy,...
            result(i).svm_simulation.roc_1.auc,...
            result(i).svm_simulation.roc_2.auc,...
            result(i).svm_simulation.roc_3.auc,...
            result(i).svm_simulation.roc_4.auc);
            fprintf('|   %1.2f (%1.2f,%1.2f,%1.2f,%1.2f)   ',...
            result(i).knn_simulation.vAccuracy,...
            result(i).knn_simulation.roc_1.auc,...
            result(i).knn_simulation.roc_2.auc,...
            result(i).knn_simulation.roc_3.auc,...
            result(i).knn_simulation.roc_4.auc);
            fprintf('|   %1.2f (%1.2f,%1.2f,%1.2f,%1.2f)|',...
            result(i).ens_simulation.vAccuracy,...
            result(i).ens_simulation.roc_1.auc,...
            result(i).ens_simulation.roc_2.auc,...
            result(i).ens_simulation.roc_3.auc,...
            result(i).ens_simulation.roc_4.auc);
            fprintf('\n');
          else
            %running 3-class optimized models: svm, knn, ens
            result(i)=threeClassModels(peri_temp, label_temp);
            fprintf('------------------------------------------------------\n');
            fprintf('P%d   ',patients_open(i));
            fprintf('|   %1.2f (%1.2f,%1.2f,%1.2f)   ',...
            result(i).svm_simulation.vAccuracy,...
            result(i).svm_simulation.roc_1.auc,...
            result(i).svm_simulation.roc_2.auc,...
            result(i).svm_simulation.roc_3.auc);
            fprintf('|   %1.2f (%1.2f,%1.2f,%1.2f)   ',...
            result(i).knn_simulation.vAccuracy,...
            result(i).knn_simulation.roc_1.auc,...
            result(i).knn_simulation.roc_2.auc,...
            result(i).knn_simulation.roc_3.auc);
            fprintf('|   %1.2f (%1.2f,%1.2f,%1.2f)|',...
            result(i).ens_simulation.vAccuracy,...
            result(i).ens_simulation.roc_1.auc,...
            result(i).ens_simulation.roc_2.auc,...
            result(i).ens_simulation.roc_3.auc);
            fprintf('\n');
          end

        else
            %running binary optimized models: svm, knn, ens
            result(i)=binaryModels(peri_temp, label_temp);
            fprintf('------------------------------------------------------\n');
            fprintf('P%d   ',patients_open(i));
            fprintf('|   %1.2f (%1.2f,%1.2f)   ',...
            result(i).svm_simulation.vAccuracy,...
            result(i).svm_simulation.roc_1.auc,...
            result(i).svm_simulation.roc_2.auc);
            fprintf('|   %1.2f (%1.2f,%1.2f)   ',...
            result(i).knn_simulation.vAccuracy,...
            result(i).knn_simulation.roc_1.auc,...
            result(i).knn_simulation.roc_2.auc);
            fprintf('|   %1.2f (%1.2f,%1.2f)|',...
            result(i).ens_simulation.vAccuracy,...
            result(i).ens_simulation.roc_1.auc,...
            result(i).ens_simulation.roc_2.auc);
             fprintf('\n');
        end
  end
  fprintf('------------------------------------------------------\n');
end

function [results]=binaryModels(features, labels)
%   st = 801;
%   sp = 900;
%   features(1001:1100,:) = [];
%   labels(1001:1100)=[];
%   for k=1:11
  %initialize values
  kfold = 5;
  peri_temp = features;
  label_temp = labels;
  %perform training - testing split
  partition = cvpartition(label_temp,'Holdout',0.2,'Stratify',true);
  %idxTrain = training(partition);
%   [idxTrain,~] = size(features);
%   idxTrain(1:idxTrain)=1;
%   idxTrain(1:1200)=1;
%   idxTrain(st:sp)=0;
%   peri_temp = features(idxTrain,:);
%   label_temp = labels(idxTrain); 
  c = cvpartition((label_temp),'KFold',kfold,'Stratify',true);
  %c = cvpartition(label_temp,'Holdout',0.5,'Stratify',true);


  %Bayesian Optimization for SVM 
   
  opts = statset('display','iter','UseParallel',true);
  %classf = @classfsvm;
  %classf = @(train_data, train_labels, test_data, test_labels)...
   %sum(predict(fitcsvm(train_data, train_labels,'KernelFunction','rbf','Cost',[0,1;2 0]), test_data) ~= test_labels);
    
  [~,colum]=size(peri_temp);
  fs =1:1:colum;
  %fs=[1 4 9 10 11 18 20 24 27 28 36 37 38 39 40 ];
  %[fs, history] = sequentialfs(classf, peri_temp, double(label_temp), 'cv', c, 'options', opts);
   parameters.featSelection = 'mrmr';
   [fs,~,~] = feature_sel_module(peri_temp,peri_temp, label_temp, parameters);
  X_train_w_best_feature = peri_temp(:,fs);
  
  params = hyperparameters('fitcsvm',X_train_w_best_feature,double(label_temp));
  %params(3).Range(1,1)=cellstr('rbf');
  params(3).Optimize = false;
  params(4).Optimize = true;
  params(5).Optimize = true;

  svm_temp = fitcsvm(X_train_w_best_feature,label_temp,'KernelFunction','polynomial',...
             'OptimizeHyperparameters',params,...
             'HyperparameterOptimizationOptions',...
            struct('Repartition',true,'ShowPlots',false,'Verbose',1,...
                   'UseParallel',true));

 if svm_temp.HyperparameterOptimizationResults.XAtMinObjective.Standardize == 'true'
   stand = true;
 else
   stand = false;
 end
 
  if svm_temp.HyperparameterOptimizationResults.XAtMinObjective.KernelScale == 'NaN'
   ks = 0;
 else
   ks = svm_temp.HyperparameterOptimizationResults.XAtMinObjective.KernelScale;
 end

 svm_temp_all = fitcsvm(X_train_w_best_feature,label_temp,'KernelFunction','polynomial',...
    'Cost',[0,1;1 0],'ClassNames',{'1','2'},...
    'BoxConstraint',svm_temp.HyperparameterOptimizationResults.XAtMinObjective.BoxConstraint,...
    'PolynomialOrder',svm_temp.HyperparameterOptimizationResults.XAtMinObjective.PolynomialOrder,...
    'KernelScale',ks,...
    'Standardize',stand);
    

svm_temp_cv = fitcsvm(X_train_w_best_feature,label_temp,'CVPartition',c,'KernelFunction','polynomial',...
    'Cost',[0,1;1 0],'ClassNames',{'1','2'},...
    'BoxConstraint',svm_temp.HyperparameterOptimizationResults.XAtMinObjective.BoxConstraint,...
    'PolynomialOrder',svm_temp.HyperparameterOptimizationResults.XAtMinObjective.PolynomialOrder,...
    'KernelScale',ks,...
    'Standardize',stand);
         
%   %perform cross-validation
    %svm_temp_cv = crossval(svm_temp, 'KFold', kfold);
    svm_temp=svm_temp_all;
% 
%   %compute validation predictions
  [vPredictions, vScores] = kfoldPredict(svm_temp_cv);

  %compute validation accuracy
  vAccuracy = 1 - kfoldLoss(svm_temp_cv);

  %perform Receiver Operating Characteristic (ROC)
  [~,~,~,auc_1,~] = perfcurve(label_temp,vScores(:,1),1);
  [~,~,~,auc_2,~] = perfcurve(label_temp,vScores(:,2),2);
  
  %get confusion matrix for validation
  confuM = confusionmat(label_temp, vPredictions,'order',{'1','2'});
  
  %compute individual validation loss
  modelLosses = kfoldLoss(svm_temp_cv,'mode','individual');
  [~,row_min] = min(modelLosses);
   
  %compute testing accuracy for each subrrogate models
  tAccuracy = 1 - min(modelLosses);
  
  %compute testing predictions - unseen testing points
%   [tPredictions, tScores] = predict(svm_temp_cv.Trained{1}, features(~idxTrain,:));
%     confuM_t = confusionmat(labels(~idxTrain), tPredictions);
%   [tPredictions2, tScores2] = predict(svm_temp_cv.Trained{2}, features(~idxTrain,:));
%     confuM_t2 = confusionmat(labels(~idxTrain), tPredictions2);
%   [tPredictions3, tScores3] = predict(svm_temp_cv.Trained{3}, features(~idxTrain,:));
%     confuM_t3 = confusionmat(labels(~idxTrain), tPredictions3);
%   [tPredictions4, tScores4] = predict(svm_temp_cv.Trained{4}, features(~idxTrain,:));
%     confuM_t4 = confusionmat(labels(~idxTrain), tPredictions4);
%   [tPredictions5, tScores5] = predict(svm_temp_cv.Trained{5}, features(~idxTrain,:));
%     confuM_t5 = confusionmat(labels(~idxTrain), tPredictions5);

  %perform Receiver Operating Characteristic (ROC) for testing
%   [~,~,~,auc_1_t,~] = perfcurve(labels(~idxTrain),tScores(:,1),1);
%   [~,~,~,auc_2_t,~] = perfcurve(labels(~idxTrain),tScores(:,2),2);
  
  %check gmean
%   svm_sent   = confuM_t(2,2)/(confuM_t(2,2)+confuM_t(1,2));
%   svm_spet   = confuM_t(1,1)/(confuM_t(1,1)+confuM_t(2,1));
%   svm_gmeant =sqrt(svm_sent *svm_spet);
%   svm_sent   = confuM_t2(2,2)/(confuM_t2(2,2)+confuM_t2(1,2));
%   svm_spet   = confuM_t2(1,1)/(confuM_t2(1,1)+confuM_t2(2,1));
%   svm_gmeant2 =sqrt(svm_sent *svm_spet);
%   svm_sent   = confuM_t3(2,2)/(confuM_t3(2,2)+confuM_t3(1,2));
%   svm_spet   = confuM_t3(1,1)/(confuM_t3(1,1)+confuM_t3(2,1));
%   svm_gmeant3 =sqrt(svm_sent *svm_spet);
%   svm_sent   = confuM_t4(2,2)/(confuM_t4(2,2)+confuM_t4(1,2));
%   svm_spet   = confuM_t4(1,1)/(confuM_t4(1,1)+confuM_t4(2,1));
%   svm_gmeant4 =sqrt(svm_sent *svm_spet);
%   svm_sent   = confuM_t5(2,2)/(confuM_t5(2,2)+confuM_t5(1,2));
%   svm_spet   = confuM_t5(1,1)/(confuM_t5(1,1)+confuM_t5(2,1));
%   svm_gmeant5 =sqrt(svm_sent *svm_spet);
        
  
  svm_simulation.ClassifierAll = svm_temp;
  svm_simulation.Classifier = svm_temp_cv;
  svm_simulation.vPredictions = vPredictions;
  svm_simulation.vScores = vScores;
  svm_simulation.vAccuracy = vAccuracy;
  svm_simulation.roc_1.auc = auc_1;
  svm_simulation.roc_2.auc = auc_2;
  svm_simulation.CM = confuM;
  
  svm_simulation.Classifier_test = row_min;
%   svm_simulation.tPredictions = tPredictions;
%   svm_simulation.tScores = tScores;
  svm_simulation.tAccuracy = tAccuracy;
%   svm_simulation.roc_1_t.auc = auc_1_t;
%   svm_simulation.roc_2_t.auc = auc_2_t;
%   svm_simulation.CM_t = [confuM_t;confuM_t2;confuM_t3;confuM_t4;confuM_t5];   
%   svm_simulation.gmean_t = ...
%       [svm_gmeant;svm_gmeant2;svm_gmeant3;svm_gmeant4;svm_gmeant5];   

 svm_simulation.sfs=fs;
  
  %Bayesian Optimization for KNN   
  
   opts = statset('display','iter','UseParallel',true);
   classf = @classfknn;%(train_data, train_labels, test_data, test_labels)...
%    % sum(predict(fitcknn(train_data, train_labels,'NumNeighbors',5,'Cost',[0,1;2 0]), test_data) ~= test_labels);
% 
  [~,colum]=size(peri_temp);
  fs =1:1:colum;
  %[fs, history] = sequentialfs(classf, peri_temp, label_temp, 'cv', c, 'options', opts);
  X_train_w_best_feature = peri_temp(:,fs);
  
  params = hyperparameters('fitcknn',peri_temp,double(label_temp));
  params(1).Range = [10,900];
  params(3).Optimize = true;
  params(4).Optimize = true;
  params(5).Optimize = true;
  
  knn_temp = fitcknn(X_train_w_best_feature,label_temp,...
             'OptimizeHyperparameters',params,...
             'HyperparameterOptimizationOptions',...
             struct('ShowPlots',false,'Verbose',1,...
             'UseParallel',true,'Repartition',true));

 if knn_temp.HyperparameterOptimizationResults.XAtMinObjective.Standardize == 'true'
   stand = true;
 else
   stand = false;
 end

knn_temp_all = fitcknn(X_train_w_best_feature,label_temp,...
'Cost',[0,1;1 0],'ClassNames',{'1','2'},...
'NumNeighbors',knn_temp.HyperparameterOptimizationResults.XAtMinObjective.NumNeighbors,...
'Distance',char(knn_temp.HyperparameterOptimizationResults.XAtMinObjective.Distance),...
'DistanceWeight',char(knn_temp.HyperparameterOptimizationResults.XAtMinObjective.DistanceWeight),...
'Standardize',stand);

knn_temp_cv = fitcknn(X_train_w_best_feature,label_temp,'CVPartition',c,...
    'Cost',[0,1;1 0],'ClassNames',{'1','2'},...
'NumNeighbors',knn_temp.HyperparameterOptimizationResults.XAtMinObjective.NumNeighbors,...
'Distance',char(knn_temp.HyperparameterOptimizationResults.XAtMinObjective.Distance),...
'DistanceWeight',char(knn_temp.HyperparameterOptimizationResults.XAtMinObjective.DistanceWeight),...
'Standardize',stand);
         
  % Perform cross-validation
  %knn_temp_cv = crossval(knn_temp, 'KFold', kfold);
  knn_temp =knn_temp_all;

  % Compute validation predictions
  [vPredictions, vScores] = kfoldPredict(knn_temp_cv);
  confuM = confusionmat(label_temp, vPredictions,'order',{'1','2'});
%   [tPredictions2, tScores2] = predict(knn_temp_cv.Trained{2}, features(~idxTrain,:));
%     confuM_t2 = confusionmat(labels(~idxTrain), tPredictions2);
%   [tPredictions3, tScores3] = predict(knn_temp_cv.Trained{3}, features(~idxTrain,:));
%     confuM_t3 = confusionmat(labels(~idxTrain), tPredictions3);
%   [tPredictions4, tScores4] = predict(knn_temp_cv.Trained{4}, features(~idxTrain,:));
%     confuM_t4 = confusionmat(labels(~idxTrain), tPredictions4);
%   [tPredictions5, tScores5] = predict(knn_temp_cv.Trained{5}, features(~idxTrain,:));
%     confuM_t5 = confusionmat(labels(~idxTrain), tPredictions5);

  % Compute validation accuracy
  vAccuracy = 1 - kfoldLoss(knn_temp_cv);

  %perform Receiver Operating Characteristic (ROC)
  [~,~,~,auc_1,~] = perfcurve(label_temp,vScores(:,1),1);
  [~,~,~,auc_2,~] = perfcurve(label_temp,vScores(:,2),2);
  
  %compute individual validation loss
  modelLosses = kfoldLoss(knn_temp_cv,'mode','individual');
  [~,row_min] = min(modelLosses);
  
  %compute testing predictions - unseen testing points
%   [tPredictions, tScores] = predict(knn_temp_cv.Trained{row_min}, features(~idxTrain,:));
  
  %compute testing accuracy
  tAccuracy = 1 - min(modelLosses);

  %perform Receiver Operating Characteristic (ROC) for testing
%   [~,~,~,auc_1_t,~] = perfcurve(labels(~idxTrain),tScores(:,1),1);
%   [~,~,~,auc_2_t,~] = perfcurve(labels(~idxTrain),tScores(:,2),2);
  
  %get confusion matrix for validation
%   confuM_t = confusionmat(labels(~idxTrain), tPredictions);
  
  %check gmean
%   knn_sent   = confuM_t(2,2)/(confuM_t(2,2)+confuM_t(1,2));
%   knn_spet   = confuM_t(1,1)/(confuM_t(1,1)+confuM_t(2,1));
%   knn_gmeant =sqrt(knn_sent *knn_spet);
%   knn_sent   = confuM_t2(2,2)/(confuM_t2(2,2)+confuM_t2(1,2));
%   knn_spet   = confuM_t2(1,1)/(confuM_t2(1,1)+confuM_t2(2,1));
%   knn_gmeant2 =sqrt(knn_sent *knn_spet);
%   knn_sent   = confuM_t3(2,2)/(confuM_t3(2,2)+confuM_t3(1,2));
%   knn_spet   = confuM_t3(1,1)/(confuM_t3(1,1)+confuM_t3(2,1));
%   knn_gmeant3 =sqrt(knn_sent *knn_spet);
%   knn_sent   = confuM_t4(2,2)/(confuM_t4(2,2)+confuM_t4(1,2));
%   knn_spet   = confuM_t4(1,1)/(confuM_t4(1,1)+confuM_t4(2,1));
%   knn_gmeant4 =sqrt(knn_sent *knn_spet);
%   knn_sent   = confuM_t5(2,2)/(confuM_t5(2,2)+confuM_t5(1,2));
%   knn_spet   = confuM_t5(1,1)/(confuM_t5(1,1)+confuM_t5(2,1));
%   knn_gmeant5 =sqrt(knn_sent *knn_spet);

  knn_simulation.ClassifierAll = knn_temp;
  knn_simulation.Classifier = knn_temp_cv;
  knn_simulation.vPredictions = vPredictions;
  knn_simulation.vScores = vScores;
  knn_simulation.vAccuracy = vAccuracy;
  knn_simulation.roc_1.auc = auc_1;
  knn_simulation.roc_2.auc = auc_2;
  knn_simulation.CM = confuM;
  
  knn_simulation.Classifier_test = row_min;
%   knn_simulation.tPredictions = tPredictions;
%   knn_simulation.tScores = tScores;
  knn_simulation.tAccuracy = tAccuracy;
%   knn_simulation.roc_1_t.auc = auc_1_t;
%   knn_simulation.roc_2_t.auc = auc_2_t;
%   knn_simulation.CM_t = [confuM_t;confuM_t2;confuM_t3;confuM_t4;confuM_t5]; 
%   knn_simulation.gmean_t = ...
%       [knn_gmeant;knn_gmeant2;knn_gmeant3;knn_gmeant4;knn_gmeant5];   

  knn_simulation.sfs=fs;
         
  %Bayesian Optimization for ENS
  
   opts = statset('display','iter','UseParallel',true);
   classf = @classfens;%(train_data, train_labels, test_data, test_labels)...
%     %sum(predict(fitcensemble(train_data, train_labels,'Cost',[0,1;2 0]), test_data) ~= test_labels);
% 
  [~,colum]=size(peri_temp);
  fs =1:1:colum;
  %[fs, history] = sequentialfs(classf, peri_temp, label_temp, 'cv', c, 'options', opts);
   X_train_w_best_feature = peri_temp(:,fs);
   
  params = hyperparameters('fitcensemble',peri_temp,label_temp,'Tree');
  params(1, 1).Optimize = false;
  %params(2, 1).Range = [300,600];
  %params(3, 1).Range = [0.99913,0.99999]; 
  %params(4, 1).Range = [200,1000];   
  params(5, 1).Optimize = true;
  params(6, 1).Optimize = true;
  params(7, 1).Optimize = true;
  
  ens_temp = fitcensemble(X_train_w_best_feature,label_temp,'Method','AdaBoostM1',...
             'OptimizeHyperparameters',params,...
             'HyperparameterOptimizationOptions',...
             struct('ShowPlots',false,'Verbose',1,...
             'UseParallel',true,'Repartition',true)); 

ens_temp_all = fitcensemble(X_train_w_best_feature,label_temp,'ScoreTransform','logit','Method','AdaBoostM1',...
'Cost',[0,1;1 0],'ClassNames',{'1','2'},...
'NumLearningCycles',ens_temp.HyperparameterOptimizationResults.XAtMinObjective.NumLearningCycles,...
'LearnRate',ens_temp.HyperparameterOptimizationResults.XAtMinObjective.LearnRate,...
'Learners',templateTree('MinLeafSize',ens_temp.HyperparameterOptimizationResults.XAtMinObjective.MinLeafSize),...
'Learners',templateTree('MaxNumSplits',ens_temp.HyperparameterOptimizationResults.XAtMinObjective.MaxNumSplits),...
'Learners',templateTree('SplitCriterion',char(ens_temp.HyperparameterOptimizationResults.XAtMinObjective.SplitCriterion)),...
'Learners',templateTree('NumVariablesToSample',(ens_temp.HyperparameterOptimizationResults.XAtMinObjective.NumVariablesToSample)));

ens_temp_cv = fitcensemble(X_train_w_best_feature,label_temp,'ScoreTransform','logit','CVPartition',c,'Method','AdaBoostM1',...
'Cost',[0,1;1 0],'ClassNames',{'1','2'},...
'NumLearningCycles',ens_temp.HyperparameterOptimizationResults.XAtMinObjective.NumLearningCycles,...
'LearnRate',ens_temp.HyperparameterOptimizationResults.XAtMinObjective.LearnRate,...
'Learners',templateTree('MinLeafSize',ens_temp.HyperparameterOptimizationResults.XAtMinObjective.MinLeafSize),...
'Learners',templateTree('MaxNumSplits',ens_temp.HyperparameterOptimizationResults.XAtMinObjective.MaxNumSplits),...
'Learners',templateTree('SplitCriterion',char(ens_temp.HyperparameterOptimizationResults.XAtMinObjective.SplitCriterion)),...
'Learners',templateTree('NumVariablesToSample',(ens_temp.HyperparameterOptimizationResults.XAtMinObjective.NumVariablesToSample)));
         
  % Perform cross-validation
  %ens_temp_cv = crossval(ens_temp, 'KFold', kfold);
  ens_temp = ens_temp_all;

  % Compute validation predictions
  [vPredictions, vScores] = kfoldPredict(ens_temp_cv);

  % Compute validation accuracy
  vAccuracy = 1 - kfoldLoss(ens_temp_cv);

  %perform Receiver Operating Characteristic (ROC)
  [~,~,~,auc_1,~] = perfcurve(label_temp,vScores(:,1),1);
  [~,~,~,auc_2,~] = perfcurve(label_temp,vScores(:,2),2);
  
  %get confusion matrix
  confuM = confusionmat(label_temp, vPredictions,'order',{'1','2'});
  
  %compute individual validation loss
  modelLosses = kfoldLoss(ens_temp_cv,'mode','individual');
  [~,row_min] = min(modelLosses);
  
  %compute testing predictions - unseen testing points
%   [tPredictions, tScores] = predict(ens_temp_cv.Trained{row_min}, features(~idxTrain,:));
%     confuM_t = confusionmat(labels(~idxTrain), tPredictions);
%   [tPredictions2, tScores2] = predict(ens_temp_cv.Trained{2}, features(~idxTrain,:));
%     confuM_t2 = confusionmat(labels(~idxTrain), tPredictions2);
%   [tPredictions3, tScores3] = predict(ens_temp_cv.Trained{3}, features(~idxTrain,:));
%     confuM_t3 = confusionmat(labels(~idxTrain), tPredictions3);
%   [tPredictions4, tScores4] = predict(ens_temp_cv.Trained{4}, features(~idxTrain,:));
%     confuM_t4 = confusionmat(labels(~idxTrain), tPredictions4);
%   [tPredictions5, tScores5] = predict(ens_temp_cv.Trained{5}, features(~idxTrain,:));
%     confuM_t5 = confusionmat(labels(~idxTrain), tPredictions5);
  
  %compute testing accuracy
  tAccuracy = 1 - min(modelLosses);

  %perform Receiver Operating Characteristic (ROC) for testing
%   [~,~,~,auc_1_t,~] = perfcurve(labels(~idxTrain),tScores(:,1),1);
%   [~,~,~,auc_2_t,~] = perfcurve(labels(~idxTrain),tScores(:,2),2);
    
  %check gmean
%   ens_sent   = confuM_t(2,2)/(confuM_t(2,2)+confuM_t(1,2));
%   ens_spet   = confuM_t(1,1)/(confuM_t(1,1)+confuM_t(2,1));
%   ens_gmeant =sqrt(ens_sent * ens_spet);
%   ens_sent   = confuM_t2(2,2)/(confuM_t2(2,2)+confuM_t2(1,2));
%   ens_spet   = confuM_t2(1,1)/(confuM_t2(1,1)+confuM_t2(2,1));
%   ens_gmeant2 =sqrt(ens_sent *ens_spet);
%   ens_sent   = confuM_t3(2,2)/(confuM_t3(2,2)+confuM_t3(1,2));
%   ens_spet   = confuM_t3(1,1)/(confuM_t3(1,1)+confuM_t3(2,1));
%   ens_gmeant3 =sqrt(ens_sent *ens_spet);
%   ens_sent   = confuM_t4(2,2)/(confuM_t4(2,2)+confuM_t4(1,2));
%   ens_spet   = confuM_t4(1,1)/(confuM_t4(1,1)+confuM_t4(2,1));
%   ens_gmeant4 =sqrt(ens_sent *ens_spet);
%   ens_sent   = confuM_t5(2,2)/(confuM_t5(2,2)+confuM_t5(1,2));
%   ens_spet   = confuM_t5(1,1)/(confuM_t5(1,1)+confuM_t5(2,1));
%   ens_gmeant5 =sqrt(ens_sent *ens_spet);
  
  ens_simulation.ClassifierAll = ens_temp;
  ens_simulation.Classifier = ens_temp_cv;
  ens_simulation.vPredictions = vPredictions;
  ens_simulation.vScores = vScores;
  ens_simulation.vAccuracy = vAccuracy;
  ens_simulation.roc_1.auc = auc_1;
  ens_simulation.roc_2.auc = auc_2;
  ens_simulation.CM = confuM;
  
  ens_simulation.Classifier_test = row_min;
%   ens_simulation.tPredictions = tPredictions;
%   ens_simulation.tScores = tScores;
  ens_simulation.tAccuracy = tAccuracy;
%   ens_simulation.roc_1_t.auc = auc_1_t;
%   ens_simulation.roc_2_t.auc = auc_2_t;
%   ens_simulation.CM_t = [confuM_t;confuM_t2;confuM_t3;confuM_t4;confuM_t5];  
%   ens_simulation.gmean_t = ...
%       [ens_gmeant;ens_gmeant2;ens_gmeant3;ens_gmeant4;ens_gmeant5];   

  ens_simulation.sfs=fs;
    
 results.svm_simulation = svm_simulation;
 results.knn_simulation = knn_simulation;
 results.ens_simulation = ens_simulation;

%   results(k).svm_simulation = svm_simulation;
%   results(k).knn_simulation = knn_simulation;
%   results(k).ens_simulation = ens_simulation;
%   st = sp + 1;
%   sp = sp + 100;
%   end
end

function [results]=threeClassModels(features, labels)
    
    %initialize values
    kfold = 10;
    peri_temp = features;
    label_temp = labels;
    c = cvpartition(numel(label_temp),'KFold',kfold);
    
    %Bayesian Optimization for SVM
    svm_temp = fitcecoc(peri_temp,label_temp,...
           'Learners','svm',...
           'OptimizeHyperparameters','all',...
           'HyperparameterOptimizationOptions',...
           struct('CVPartition',c,'ShowPlots',false,'Verbose',0));

    %perform cross-validation
    svm_temp_cv = crossval(svm_temp, 'KFold', kfold);

    %compute validation predictions
    [vPredictions, vScores] = kfoldPredict(svm_temp_cv);

    %compute validation accuracy
    vAccuracy = 1 - kfoldLoss(svm_temp_cv);

    %perform Receiver Operating Characteristic (ROC)
    [~,~,~,auc_1,~] = perfcurve(label_temp,vScores(:,1),str2double(svm_temp_cv.ClassNames(1)));
    [~,~,~,auc_2,~] = perfcurve(label_temp,vScores(:,2),str2double(svm_temp_cv.ClassNames(2)));
    [~,~,~,auc_3,~] = perfcurve(label_temp,vScores(:,3),str2double(svm_temp_cv.ClassNames(3)));
    
    %get confusion matrix
    confuM = confusionmat(label_temp, vPredictions);

    svm_simulation.Classifier = svm_temp_cv;
    svm_simulation.vPredictions = vPredictions;
    svm_simulation.vScores = vScores;
    svm_simulation.vAccuracy = vAccuracy;
    svm_simulation.roc_1.auc = auc_1;
    svm_simulation.roc_2.auc = auc_2;
    svm_simulation.roc_3.auc = auc_3;
    svm_simulation.CM = confuM;

    %Bayesian Optimization for KNN
    knn_temp = fitcecoc(peri_temp,label_temp,...
           'Learners','knn',...
           'OptimizeHyperparameters','all',...
           'HyperparameterOptimizationOptions',...
           struct('CVPartition',c,'ShowPlots',false,'Verbose',0));

    % Perform cross-validation
    knn_temp_cv = crossval(knn_temp, 'KFold', kfold);

    % Compute validation predictions
    [vPredictions, vScores] = kfoldPredict(knn_temp_cv);

    % Compute validation accuracy
    vAccuracy = 1 - kfoldLoss(knn_temp_cv);

    %perform Receiver Operating Characteristic (ROC)
    [~,~,~,auc_1,~] = perfcurve(label_temp,vScores(:,1),str2double(svm_temp_cv.ClassNames(1)));
    [~,~,~,auc_2,~] = perfcurve(label_temp,vScores(:,2),str2double(svm_temp_cv.ClassNames(2)));
    [~,~,~,auc_3,~] = perfcurve(label_temp,vScores(:,3),str2double(svm_temp_cv.ClassNames(3)));
    
    %get confusion matrix
    confuM = confusionmat(label_temp, vPredictions);

    knn_simulation.Classifier = knn_temp_cv;
    knn_simulation.vPredictions = vPredictions;
    knn_simulation.vScores = vScores;
    knn_simulation.vAccuracy = vAccuracy;
    knn_simulation.roc_1.auc = auc_1;
    knn_simulation.roc_2.auc = auc_2;
    knn_simulation.roc_3.auc = auc_3;
    knn_simulation.CM = confuM;

    %Bayesian Optimization for ENS
    ens_temp = fitcensemble(peri_temp,label_temp,...
           'OptimizeHyperparameters','all',...
           'HyperparameterOptimizationOptions',...
           struct('CVPartition',c,'ShowPlots',false,'Verbose',0)); 

    % Perform cross-validation
    ens_temp_cv = crossval(ens_temp, 'KFold', kfold);

    % Compute validation predictions
    [vPredictions, vScores] = kfoldPredict(ens_temp_cv);

    % Compute validation accuracy
    vAccuracy = 1 - kfoldLoss(ens_temp_cv);

    %perform Receiver Operating Characteristic (ROC)
    [~,~,~,auc_1,~] = perfcurve(label_temp,vScores(:,1),str2double(svm_temp_cv.ClassNames(1)));
    [~,~,~,auc_2,~] = perfcurve(label_temp,vScores(:,2),str2double(svm_temp_cv.ClassNames(2)));
    [~,~,~,auc_3,~] = perfcurve(label_temp,vScores(:,3),str2double(svm_temp_cv.ClassNames(3)));
    
    %get confusion matrix
    confuM = confusionmat(label_temp, vPredictions);

    ens_simulation.Classifier = ens_temp_cv;
    ens_simulation.vPredictions = vPredictions;
    ens_simulation.vScores = vScores;
    ens_simulation.vAccuracy = vAccuracy;
    ens_simulation.roc_1.auc = auc_1;
    ens_simulation.roc_2.auc = auc_2;
    ens_simulation.roc_3.auc = auc_3;
    ens_simulation.CM = confuM;
    
    results.svm_simulation = svm_simulation;
    results.knn_simulation = knn_simulation;
    results.ens_simulation = ens_simulation;
end

function [results]=fourClassModels(features, labels)
    
    %initialize values
    kfold = 10;
    peri_temp = features;
    label_temp = labels;
    c = cvpartition(numel(label_temp),'KFold',kfold);
    
    %Bayesian Optimization for SVM
    svm_temp = fitcecoc(peri_temp,label_temp,...
           'Learners','svm',...
           'OptimizeHyperparameters','all',...
           'HyperparameterOptimizationOptions',...
           struct('CVPartition',c,'ShowPlots',false,'Verbose',0));

    %perform cross-validation
    svm_temp_cv = crossval(svm_temp, 'KFold', kfold);

    %compute validation predictions
    [vPredictions, vScores] = kfoldPredict(svm_temp_cv);

    %compute validation accuracy
    vAccuracy = 1 - kfoldLoss(svm_temp_cv);

    %perform Receiver Operating Characteristic (ROC)
    [~,~,~,auc_1,~] = perfcurve(label_temp,vScores(:,1),1);
    [~,~,~,auc_2,~] = perfcurve(label_temp,vScores(:,2),2);
    [~,~,~,auc_3,~] = perfcurve(label_temp,vScores(:,3),3);
    [~,~,~,auc_4,~] = perfcurve(label_temp,vScores(:,4),4);
    
    %get confusion matrix
    confuM = confusionmat(label_temp, vPredictions);

    svm_simulation.Classifier = svm_temp_cv;
    svm_simulation.vPredictions = vPredictions;
    svm_simulation.vScores = vScores;
    svm_simulation.vAccuracy = vAccuracy;
    svm_simulation.roc_1.auc = auc_1;
    svm_simulation.roc_2.auc = auc_2;
    svm_simulation.roc_3.auc = auc_3;
    svm_simulation.roc_4.auc = auc_4;
    svm_simulation.CM = confuM;

    %Bayesian Optimization for KNN
    knn_temp = fitcecoc(peri_temp,label_temp,...
           'Learners','knn',...
           'OptimizeHyperparameters','all',...
           'HyperparameterOptimizationOptions',...
           struct('CVPartition',c,'ShowPlots',false,'Verbose',0));

    % Perform cross-validation
    knn_temp_cv = crossval(knn_temp, 'KFold', kfold);

    % Compute validation predictions
    [vPredictions, vScores] = kfoldPredict(knn_temp_cv);

    % Compute validation accuracy
    vAccuracy = 1 - kfoldLoss(knn_temp_cv);

    %perform Receiver Operating Characteristic (ROC)
    [~,~,~,auc_1,~] = perfcurve(label_temp,vScores(:,1),1);
    [~,~,~,auc_2,~] = perfcurve(label_temp,vScores(:,2),2);
    [~,~,~,auc_3,~] = perfcurve(label_temp,vScores(:,3),3);
    [~,~,~,auc_4,~] = perfcurve(label_temp,vScores(:,4),4);
    
    %get confusion matrix
    confuM = confusionmat(label_temp, vPredictions);

    knn_simulation.Classifier = knn_temp_cv;
    knn_simulation.vPredictions = vPredictions;
    knn_simulation.vScores = vScores;
    knn_simulation.vAccuracy = vAccuracy;
    knn_simulation.roc_1.auc = auc_1;
    knn_simulation.roc_2.auc = auc_2;
    knn_simulation.roc_3.auc = auc_3;
    knn_simulation.roc_4.auc = auc_4;
    knn_simulation.CM = confuM;

    %Bayesian Optimization for ENS
    ens_temp = fitcensemble(peri_temp,label_temp,...
           'OptimizeHyperparameters','all',...
           'HyperparameterOptimizationOptions',...
           struct('CVPartition',c,'ShowPlots',false,'Verbose',0)); 

    % Perform cross-validation
    ens_temp_cv = crossval(ens_temp, 'KFold', kfold);

    % Compute validation predictions
    [vPredictions, vScores] = kfoldPredict(ens_temp_cv);

    % Compute validation accuracy
    vAccuracy = 1 - kfoldLoss(ens_temp_cv);

    %perform Receiver Operating Characteristic (ROC)
    [~,~,~,auc_1,~] = perfcurve(label_temp,vScores(:,1),1);
    [~,~,~,auc_2,~] = perfcurve(label_temp,vScores(:,2),2);
    [~,~,~,auc_3,~] = perfcurve(label_temp,vScores(:,3),3);
    [~,~,~,auc_4,~] = perfcurve(label_temp,vScores(:,4),4);
    
    %get confusion matrix
    confuM = confusionmat(label_temp, vPredictions);

    ens_simulation.Classifier = ens_temp_cv;
    ens_simulation.vPredictions = vPredictions;
    ens_simulation.vScores = vScores;
    ens_simulation.vAccuracy = vAccuracy;
    ens_simulation.roc_1.auc = auc_1;
    ens_simulation.roc_2.auc = auc_2;
    ens_simulation.roc_3.auc = auc_3;
    ens_simulation.roc_4.auc = auc_4;
    ens_simulation.CM = confuM;
    
    results.svm_simulation = svm_simulation;
    results.knn_simulation = knn_simulation;
    results.ens_simulation = ens_simulation;
end

function out = classfsvm(train_data, train_labels, test_data, test_labels)

    mdl = fitcsvm(train_data, train_labels,'KernelFunction','polynomial','Cost',[0,1;1,0],'ClassNames',{'1','2'});
    
    [pred,~]=predict(mdl,test_data);
    
    confuM = confusionmat(string(test_labels), string(pred),'order',{'1','2'});
    
    sent   = confuM(2,2)/(confuM(2,2)+confuM(2,1));
    spet   = confuM(1,1)/(confuM(1,1)+confuM(1,2));
    
    %sensitivity
    %out=sent;
    
    %gmean
    gmean = sqrt(sent*spet)*100;
    out=100-gmean;
    %out=confuM(2,1);
    %out= (1 - sent)*100;
    
    %sum(predict(fitcsvm(train_data, train_labels,'KernelFunction','rbf','Cost',[0,1;2 0]), test_data) ~= test_labels);
end

function out = classfknn(train_data, train_labels, test_data, test_labels)

    mdl = fitcknn(train_data, train_labels,'ClassNames',{'1','2'});
    
    [pred,~]=predict(mdl,test_data);
    
    confuM = confusionmat(string(test_labels), string(pred),'order',{'1','2'});
    
    sent   = confuM(2,2)/(confuM(2,2)+confuM(2,1));
    spet   = confuM(1,1)/(confuM(1,1)+confuM(1,2));
    
    %sensitivity
    %out=sent;
    
    %gmean
    gmean = sqrt(sent*spet)*100;
    out=100-gmean;
    %out=confuM(2,1);
    %out= (1 - sent)*100;
    %sum(predict(fitcsvm(train_data, train_labels,'KernelFunction','rbf','Cost',[0,1;2 0]), test_data) ~= test_labels);
end

function out = classfens(train_data, train_labels, test_data, test_labels)

    mdl = fitcensemble(train_data, train_labels,'Method','AdaBoostM1','ClassNames',{'1','2'});%,'Method','AdaBoostM1'
    
    [pred,~]=predict(mdl,test_data);
    
    confuM = confusionmat(string(test_labels), string(pred),'order',{'1','2'});
    
    sent   = confuM(2,2)/(confuM(2,2)+confuM(2,1));
    spet   = confuM(1,1)/(confuM(1,1)+confuM(1,2));
    
    %sensitivity
    %out=sent;
    
    %gmean
    gmean = sqrt(sent*spet)*100;
    out=100-gmean;
    %out=confuM(2,1);
    %out= (1 - sent)*100;
    %sum(predict(fitcsvm(train_data, train_labels,'KernelFunction','rbf','Cost',[0,1;2 0]), test_data) ~= test_labels);
end