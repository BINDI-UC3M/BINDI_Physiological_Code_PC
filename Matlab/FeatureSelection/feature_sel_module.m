function [iFeatSelected, train_data, test_data] = feature_sel_module(train_data, test_data, labelsTrain, parameters)
% global first_three;
%feature selection module
global features_selected;
global i;
iFeatSelected = [];
train_data(isnan(train_data)) = 0;
if ~isfield(parameters, 'pca_tresh')
    pca_tresh = 0.95;
else
    pca_tresh = parameters.pca_tresh;
end
if ~isfield(parameters, 'is_regression')
    parameters.is_regression = 0;
end
cca_tresh = 12;
nbFeatures = size(train_data,2);
switch parameters.featSelection
    case 'forward'
        c = cvpartition(labelsTrain,'k',3);
        opts = statset('display','iter');
        classifier = 'diaglinear';
        priorP = ones(1,parameters.nbClasses)/parameters.nbClasses;
%         fun = @(XT,yT,Xt,yt)...
%             (((sum((yt==2)&(classify(Xt,XT,yT,classifier,priorP)==1))/sum(yt==2))*10+(sum((yt==1)&(classify(Xt,XT,yT,classifier,priorP)==2))/sum(yt==1)))/11);
        [inmodel, ~]= sequentialfs(@fun,train_data,labelsTrain,'cv',c,'direction','forward', 'options',opts); %
        iFeatSelected = find(inmodel);
%         features_selected(parameters.runs,:,parameters.subject) = inmodel;
    case 'Fisher'
        [listFeatures,FC] = fisherCrit(train_data,labelsTrain, parameters.nbClasses);
        FisherThreshold = 0.3;
        iFeatSelected = listFeatures(FC>FisherThreshold);
        if length(iFeatSelected) < 3
%             fprintf('first three selected');
%             first_three = first_three + 1;
            iFeatSelected = listFeatures(1:3);
        end
    case 'mrmr'
        %P = cvpartition(labelsTrain,'Holdout',0.20);

        X_train = double( train_data);
        Y_train = double( labelsTrain); 
        %X_test = double( train_data(P.test,:) );
        %Y_test = double( labelsTrain(P.test) ); 
        % number of features
        numF = size(X_train,2);
        iFeatSelected = mRMR(X_train, Y_train, numF);
        
        k = 5; % select the first 2 features

        % Use a support vector machine classifier
        %svmStruct = svmtrain(Y_train,X_train(:,iFeatSelected(1:k)));
        %C = svmpredict(Y_test, X_test(:,iFeatSelected(1:k)),svmStruct);
        %err_rate = sum(Y_test~= C)/P.TestSize; % mis-classification rate
        %conMat = confusionmat(Y_test,C); % the confusion matrix
        iFeatSelected = iFeatSelected(1:k);
        %features_selected(1:k,parameters.subject) = iFeatSelected;
        fprintf('\nMethod mrmr (SVM): ')%;Accuracy: %.2f%%, Error-Rate: %.2f \n',100*(1-err_rate),err_rate);
        disp('Selected:\n')
        iFeatSelected
    case 'mcfs'
        P = cvpartition(labelsTrain,'Holdout',0.20);

        X_train = double( train_data(P.training,:));
        Y_train = double( labelsTrain(P.training)); 
        X_test = double( train_data(P.test,:) );
        Y_test = double( labelsTrain(P.test) ); 
        % number of features
        numF = size(X_train,2);
        % MCFS: Unsupervised Feature Selection for Multi-Cluster Data
        options = [];
        options.k = 5; %For unsupervised feature selection, you should tune
        %this parameter k, the default k is 5.
        options.nUseEigenfunction = 4;  %You should tune this parameter.
        [FeaIndex,~] = MCFS_p(X_train,numF,options);
        iFeatSelected = FeaIndex{1};
        
        k = 10; % select the first 2 features

        % Use a support vector machine classifier
        svmStruct = svmtrain(Y_train,X_train(:,iFeatSelected(1:k)));
        C = svmpredict(Y_test, X_test(:,iFeatSelected(1:k)),svmStruct);
        err_rate = sum(Y_test~= C)/P.TestSize; % mis-classification rate
        conMat = confusionmat(Y_test,C); % the confusion matrix
        iFeatSelected = iFeatSelected(1:k);
        fprintf('\nMethod mcfs (SVM): Accuracy: %.2f%%, Error-Rate: %.2f \n',100*(1-err_rate),err_rate);
    case 'ilfs'
%         P = cvpartition(labelsTrain,'Holdout',0.20);

        X_train = double( train_data);
        Y_train = double( labelsTrain); 
%         X_test = double( train_data(P.test,:) );
%         Y_test = double( labelsTrain(P.test) ); 
        % number of features
%         numF = size(X_train,2);
        % Infinite Latent Feature Selection - ICCV 2017
        [iFeatSelected, weights] = ILFS(X_train, Y_train , 10, 1 );
        
        k = 10; % select the first 2 features

        % Use a support vector machine classifier
%         svmStruct = svmtrain(Y_train,X_train(:,iFeatSelected(1:k)));
%         C = svmpredict(Y_test, X_test(:,iFeatSelected(1:k)),svmStruct);
%         err_rate = sum(Y_test~= C)/P.TestSize; % mis-classification rate
%         conMat = confusionmat(Y_test,C); % the confusion matrix
        iFeatSelected = iFeatSelected(1:k);
%         fprintf('\nMethod ilfs (SVM): Accuracy: %.2f%%, Error-Rate: %.2f \n',100*(1-err_rate),err_rate);
    case 'lasso'
        %P= cvpartition(labelsTrain,'Holdout',0.30);

        X_train = double( train_data);
        Y_train = double( labelsTrain); 
%         X_test = double( train_data(P.test,:) );
%         Y_test = double( labelsTrain(P.test) ); 
        % number of features
%         numF = size(X_train,2);
        lambda = 25;
        B = lasso(X_train,Y_train);
        [v,iFeatSelected]=sort(B(:,lambda),'descend');
        
        k = 10; % select the first 2 features

        % Use a support vector machine classifier
%         svmStruct = svmtrain(Y_train,X_train(:,iFeatSelected(1:k)));
%         C = svmpredict(Y_test, X_test(:,iFeatSelected(1:k)),svmStruct);
%         err_rate = sum(Y_test~= C)/P.TestSize; % mis-classification rate
%         conMat = confusionmat(Y_test,C); % the confusion matrix
        iFeatSelected = iFeatSelected(1:k);
        %fprintf('\nMethod ilfs (SVM): Accuracy: %.2f%%, Error-Rate: %.2f \n',100*(1-err_rate),err_rate);
        
    case 'relief'
        X_train = double( train_data);
        Y_train = double( labelsTrain); 
        [iFeatSelected, w] = reliefF( X_train, Y_train, 20);
        k=10;
        iFeatSelected = iFeatSelected(1:k);
        disp('Selected:\n')
        iFeatSelected
    case 'none'
        iFeatSelected = 1:size(train_data,2);
end
if isempty(iFeatSelected)
    iFeatSelected = 1:nbFeatures;
end
train_data  = train_data(:,iFeatSelected);
test_data = test_data(:,iFeatSelected);
end


% fun = @(XT,yT,Xt,yt)...
%             (((sum((yt==2)&(classify(Xt,XT,yT,classifier,priorP)==1))/sum(yt==2))*10+(sum((yt==1)&(classify(Xt,XT,yT,classifier,priorP)==2))/sum(yt==1)))/11);
function funResult = fun(XT,yT,Xt,yt)
  nbClasses = 2;
  classifier = 'diaglinear';
  priorP = ones(1,nbClasses)/nbClasses;
%   funResult = (((sum((yt==2)&(classify(Xt,XT,yT,classifier,priorP)==1))/sum(yt==2))*10+(sum((yt==1)&(classify(Xt,XT,yT,classifier,priorP)==2))/sum(yt==1)))/11);
  funResult = (((sum((yt==2)&(classify(Xt,XT,yT,classifier,priorP)==1))/sum(yt==2))+(sum((yt==1)&(classify(Xt,XT,yT,classifier,priorP)==2))/sum(yt==1))));
  
end