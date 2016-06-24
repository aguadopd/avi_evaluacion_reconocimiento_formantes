classdef BaseDeDatosPRODIVOZ < BaseDeDatos
    %BASEDEDATOSDUMMY Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
    end
    
    methods
        function obj = BaseDeDatosPRODIVOZ(nombre)
            obj = obj@BaseDeDatos(nombre); % Constructor de la clase padre
        end
        
        function obj = cargar(obj,direccion)
            % assert..
             T = readtable(fullfile(direccion,'formantes.txt'),'Delimiter',';', ...
                            'Format','%s%c%d%d');
            archivos = table2array(T(:,'nombre'));
            vocales = num2cell(table2array(T(:,'fonema')));
            formantes = table2array(T(:,{'f1','f2'}));
            direcciones = fullfile(direccion,archivos);
            
            obj = cargar_y_preparar(obj,direcciones,formantes,vocales);
        end
    end
    
end

