inicializar;

%% Añadimos bases de datos
base_dummy = BaseDeDatosEDWIN('edwin');
base_dummy.cargar('../bases/edwin8k');

%% Añadimos extractores
extractor_burg1 = ExtractorBURG('extractorburg1');
extractor_burg1.parametros('tms') = 25;
extractor_burg1.parametros('orden') = 9;
extractor_burg1.parametros('resample') = false;
extractor_burg1.parametros('resample_fs') = 1800;

extractor_lpc1 = ExtractorLPC('extractorlpc1');
extractor_lpc1.parametros('tms') = 25;
extractor_lpc1.parametros('orden') = 9;
extractor_lpc1.parametros('resample') = false;
extractor_lpc1.parametros('resample_fs') = 1800;

%% Añadimos clasificadores
clasificador_dummy = ClasificadorDUMMY('clasificadordummy');

%% Creamos evaluaciones
ev1 = Evaluacion('ev1');
ev1.addBase(base_dummy,'validacion');
ev1.addExtClas(extractor_burg1,clasificador_dummy);
ev1.addExtClas(extractor_lpc1,clasificador_dummy);
ev1.evaluarTodo;

%% Vemos los resultados
ev1.tabla
