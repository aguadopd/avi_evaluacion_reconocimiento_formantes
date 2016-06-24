function formantes_estimados = extraerFormantesFonema( obj, fonema )
%EXTRAERFORMANTESFONEMA Summary of this function goes here
%   Detailed explanation goes here

validateattributes(fonema,{'Fonema'},{'numel',1},'','fonema',1);
audio = fonema.sonido;
Fs = fonema.fs;


if obj.parametros('resample')
    audio = resample(audio,obj.parametros('resample_fs'),Fs,20);
    Fs = obj.parametros('resample_fs');
elseif obj.parametros('lowpass')
    %lowpass
end


tms = obj.parametros('tms'); % tiempo en ms
muestras = round(Fs*(tms/1000));
centro = floor(length(audio+1)/2);
 
if muestras > length(audio)
    izq = 1;
    der = length(audio);
    warning('BURG:EXTRAER: Se están requiriendo más muestras de las que existen. Se usarán todas las disponibles');
    audio = audio(izq:der);
    centro = floor(length(audio+1)/2);
else
    izq = centro - ceil(muestras/2); % 
    der = centro + floor(muestras/2); %
    audio = audio(izq : der);
    centro = floor(length(audio+1)/2);
end


burg_orden = obj.parametros('orden');




if obj.parametros('preenfasis')
    % http://www.fon.hum.uva.nl/praat/manual/Sound__To_Formant__burg____.html
    % http://www.fon.hum.uva.nl/praat/manual/Sound__Pre-emphasize__in-line____.html
    % http://www.fon.hum.uva.nl/praat/manual/Sound__Filter__pre-emphasis____.html
    preEmphasisFrequency = 50; % Esto debería ser variable. 
    %double preEmphasis = exp (- 2.0 * NUMpi * preEmphasisFrequency * my dx);
    preEmphasis = exp(-2 * pi * preEmphasisFrequency / Fs );
    for i = 2:length(audio)
        audio(i) = audio(i) - preEmphasis.*audio(i-1);
    end
end


if obj.parametros('ventana_hamming')
    x = audio.*hamming(length(audio));
elseif obj.parametros('ventana_gaussianPRAAT')
    nsamp_window = length(audio);
    imid = centro;
    edge = exp (-12.0);
    window = zeros(nsamp_window,1);
    for i = 1 : length(window)
        window(i) = (exp (-48.0 .* (i - imid) .* (i - imid) ./ (nsamp_window + 1) ./ (nsamp_window + 1)) - edge) ./ (1 - edge);
    end
    x = audio.*window;
elseif obj.parametros('ventana_gaussian')
    x = audio.*gausswin(length(audio),3);    
else
    x = audio;
end

% Para entender el funcionamiento, referirse al ejemplo de formant
% estimation de Matlab, en la ayuda. También, [1] Snell. R. "Formant location from LPC 
% analysis data", IEEE® Transactions on Speech and Audio Processing, 1(2), pp. 129–134, 1993.
% https://www.ee.columbia.edu/~dpwe/papers/SnelM93-fmnt.pdf 
% El artículo de Snell implementa todo con integrales, pero lo importante
% está en la primera hoja. Intento transcribir:
% Sea un par de polos complejos z = r0 * e^(+-)tita0, siendo r0 el módulo y tita0 el ángulo de los polos, con frecuencia de
% muestreo fs. Se puede obtener la frecuencia de formante F y el ancho de
% banda de 3 dB a partir de:
% F = (fs/2pi)*tita0 [Hz]
% B = -(fs/pi)*ln(r0) [Hz]

% x = audio.*hamming(length(audio));

% Encontramos los coeficientes de un polinomio
A = arburg(x,burg_orden);

% Encontramos las raíces COMPLEJAS del polinomio.
rts = roots(A);
% NUEVO**** 2016 reflejamos las raices de modulo > 1
for i = 1 : length(rts)
    if abs(rts(i))>1
        rts(i) = 1/rts(i);
    end
end

% Nos quedamos con sólo un par de las raices (complejas) y todas las reales
rts = rts(imag(rts)>=0);

% Calculamos el ángulo (en radianes) de las raices/polos. // El ángulo, al
% menos para un sistema de 2° orden, es igual al arcocoseno del factor de amorguamiento
% del polo
angz = atan2(imag(rts),real(rts));

% Ordenamos las ¿frecuencias de resonancia de las raices? en orden
% ascendente
[frqs,indices] = sort(angz.*(Fs/(2*pi)));

%NUEVO******2016
a_borrar = [];
for i = 1 : length(frqs)
    if frqs(i) < 50 || frqs(i) > (Fs/2)-50
        a_borrar = [a_borrar , i];
    end
end
frqs(a_borrar) = [];
indices(a_borrar) = [];

% Calculamos los anchos de banda de 3dB para cada polo (log natural)
bw = -1/2*(Fs/(2*pi))*log(abs(rts(indices)));


% Y eliminamos los que sean menores a 50 Hz o tengan anchos de banda
% mayores a 400. // Criterio empírico. En la ayuda de matlab dice > 90
formants = 0;
nn = 1;
for kk = 1:length(frqs)
    if (frqs(kk) > 90 && bw(kk) < 400)
        formants(nn) = frqs(kk);
        nn = nn+1;
    end
end
formants = frqs;

%% De aquí en adelante es extra. 
formants = round(formants);

% Chequeamos que haya encontrado algo
if(exist('formants','var')==1 && numel(formants)>1)
    F1_burg = formants(1);
    F2_burg = formants(2);
else
    F1_burg = 0;
    F2_burg = 0;
end

formantes_estimados = [F1_burg, F2_burg];
fonema.formantes_estimados = formantes_estimados;

end

