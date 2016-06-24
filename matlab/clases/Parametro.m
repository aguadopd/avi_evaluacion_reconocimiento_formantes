classdef Parametro
    %PARAMETRO Summary of this class goes here
    %   Detailed explanation goes here
    
    properties (SetAccess = private)
        nombre;
        valor;
    end
    
    methods
        
        function obj = Parametro(nombre,valor)
            validateattributes(nombre,{'char'},{'vector'},'','nombre',1);
            assert(~isempty(valor), 'El segundo argumento no puede estar vacío');
            obj.nombre = nombre;
            obj.valor = valor;
        end
        
    end
    
end

