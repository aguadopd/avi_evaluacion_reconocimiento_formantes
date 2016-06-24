classdef Clasificador < matlab.mixin.Copyable
    %CLASIFICADOR Summary of this class goes here
    %   Detailed explanation goes here
    
    properties (SetAccess = private, GetAccess = public)
        nombre;
        parametros;
    end
    
    
    
    methods
        
        function obj = Clasificador(nombre)
            validateattributes(nombre,{'char'},{'vector','nonempty'},'','nombre',1);
            obj.nombre = nombre;
            obj.parametros = containers.Map('KeyType','char','ValueType','any');
        end % Clasificador
        
        
        function obj = addParametro(obj, parametro)
            validateattributes(parametro,{'Parametro'},{'numel',1},'','parametro',1);
            obj.parametros(parametro.nombre) = parametro;
        end % addParametro
        
        
        function argout = clasificar(obj, varargin)
            assert(nargin == 2 || nargin == 3,'Clasificar(Fonema) o Clasificar(BaseDeDatos,indices)');
            validateattributes(varargin{1},{'Fonema','BaseDeDatos'},{'numel',1});
            if isa(varargin{1},'Fonema')
                argout = obj.clasificarFonema(varargin{1});
            else
                validateattributes(varargin{2},{'logical'},{'vector'},'','indices',2);
                % clasificarBase no es un for de clasificarFonema porque
                % puede llegar a utilizar información de la base completa
                % para algo.
                argout = obj.clasificarBase(varargin{1},varargin{2});
            end
        end % clasificar
        
        
    end % methods
    
    
    
    methods (Abstract = true)
        vocal_estimada = clasificarFonema(obj,fonema)
        vocales_estimadas = clasificarBase(obj,base_de_datos,indices)
    end
    
end

