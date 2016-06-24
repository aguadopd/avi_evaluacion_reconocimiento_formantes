classdef ClasificadorDUMMY < Clasificador
    %CLASIFICADORDUMMY Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
    end
    
    methods
        
        function obj = ClasificadorDUMMY(nombre)
            obj = obj@Clasificador(nombre); % Constructor de la clase padre
        end
        
        
        function vocal_estimada = clasificarFonema(obj,fonema)
            validateattributes(fonema,{'Fonema'},{'numel',1},'','fonema',1);
            fonema.vocal_estimada = '?';
            vocal_estimada = fonema.vocal_estimada;
        end % clasificarFonema
        
        
        function vocales_estimadas = clasificarBase(obj,base_de_datos,indices)
            validateattributes(base_de_datos,{'BaseDeDatos'},{'numel',1},'','base_de_datos',1);
            validateattributes(indices,{'logical'},{'vector'},'','indices',2);
            for i = 1 : length(indices)
                if indices(i) == true
                    obj.clasificarFonema(base_de_datos.fonemas(i));
                end
            end
            vocales_estimadas = [base_de_datos.fonemas(indices).vocal_estimada]';
        end % clasificarBase
        
    end
    
end

