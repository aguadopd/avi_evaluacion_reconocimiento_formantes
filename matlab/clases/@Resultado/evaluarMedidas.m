function obj = evaluarMedidas( obj )
%EVALUARMEDIDAS Summary of this function goes here
%   Detailed explanation goes here

n = length(obj.vocales_reales);

e_correctas = sum(obj.vocales_reales == obj.vocales_estimadas);
obj.medidas('e_correctas') = e_correctas;

e_incorrectas = n - e_correctas;
obj.medidas('e_incorrectas') = e_incorrectas;

p_correctas = e_correctas / n;
obj.medidas('p_correctas') = p_correctas;

distancias_euclideas = zeros(n,1);
cant_formantes = min([size(obj.formantes_reales,2);size(obj.formantes_estimados,2)]);
for i = 1 : n
    f_real = obj.formantes_reales(i,1:cant_formantes);
    f_estimado = obj.formantes_estimados(i,1:cant_formantes);
    distancias_euclideas(i) = pdist([f_real;f_estimado],'euclidean');
end
distancia_euclidea_promedio = mean(distancias_euclideas);
obj.medidas('d_euc_prom') = distancia_euclidea_promedio;


obj.medidas('drms') = sqrt((sum(distancias_euclideas.^2))/n);
    
end

