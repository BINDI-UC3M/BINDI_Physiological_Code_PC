

% Max and min diferences


for n_video=1:3

    for n_voluntaria=1:21
        [feature_mat(n_video,n_voluntaria).max_diff_da,feature_mat(n_video,n_voluntaria).max_diff_index_da]=max(diff(resultados_nt_reordered(n_video+1,n_voluntaria).da));
        [feature_mat(n_video,n_voluntaria).max_diff_a,feature_mat(n_video,n_voluntaria).max_diff_index_a]=max(diff(resultados_nt_reordered(n_video+1,n_voluntaria).a));
        [feature_mat(n_video,n_voluntaria).max_diff_na,feature_mat(n_video,n_voluntaria).max_diff_index_na]=max(diff(resultados_nt_reordered(n_video+1,n_voluntaria).na));
    end
end



figure
subplot(2,3)