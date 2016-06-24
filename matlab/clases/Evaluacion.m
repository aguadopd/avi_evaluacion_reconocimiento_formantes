classdef Evaluacion < handle
    %EVALUACION Prueba un/os algoritmo/s con un/os clasificador/es en una/s base/s de
    %datos, cada uno con un coonjunto de parámetros.
    %   Detailed explanation goes here
    
    properties (SetAccess = private, GetAccess = public)
        nombre;
        resultados;
        bases_de_datos;
        algoritmos_y_clasificadores;
        tabla;
    end
    
    methods
        
        function obj = Evaluacion(nombre)
            validateattributes(nombre,{'char'},{'vector','nonempty'},'','nombre',1);
            obj.nombre = nombre;
            obj.resultados = {};
            obj.bases_de_datos = {};
            obj.algoritmos_y_clasificadores = {};
            obj.tabla = cell(0);
        end
        
        
        function obj = addBase(obj, base_de_datos, entrenamiento_o_validacion)
            validateattributes(base_de_datos,{'BaseDeDatos'},{'numel',1},'','base_de_datos',1);
            validateattributes(entrenamiento_o_validacion,{'char'},{'vector'},'','entrenamiento_o_validacion',2);
            assert(strcmp(entrenamiento_o_validacion,'entrenamiento') || ...
                strcmp(entrenamiento_o_validacion,'validacion'), ...
                'El tercer argumento debe ser ''entrenamiento'' o ''validacion''')
                
            obj.bases_de_datos(end+1,:) = {base_de_datos, entrenamiento_o_validacion};
        end % addBase
        
        % addExtClas. Se agregan los pares extractor-clasificador que se
        % quieran probar
        function obj = addExtClas(obj, algoritmo_de_extraccion, clasificador)
            validateattributes(algoritmo_de_extraccion,{'Extractor'},{'numel',1},'','algoritmo_de_extraccion',1);
            validateattributes(clasificador,{'Clasificador'},{'numel',1},'','clasificador',2);
            % Guardamos copias porque son handles y el objeto se va a
            % modificar, y queremos no perder los parámetros. 
            % Shallow copy así que no duplicamos los fonemas. El
            % único problema van a ser los clasificadores que tengan archivos
            % de entrenamiento pesados, si es que los hay.
            algoritmo_copia = algoritmo_de_extraccion.copy();
            clasificador_copia = clasificador.copy();
            obj.algoritmos_y_clasificadores(end+1,:) = {algoritmo_copia, clasificador_copia}; 
        end % addAlgClas        
        

        function obj = evaluarTodo(obj)
            for i = 1 : size(obj.bases_de_datos,1)
                for j = 1 : size(obj.algoritmos_y_clasificadores,1)
                    algoritmo = obj.algoritmos_y_clasificadores{j,1};
                    clasificador = obj.algoritmos_y_clasificadores{j,2};
                    base_de_datos = obj.bases_de_datos{i,1};
                    entrenamiento_o_validacion = obj.bases_de_datos{i,2};
                    obj.resultados(end+1) = {obj.evaluar(algoritmo, clasificador, ...
                        base_de_datos, entrenamiento_o_validacion)};
                end
            end
            
            for i = 1 : length(obj.resultados)
                obj.resultados{i}.nombre = num2str(i);
            end
           
            
            % Para cada resultado
            for i = 1 : length(obj.resultados);
                % calculamos las medidas
                obj.resultados{i}.evaluarMedidas;
                % y guardamos todo en la tabla. La tabla solo tendrá resultados y no parámetros
                % porque los parámetros son distintos para diferentes
                % extractores y clasificadores.
                obj.tabla = obj.resultados{i}.aTabla(obj.tabla);
            end
            
            obj.tabla.Properties.Description = obj.nombre;
            
            
        end % evaluarTodo
        
        
       function guardarTabla(obj,dir_a_archivo,varargin)
           if isempty(varargin)
               writetable(obj.tabla,dir_a_archivo,'FileType','spreadsheet',...
                   'WriteVariableNames',true,'WriteRowNames',true,'Sheet',obj.nombre);                   
           else writetable(obj.tabla,dir_a_archivo,varargin);
           end
       end % guardarTabla
        
    end % methods
    
    
    methods (Static)
    
        %evaluacionindividual
        function resultado = evaluar(algoritmo, clasificador, base_de_datos, entrenamiento_o_validacion)
            validateattributes(algoritmo,{'Extractor'},{'numel',1},'','algoritmo',1);
            validateattributes(clasificador,{'Clasificador'},{'numel',1},'','clasificador',2);
            validateattributes(base_de_datos,{'BaseDeDatos'},{'numel',1},'','base_de_datos',3);
            validateattributes(entrenamiento_o_validacion,{'char'},{'vector'},'','entrenamiento_o_validacion',4);
            assert(strcmp(entrenamiento_o_validacion,'entrenamiento') || ...
                strcmp(entrenamiento_o_validacion,'validacion'), ...
                'El tercer argumento debe ser ''entrenamiento'' o ''validacion''')
            
            % Los argumentos ya fueron shallow copiados en este objeto.
            resultado = Resultado(algoritmo, clasificador, base_de_datos, entrenamiento_o_validacion);

            resultado.extraer();
            resultado.clasificar();
            resultado.evaluarMedidas();
        end % evaluar
        
    end % methods (Static)
    
end % classdef