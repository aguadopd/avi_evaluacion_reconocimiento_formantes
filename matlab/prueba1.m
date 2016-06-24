addpath('./clases/');

%% A�adimos bases de datos
base_dummy = BaseDeDatosDUMMY('basedummy');
base_dummy.cargar();

%% A�adimos extractores
extractor_dummy = ExtractorBURG('extractordummy');

%% A�adimos clasificadores
clasificador_dummy = ClasificadorDUMMY('clasificadordummy');

%% Creamos evaluaciones
ev1 = Evaluacion('ev1');
ev1.addBase(base_dummy,'validacion');
ev1.addExtClas(extractor_dummy,clasificador_dummy);
ev1.evaluarTodo;

%% Vemos los resultados
r1 = ev1.resultados{1};
r1.mostrarMedidas();
