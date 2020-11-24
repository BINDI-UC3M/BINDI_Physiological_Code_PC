% Potencia relativa de la componente de la frecuencia

function rel_power = relative_power(Banda_calculada, Energia_banda1, Energia_banda2)

rel_power = Banda_calculada/(Banda_calculada + Energia_banda1 + Energia_banda2);

end