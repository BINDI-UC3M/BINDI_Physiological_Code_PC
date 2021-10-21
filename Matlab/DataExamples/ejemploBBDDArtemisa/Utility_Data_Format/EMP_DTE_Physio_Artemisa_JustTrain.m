function Results_BioSpeech = EMP_DTE_Physio_Artemisa_JustTrain(info)


dbstop if error
% Input: data_in --> (info.data_in)this is an array of tables
  %        each table corresponds to BVP and GSR extracted features
  %        In case of having a need to normalize there would be two fields,
  %        data_in.Baseline and data_in.Experiment, the first can be taken
  %        for performing the normalization procedure
  %        response_in --> (info.response_in)labels for training and testing.
  %        info --> configuration parameters
  
  %Get Data and Labels
%   data_in     = info.features;
%   response_in = info.response_in;
  
  %Get the number of volunteers and trials
  %Max Volunteers are 47 and max trial are 14

  %check values
%   if volunteers > 47 || trials > 14
%     error('Number of volunteers or trials exceed the maximun allowed');
%   end
     
  %% Stage 3: Assign labels
%   peri   = {};
%   labels = {}; 
%   if ~isempty(response_in)
    %Get the volunteers number ID
%     volunts = unique(response_in.Voluntaria,'rows');
%     volunts = sort(volunts);
exclude_vec=[12];
index=1;
for k=1:21
    if (~ (sum(k==exclude_vec)>0))  
        
      data_in{index,:}=info.features{k,:};
            
      index=index+1;
    end
    
    
end


  [volunteers, trials] = size(data_in);

volunteers=index-1;


    for i=1:volunteers
      k = 1;
      win_num=length(data_in{i,k}.EH.Video.HR_feats(:,1));
      temp = [(data_in{i,k}.EH.Video.HR_feats(:,2:23)) ...
                       (data_in{i,k}.EH.Video.GSR_feats(:,:))...
                       (data_in{i,k}.EH.Video.SKT_feats(:,:))...
                       (data_in{i,k}.EH.Video.RESP_feats(:,:))];
      peri_loto{i,k} = temp;
      peri{:,:,i}    = temp;
%       [win, ~] = size(peri{:,:,i});
%       t = 1:1:win;
      %t(:) = response_in.PAD(response_in.Voluntaria==volunts(i) & response_in.Video==1);
%       t(:) = response_in.EmocionReportada(response_in.Voluntaria==volunts(i) & response_in.Video==1);     
      
      t(1:length(data_in{i,k}.EH.Video.HR_feats(1,:)))=0;
      labels_loto{i,k} = t(:);
      labels{:,:,i} = t(:); 
      win_num=length(data_in{i,k}.EH.Video.HR_feats(:,1));
      for k=2:trials
        temp = [(data_in{i,k}.EH.Video.HR_feats(1:win_num,2:23)) ...
                         (data_in{i,k}.EH.Video.GSR_feats(1:win_num,:))...
                         (data_in{i,k}.EH.Video.SKT_feats(1:win_num,:))...
                         (data_in{i,k}.EH.Video.RESP_feats(1:win_num,:))];
        peri_loto{i,k} = temp;
        peri{:,:,i}   =[ peri{:,:,i}; temp];
%         [win, ~] = size(temp);
%         t = 1:1:win;
        %t(:) = response_in.PAD(response_in.Voluntaria==volunts(i) & response_in.Video==k);
%         t(:) = response_in.EmocionReportada(response_in.Voluntaria==volunts(i) & response_in.Video==k);
        if k==3
            t(1:length(data_in{i,k}.EH.Video.HR_feats(1,:)))=0;
        else
            t(1:length(data_in{i,k}.EH.Video.HR_feats(1,:)))=1;
        end
        labels_loto{i,k} = t(:);
        labels{:,:,i} = [labels{:,:,i}; t(:)]; 
      end
    end
%   end
  
  %% Stage 3.1: Option to normalize data with baseline:
%   % This step is optional and should be subjected to application neeeds
%   normalizeBybaseline = info.normalizeBybaseline;  
%   if normalizeBybaseline
%     %%TBD
%   end
end