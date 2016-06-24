inicializar;

%% A�adimos bases de datos
base_dummy = BaseDeDatosEDWIN('edwin');
base_dummy.cargar('../bases/edwin8k');

%% A�adimos extractores
extractor1 = ExtractorCEPSTRUM('extractorcepstrum');

%% A�adimos clasificadores
clasificador_dummy = ClasificadorDUMMY('clasificadordummy');

%% Creamos evaluaciones
ev1 = Evaluacion('ev1');
ev1.addBase(base_dummy,'validacion');
ev1.addExtClas(extractor1,clasificador_dummy);
ev1.evaluarTodo;

%% Vemos los resultados
ev1.tabla
