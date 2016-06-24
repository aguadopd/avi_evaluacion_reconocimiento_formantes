classdef Resultado < matlab.mixin.Copyable
    %RESULTADO Summary of this class goes here
    %   Detailed explanation goes here
    
    properties (SetAccess = private, GetAccess = public)
        formantes_estimados;
        vocales_estimadas;
        formantes_reales;
        vocales_reales;
        algoritmo;
        clasificador;
        base_de_datos;
        entrenamiento_o_validacion;
        indices;
        medidas;
    end
    
    
    properties 
        nombre;
    end
    
    
    methods
        
        function obj = Resultado(algoritmo, clasificador, base_de_datos, entrenamiento_o_validacion)
            validateattributes(algoritmo,{'Extractor'},{'numel',1},'','algoritmo',1);
            validateattributes(clasificador,{'Clasificador'},{'numel',1},'','clasificador',2);
            validateattributes(base_de_datos,{'BaseDeDatos'},{'numel',1},'','base_de_datos',3);
            validateattributes(entrenamiento_o_validacion,{'char'},{'vector'},'','entrenamiento_o_validacion',4);
            
            obj.algoritmo = algoritmo; % ya fue shallow copiado en Evaluacion
            obj.clasificador = clasificador; % ya fue shallow copiado en Evaluacion
            obj.base_de_datos = base_de_datos;
            obj.entrenamiento_o_validacion = entrenamiento_o_validacion;
            
            obj.medidas = containers.Map();
            
            if strcmp(entrenamiento_o_validacion, 'entrenamiento')
                obj.indices = base_de_datos.indices_set_de_entrenamiento;
            else
                obj.indices = base_de_datos.indices_set_de_validacion;
            end
            
            obj.formantes_reales = [base_de_datos.fonemas(obj.indices).formantes_reales]';
            obj.vocales_reales = [base_de_datos.fonemas(obj.indices).vocal]';
            
        end % Resultado
        
        
        function obj = extraer(obj)
            obj.formantes_estimados = obj.algoritmo.extraerFormantes(obj.base_de_datos,obj.indices);
        end % extraer
        
        
        function obj = clasificar(obj)
            obj.vocales_estimadas = obj.clasificador.clasificar(obj.base_de_datos,obj.indices);
        end % clasificar
        
        
        obj = evaluarMedidas(obj); % Definida afuera para poder modificar sin recalcular todo
        
        
        function mostrarMedidas(obj)
            keys = obj.medidas.keys;
            for i = 1 : obj.medidas.Count
                disp(keys(i));
                disp(obj.medidas(keys{i}));
            end                
        end % mostrarMedidas
        
        
        function tabla = aTabla(obj,tabla)
            c = cell(0,2);
            c(end+1,:) = {'Base', obj.base_de_datos.nombre};
            c(end+1,:) = {'EV', obj.entrenamiento_o_validacion};
            c(end+1,:) = {'Extractor', obj.algoritmo.nombre};
            c(end+1,:) = {'Clasificador', obj.clasificador.nombre};
            keys = obj.medidas.keys;
            for i = 1 : length(keys)
                c(end+1,:) = {keys{i}, obj.medidas(keys{i})};
            end
            
            t = cell2table(c(:,2)');
            t.Properties.VariableNames = c(:,1)';
            t.Properties.RowNames = {obj.nombre};
            t.Properties.DimensionNames = {'Resultado', 'Variable'};
            
            if ~isempty(tabla) && width(tabla) ~= width(t)
                tabla = table();
            end
            tabla = [tabla ; t];
        end % aTabla
        
        
        function obj = set.nombre(obj,nombre)
            validateattributes(nombre,{'char'},{'vector','nonempty'},'','nombre',1);
            obj.nombre = nombre;
        end
        
    end % methods
    
end % classdef
