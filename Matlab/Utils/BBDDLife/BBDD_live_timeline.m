function result= BBDD_live_timeline(in_data,in_labels)


 [field_pulsera,field_colgante]=getDevicesFields(in_data);
 %% Bracelet
 dif_count=diff(in_data.(field_pulsera).COUNT.count);
 fallos_index=find((dif_count>-255&dif_count<1)|(dif_count>1))+1;

on_time=zeros();
n=2;
on_time(1)=1;
timestamp(1)=in_data.(field_pulsera).COUNT.timestamp(1);
result.total_on=0;
for loop2=1:length(fallos_index)
    
    on_time(n)=1;
    on_time(n+1)=0;
    on_time(n+2)=0;
    on_time(n+3)=1;

    timestamp(n)=in_data.(field_pulsera).COUNT.timestamp(fallos_index(loop2)-1);
    timestamp(n+1)=in_data.(field_pulsera).COUNT.timestamp(fallos_index(loop2)-1);
    timestamp(n+2)=in_data.(field_pulsera).COUNT.timestamp(fallos_index(loop2));
    timestamp(n+3)=in_data.(field_pulsera).COUNT.timestamp(fallos_index(loop2));
    
    if(loop2>2)
        result.total_on=result.total_on+timestamp(n)-timestamp(n-1);
    end
    
    n=n+4;
end

result.total_time=timestamp(end)-timestamp(1);
result.total_on_percent=result.total_on/result.total_time*100;
result.on_time=on_time;
result.timestamp=timestamp;

%% Pendant



%% Plots

figure
area(timestamp,on_time,'EdgeColor',	[0 0.4470 0.7410])


  [num_labels,~]=size(in_labels);

 hold on
 n_emotion=0;
 for loop=1:num_labels
     if(in_labels.mode(loop)=="NaN" && in_labels.emotion(loop)~="NaN")
        temp_date= datenum(in_labels.happened_time(loop,:),'dd-mmm-yyyy HH:MM:SS');
        temp_date=datetime(temp_date,'TimeZone','Europe/Madrid','ConvertFrom','datenum'); 
        
        xline(temp_date,'--r','LineWidth',1);
%         xline(temp_date,'--r',in_labels.emotion(loop,:),'LineWidth',1);
      n_emotion=n_emotion+1;
     end
 end
 result.n_emot_labels=n_emotion;
 end