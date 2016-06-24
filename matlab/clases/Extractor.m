classdef Extractor < matlab.mixin.Copyable
    %EXTRACTOR Summary of this class goes here
    %   Detailed explanation goes here
    
    properties (SetAccess = private, GetAccess = public)
        nombre;
        parametros;
    end
    
    
    
    methods
        
        function obj = Extractor(nombre)
            validateattributes(nombre,{'char'},{'vector','nonempty'},'','nombre',1);
            obj.nombre = nombre;
            obj.parametros = containers.Map('KeyType','char','ValueType','any');
        end % Extractor
        
        
%         function obj = addParametro(obj, parametro)
%             validateattributes(parametro,{'Parametro'},{'numel',1},'','parametro',1);
%             obj.parametros(parametro.nombre) = parametro;
%         end % addParametro
        
        
        function argout = extraerFormantes(obj, varargin)
            assert(nargin == 2 || nargin == 3,'extraerFormantes(Fonema) o extraerFormantes(BaseDeDatos,indices)');
            validateattributes(varargin{1},{'Fonema','BaseDeDatos'},{'numel',1});
            if isa(varargin{1},'Fonema')
                argout = obj.extraerFormantesFonema(varargin{1});
            else
                validateattributes(varargin{2},{'logical'},{'vector'},'','indices',2);
                argout = obj.extraerFormantesBase(varargin{1},varargin{2});
            end
        end % extraerFormantes
        
        
    end % methods
    
    
    
    methods (Abstract = true)
        formantes_estimados = extraerFormantesFonema(obj,fonema)
        formantes_estimados = extraerFormantesBase(obj,base_de_datos,indices)
    end
    
end

