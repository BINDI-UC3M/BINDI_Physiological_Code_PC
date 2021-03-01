%s --> matriz
% pa --> start volunteer
% pb --> stop volunteer
% va --> start stimulus
% va --> stop stimulus
function plot_dataBBDDLab_Features(s,pa,pb,va,vb)

    for i=pa:pb
        
    bvp_hrv=[];
    bvp_ibi=[];
    bvp_lf=[];

    %BVP
    f = figure('units','normalized','outerposition',[0 0 1 1]);
    f.Name = "Volunteer " + num2str(i) +  " Complete Experiment";
    thrv=0;
    tibi=0;
    
    for j=va:vb

        bvp_hrv = s.features{i, j}.EH.Video.BVP_feats(:,12);
        bvp_ibi = s.features{i, j}.EH.Video.BVP_feats(:,4);
        
        x_hrv = thrv:(thrv+length(bvp_hrv)-1);
        subplot(2,1,1)
        plot(x_hrv,bvp_hrv*1000)
        hold on
        ylabel('ms') 
        title(['HRV(RMSSD) Volunteer ' num2str(i) ' Complete Experiment'])
        %legend({'Neutro','Video','Labels'})
        
        x_ibi = tibi:(tibi+length(bvp_ibi)-1);
        subplot(2,1,2)
        plot(x_ibi,bvp_ibi)
        hold on
        ylabel('seconds') 
        title(['IBI Volunteer ' num2str(i) ' Complete Experiment'])
        
        thrv = thrv + length(bvp_hrv);
        tibi = tibi + length(bvp_ibi);

    end

    gsr_mean=[];
    gsr_peaks=[];
    
    %GSR
    f = figure('units','normalized','outerposition',[0 0 1 1]);
    f.Name = "Volunteer " + num2str(i) +  " Complete Experiment";
    thrv=0;
    tibi=0;
    
    for j=va:vb

        gsr_mean = s.features{i, j}.EH.Video.GSR_feats(:,6);
        gsr_peaks = s.features{i, j}.EH.Video.GSR_feats(:,1);
        
        x_hrv = thrv:(thrv+length(gsr_mean)-1);
        subplot(2,1,1)
        plot(x_hrv,gsr_mean)
        hold on
        ylabel('uSiemens') 
        title(['GSR Mean Volunteer ' num2str(i) ' Complete Experiment'])
        %legend({'Neutro','Video','Labels'})
        
        x_ibi = tibi:(tibi+length(gsr_peaks)-1);
        subplot(2,1,2)
        plot(x_ibi,gsr_peaks*20)
        hold on
        ylabel('peaks') 
        title(['GSR Peaks Volunteer ' num2str(i) ' Complete Experiment'])
        
        thrv = thrv + length(gsr_mean);
        tibi = tibi + length(gsr_peaks);

    end

    end
    

    
end