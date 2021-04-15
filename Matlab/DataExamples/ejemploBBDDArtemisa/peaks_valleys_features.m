



for n_video=1:3    

    for n_voluntaria=1:21
        
        [peaks,locks]=findpeaks(resultados_nt_reordered(n_video+1,n_voluntaria).da)
           % Peaks
        data=zeros(1,7);
        data(2:6)=resultados_nt_reordered(n_video+1,n_voluntaria).da
        [pks,locs] = findpeaks(data,'MinPeakProminence',1,'SortStr','descend')
        feature_mat(n_video,n_voluntaria).peaks_da=pks;
        feature_mat(n_video,n_voluntaria).peaks_pos_da=locs-1;
        figure
        findpeaks(data,'MinPeakProminence',1,'Annotate','extents')
        hold on
        data=zeros(1,7);
        data(2:6)=-1*resultados_nt_reordered(n_video+1,n_voluntaria).da;%+abs(max(resultados_nt_reordered(n_video+1,n_voluntaria).da));
        data([1 7])= min(data(2:6))-5;
        findpeaks(data,'MinPeakProminence',1,'Annotate','extents')
        [val,locs] = findpeaks(data,'MinPeakProminence',1,'SortStr','descend')
        feature_mat(n_video,n_voluntaria).valleys_da=data(locs);
        feature_mat(n_video,n_voluntaria).valleys_pos_da=locs-1;
        
    end
end
