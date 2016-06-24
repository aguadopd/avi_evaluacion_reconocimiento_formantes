classdef ExtractorBURG < Extractor
    %EXTRACTORBURG Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
    end
    
    methods
        
        function obj = ExtractorBURG(nombre)
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

