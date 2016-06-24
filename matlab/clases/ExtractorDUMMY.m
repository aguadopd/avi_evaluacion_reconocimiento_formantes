classdef ExtractorDUMMY < Extractor
    %EXTRACTORDUMMY Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
    end
    
    methods
        
        function obj = ExtractorDUMMY(nombre)
            obj = obj@Extractor(nombre); % Constructor de la clase padre
        end
        
        
        function formantes_estimados = extraerFormantesFonema(obj,fonema)
            validateattributes(fonema,{'Fonema'},{'numel',1},'','fonema',1);
            fonema.formantes_estimados = [0,0];
            formantes_estimados = fonema.formantes_estimados;
        end % extraerFormantesFonema
        
        
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

