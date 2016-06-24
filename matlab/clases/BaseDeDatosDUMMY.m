classdef BaseDeDatosDUMMY < BaseDeDatos
    %BASEDEDATOSDUMMY Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
    end
    
    methods
        function obj = BaseDeDatosDUMMY(nombre)
            obj = obj@BaseDeDatos(nombre); % Constructor de la clase padre
        end
        
        function obj = cargar(obj,direccion)
            direcciones = {'D:\musicatito\Internacionales\Symphony X\V - The New Mythology Suite\04 - Trascendence (Segue).mp3',...
                'D:\musicatito\Internacionales\Symphony X\V - The New Mythology Suite\04 - Trascendence (Segue).mp3',...
                'D:\musicatito\Internacionales\Symphony X\V - The New Mythology Suite\04 - Trascendence (Segue).mp3'};
            formantes = [11,12;21,22;31,32];
            vocales = {'a','a','e'};
            obj = cargar_y_preparar(obj,direcciones,formantes,vocales);
        end
    end
    
end

