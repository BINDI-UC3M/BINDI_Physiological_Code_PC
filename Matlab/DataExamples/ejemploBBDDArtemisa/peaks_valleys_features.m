



for n_video=1:3    

    for n_voluntaria=1:21
        
        
        feature_mat_da(n_video,n_voluntaria)=peaks_valeys_features(resultados_nt_reordered(n_video+1,n_voluntaria).da,"Dopamina_"+n_voluntaria+"_"+n_video);
        
        feature_mat_a(n_video,n_voluntaria)=peaks_valeys_features(resultados_nt_reordered(n_video+1,n_voluntaria).a,"Adrenalina_"+n_voluntaria+"_"+n_video);  
        
        feature_mat_na(n_video,n_voluntaria)=peaks_valeys_features(resultados_nt_reordered(n_video+1,n_voluntaria).na,"Noradrenalina_"+n_voluntaria+"_"+n_video);  
       
        
    end
end
    
    
function feature_mat = peaks_valeys_features(nt_data,name_fig)
        
        umbral=mean(nt_data)*0.15;
        if umbral <100 && umbral >3
            umbral= 2.5;
        end
        [pks,pks_locs,vall,vall_locs] = extract_peaks_valleys(nt_data',umbral,name_fig);
        
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
        
        
        umbral=mean(temp_sig)*0.10;
        if umbral <100 && umbral >3
            umbral= 2.5;
        end
        [pks,pks_locs,vall,vall_locs] = extract_peaks_valleys(temp_sig,0.1*mean(umbral),"segunda it");
        
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
            if feature_mat.order(1)==1
              feature_mat.type=1;
            else
                
            end
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



function [peaks,peaks_locs,valleys,valleys_locs] = extract_peaks_valleys(in_data,min_promenance,name)
        
        
% %         Peaks
%         mean_data=mean(in_data);
%         data=horzcat(mean_data,in_data,mean_data);
% %         data(2:l_data+1)=in_data;
% % 'MinPeakProminence',1,'Threshold',mean_threshold
%         [peaks,peaks_locs] = findpeaks(data,'MinPeakProminence',min_promenance,'SortStr','descend');
%         
%         peaks_locs=peaks_locs-1;
%         figure
%         findpeaks(data,'MinPeakProminence',min_promenance,'Annotate','extents')
%         hold on
%         title(name);
%         
%         temp_1=-1*(in_data-mean(in_data))+mean(in_data);  
%         data=horzcat(mean_data,temp_1,mean_data);              
%         [valleys,valleys_locs] = findpeaks(data,'MinPeakProminence',min_promenance,'SortStr','descend');
%         valleys_locs=valleys_locs-1;
%         valleys=in_data(valleys_locs);
%         findpeaks(data,'MinPeakProminence',min_promenance,'Annotate','extents')
        

%          mean_data=mean(in_data);
        data=horzcat(min(in_data),in_data,min(in_data));
%         data(2:l_data+1)=in_data;
% 'MinPeakProminence',1,'Threshold',mean_threshold
        [peaks,peaks_locs] = findpeaks(data,'MinPeakProminence',min_promenance,'SortStr','descend');
        
        peaks_locs=peaks_locs-1;
%         figure
%         findpeaks(data,'MinPeakProminence',min_promenance,'Annotate','extents')
%         hold on
%         title(name);
        
        temp_1=-1*(in_data-mean(in_data))+mean(in_data);  
        data=horzcat(min(temp_1),temp_1,min(temp_1));              
        [valleys,valleys_locs] = findpeaks(data,'MinPeakProminence',min_promenance,'SortStr','descend');
        valleys_locs=valleys_locs-1;
        valleys=in_data(valleys_locs);
%         findpeaks(data,'MinPeakProminence',min_promenance,'Annotate','extents')


end