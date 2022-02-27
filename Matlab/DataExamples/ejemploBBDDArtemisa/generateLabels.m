



labels_bin=generateBinLabelsSelfReported(labels_reordered);



function labels_out=generateBinLabelsSelfReported(labels_in)
labels_out=0;
    for i=1:length(labels_in)
        for j=2:5
            if strcmp(labels_in{1,i}.emotions(j),'Miedo')
                labels_out(j-1,i)=1;
            else
                labels_out(j-1,i)=0;
            end
        end
    end


end


function labels_out=generateBinLabelsFixed(labels_in)
labels_out=0;
    for i=1:length(labels_in)
        for j=2:5
            if (j==3 || j==5)
                labels_out(j-1,i)=1;
            else
                labels_out(j-1,i)=0;
            end
        end
    end


end