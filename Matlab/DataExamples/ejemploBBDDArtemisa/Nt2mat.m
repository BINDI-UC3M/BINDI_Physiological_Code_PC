


for voluntarias =1:21
    mat(:,(voluntarias-1)*4+1)=vertcat(resultados_nt_reordered(:,voluntarias).a);
    mat(:,(voluntarias-1)*4+2)=vertcat(resultados_nt_reordered(:,voluntarias).da);
    mat(:,(voluntarias-1)*4+3)=vertcat(resultados_nt_reordered(:,voluntarias).na);
    mat(:,(voluntarias-1)*4+4)=vertcat(resultados_nt_reordered(:,voluntarias).hemolizado);
end