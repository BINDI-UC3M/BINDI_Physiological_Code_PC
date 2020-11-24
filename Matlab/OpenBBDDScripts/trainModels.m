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

function  [result] = trainModels(features, labels, varargin)

  warning('off','all')
  warning

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
%         patients_open = [4,5,7,14,19,20,21,22,23,24,28,29];
        patients_open = [4,5,7,14,19,20,21,22,23,24,29];
%          patients_open = [5];
        %only males
%         patients_open = [1,2,8,10,13,17,18,27,30];
        patients = 29;
        trials   = 20;
      case 3
        disp('WESAD Open BBDD simulation running');
        patients_open = [1,2,3,4,5];
        patients = 15;
        trials   = 5;        
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
        [r,~] = find(isinf(p_temp(:,:)));
        if r>0
          p_temp(r,:) = [];
          l_temp(r,:,:)= [];
        end
        peri_temp  = [peri_temp ; zscore(p_temp)];
        label_temp = [label_temp ; l_temp];
      end
      i = 1;

        %convert from '0' to +1
        if numel(label_temp(strcmp(label_temp,'0'),1))>0
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
  
  %initialize values
  kfold = 5;
  peri_temp = features;
  label_temp = labels;
  c = cvpartition(numel(label_temp),'KFold',kfold);

  %Bayesian Optimization for SVM
  svm_temp = fitcsvm(peri_temp,label_temp,...
             'OptimizeHyperparameters','all',...
             'HyperparameterOptimizationOptions',...
             struct('CVPartition',c,'ShowPlots',false,'Verbose',1));
         
  %perform cross-validation
  svm_temp_cv = crossval(svm_temp, 'KFold', kfold);

  %compute validation predictions
  [vPredictions, vScores] = kfoldPredict(svm_temp_cv);

  %compute validation accuracy
  vAccuracy = 1 - kfoldLoss(svm_temp_cv);

  %perform Receiver Operating Characteristic (ROC)
  [~,~,~,auc_1,~] = perfcurve(label_temp,vScores(:,1),1);
  [~,~,~,auc_2,~] = perfcurve(label_temp,vScores(:,2),2);
  
  %get confusion matrix
  confuM = confusionmat(label_temp, vPredictions);

  svm_simulation.Classifier = svm_temp_cv;
  svm_simulation.vPredictions = vPredictions;
  svm_simulation.vScores = vScores;
  svm_simulation.vAccuracy = vAccuracy;
  svm_simulation.roc_1.auc = auc_1;
  svm_simulation.roc_2.auc = auc_2;
  svm_simulation.CM = confuM;
         
  %Bayesian Optimization for KNN      
  knn_temp = fitcknn(peri_temp,label_temp,...
             'OptimizeHyperparameters','all',...
             'HyperparameterOptimizationOptions',...
             struct('CVPartition',c,'ShowPlots',false,'Verbose',1));

  % Perform cross-validation
  knn_temp_cv = crossval(knn_temp, 'KFold', kfold);

  % Compute validation predictions
  [vPredictions, vScores] = kfoldPredict(knn_temp_cv);

  % Compute validation accuracy
  vAccuracy = 1 - kfoldLoss(knn_temp_cv);

  %perform Receiver Operating Characteristic (ROC)
  [~,~,~,auc_1,~] = perfcurve(label_temp,vScores(:,1),1);
  [~,~,~,auc_2,~] = perfcurve(label_temp,vScores(:,2),2);
  
  %get confusion matrix
  confuM = confusionmat(label_temp, vPredictions);

  knn_simulation.Classifier = knn_temp_cv;
  knn_simulation.vPredictions = vPredictions;
  knn_simulation.vScores = vScores;
  knn_simulation.vAccuracy = vAccuracy;
  knn_simulation.roc_1.auc = auc_1;
  knn_simulation.roc_2.auc = auc_2;
  knn_simulation.CM = confuM;
         
  %Bayesian Optimization for ENS
  ens_temp = fitcensemble(peri_temp,label_temp,...
             'OptimizeHyperparameters','all',...
             'HyperparameterOptimizationOptions',...
             struct('CVPartition',c,'ShowPlots',false,'Verbose',1)); 
         
  % Perform cross-validation
  ens_temp_cv = crossval(ens_temp, 'KFold', kfold);

  % Compute validation predictions
  [vPredictions, vScores] = kfoldPredict(ens_temp_cv);

  % Compute validation accuracy
  vAccuracy = 1 - kfoldLoss(ens_temp_cv);

  %perform Receiver Operating Characteristic (ROC)
  [~,~,~,auc_1,~] = perfcurve(label_temp,vScores(:,1),1);
  [~,~,~,auc_2,~] = perfcurve(label_temp,vScores(:,2),2);
  
  %get confusion matrix
  confuM = confusionmat(label_temp, vPredictions);
  
  ens_simulation.Classifier = ens_temp_cv;
  ens_simulation.vPredictions = vPredictions;
  ens_simulation.vScores = vScores;
  ens_simulation.vAccuracy = vAccuracy;
  ens_simulation.roc_1.auc = auc_1;
  ens_simulation.roc_2.auc = auc_2;
  ens_simulation.CM = confuM;
    
  results.svm_simulation = svm_simulation;
  results.knn_simulation = knn_simulation;
  results.ens_simulation = ens_simulation;
end

function [results]=threeClassModels(features, labels)
    
    %initialize values
    kfold = 5;
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
    kfold = 5;
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