

% Max and min diferences
cuenta_da=0;
cuenta_a=0;
cuenta_na=0;
for n_video=1:3
    

    for n_voluntaria=1:21
        % Max diff
        [feature_mat(n_video,n_voluntaria).max_diff_da,feature_mat(n_video,n_voluntaria).max_diff_index_da]=max(diff(resultados_nt_reordered(n_video+1,n_voluntaria).da));
        [feature_mat(n_video,n_voluntaria).max_diff_a,feature_mat(n_video,n_voluntaria).max_diff_index_a]=max(diff(resultados_nt_reordered(n_video+1,n_voluntaria).a));
        [feature_mat(n_video,n_voluntaria).max_diff_na,feature_mat(n_video,n_voluntaria).max_diff_index_na]=max(diff(resultados_nt_reordered(n_video+1,n_voluntaria).na));
        % Min diff
        [feature_mat(n_video,n_voluntaria).min_diff_da,feature_mat(n_video,n_voluntaria).min_diff_index_da]=min(diff(resultados_nt_reordered(n_video+1,n_voluntaria).da));
        [feature_mat(n_video,n_voluntaria).min_diff_a,feature_mat(n_video,n_voluntaria).min_diff_index_a]=min(diff(resultados_nt_reordered(n_video+1,n_voluntaria).a));
        [feature_mat(n_video,n_voluntaria).min_diff_na,feature_mat(n_video,n_voluntaria).min_diff_index_na]=min(diff(resultados_nt_reordered(n_video+1,n_voluntaria).na));
        % Max relative diff 
        [feature_mat(n_video,n_voluntaria).max_relative_diff_da,feature_mat(n_video,n_voluntaria).max_relative_diff_index_da]=max(diff(resultados_nt_reordered(n_video+1,n_voluntaria).da)./resultados_nt_reordered(n_video+1,n_voluntaria).da(1:end-1)*100);
        [feature_mat(n_video,n_voluntaria).max_relative_diff_a,feature_mat(n_video,n_voluntaria).max_relative_diff_index_a]=max(diff(resultados_nt_reordered(n_video+1,n_voluntaria).a)./resultados_nt_reordered(n_video+1,n_voluntaria).a(1:end-1)*100);
        [feature_mat(n_video,n_voluntaria).max_relative_diff_na,feature_mat(n_video,n_voluntaria).max_relative_diff_index_na]=max(diff(resultados_nt_reordered(n_video+1,n_voluntaria).na)./resultados_nt_reordered(n_video+1,n_voluntaria).na(1:end-1)*100);
        % Min relative diff 
        [feature_mat(n_video,n_voluntaria).min_relative_diff_da,feature_mat(n_video,n_voluntaria).min_relative_diff_index_da]=min(diff(resultados_nt_reordered(n_video+1,n_voluntaria).da)./resultados_nt_reordered(n_video+1,n_voluntaria).da(1:end-1)*100);
        [feature_mat(n_video,n_voluntaria).min_relative_diff_a,feature_mat(n_video,n_voluntaria).min_relative_diff_index_a]=min(diff(resultados_nt_reordered(n_video+1,n_voluntaria).a)./resultados_nt_reordered(n_video+1,n_voluntaria).a(1:end-1)*100);
        [feature_mat(n_video,n_voluntaria).min_relative_diff_na,feature_mat(n_video,n_voluntaria).min_relative_diff_index_na]=min(diff(resultados_nt_reordered(n_video+1,n_voluntaria).na)./resultados_nt_reordered(n_video+1,n_voluntaria).na(1:end-1)*100);
        % Range
        [feature_mat(n_video,n_voluntaria).range_da]=range(resultados_nt_reordered(n_video+1,n_voluntaria).da);
        [feature_mat(n_video,n_voluntaria).range_a]=range(resultados_nt_reordered(n_video+1,n_voluntaria).a);
        [feature_mat(n_video,n_voluntaria).range_na]=range(resultados_nt_reordered(n_video+1,n_voluntaria).na);
        % Peaks
%         data=zeros(1,7);
%         data(2:6)=resultados_nt_reordered(n_video+1,n_voluntaria).da
%         [pks,locs] = findpeaks(data,'MinPeakProminence',0)
%         figure
%         findpeaks(data,'MinPeakProminence',0,'Annotate','extents')
%         hold on
%         data=zeros(1,7);
%         data(2:6)=-1*resultados_nt_reordered(n_video+1,n_voluntaria).da+max(resultados_nt_reordered(n_video+1,n_voluntaria).da)
%         findpeaks(data,'MinPeakProminence',0,'Annotate','extents')
         
        % Max abs 
        [feature_mat(n_video,n_voluntaria).max_abs_da,feature_mat(n_video,n_voluntaria).max_abs_index_da]=max((resultados_nt_reordered(n_video+1,n_voluntaria).da));
        [feature_mat(n_video,n_voluntaria).max_abs_a,feature_mat(n_video,n_voluntaria).max_abs_index_a]=max((resultados_nt_reordered(n_video+1,n_voluntaria).a));
        [feature_mat(n_video,n_voluntaria).max_abs_na,feature_mat(n_video,n_voluntaria).max_abs_index_na]=max((resultados_nt_reordered(n_video+1,n_voluntaria).na));
        % Min abs
        [feature_mat(n_video,n_voluntaria).min_abs_da,feature_mat(n_video,n_voluntaria).min_abs_index_da]=min((resultados_nt_reordered(n_video+1,n_voluntaria).da));
        [feature_mat(n_video,n_voluntaria).min_abs_a,feature_mat(n_video,n_voluntaria).min_abs_index_a]=min((resultados_nt_reordered(n_video+1,n_voluntaria).a));
        [feature_mat(n_video,n_voluntaria).min_abs_na,feature_mat(n_video,n_voluntaria).min_abs_index_na]=min((resultados_nt_reordered(n_video+1,n_voluntaria).na));
%         Rngo orden temporal
        if(feature_mat(n_video,n_voluntaria).min_abs_index_da<feature_mat(n_video,n_voluntaria).max_abs_index_da)
            feature_mat(n_video,n_voluntaria).range_sign_da=feature_mat(n_video,n_voluntaria).range_da;
            cuenta_da=cuenta_da+1;
        else
            feature_mat(n_video,n_voluntaria).range_sign_da=feature_mat(n_video,n_voluntaria).range_da*-1;
        end
        
        if(feature_mat(n_video,n_voluntaria).min_abs_index_na<feature_mat(n_video,n_voluntaria).max_abs_index_na)
            feature_mat(n_video,n_voluntaria).range_sign_na=feature_mat(n_video,n_voluntaria).range_na;
            cuenta_na=cuenta_na+1;
        else
            feature_mat(n_video,n_voluntaria).range_sign_na=feature_mat(n_video,n_voluntaria).range_na*-1;
        end
        
        if(feature_mat(n_video,n_voluntaria).min_abs_index_a<feature_mat(n_video,n_voluntaria).max_abs_index_a)
            feature_mat(n_video,n_voluntaria).range_sign_a=feature_mat(n_video,n_voluntaria).range_a;
            cuenta_a=cuenta_a+1;
        else
            feature_mat(n_video,n_voluntaria).range_sign_a=feature_mat(n_video,n_voluntaria).range_a*-1;
        end

    end
end



figure

subplot(2,3,1)
boxplot(reshape([feature_mat(:,:).max_diff_da],[3,21])')
subplot(2,3,2)
boxplot(reshape([feature_mat(:,:).max_diff_a],[3,21])')
subplot(2,3,3)
boxplot(reshape([feature_mat(:,:).max_diff_na],[3,21])')

subplot(2,3,4)
boxplot(reshape([feature_mat(:,:).max_diff_index_da],[3,21])')
subplot(2,3,5)
boxplot(reshape([feature_mat(:,:).max_diff_index_a],[3,21])')
subplot(2,3,6)
boxplot(reshape([feature_mat(:,:).max_diff_index_na],[3,21])')



figure

subplot(2,3,1)
boxplot(reshape([feature_mat(:,:).min_diff_da],[3,21])')
subplot(2,3,2)
boxplot(reshape([feature_mat(:,:).min_diff_a],[3,21])')
subplot(2,3,3)
boxplot(reshape([feature_mat(:,:).min_diff_na],[3,21])')

subplot(2,3,4)
boxplot(reshape([feature_mat(:,:).min_diff_index_da],[3,21])')
subplot(2,3,5)
boxplot(reshape([feature_mat(:,:).min_diff_index_a],[3,21])')
subplot(2,3,6)
boxplot(reshape([feature_mat(:,:).min_diff_index_na],[3,21])')


figure

subplot(1,3,1)
boxplot(reshape([feature_mat(:,:).range_da],[3,21])')
subplot(1,3,2)
boxplot(reshape([feature_mat(:,:).range_a],[3,21])')
subplot(1,3,3)
boxplot(reshape([feature_mat(:,:).range_na],[3,21])')



figure

subplot(2,3,1)
boxplot(zscore(reshape([feature_mat(:,:).max_diff_da],[3,21])'))
subplot(2,3,2)
boxplot(zscore(reshape([feature_mat(:,:).max_diff_a],[3,21])'))
subplot(2,3,3)
boxplot(zscore(reshape([feature_mat(:,:).max_diff_na],[3,21])'))

subplot(2,3,4)
boxplot(reshape([feature_mat(:,:).max_diff_index_da],[3,21])')
subplot(2,3,5)
boxplot(reshape([feature_mat(:,:).max_diff_index_a],[3,21])')
subplot(2,3,6)
boxplot(reshape([feature_mat(:,:).max_diff_index_na],[3,21])')

figure

subplot(2,3,1)
boxplot((reshape([feature_mat(:,:).max_diff_da],[3,21])./mean(reshape([feature_mat(:,:).max_diff_da],[3,21])))')
subplot(2,3,2)
boxplot((reshape([feature_mat(:,:).max_diff_a],[3,21])./mean(reshape([feature_mat(:,:).max_diff_a],[3,21])))')
subplot(2,3,3)
boxplot((reshape([feature_mat(:,:).max_diff_na],[3,21])./mean(reshape([feature_mat(:,:).max_diff_na],[3,21])))')



figure

subplot(2,3,1)
boxplot(reshape([feature_mat(:,:).max_relative_diff_da],[3,21])')
subplot(2,3,2)
boxplot(reshape([feature_mat(:,:).max_relative_diff_a],[3,21])')
subplot(2,3,3)
boxplot(reshape([feature_mat(:,:).max_relative_diff_na],[3,21])')

subplot(2,3,4)
boxplot(reshape([feature_mat(:,:).max_relative_diff_index_da],[3,21])')
subplot(2,3,5)
boxplot(reshape([feature_mat(:,:).max_relative_diff_index_a],[3,21])')
subplot(2,3,6)
boxplot(reshape([feature_mat(:,:).max_relative_diff_index_na],[3,21])')

figure

subplot(2,3,1)
boxplot(reshape([feature_mat(:,:).min_relative_diff_da],[3,21])')
subplot(2,3,2)
boxplot(reshape([feature_mat(:,:).min_relative_diff_a],[3,21])')
subplot(2,3,3)
boxplot(reshape([feature_mat(:,:).min_relative_diff_na],[3,21])')

subplot(2,3,4)
boxplot(reshape([feature_mat(:,:).min_relative_diff_index_da],[3,21])')
subplot(2,3,5)
boxplot(reshape([feature_mat(:,:).min_relative_diff_index_a],[3,21])')
subplot(2,3,6)
boxplot(reshape([feature_mat(:,:).min_relative_diff_index_na],[3,21])')

% Plot max abs

figure

subplot(2,3,1)
boxplot(reshape([feature_mat(:,:).max_abs_da],[3,21])')
title('Dopamina')
subplot(2,3,2)
boxplot(reshape([feature_mat(:,:).max_abs_a],[3,21])')
title('Adrenalina')
subplot(2,3,3)
boxplot(reshape([feature_mat(:,:).max_abs_na],[3,21])')
title('Noradrenaline')

subplot(2,3,4)
boxplot(reshape([feature_mat(:,:).max_abs_index_da],[3,21])')
subplot(2,3,5)
boxplot(reshape([feature_mat(:,:).max_abs_index_a],[3,21])')
subplot(2,3,6)
boxplot(reshape([feature_mat(:,:).max_abs_index_na],[3,21])')

sgtitle('Max abs')
% Plot min abs

figure
sgtitle('Min abs')

subplot(2,3,1)
boxplot(reshape([feature_mat(:,:).min_abs_da],[3,21])')
title('Dopamina')

subplot(2,3,2)
boxplot(reshape([feature_mat(:,:).min_abs_a],[3,21])')
title('Adrenalina')

subplot(2,3,3)
boxplot(reshape([feature_mat(:,:).min_abs_na],[3,21])')
title('Noradrenaline')

subplot(2,3,4)
boxplot(reshape([feature_mat(:,:).min_abs_index_da],[3,21])')
subplot(2,3,5)
boxplot(reshape([feature_mat(:,:).min_abs_index_a],[3,21])')
subplot(2,3,6)
boxplot(reshape([feature_mat(:,:).min_abs_index_na],[3,21])')



%plot range sign
figure
sgtitle('range sign')
subplot(1,3,1)
boxplot(reshape([feature_mat(:,:).range_sign_da],[3,21])')
title('Dopamina')
subplot(1,3,2)
boxplot(reshape([feature_mat(:,:).range_sign_a],[3,21])')
title('Adrenalina')
subplot(1,3,3)
boxplot(reshape([feature_mat(:,:).range_sign_na],[3,21])')
title('Noradrenaline')

temp=reshape([feature_mat(:,:).range_sign_da],[3,21])';
cuenta