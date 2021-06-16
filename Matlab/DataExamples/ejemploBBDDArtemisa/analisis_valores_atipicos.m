

mat_da=[[out_s(2,:).da];[out_s(3,:).da] ;[out_s(4,:).da]];
mat_a=[[out_s(2,:).a];[out_s(3,:).a] ;[out_s(4,:).a]];
mat_na=[[out_s(2,:).na];[out_s(3,:).na] ;[out_s(4,:).na]];



mean_all_da=mean([[out_s(2,:).da];[out_s(3,:).da] ;[out_s(4,:).da]],2);
mean_all_a=mean([[out_s(2,:).a];[out_s(3,:).a] ;[out_s(4,:).a]],2);
mean_all_na=mean([[out_s(2,:).na];[out_s(3,:).na] ;[out_s(4,:).na]],2);

std_all_da=std([[out_s(2,:).da];[out_s(3,:).da] ;[out_s(4,:).da]],0,2);
std_all_a=std([[out_s(2,:).a];[out_s(3,:).a] ;[out_s(4,:).a]],0,2);
std_all_na=std([[out_s(2,:).na];[out_s(3,:).na] ;[out_s(4,:).na]],0,2);


mean_plus_std_da=mean_all_da+std_all_da;
mean_plus_std_a=mean_all_a+std_all_a;
mean_plus_std_na=mean_all_na+std_all_na;

mean_minus_std_da=mean_all_da-std_all_da;
mean_minus_std_a=mean_all_a-std_all_a;
mean_minus_std_na=mean_all_na-std_all_na;

Vect_voluntarias_atipicas_a=zeros(1,21);
Vect_voluntarias_atipicas_da=zeros(1,21);
Vect_voluntarias_atipicas_na=zeros(1,21);


% [mat_samples_atipicas_a,vect_lower_limit_a,vect_upper_limit_a,vect_center_value_a]=isoutlier(mat_a,'mean',2,'ThresholdFactor',1);
% [mat_samples_atipicas_da,vect_lower_limit_da,vect_upper_limit_da,vect_center_value_da]=isoutlier(mat_da,'mean',2,'ThresholdFactor',1);
% [mat_samples_atipicas_na,vect_lower_limit_na,vect_upper_limit_na,vect_center_value_na]=isoutlier(mat_na,'mean',2,'ThresholdFactor',1);


[mat_samples_atipicas_a,vect_lower_limit_a,vect_upper_limit_a,vect_center_value_a]=isoutlier(mat_a,'mean',2,'ThresholdFactor',1);
[mat_samples_atipicas_da,vect_lower_limit_da,vect_upper_limit_da,vect_center_value_da]=isoutlier(mat_da,'mean',2,'ThresholdFactor',1);
[mat_samples_atipicas_na,vect_lower_limit_na,vect_upper_limit_na,vect_center_value_na]=isoutlier(mat_na,'mean',2,'ThresholdFactor',1);


vec_volun_atipicas_a=sum(mat_samples_atipicas_a);
vec_volun_atipicas_na=sum(mat_samples_atipicas_na);
vec_volun_atipicas_da=sum(mat_samples_atipicas_da);

figure
bar(vec_volun_atipicas_a)
title('Adrenalina - Numero de datos atipicos por voluntaria')
figure
bar(vec_volun_atipicas_da)
title('Dopamina - Numero de datos atipicos por voluntaria')
figure
bar(vec_volun_atipicas_na)
title('Noradrenalina - Numero de datos atipicos por voluntaria')




% for loop1=0:20
%     temp=out_mat(:,4*loop1+1);
%     Vect_voluntarias_atipicas_a(loop1+1)=sum((temp>mean_plus_std_a|temp<mean_minus_std_a));
%     
%     temp=out_mat(:,4*loop1+2);
%     Vect_voluntarias_atipicas_da(loop1+1)=sum((temp>mean_plus_std_da|temp<mean_minus_std_da));
%     
%     temp=out_mat(:,4*loop1+3);
%     Vect_voluntarias_atipicas_na(loop1+1)=sum((temp>mean_plus_std_na|temp<mean_minus_std_na));
% 
% end
mark_types=['o';'+';'*';'.';'x';'s';'d';'^';'v';'>';'<';'p';'h';'o';'+';'*';'.';'x';'s';'d';'^';'v';'>';'<';'p';'h'];



figure
plot(mat_a(:,1),mark_types(1))
hold on
for loop1=2:21
    
    plot(mat_a(:,loop1),mark_types(loop1+1))
    
end
plot(mean_all_a,'-.k')
plot(mean_plus_std_a,'-.k')
plot(mean_minus_std_a,'-.k')
title('Adrenalina')
legend('V1','V2','V3','V4','V5','V6','V7','V8','V9','V10','V11','V12','V13','V14','V15','V16','V17','V18','V19','V20','V21','Mean','Mean+std','Mean-std')

figure
plot(mat_da(:,1),mark_types(1))
hold on
for loop1=2:21
    
    plot(mat_da(:,loop1),mark_types(loop1+1))
    
end
plot(mean_all_da,'-.k')
plot(mean_plus_std_da,'-.k')
plot(mean_minus_std_da,'-.k')
title('Dopamina')

legend('V1','V2','V3','V4','V5','V6','V7','V8','V9','V10','V11','V12','V13','V14','V15','V16','V17','V18','V19','V20','V21','Mean','Mean+std','Mean-std')


figure
plot(mat_na(:,1),mark_types(1))
hold on
for loop1=2:21
    
    plot(mat_na(:,loop1),mark_types(loop1+1))
    
end
plot(mean_all_na,'-.k')
plot(mean_plus_std_na,'-.k')
plot(mean_minus_std_na,'-.k')
title('Noradrenalina')

legend('V1','V2','V3','V4','V5','V6','V7','V8','V9','V10','V11','V12','V13','V14','V15','V16','V17','V18','V19','V20','V21','Mean','Mean+std','Mean-std')


% 
% mat_da_z = zscore(mat_da)
% mean_all_da_z=mean(mat_da_z,2);
% std_all_da_z=std(mat_da_z,0,2);
% 
% temp1=mean_all_da_z+std_all_da_z;
% temp2=mean_all_da_z-std_all_da_z;
% 
% 
% 
% figure
% plot(mat_da_z(:,1),mark_types(1))
% hold on
% for loop1=2:21
%     
%     plot(mat_da_z(:,loop1),mark_types(loop1+1))
%     
% end
% 
% 
% plot(mean_all_da_z,'-.k')
% plot(temp1,'-.k')
% plot(temp2,'-.k')


























