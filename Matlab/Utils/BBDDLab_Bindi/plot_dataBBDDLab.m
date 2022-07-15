%s --> matriz
% pa --> start volunteer
% pb --> stop volunteer
% va --> start stimulus
% va --> stop stimulus
% To save the graph/plot in pdf format execute the following code in the 
% command shell:
% figHandles = findall(0,'Type','figure');
% export_fig(figHandles(1).Name,'-pdf', figHandles(1))
% for i = 2:numel(figHandles)
% export_fig( figHandles(i).Name,'-pdf', figHandles(i),'-append')
% end
function s_out = plot_dataBBDDLab(s_in,pa,pb,va,vb)

    s = s_in;
    correlation_vector = [];

    for i=pa:pb
        
    bvp=[];
    bvp_neutro=[];
    bvp_video=[];
    bvp_labels=[];
    bvp_recov=[];
    gsr0 = [];
    gsr0_neutro=[];
    gsr0_video=[];
    gsr0_labels=[];
    gsr0_recov=[];
    gsr=[];
    gsr_neutro=[];
    gsr_video=[];
    gsr_labels=[];
    gsr_recov=[];
    skt=[];
    skt_neutro=[];
    skt_video=[];
    skt_labels=[];
    skt_recov=[];
    
    %f = figure('units','normalized','outerposition',[0 0 1 1]);
    %f.Name = "Volunteer " + s{i,1}.ParticipantNum +  " Complete Experiment";
    tb=0;
    tg=0;
    tg0=0;
    ts=0;
%     
    for j=va:vb

%         bvp_neutro = s{i, j}.EH.Neutro.raw.bvp_filt;
%         bvp_video  = s{i, j}.EH.Video.raw.bvp_filt;
%         bvp_labels = s{i, j}.EH.Labels.raw.bvp_filt;
%         bvp_recov = s{i, j}.EH.Recovery.raw.bvp_filt;
%         bvp = [bvp; bvp_neutro; bvp_video; bvp_labels; bvp_recov];

        gsr_neutro = s{i, j}.EH.Neutro.raw.gsr_uS_filtered_sm;
        gsr_video  = s{i, j}.EH.Video.raw.gsr_uS_filtered_sm;
        gsr_labels = s{i, j}.EH.Labels.raw.gsr_uS_filtered_sm;
        gsr_recov = s{i, j}.EH.Recovery.raw.gsr_uS_filtered_sm;
        gsr = [gsr; gsr_neutro; gsr_video; gsr_labels; gsr_recov];

        gsr0_neutro = s{i, j}.GSR.Neutro.raw.gsr_uS_filtered_sm;
        gsr0_video  = s{i, j}.GSR.Video.raw.gsr_uS_filtered_sm;
        gsr0_labels = s{i, j}.GSR.Labels.raw.gsr_uS_filtered_sm;
        gsr0_recov  = s{i, j}.GSR.Recovery.raw.gsr_uS_filtered_sm;
        gsr0 = [gsr0; gsr0_neutro; gsr0_video; gsr0_labels; gsr0_recov];

%         skt_neutro = s{i, j}.EH.Neutro.raw.skt_filt_dn_sm;
%         skt_video  = s{i, j}.EH.Video.raw.skt_filt_dn_sm;
%         skt_labels = s{i, j}.EH.Labels.raw.skt_filt_dn_sm;
%         skt_recov = s{i, j}.EH.Recovery.raw.skt_filt_dn_sm;
%         skt = [skt; skt_neutro; skt_video; skt_labels; skt_recov];
        
        %fix lenght missmatch
%         if length(gsr0_neutro)>length(gsr_neutro)
%             dif = length(gsr0_neutro) - length(gsr_neutro);
%             gsr0_neutro((end-dif+1):end)= [];
%             s{i, j}.GSR.Neutro.raw.gsr_uS_filtered_sm = gsr0_neutro;
%         else
%             dif = length(gsr_neutro) - length(gsr0_neutro);
%             gsr_neutro((end-dif+1):end)= [];
%             s{i, j}.EH.Neutro.raw.gsr_uS_filtered_sm = gsr_neutro;
%             bvp_neutro((end-dif+1):end)= [];
%             s{i, j}.EH.Neutro.raw.bvp_filt = bvp_neutro;
%             if dif>=20 
%                 dif=round(dif/20); 
%                 skt_neutro((end-dif+1):end)= [];
%                 s{i, j}.EH.Neutro.raw.skt_filt_dn_sm = skt_neutro;
%             end
%         end
%         if length(gsr0_video)>length(gsr_video)
%             dif = length(gsr0_video) - length(gsr_video);
%             gsr0_video((end-dif+1):end)= [];
%             s{i, j}.GSR.Video.raw.gsr_uS_filtered_sm = gsr0_video;
%         else
%             dif = length(gsr_video) - length(gsr0_video);
%             gsr_video((end-dif+1):end)= [];
%             s{i, j}.EH.Video.raw.gsr_uS_filtered_sm = gsr_video;      
%             bvp_video((end-dif+1):end)= [];
%             s{i, j}.EH.Video.raw.bvp_filt = bvp_video;
%             if dif>=20 
%                 dif=round(dif/20); 
%                 skt_video((end-dif+1):end)= [];
%                 s{i, j}.EH.Video.raw.skt_filt_dn_sm = skt_video;    
%             end
%         end
%         if length(gsr0_labels)>length(gsr_labels)
%             dif = length(gsr0_labels) - length(gsr_labels);
%             gsr0_labels((end-dif+1):end)= [];
%             s{i, j}.GSR.Labels.raw.gsr_uS_filtered_sm = gsr0_labels;
%         else
%             dif = length(gsr_labels) - length(gsr0_labels);
%             gsr_labels((end-dif+1):end)= [];
%             s{i, j}.EH.Labels.raw.gsr_uS_filtered_sm = gsr_labels;  
%             bvp_labels((end-dif+1):end)= [];
%             s{i, j}.EH.Labels.raw.bvp_filt = bvp_labels;
%             if dif>=20 
%                 dif=round(dif/20); 
%                 skt_labels((end-dif+1):end)= [];
%                 s{i, j}.EH.Labels.raw.skt_filt_dn_sm = skt_labels;
%             end
%         end
%         if length(gsr0_recov)>length(gsr_recov)
%             dif = length(gsr0_recov) - length(gsr_recov);
%             gsr0_recov((end-dif+1):end)= [];
%             s{i, j}.GSR.Recovery.raw.gsr_uS_filtered_sm = gsr0_recov;
%         else
%             dif = length(gsr_recov) - length(gsr0_recov);
%             gsr_recov((end-dif+1):end)= [];
%             s{i, j}.EH.Recovery.raw.gsr_uS_filtered_sm = gsr_recov;  
%             bvp_recov((end-dif+1):end)= [];
%             s{i, j}.EH.Recovery.raw.bvp_filt = bvp_recov;
%             if dif>=20 
%                 dif=round(dif/20); 
%                 skt_recov((end-dif+1):end)= [];
%                 s{i, j}.EH.Recovery.raw.skt_filt_dn_sm = skt_recov; 
%             end
%         end

%PER TRIAL
%         f = figure('units','normalized','outerposition',[0 0 1 1]);
%         f.Name = "Volunteer " + s{i,j}.ParticipantNum +  " Stimulus" + j;
%         
%         subplot(3,1,1)
%         t = 0:1/200:(length(bvp_neutro)/200 - 1/200);
%         plot(t, bvp_neutro,'b')
%         hold on
%         t = (t(end)+1/200):1/200:(t(end)+length(bvp_video)/200);
%         plot(t, bvp_video,'k')    
%         t = (t(end)+1/200):1/200:(t(end)+length(bvp_labels)/200);
%         plot(t, bvp_labels,'r')  
%         ylabel('A.U.') 
%         title(['Volunteer ' s{i,j}.ParticipantNum ' Stimulus' num2str(j)])
%         legend({'Neutro','Video','Labels'})
%         
%         subplot(3,1,2)
%         t = 0:1/10:(length(gsr_neutro)/10 - 1/10);
%         plot(t, gsr_neutro,'b')
%         hold on
%         t = (t(end)+1/10):1/10:(t(end)+length(gsr_video)/10);
%         plot(t, gsr_video,'k')
%         t = (t(end)+1/10):1/10:(t(end)+length(gsr_labels)/10);
%         plot(t, gsr_labels,'r')
%         ylabel('uSiemens') 
%         title(['Volunteer ' s{i,j}.ParticipantNum ' Stimulus' num2str(j)])
%         legend({'Neutro','Video','Labels'})
%         
%         subplot(3,1,3)
%         t = 0:1/10:(length(skt_neutro)/10 - 1/10);
%         plot(t, skt_neutro,'b')
%         hold on
%         t = (t(end)+1/10):1/10:(t(end)+length(skt_video)/10);
%         plot(t, skt_video,'k')
%         t = (t(end)+1/10):1/10:(t(end)+length(skt_labels)/10);
%         plot(t, skt_labels,'r')
%         ylabel('ºC') 
%         title(['Volunteer ' s{i,j}.ParticipantNum ' Stimulus' num2str(j)])
%         legend({'Neutro','Video','Labels'})
        
        
%ALL
%         subplot(3,1,1)
%         tb = tb(end):1/200:(tb(end)+length(bvp_neutro)/200 - 1/200);
%         plot(tb, bvp_neutro,'b')
%         hold on
%         tb = (tb(end)+1/200):1/200:(tb(end)+length(bvp_video)/200);
%         plot(tb, bvp_video,'k')    
%         tb = (tb(end)+1/200):1/200:(tb(end)+length(bvp_labels)/200);
%         plot(tb, bvp_labels,'r')  
%         tb = (tb(end)+1/200):1/200:(tb(end)+length(bvp_recov)/200);
%         plot(tb, bvp_recov,'g')  
%         ylabel('A.U.') 
%         title(['Volunteer ' s{i,j}.ParticipantNum ' Total Stimuli:' num2str(j)])
%         legend({'Neutro','Video','Labels','Recovery'})
        
%         subplot(3,1,2)
%         tg = tg(end):1/10:(tg(end)+length(gsr_neutro)/10 - 1/10);
%         plot(tg, gsr_neutro,'b')
%         hold on
%         tg = (tg(end)+1/10):1/10:(tg(end)+length(gsr_video)/10);
%         plot(tg, gsr_video,'k')
%         tg = (tg(end)+1/10):1/10:(tg(end)+length(gsr_labels)/10);
%         plot(tg, gsr_labels,'r')
%         tg = (tg(end)+1/10):1/10:(tg(end)+length(gsr_recov)/10);
%         plot(tg, gsr_recov,'g')  
%         ylabel('uSiemens') 
%         title(['Volunteer ' s{i,j}.ParticipantNum ' Total Stimuli:' num2str(j)])
%         legend({'Neutro','Video','Labels','Recovery'})

        %subplot(3,1,2)
%         tg = tg(end):1/200:(tg(end)+length(gsr_neutro)/200 - 1/200);
%         tg0 = tg0(end):1/200:(tg0(end)+length(gsr0_neutro)/200 - 1/200);
%         plot(tg, gsr_neutro,'b')
%         hold on
%         plot(tg0, gsr0_neutro,'-.b')
%         tg = (tg(end)+1/200):1/200:(tg(end)+length(gsr_video)/200);
%         tg0 = (tg0(end)+1/200):1/200:(tg0(end)+length(gsr0_video)/200);
%         plot(tg, gsr_video,'k')
%         plot(tg0, gsr0_video,'-.k')
%         tg = (tg(end)+1/200):1/200:(tg(end)+length(gsr_labels)/200);
%         tg0 = (tg0(end)+1/200):1/200:(tg0(end)+length(gsr0_labels)/200);
%         plot(tg, gsr_labels,'r')
%         plot(tg0, gsr0_labels,'-.r')
%         tg = (tg(end)+1/200):1/200:(tg(end)+length(gsr_recov)/200);
%         tg0 = (tg0(end)+1/200):1/200:(tg0(end)+length(gsr0_recov)/200);
%         plot(tg, gsr_recov,'g') 
%         plot(tg0, gsr0_recov,'-.g') 
%         ylabel('uSiemens') 
%         title(['Volunteer ' s{i,j}.ParticipantNum ' Total Stimuli:' num2str(j)])
%         legend({'Neutro','Video','Labels','Recovery'})
%         
%         subplot(3,1,3)
%         ts = ts(end):1/10:(ts(end)+length(skt_neutro)/10 - 1/10);
%         plot(ts, skt_neutro,'b')
%         hold on
%         ts = (ts(end)+1/10):1/10:(ts(end)+length(skt_video)/10);
%         plot(ts, skt_video,'k')
%         ts = (ts(end)+1/10):1/10:(ts(end)+length(skt_labels)/10);
%         plot(ts, skt_labels,'r')
%         ts = (ts(end)+1/10):1/10:(ts(end)+length(skt_recov)/10);
%         plot(ts, skt_recov,'g')  
%         ylabel('ºC') 
%         title(['Volunteer ' s{i,j}.ParticipantNum ' Total Stimuli:' num2str(j)])
%         legend({'Neutro','Video','Labels','Recovery'})
        
%         bvp=[];
%         bvp_neutro=[];
%         bvp_video=[];
%         bvp_labels=[];
%         gsr0 = [];
%         gsr0_neutro=[];
%         gsr0_video=[];
%         gsr0_labels=[];
%         gsr=[];
%         gsr_neutro=[];
%         gsr_video=[];
%         gsr_labels=[];
%         skt=[];
%         skt_neutro=[];
%         skt_video=[];
%         skt_labels=[];

    end
    
    a = zscore(gsr);
    b = zscore(gsr0);
    len = min([length(a) length(b)]);
    [r,~] = corr(a(1:len),b(1:len),'Type','Pearson');
    correlation_vector(i,1) = r; 

    end
    
    s_out = s;
    
end