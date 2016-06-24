classdef (Abstract = true) BaseDeDatos < matlab.mixin.Copyable
    %BASEDEDATOS Clase padre para las bases de datos de fonemas. Cada
    %subclase implementará la forma de cargar según el formato.
    %   Detailed explanation goes here
    
    properties (SetAccess = protected, GetAccess = public)
        nombre;
        indices_set_de_entrenamiento;
        indices_set_de_validacion;
        fonemas;
    end        
    
    methods (Abstract = true)
        % Esta función debe implementarse en cada clase derivada. A partir
        % de una dirección base debe obtener las direcciones de los
        % archivos y los respectivos valores de los formantes. Las filas de
        % la matriz de formantes corresponden a cada fonema; las columnas
        % corresponden a cada formante. La clase derivada debe llamar a la
        % función cargar_y_preparar(direcciones,formantes,vocales). Los
        % formantes y las vocales se suponen correspondientes a las
        % direcciones de los sonidos con el mismo índice.
        obj = cargar(obj,direccion)
    end %abstractmethods
    
    methods
        function obj = BaseDeDatos(nombre)
            validateattributes(nombre,{'char'},{'vector'},'','nombre',1);
            obj.nombre = nombre;
            %obj.indices_set_de_entrenamiento = [];
            %obj.indices_set_de_validacion = [];
            obj.fonemas = Fonema.empty();
        end
        
        
        function obj = set.indices_set_de_validacion(obj, indices)
            validateattributes(indices,{'logical'},{'vector'},'','indices',1);
            obj.indices_set_de_validacion = indices;
        end
        
        
        function obj = set.indices_set_de_entrenamiento(obj, indices)
            validateattributes(indices,{'logical'},{'vector'},'','indices',1);
            obj.indices_set_de_entrenamiento = indices;
        end
        
        
        function obj = cargar_y_preparar(obj,direcciones,formantes,vocales)
            validateattributes(direcciones,{'cell'},{'vector'},'','direcciones',1);
            n_direcciones = length(direcciones);
            for i = 1 : n_direcciones
                if ~isa(direcciones{i},'char')
                    error('La dirección %d no es un string',i);
                end
            end
            
            validateattributes(vocales,{'cell'},{'vector','numel',n_direcciones},'','vocales',3);
            for i = 1 : length(vocales)
                if numel(vocales{i}) > 1
                    error('La vocal %d tiene más de un caracter',i);
                end
            end
            
            validateattributes(formantes,{'numeric'},{'ndims',2},'','formantes',2);
            assert((size(formantes,1) == n_direcciones) || (size(formantes,2) == n_direcciones),...
                'El número de direcciones es distinto al número de formantes disponibles');
            % Cada fila corresponde a un fonema, las columnas son los formantes
            if (size(formantes,2) == n_direcciones)
                formantes = formantes';
            end
            
            
            % división en sets de entrenamiento y de validación
            if n_direcciones > 50
                c = cvpartition(vocales,'KFold',5);
                r = round(rand()*5);
                obj.indices_set_de_validacion = c.test(r);
                obj.indices_set_de_entrenamiento = c.training(r);
            else
                c = cvpartition(vocales,'resubstitution');
                obj.indices_set_de_validacion = c.test();
                obj.indices_set_de_entrenamiento = c.training();
            end
            
            obj.fonemas(n_direcciones) = Fonema();
            
            for i = 1 : n_direcciones
                obj.fonemas(i) = Fonema(vocales{i},direcciones{i});
                obj.fonemas(i).formantes_reales = formantes(i,:);
                fprintf('Se han cargado %d de %d fonemas - %d%%\n',i,n_direcciones,floor(i*100/n_direcciones));
            end
        end % cargar_y_preparar
        
    end % methods
    
end % classdef

