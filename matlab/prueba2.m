inicializar;

%% Añadimos bases de datos
base_dummy = BaseDeDatosEDWIN('edwin');
base_dummy.cargar('../bases/edwin8k');

%% Añadimos extractores
extractor1 = ExtractorBURG('extractor1');
extractor1.parametros('ventana_hamming') = false;

extractor2 = ExtractorBURG('extractor2');
extractor2.parametros('ventana_hamming') = true;

extractor3 = ExtractorBURG('extractor3');
extractor3.parametros('ventana_hamming')=false;
extractor3.parametros('preenfasis') = true;

extractor4 = ExtractorBURG('extractor4');
extractor4.parametros('ventana_hamming') = true;
extractor4.parametros('preenfasis') = true;

extractor5 = ExtractorBURG('extractor5');
extractor5.parametros('ventana_hamming') = false;
extractor5.parametros('ventana_gaussianPRAAT') = true;

extractor6 = ExtractorBURG('extractor6');
extractor6.parametros('ventana_hamming') = false;
extractor6.parametros('ventana_gaussianPRAAT') = true;
extractor6.parametros('preenfasis') = true;

extractor7 = ExtractorBURG('extractor7');
extractor7.parametros('ventana_hamming') = false;
extractor7.parametros('ventana_gaussianPRAAT') = true;
extractor7.parametros('preenfasis') = true;
extractor7.parametros('resample') = true;
extractor7.parametros('resample_fs') = 5000;
extractor7.parametros('orden') = 6;

extractor8 = ExtractorBURG('extractor8');
extractor8.parametros('ventana_hamming') = false;
extractor8.parametros('ventana_gaussian') = true;
extractor8.parametros('preenfasis') = true;

extractor9 = ExtractorBURG('extractor9');
extractor9.parametros('ventana_hamming') = false;
extractor9.parametros('ventana_gaussianPRAAT') = true;
extractor9.parametros('orden') = 8;
extractor9.parametros('resample') = false;
extractor9.parametros('resample_fs') = 12000;
extractor9.parametros('preenfasis') = true;

extractor10 = ExtractorBURG('extractor9');
extractor10.parametros('ventana_hamming') = false;
extractor10.parametros('ventana_gaussianPRAAT') = true;
extractor10.parametros('orden') = 6;
extractor10.parametros('resample') = true;
extractor10.parametros('resample_fs') = 2*3300;
extractor10.parametros('preenfasis') = true;


%% Añadimos clasificadores
clasificador_dummy = ClasificadorDUMMY('clasificadordummy');

%% Creamos evaluaciones
ev1 = Evaluacion('ev1');
ev1.addBase(base_dummy,'validacion');
ev1.addExtClas(extractor1,clasificador_dummy);
ev1.addExtClas(extractor2,clasificador_dummy);
ev1.addExtClas(extractor3,clasificador_dummy);
ev1.addExtClas(extractor4,clasificador_dummy);
ev1.addExtClas(extractor5,clasificador_dummy);
ev1.addExtClas(extractor6,clasificador_dummy);
ev1.addExtClas(extractor7,clasificador_dummy);
ev1.addExtClas(extractor8,clasificador_dummy);
ev1.addExtClas(extractor9,clasificador_dummy);
ev1.addExtClas(extractor10,clasificador_dummy);
ev1.evaluarTodo;

%% Vemos los resultados
ev1.tabla
