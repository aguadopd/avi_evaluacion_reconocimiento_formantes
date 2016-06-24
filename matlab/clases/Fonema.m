classdef Fonema < matlab.mixin.Copyable
    %FONEMA En esta clase se almacena cada sonido y los correspondientes
    %formantes obtenidos de forma analítica. También se almacenan los
    %formantes estimados por algún algoritmo.
    %   Detailed explanation goes here
    
    properties (SetAccess = private)
        sonido;     % Sonido normalizado
        fs = 0;     % Frecuencia de muestreo
        vocal = '';
    end
    
    properties (SetAccess = public)
        formantes_reales;
        formantes_estimados;
        vocal_estimada;
    end
    
    properties (Dependent = true)
        cantidad_de_formantes = 0;
    end
    
    methods
        
        function obj = Fonema(varargin)
            assert(nargin<=3 && nargin~=1,['Debe ingresarse la vocal (ej:''a'') y luego '...
                'una dirección, o un vector normalizado y su frecuencia de muestreo']);
            if nargin == 0
                %
            elseif nargin == 2
                obj.vocal = varargin{1};
                obj.sonido = varargin{2};
            elseif nargin == 3
                obj.vocal = varargin{1};
                obj.sonido = varargin{2};
                obj.fs = varargin{3};
            end
        end
        
        function obj = set.vocal(obj, v)
            validateattributes(v,{'char'},{'numel',1},'','vocal',1);
            obj.vocal = v;
        end % set.vocal
        
        function obj = set.sonido(obj, dir_o_vector)
        % Puede ingresarse una dirección o un vector normalizado con una
        % frecuencia de muestreo.
            validateattributes(dir_o_vector,{'numeric','char'},{});
            if isa(dir_o_vector,'char')
                direccion = dir_o_vector;
                try
                    [sonido,ffs] = audioread(direccion);
                    obj.sonido = sonido(:,1); % mono, canal izquierdo
                    obj.fs = ffs;
                catch ME
                    error(ME.message)
                end
            else 
                vector = dir_o_vector;
                validateattributes(vector,{'numeric'},{'vector','>=',-1,'<=',1},'','vector',1);
                obj.sonido = vector;    
            end
        end
        
            
        function obj = set.fs(obj, frecuencia)
            validateattributes(frecuencia,{'numeric'},{'scalar','>=',0},'','frecuencia',1);
            obj.fs = frecuencia;
        end
        
        
        function obj = set.formantes_reales(obj,formantes)
            validateattributes(formantes,{'numeric'},{'vector','>=',0},'','formantes',1);
            obj.formantes_reales = double(formantes(:));
        end
        
        
        function obj = set.formantes_estimados(obj,formantes)
            validateattributes(formantes,{'numeric'},{'vector','>=',0},'','formantes',1);
            obj.formantes_estimados = double(formantes(:));
        end
        
        
        function obj = set.vocal_estimada(obj,v)
            validateattributes(v,{'char'},{'numel',1},'','vocal',1);
            obj.vocal_estimada = v;
        end
%         function graficar(obj,handle)
%             if handle 
%         end
            
    end % methods    
end %classdef

