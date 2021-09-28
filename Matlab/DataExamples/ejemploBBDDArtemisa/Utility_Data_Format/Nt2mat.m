

function out_mat=Nt2mat(in_s)
    for voluntarias =1:21
        out_mat(:,(voluntarias-1)*4+1)=vertcat(in_s(:,voluntarias).a);
        out_mat(:,(voluntarias-1)*4+2)=vertcat(in_s(:,voluntarias).da);
        out_mat(:,(voluntarias-1)*4+3)=vertcat(in_s(:,voluntarias).na);
        out_mat(:,(voluntarias-1)*4+4)=vertcat(in_s(:,voluntarias).hemolizado);
    end
end