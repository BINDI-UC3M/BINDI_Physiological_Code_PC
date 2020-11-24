%% BANDAS DE FRECUENCIA
%

function [LF_signal, HF_signal, UHF_signal] = bandas_frec(fft_HRV, vector_frecuencia)
%
% Ahora ya podemos trabajar con de la gráfica directamente
% ULF: 0,01 Hz - 0,04 Hz --> omitimos la banda de ULF por su resolución en
% ventanado de 8 segundos
% LF: 0,04 Hz - 0,15 Hz
% HF: 0,15 Hz - 0,4 Hz
% UHF: 0,4 Hz - 1,0 Hz
%
% Para sacar ULFinicio y ULFfin utilizamos la relación de la siguiente
% formula: intervalo(fft) = frecuencia_buscada*n_tot_interv/frec_señal
%

%ULFinicio = round(0.01*length(signal_wrist_BVP)/64);
%ULFfin = round(0.04*length(signal_wrist_BVP)/64);
%ULF_signal = fft_BVP(ULFinicio:ULFfin);
%ULF_tiempos = ULFinicio:ULFfin;
%ULF_frec = ULF_tiempos*64/n_total_intervalos_frec;

aux1 = 1;
aux2 = 1;
aux3 = 1;

for n = 1:length(fft_HRV)
    %
    % LF
    %
   if vector_frecuencia(n) >= 0.01 && vector_frecuencia(n) <= 0.15 
       LF_signal(aux1) = fft_HRV(n);
       aux1 = aux1 + 1;
   end
   %
   % HF
   %
   if vector_frecuencia(n) > 0.15 && vector_frecuencia(n) <= 0.4
       HF_signal(aux2) = fft_HRV(n);
       aux2 = aux2 + 1;
   end
   %
   % UHF
   %
   if vector_frecuencia(n) > 0.4 && vector_frecuencia(n) <= 1 
       UHF_signal(aux3) = fft_HRV(n);
       aux3 = aux3 + 1;
   end
   
end

if aux1 == 1
    LF_signal(aux1) = 0;
end

if aux2 == 1
    HF_signal(aux2) = 0;
end

if aux3 == 1
    UHF_signal(aux3) = 0;
end

end