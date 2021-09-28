

for voluntaria=1:length(allraw)

    if isfield(allraw{1,voluntaria},'ecg') && ~isempty(allraw{1,voluntaria}.ecg)
        num_var=6;
    else
        num_var=5;
    end
    ax=0;
    figure
    ax(1)=subplot(num_var,1,1);
    plot(allraw{1,voluntaria}.gsr_uS)
    hold on
    plot(allraw{1,voluntaria}.index,allraw{1,voluntaria}.gsr_uS(allraw{1,voluntaria}.index),'*r')
    
    ax(2)=subplot(num_var,1,2);
    plot(allraw{1,voluntaria}.resp)
     hold on
    plot(allraw{1,voluntaria}.index,allraw{1,voluntaria}.resp(allraw{1,voluntaria}.index),'*r')
    
    
    ax(3)=subplot(num_var,1,3);
    plot(allraw{1,voluntaria}.emg)
     hold on
    plot(allraw{1,voluntaria}.index,allraw{1,voluntaria}.emg(allraw{1,voluntaria}.index),'*r')
    
    
    ax(4)=subplot(num_var,1,4);
    plot(allraw{1,voluntaria}.skt)
     hold on
    plot(allraw{1,voluntaria}.index,allraw{1,voluntaria}.skt(allraw{1,voluntaria}.index),'*r')
    
    
    ax(5)=subplot(num_var,1,5);
    plot(allraw{1,voluntaria}.bvp)
     hold on
    plot(allraw{1,voluntaria}.index,allraw{1,voluntaria}.bvp(allraw{1,voluntaria}.index),'*r')
    
    
    if isfield(allraw{1,voluntaria},'ecg') && ~isempty(allraw{1,voluntaria}.ecg)
        ax(6)=subplot(num_var,1,6)
        plot(allraw{1,voluntaria}.ecg)
         hold on
    plot(allraw{1,voluntaria}.index,allraw{1,voluntaria}.ecg(allraw{1,voluntaria}.index),'*r')
    
    end
    
    linkaxes(ax,'x');
end


% Plot online heart variables
for voluntaria=5: 5  %length(allraw)

    if isfield(allraw{1,voluntaria},'ecg') && ~isempty(allraw{1,voluntaria}.ecg)
        num_var=2;
    else
        num_var=1;
    end
    ax=0;
    figure      
    ax(1)=subplot(num_var,1,1);
    plot(allraw{1,voluntaria}.bvp)
    hold on
    plot(allraw{1,voluntaria}.index,allraw{1,voluntaria}.bvp(allraw{1,voluntaria}.index),'*r')
    
    if isfield(allraw{1,voluntaria},'ecg') && ~isempty(allraw{1,voluntaria}.ecg)
        ax(2)=subplot(num_var,1,2);
        plot(allraw{1,voluntaria}.ecg)
        hold on
        plot(allraw{1,voluntaria}.index,allraw{1,voluntaria}.ecg(allraw{1,voluntaria}.index),'*r')
    end
    
    linkaxes(ax,'x');
end




for voluntaria=1:length(allraw)

    figure
%     ax(1)=subplot(num_var,1,1);
    plot(allraw{1,voluntaria}.gsr_uS_filtered)
    hold on
    plot(allraw{1,voluntaria}.index,allraw{1,voluntaria}.gsr_uS(allraw{1,voluntaria}.index),'*r')
    
end

for voluntaria=1:length(allraw)

    figure
%     ax(1)=subplot(num_var,1,1);
    temp_time=0:1/200:(length(allraw{1,1}.gsr_uS_filtered)-1)/200;
    plot(temp_time,allraw{1,1}.gsr_uS_filtered)
    hold on
    plot(temp_time(allraw{1,1}.index),allraw{1,1}.gsr_uS(allraw{1,1}.index),'*r')
    
end



for voluntaria=1:length(allraw)
    figure
%  ax(2)=subplot(num_var,1,2);
    plot(allraw{1,voluntaria}.resp)
     hold on
    plot(allraw{1,voluntaria}.index,allraw{1,voluntaria}.resp(allraw{1,voluntaria}.index),'*r')

end
