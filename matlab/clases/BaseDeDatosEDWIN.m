classdef BaseDeDatosEDWIN < BaseDeDatos
    %BASEDEDATOSDUMMY Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
    end
    
    methods
        function obj = BaseDeDatosEDWIN(nombre)
            obj = obj@BaseDeDatos(nombre); % Constructor de la clase padre
        end
        
        function obj = cargar(obj,direccion)
            % assert..
            direcciones = dir(direccion);
            direcciones(strncmp({direcciones.name},'.',1))=[]; %Not . and .. folders
            direcciones = {direcciones.name}; % a cell
            direcciones = fullfile(direccion,direcciones)';
           
            formantes = [678,1237; 478,2091; 354,2348; 486,993; 310,575];
            vocales = {'a','e','i','o','u'};
            obj = cargar_y_preparar(obj,direcciones,formantes,vocales);
        end
    end
    
end

