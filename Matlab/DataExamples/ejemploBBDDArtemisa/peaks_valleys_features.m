



for n_video=1:3    

    for n_voluntaria=1:21
        
        
        feature_mat_da(n_video,n_voluntaria)=peaks_valeys_features(resultados_nt_reordered(n_video+1,n_voluntaria).da);
        
        feature_mat_a(n_video,n_voluntaria)=peaks_valeys_features(resultados_nt_reordered(n_video+1,n_voluntaria).a);  
        
        feature_mat_na(n_video,n_voluntaria)=peaks_valeys_features(resultados_nt_reordered(n_video+1,n_voluntaria).na);  
       
        
    end
end
    
    
function feature_mat = peaks_valeys_features(nt_data)

        [pks,pks_locs,vall,vall_locs] = extract_peaks_valleys(nt_data',mean(nt_data)*0.1);
        
        feature_mat.all_peaks=pks;
        feature_mat.all_peaks_pos=pks_locs;
        
        feature_mat.all_valleys=vall;
        feature_mat.all_valleys_pos=vall_locs;
        
        
%         temp_locs=diff(feature_mat(n_video,n_voluntaria).peaks_pos_da)
        if length(feature_mat.all_peaks)>2
            feature_mat.peaks=feature_mat.all_peaks(1:2);
            feature_mat.peaks_pos=feature_mat.all_peaks_pos(1:2);
        else
            feature_mat.peaks=feature_mat.all_peaks;
            feature_mat.peaks_pos=feature_mat.all_peaks_pos;
        end
        
        if length(feature_mat.all_valleys)>2
            feature_mat.valleys=feature_mat.all_valleys(1:2);
            feature_mat.valleys_pos=feature_mat.all_valleys_pos(1:2);
        else
            feature_mat.valleys=feature_mat.all_valleys;
            feature_mat.valleys_pos=feature_mat.all_valleys_pos;
        end
        
        
        temp_sig=horzcat(feature_mat.peaks,feature_mat.valleys);
        temp_sig_pos=horzcat(feature_mat.peaks_pos,feature_mat.valleys_pos);
        [~,index]=sort(temp_sig_pos);
        temp_sig=temp_sig(index);
        
        [pks,pks_locs,vall,vall_locs] = extract_peaks_valleys(temp_sig,0);
        
        feature_mat.peaks_pos=feature_mat.peaks_pos(feature_mat.peaks==pks);
        feature_mat.peaks=pks;
        
        feature_mat.valleys_pos=feature_mat.valleys_pos(feature_mat.valleys==vall);
        feature_mat.valleys=vall;
        
        temp_sig=horzcat(feature_mat.peaks,feature_mat.valleys);
        temp_sig_pos=horzcat(feature_mat.peaks_pos,feature_mat.valleys_pos);
        [temp_pos,index]=sort(temp_sig_pos);
        temp_sig=temp_sig(index);
        
        
        
        
        feature_mat.num_peaks=length(feature_mat.peaks);
        feature_mat.num_valleys=length(feature_mat.valleys);
        feature_mat.deltas=diff(temp_sig);
        feature_mat.slope=feature_mat.deltas./diff(temp_pos);
        feature_mat.first_peak_pos=feature_mat.peaks_pos(1);
        feature_mat.first_valley_pos=feature_mat.valleys_pos(1);
        
        temp_order_peak=ones(1,feature_mat.num_peaks);
        temp_order_val=zeros(1,feature_mat.num_valleys);
        temp_order=horzcat(temp_order_peak,temp_order_val);
        feature_mat.order=temp_order(index);
        
        if feature_mat.num_valleys==0 && feature_mat.num_peaks==0
            feature_mat.type=0;
        elseif feature_mat.num_valleys==1 && feature_mat.num_peaks==1
            feature_mat.type=1;
        elseif feature_mat.num_valleys==2 && feature_mat.num_peaks==1
            feature_mat.type=2;
        elseif feature_mat.num_valleys==1 && feature_mat.num_peaks==2
            feature_mat.type=3;
        elseif feature_mat.num_valleys==2 && feature_mat.num_peaks==2
            if feature_mat.order(1)==1
                feature_mat.type=4;
            else
                feature_mat.type=5;
            end
        end
        
        

end



function [peaks,peaks_locs,valleys,valleys_locs] = extract_peaks_valleys(in_data,min_promenance)
        
%         l_data=legnth(in_data);
        % Peaks
        mean_data=mean(in_data);
        data=horzcat(mean_data,in_data,mean_data);
%         data(2:l_data+1)=in_data;
% 'MinPeakProminence',1
        [peaks,peaks_locs] = findpeaks(data,'MinPeakProminence',min_promenance,'SortStr','descend');
        
        peaks_locs=peaks_locs-1;
        figure
        findpeaks(data,'Annotate','extents')
        hold on
        
        temp_1=-1*(in_data-mean(in_data))+mean(in_data);  
        data=horzcat(mean_data,temp_1,mean_data);              
        [valleys,valleys_locs] = findpeaks(data,'MinPeakProminence',min_promenance,'SortStr','descend');
        valleys_locs=valleys_locs-1;
        valleys=in_data(valleys_locs);
        findpeaks(data,'Annotate','extents')


end