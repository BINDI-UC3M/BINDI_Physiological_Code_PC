function [HR_final_temp, HR_final_1, HR_final_2, HR_final_3] = get_HeartRate(s_input, f_s, HR)

  [picos, valles] = Sacar_picos(s_input);
  [picos_1, valles_1] = Filtro_picos_1(picos, valles);
  [picos_2, valles_2] = Filtro_picos_2(s_input, f_s);
  [picos_3, valles_3] = Filtro_picos_3(picos, valles, s_input, f_s);
  %% --------------------------------------------------------------------------
  
  %% --------------------------------------------------------------------------
  if(nargin > 1)
      [HR_0, IBI_0, media_0] = HR_temporal(picos, valles, s_input, f_s);
      [HR_1, IBI_1, media_1] = HR_temporal(picos_1, valles_1, s_input, f_s);
      [HR_2, IBI_2, media_2] = HR_temporal(picos_2, valles_2, s_input, f_s);
      [HR_3, IBI_3, media_3] = HR_temporal(picos_3, valles_3, s_input, f_s);
  else
      IBI_0 = 0;
      HR_0  = 0;
  end
  
  ecm_0 = round(immse(HR_0, HR*ones(size(HR_0,1), size(HR_0, 2))));
  ecm_1 = round(immse(HR_1, HR*ones(size(HR_1,1), size(HR_1, 2))));
  ecm_2 = round(immse(HR_2, HR*ones(size(HR_2,1), size(HR_2, 2))));
  ecm_3 = round(immse(HR_3, HR*ones(size(HR_3,1), size(HR_3, 2))));
  
  HR_final_temp.HR        = HR_0;
  HR_final_temp.IBI       = IBI_0;
  HR_final_temp.media     = mean(HR_0);
  HR_final_temp.desv_tip  = std(HR_0);
  HR_final_temp.ecm       = ecm_0;
  HR_final_temp.picos     = picos;
  HR_final_temp.valles    = valles;
  HR_final_temp.media_puntos = media_0;
  
  HR_final_1.HR        = HR_1;
  HR_final_1.IBI       = IBI_1;
  HR_final_1.media     = mean(HR_1);
  HR_final_1.desv_tip  = std(HR_1);
  HR_final_1.ecm       = ecm_1;
  HR_final_1.picos     = picos_1;
  HR_final_1.valles    = valles_1;
  HR_final_1.media_puntos = media_1;
  
  HR_final_2.HR        = HR_2;
  HR_final_2.IBI       = IBI_2;
  HR_final_2.media     = mean(HR_2);
  HR_final_2.desv_tip  = std(HR_2);
  HR_final_2.ecm       = ecm_2;
  HR_final_2.picos     = picos_2;
  HR_final_2.valles    = valles_2;
  HR_final_2.media_puntos = media_2;
  
  HR_final_3.HR        = HR_3;
  HR_final_3.IBI       = IBI_3;
  HR_final_3.media     = mean(HR_3);
  HR_final_3.desv_tip  = std(HR_3);
  HR_final_3.ecm       = ecm_3;
  HR_final_3.picos     = picos_3;
  HR_final_3.valles    = valles_3;
  HR_final_3.media_puntos = media_3;
end
%% Sacar todos los picos y los valles
function [picos, valles] = Sacar_picos(s_input)
longitud        = length(s_input);
posible_pico    = 1;
posible_valle   = 1;
k_anterior      = 1;
valor_anterior  = s_input(k_anterior);
picos.posicion  = [];
id_ptp          = 0;
valles.posicion = [];
id_ptv          = 0;
picos.valor     = [];
id_vtp          = 0;
valles.valor    = [];
id_vtv          = 0;

for k = 2:longitud
    if(posible_pico && (s_input(k) <= valor_anterior))
        id_vtp = id_vtp + 1;
        id_ptp = id_ptp + 1; 
        picos(id_vtp).valor    = valor_anterior;
        picos(id_ptp).posicion = k_anterior;
    end
    
    if(posible_valle && (s_input(k) >= valor_anterior))
        id_vtv = id_vtv + 1;
        id_ptv = id_ptv + 1;
        valles(id_vtv).valor    = valor_anterior;
        valles(id_ptv).posicion = k_anterior;
    end
    
    if(s_input(k) >= valor_anterior)
        posible_pico = 1;
    else
        posible_pico = 0;
    end
    
    if(s_input(k) <= valor_anterior)
        posible_valle = 1;
    else
        posible_valle = 0;
    end
    
    k_anterior=k_anterior+1;
    valor_anterior= s_input(k_anterior);
end
end
%% Función para sacar el HR a partir de los picos detectados sin ningún postprocesado.
function [HR, IBI, media_puntos]      = HR_temporal(picos, valles, s_input, f_s)

if(nargin == 1)
    IBI = diff([picos.posicion]) / f_s;
    HR  = (60 * f_s) ./ diff([picos.posicion]);
elseif(nargin == 2)
    if(length([picos.posicion]) == length([valles.posicion]))
        IBI = (diff([picos.posicion]) / f_s + diff([valles.posicion]) / f_s) /2;
        HR  = ((60 * f_s) ./ diff([picos.posicion]) + (60 * f_s) ./ diff([valles.posicion])) /2;
    end
end

if(nargin == 4)
    tiempo  = 1/f_s:1/f_s:length(s_input)/f_s;
    HR      = zeros(size(tiempo, 1),size(tiempo, 2));
    IBI     = zeros(size(tiempo, 1),size(tiempo, 2));
    id_pic  = 2;
    id_val  = 2;
    for k = 2:length(tiempo)
        IBI(k)  = IBI(k-1);
        HR(k)   = HR(k-1);
        if(id_pic < length(picos) && id_val < length(valles))
            if(picos(id_pic).posicion < valles(id_val).posicion && picos(id_pic).posicion <= k)
                if((picos(id_pic).posicion - picos(id_pic-1).posicion) == 0)
                    id_pic  = id_pic + 1;
                    continue;
                end
                IBI(k)  = (picos(id_pic).posicion - picos(id_pic-1).posicion) / f_s;
                HR(k)   = (60 * f_s) / (picos(id_pic).posicion - picos(id_pic-1).posicion);
                id_pic  = id_pic + 1;   
                if(HR(k) > 300)
                     HR(k)= 0;
%                     fprintf('HR demasiado elevado\n');
                end
            end
        end
        if(id_val < length(valles) && id_pic < length(picos))
            if(picos(id_pic).posicion > valles(id_val).posicion && valles(id_val).posicion <= k)
                if((valles(id_val).posicion  - valles(id_val-1).posicion) == 0)
                    id_val  = id_val + 1;
                    continue;
                end
                IBI(k)  = (valles(id_val).posicion  - valles(id_val-1).posicion) / f_s;
                HR(k)   = (60 * f_s) / (valles(id_val).posicion  - valles(id_val-1).posicion);
                id_val  = id_val + 1;
                if(HR(k) > 300)
                     HR(k)= 0;
%                     fprintf('HR demasiado elevado\n');
                    
                end
            end
        end
    
    end
elseif(nargin == 3)
    tiempo  = 1:length(s_input);
    HR      = zeros(size(tiempo, 1),size(tiempo, 2));
    IBI     = zeros(size(tiempo, 1),size(tiempo, 2));
    id_pic  = 2;
    id_val  = 2;
    for k = 2:length(tiempo)
        IBI(k)  = IBI(k-1);
        HR(k)   = HR(k-1);
        if(id_pic <= length(picos))
            if(picos(id_pic).posicion < valles(id_val).posicion && picos(id_pic).posicion < k)
                IBI(k)  = (picos(id_pic).posicion - picos(id_pic-1).posicion);
                HR(k)   = 60 / (picos(id_pic).posicion - picos(id_pic-1).posicion);
                id_pic  = id_pic + 1;
            end
        end
        if(id_val <= length(valles))
            if(picos(id_pic).posicion > valles(id_val).posicion && valles(id_val).posicion < k)
                IBI(k)  = (valles(id_val).posicion  - valles(id_val-1).posicion);
                HR(k)   = 60 / (valles(id_val).posicion  - valles(id_val-1).posicion);
                id_pic  = id_pic + 1;
            end
        end
    end
end
HR_pics = 0;
HR_vall = 0;
if(length(picos) > 1)
HR_pics = (60 * f_s) ./ diff([picos.posicion]);
HR_pics(HR_pics > 300) =[];
end
if(length(valles) > 1)
HR_vall  = (60 * f_s) ./ diff([valles.posicion]);
HR_vall(HR_vall > 300) =[];
end
media_puntos = mean([HR_pics, HR_vall]);
HR=HR(round(f_s):end);
IBI=HR(round(f_s):end);
HR(HR==0)=[];
IBI(IBI==0)=[];
if(isempty(HR))
    HR = 0;
end
if(isempty(IBI))
    IBI = 0;
end
end
%% An Efficient and Automatic Systolic Peak Detection Algorithm for Photoplethysmographic Signals
function [picos_final, valles_final] = Filtro_picos_1(picos, valles)

if (picos(1).posicion < valles(1).posicion)
    picos(1) = [];
%     fprintf('Filtro picos 1: primer pico eliminado.\n');
end

if(length(picos) > length(valles))
    picos(length(valles)+1:end)=[];
%     fprintf('Filtro picos 1: picos extras eliminados.\n');
elseif(length(picos) < length(valles))
    valles(length(picos)+1:end)=[];
%     fprintf('Filtro picos 1: valles extras eliminados.\n');
end

num_picos_pre   = length(picos);
num_picos_pos   = 0; 
iteraciones     = 0;

while(num_picos_pre ~= num_picos_pos && length(picos) > 2 )
    VPD             = [picos.valor] - [valles.valor];
    lim_VPD         = zeros(size(VPD, 1), size(VPD, 2));    
    num_picos_pre   = length(picos);
    i               = 0;
    lim_VPD         = 0.7 * (VPD(1) + VPD(2)) / 3;
    if(VPD(1) > lim_VPD(1))
        i                   = i + 1;
        picos_nuevos(i)     = picos(1);
        valles_nuevos(i)    = valles(1);
    end
    for k = 2:length(VPD)-1
        lim_VPD(k)  = 0.7 * (VPD(k-1) + VPD(k) + VPD(k+1)) / 3;
        
        if(VPD(k) > lim_VPD(k))
            % ver picos
            i                   = i + 1;
            picos_nuevos(i)     = picos(k);
            valles_nuevos(i)    = valles(k);
        end
        
    end
    if(i> 0)
        picos           = picos_nuevos;
        valles          = valles_nuevos;
    end
    num_picos_pos   = length(picos);
    iteraciones     = iteraciones + 1;
end

% fprintf('Filtro picos 1: converge después de %i iteraciones.\n', iteraciones);
%-----------------------------------------------------------------------------
picos_final     = picos;
valles_final    = valles;

end
%% Adaptive threshold method for the peak detection of photoplethysmographic waveform
function [picos_final, valles_final] = Filtro_picos_2(s_input, f_s)
inicio_ppg = 1;
picos_final     = 0;
valles_final    = 0;
[picos, valles] = Sacar_picos(s_input);
tiempo_maximo = length(s_input);
slope_max = zeros(1, tiempo_maximo);
slope_min = zeros(1, tiempo_maximo);
if(isempty([picos.valor]) || isempty([valles.valor]))
    %nothing
else
slope_max(1)= 0.6*max([picos.valor]);
slope_min(1)= 0.6*min([valles.valor]);
Sr_max = -1.2;  % factor reductor de treshold superior experimental paper
Sr_min = 150.7;   % factor incrementador de treshold inferior experimental paper
muestras_IBI_previo = 0;
period_refractory = round(0.6 * muestras_IBI_previo);
i_p=1;
i_v=1;
V_max = 0;
V_min = 0;
i_p_new = 1;
i_v_new = 1;
picos_new(i_p_new) = picos(i_p);
valles_new(i_v_new) = valles(i_v);

for k = 2:tiempo_maximo
    if(k + f_s < tiempo_maximo)
        inicio_ppg = k;
        fin_ppg = k + f_s;
    else
        inicio_ppg = k;
        fin_ppg = tiempo_maximo;
    end
    slope_max(k) = slope_max(k-1) + Sr_max * abs(V_max + std(s_input(inicio_ppg:round(fin_ppg)))) / f_s;
    slope_min(k) = slope_min(k-1) + Sr_min * abs(V_min + std(s_input(inicio_ppg:round(fin_ppg)))) / f_s;
    
    if(slope_max(k) < s_input(k) && period_refractory <= (picos(i_p).posicion - picos_new(i_p_new).posicion) && s_input(k) > s_input(k-1))
        slope_max(k) = s_input(k);
    end
    if(slope_min(k) > s_input(k) && period_refractory <= (valles(i_v).posicion - valles_new(i_v_new).posicion) && s_input(k) < s_input(k-1))
        slope_min(k) = s_input(k);
    end
    if(k >= picos(i_p).posicion)
        if(picos(i_p).valor >= slope_max(k) && period_refractory <= (picos(i_p).posicion - picos_new(i_p_new).posicion))
            V_max = picos(i_p).valor;
            i_p_new = i_p_new + 1;
            picos_new(i_p_new) = picos(i_p);
            if(i_p_new >1)
                muestras_IBI_previo = picos_new(i_p_new).posicion - picos_new(i_p_new-1).posicion;
            end
            period_refractory = round(0.1 * muestras_IBI_previo);
        end
       
         i_p = i_p + 1;
        if(i_p > length(picos))
            i_p = length(picos);
        end
    end
    if(k >= valles(i_v).posicion)
        if(valles(i_v).valor <= slope_min(k) && period_refractory <= (valles(i_v).posicion - valles_new(i_v_new).posicion))
            V_min = valles(i_v).valor;
            i_v_new = i_v_new + 1;
            valles_new(i_v_new) = valles(i_v);
            if(i_v_new > 1)
                muestras_IBI_previo = valles_new(i_v_new).posicion - valles_new(i_v_new-1).posicion;
            end
            period_refractory = round(0.1 * muestras_IBI_previo);
        end
            i_v = i_v+1;
            if(i_v > length(valles))
                i_v = length(valles);
            end
            
    end
end
%-----------------------------------------------------------------------------
picos_final     = picos_new;
valles_final    = valles_new;
end
end
%% funcion propia con maximos y minimos
function [picos_final, valles_final] = Filtro_picos_3(picos, valles, s_input, f_s)
dist_max_punto_punto = f_s/0.5;
dist_min_pico_valle = f_s/10;
dist_min_punto_punto = f_s/5;
if(isempty([picos.posicion]) == 0)
    [p_sup]= polyfit([picos.posicion],[picos.valor],2);
    [p_inf]= polyfit([valles.posicion],[valles.valor],2);
    x1 = 1:max([picos(end).posicion, valles(end).posicion]);
    y_sup = polyval(p_sup,x1);
    y_inf = polyval(p_inf,x1);
end


while(length(picos) ~= length(valles))
    if(length(picos) > length(valles))
		picos(1)=[];
    elseif(length(picos) < length(valles))
		valles(1)=[];	
    end
    if(length(picos) == length(valles))
        for k =2:length(picos)-1
            if(abs(picos(k).posicion - valles(k+1).posicion) < dist_min_punto_punto)
%                warning('puntos muy juntos');
            end
            if(abs(picos(k).posicion - valles(k-1).posicion) < dist_min_punto_punto)
%                warning('puntos muy juntos');
            end
            if(abs(picos(k).posicion - valles(k).posicion) < dist_min_punto_punto)
%                warning('puntos muy juntos');
            end
        end
    end
end

dimension = length(picos);
%{
i_p=0;
i_v=0;
for k = 1:dimension
    if(picos(k).valor-valles(k).valor < 0.5*(y_sup(picos(k).posicion) - y_inf(valles(k).posicion)))
        if(abs(y_sup(picos(k).posicion)-picos(k).valor) < abs(y_inf(valles(k).posicion)-valles(k).valor))
            i_p=i_p+1;
            picos_new(i_p) = picos(k);
        else
            i_v=i_v+1;
            valles_new(i_v) = valles(k);
        end
    else
        i_p=i_p+1;
        picos_new(i_p) = picos(k);
        i_v=i_v+1;
        valles_new(i_v) = valles(k);
    end
end
%}
i_p=0;
i_v=0;
for k = 1:dimension
    if(picos(k).posicion + f_s < length(s_input))
        maximo = max(s_input(picos(k).posicion:picos(k).posicion+round(f_s)));
    else
        maximo = max(s_input(picos(k).posicion:end));
    end
    if(valles(k).posicion + f_s < length(s_input))
        minimo = min(s_input(valles(k).posicion:valles(k).posicion+round(f_s)));
    else
        minimo = min(s_input(valles(k).posicion:end));
    end
    if(picos(k).valor-valles(k).valor < 0.5*(maximo-minimo))
        if(abs(y_sup(picos(k).posicion)-picos(k).valor) < abs(y_inf(valles(k).posicion)-valles(k).valor))
            i_p=i_p+1;
            picos_new(i_p) = picos(k);
        else
            i_v=i_v+1;
            valles_new(i_v) = valles(k);
        end
    else
        i_p=i_p+1;
        picos_new(i_p) = picos(k);
        i_v=i_v+1;
        valles_new(i_v) = valles(k);
    end
end
continuar = 1;
picos = picos_new;
valles = valles_new;
i_v=1;
i_p=1;
i_v_new=0;
i_p_new=0;
bool_pico=1;
bool_valle=1;
while(continuar)
    if(valles(i_v).posicion < picos(i_p).posicion)
        if(bool_valle)
            i_v_new=i_v_new+1;
            valles_new(i_v_new)=valles(i_v);
            bool_pico=1;
            bool_valle=0;
        end
        i_v=i_v+1;
        if(i_v > length(valles))
            break;
        end
    else
        if(bool_pico)
            i_p_new=i_p_new+1;
            picos_new(i_p_new)=picos(i_p);
            bool_valle= 1;
            bool_pico=0;
        end
        i_p=i_p+1;
        if(i_p > length(picos))
            break;
        end
    end
end
% for k = 1:i_p
%     
% end

%-----------------------------------------------------------------------------
picos_final     = picos;
valles_final    = valles;
end