classdef ExtractorCEPSTRUM< Extractor
    %EXTRACTORBURG Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
    end
    
    methods
        
        function obj = ExtractorCEPSTRUM(nombre)
            obj = obj@Extractor(nombre); % Constructor de la clase padre
            % Lista de parámetros y valores por defecto.
            obj.parametros('orden') = 9; % Orden del filtro estimado
            obj.parametros('tms') = 50; % Tiempo de muestra en ms; se toma el centro del sonido.
            obj.parametros('preenfasis') = false;
            obj.parametros('lowpass') = false; % no está implementado
            obj.parametros('lowpass_freq') = 0;
            obj.parametros('resample') = false;
            obj.parametros('resample_fs') = 0;
            obj.parametros('preenfasis') = false;
            obj.parametros('ventana_hamming') = true;
            obj.parametros('ventana_gaussianPRAAT') = false;
            obj.parametros('ventana_gaussian') = false;
        end
        
        
        formantes_estimados = extraerFormantesFonema(obj,fonema);
        
        
        function formantes_estimados = extraerFormantesBase(obj,base_de_datos,indices)
            validateattributes(base_de_datos,{'BaseDeDatos'},{'numel',1},'','base_de_datos',1);
            validateattributes(indices,{'logical'},{'vector'},'','indices',2);
            for i = 1 : length(indices)
                if indices(i) == true
                    obj.extraerFormantesFonema(base_de_datos.fonemas(i));
                end
            end
            formantes_estimados = [base_de_datos.fonemas(indices).formantes_estimados]';
        end % extraerFormantesBase
        
    end
    
end



function [f,val] = avi_fft(x,Fs,NFFT)
%Realiza la transformada de Fourier de una secuencia x con frecuencia de
%muestreo Fs. Devuelve un vector de frecuencias f y el valor absoluto de la
%transformada, ff.

L = length(x);
t = (0:1/Fs:(L-1)*(1/Fs));

%plot(t,x);
if(nargin == 2)
    NFFT = 2^nextpow2(L);
end
    
Y = fft(x,NFFT)/L;
%f = Fs/2*linspace(0,1,NFFT/2+1); 
f = Fs*linspace(0,1,NFFT); %necesitamos todos los puntos para la ifft

% Plot single-sided amplitude spectrum.
%plot(f,2*abs(Y(1:NFFT/2+1))) 
%p1 = abs(Y(1:NFFT/2+1));
%p1 = abs(Y(1:NFFT));
%p2 = Y.*conj(Y)/NFFT;
%figure;
%%plot(f,log10(p1)) ;
%title('Single-Sided Amplitude Spectrum of y(t)')
%xlabel('Frequency (Hz)')
%ylabel('|Y(f)|')
val = abs(Y);
%val = (Y);
end

