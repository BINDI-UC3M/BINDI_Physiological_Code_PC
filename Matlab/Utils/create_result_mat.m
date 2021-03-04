

result_path="G:\Mi unidad\Investigacion\Empatia\Objetivo_2\Multimodal\LOSO_norm_features_2021_03_02\ResultsBioSpeech_V";

% mat of results
result_table=zeros(42,8);
% mat for gmean
gmean_table=zeros(42,3);

global_confu_mat.svm=zeros(2,2);
global_confu_mat.knn=zeros(2,2);
global_confu_mat.ens=zeros(2,2);

for voluntario=1:42
    
    load(result_path+voluntario+".mat")
    
%   Instancias
    result_table(voluntario,1)=sum(result_train{voluntario}.svm_test.confu{1}(1,:));
    result_table(voluntario,2)=sum(result_train{voluntario}.svm_test.confu{1}(2,:));
    vol_colum{voluntario,1}=sprintf('V%i(%i,%i)',voluntario,result_table(voluntario,1),result_table(voluntario,2));
    
    
%   SVM
    [value,index]=max(result_train{voluntario}.svm_test.gmean);
    gmean_table(voluntario,1)=value;
    result_table(voluntario,3)=result_train{voluntario}.svm_test.confu{index}(2,2)/result_table(voluntario,2)*100;
    result_table(voluntario,4)=result_train{voluntario}.svm_test.confu{index}(1,1)/result_table(voluntario,1)*100;
   
%   - Global confusion matrix
    global_confu_mat.svm(1,1)=result_train{voluntario}.svm_test.confu{index}(1,1)+global_confu_mat.svm(1,1);
    global_confu_mat.svm(2,1)=result_train{voluntario}.svm_test.confu{index}(2,1)+global_confu_mat.svm(2,1);
    global_confu_mat.svm(1,2)=result_train{voluntario}.svm_test.confu{index}(1,2)+global_confu_mat.svm(1,2);
    global_confu_mat.svm(2,2)=result_train{voluntario}.svm_test.confu{index}(2,2)+global_confu_mat.svm(2,2);
    
%   KNN
    [value,index]=max(result_train{voluntario}.knn_test.gmean);
    gmean_table(voluntario,2)=value;
    result_table(voluntario,5)=result_train{voluntario}.knn_test.confu{index}(2,2)/result_table(voluntario,2)*100;
    result_table(voluntario,6)=result_train{voluntario}.knn_test.confu{index}(1,1)/result_table(voluntario,1)*100;

%   - Global confusion matrix
    global_confu_mat.knn(1,1)=result_train{voluntario}.knn_test.confu{index}(1,1)+global_confu_mat.knn(1,1);
    global_confu_mat.knn(2,1)=result_train{voluntario}.knn_test.confu{index}(2,1)+global_confu_mat.knn(2,1);
    global_confu_mat.knn(1,2)=result_train{voluntario}.knn_test.confu{index}(1,2)+global_confu_mat.knn(1,2);
    global_confu_mat.knn(2,2)=result_train{voluntario}.knn_test.confu{index}(2,2)+global_confu_mat.knn(2,2);
    
%   ENS
    gmean_table(voluntario,3)=value;
    [value,index]=max(result_train{voluntario}.ens_test.gmean);
    result_table(voluntario,7)=result_train{voluntario}.ens_test.confu{index}(2,2)/result_table(voluntario,2)*100;
    result_table(voluntario,8)=result_train{voluntario}.ens_test.confu{index}(1,1)/result_table(voluntario,1)*100;

%   - Global confusion matrix
    global_confu_mat.ens(1,1)=result_train{voluntario}.ens_test.confu{index}(1,1)+global_confu_mat.ens(1,1);
    global_confu_mat.ens(2,1)=result_train{voluntario}.ens_test.confu{index}(2,1)+global_confu_mat.ens(2,1);
    global_confu_mat.ens(1,2)=result_train{voluntario}.ens_test.confu{index}(1,2)+global_confu_mat.ens(1,2);
    global_confu_mat.ens(2,2)=result_train{voluntario}.ens_test.confu{index}(2,2)+global_confu_mat.ens(2,2);

      
    
end

result_global=zeros(1,8);
result_global(1,1)= sum(result_table(:,1));
result_global(1,2)= sum(result_table(:,2));

result_global(1,3)= global_confu_mat.svm(2,2)/result_global(1,2)*100;
result_global(1,4)= global_confu_mat.svm(1,1)/result_global(1,1)*100;

result_global(1,5)= global_confu_mat.knn(2,2)/result_global(1,2)*100;
result_global(1,6)= global_confu_mat.knn(1,1)/result_global(1,1)*100;

result_global(1,7)= global_confu_mat.ens(2,2)/result_global(1,2)*100;
result_global(1,8)= global_confu_mat.ens(1,1)/result_global(1,1)*100;

clear voluntario index value result_path

