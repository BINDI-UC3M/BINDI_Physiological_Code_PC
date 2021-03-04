

result_path="C:\Users\equipo\Desktop\REPO\BINDI_Physiological_Code_PC\Matlab\DataExamples\ejemploBioSpeech\SingleHybrid\NormalizeFeats\ResultsBioSpeech_V";

result_table=zeros(42,8);
gmean_table=zeros(42,3);


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
%   KNN
    [value,index]=max(result_train{voluntario}.knn_test.gmean);
    gmean_table(voluntario,2)=value;
    result_table(voluntario,5)=result_train{voluntario}.knn_test.confu{index}(2,2)/result_table(voluntario,2)*100;
    result_table(voluntario,6)=result_train{voluntario}.knn_test.confu{index}(1,1)/result_table(voluntario,1)*100;    
%   ENS
    gmean_table(voluntario,3)=value;
    [value,index]=max(result_train{voluntario}.ens_test.gmean);
    result_table(voluntario,7)=result_train{voluntario}.ens_test.confu{index}(2,2)/result_table(voluntario,2)*100;
    result_table(voluntario,8)=result_train{voluntario}.ens_test.confu{index}(1,1)/result_table(voluntario,1)*100;
     
    
    
end