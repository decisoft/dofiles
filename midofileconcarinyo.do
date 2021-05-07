************************* ********
* DoFile de Mario Yanes * * 2019 *
************************* ********

*********************************************
** Técnicas de investigación cuantitativas **
*********************************************

** ÍNDICE **
*1. Dofile general. Líneas 14-545. Lo visto en clase.
*2. Dofile vox preelectoral. Líneas 549-794. Análisis artículo.
*3. Dofile append y merge. Líneas 800-962. Para unir bases de datos.

******************
* DOFILE GENERAL *
******************

** Abrir dataset
use "C:\Users\mario\Cosas\Universidad\Stata14\ESS8ES.dta", clear

* Comando para eliminar la etiqueta 'more'
set more off

* Descripción de la variable *
codebook netusoft

/* Tabla de frecuencias
Puedo poner ', nolabel' para que no
muestre etiquetas */ 
tab trstplc 

/* Si quiero introducir 
varias líneas de 
texto */

* Resumen
sum trstplc

**SÍMBOLOS**
* = igual
* != distinto
* > mayor que
* < menor que
* >= mayor o igual que
* <= menor o igual que
* & y
* | o


*****************************************
* Procesamiento y limpieza de variables *
*****************************************

** Variables sociodemográficas **
* Género
* Edad
* Marital status
* Hijos (en el hogar)
* ...

* Sexo *
tab gndr
tab gndr, nolabel
	*Para renombrar
rename gndr genero
	*Recodificar variable
recode genero 2=0 9=.
tab genero
	*Etiquetar las categorías
label define generov 0"Mujer" 1"Hombre"
label values genero generov
	*Comprobación
tab genero

/* Aquí usamos el comando 'tab'
porque es una variable dicotómica */

* Edad *
tab agea
tab agea, nolabel
	*Renombrar
rename agea edad
	*Recodificar
recode edad 999=.
	*Comprobación
sum edad

/* En la comprobación, utilizamos 'sum' 
porque no es una variable dicotómica */

* Estado civil *
tab maritalb
	*Renombrar
rename maritalb ecivil
	*Eliminar los NS/NC
tab ecivil, nolabel
recode ecivil 77=. 88=. 99=.
	*Crear variable dicotómica a partir de ecivil:
gen casado=0
replace casado=1 if ecivil==1 | ecivil==2
replace casado=. if ecivil==. // de lo contrario estaría en la categoría 0
	*Etiquetar las categorías
label define casadov 0"Otro" 1"Casado"
label values casado casadov
	*Comprobar
tab casado


* Hijos en el hogar *
tab chldhm
tab chldhm, nolabel
	*Crear la variable 'hijos' a partir de 'chldhm'
gen hijos=0
replace hijos=1 if chldhm==1
replace hijos=. if chldhm==9	
	*Etiquetar las categorías
label define hijosv 0"No" 1"Sí"
label values hijos hijosv
	*Comprobar
tab hijos // porque es una variable dicotómica

* Religiosidad *
tab rlgdgr
tab rlgdgr, nolabel
	*Renombrar
rename rlgdgr religiosidad
	*Recodificar
replace religiosidad=. if religiosidad>11
	*Comprobar
tab religiosidad

* Religión *
tab rlgdnm
tab rlgdnm, nolabel
	*Renombrar
rename rlgdnm religion
	*Recodificar
tab religion, nolabel
replace religion=. if religion>9
	*Comprobar
tab religion

* Religión_rec
gen religion_rec=0
replace religion_rec=. if religion==. //perdidos
replace religion_rec=1 if religion>=1 & religion<=4 //cristianos
replace religion_rec=2 if religion==5 //judíos
replace religion_rec=3 if religion==6 //musulmanes
replace religion_rec=4 if religion>=7 & religion<=8 //otros
tab religion_rec
*Etiquetamos
label define religion_recv 1"Cristianos" 2"Judios" 3"Musulmanes" ///
4"Otros"
label values religion_rec religion_recv
tab religion_rec

** Hacemos un "summarize" de todas las variables 
sum genero edad casado hijos 


************************
* VISUALIZAR VARIABLES *
************************

/* Los gráficos están comentados
para evitar que se abran cada 
vez que se ejecuta este .do */

** Histogramas
* Numéricas-discretas
//hist religiosidad
//hist religiosidad, color (purple) barw(0.9) discrete

* Numéricas-continuas
//hist edad
//hist edad, color (red) bin (25)

* DotPlop //gráfico con barras horizontales
//dotplot religiosidad 
//dotplot edad, color (green)

* Tarta
//graph pie, over(ecivil)

* CatPlot
//ssc install "catplot"
//catplot religion
//catplot religion, recast (bar)
//catplot religion, recast (dot)

******************
* Tarea 24/02/19 *
******************

* Autoposicionamiento ideológico *
tab lrscale
tab lrscale, nolabel
	*Renombrar
rename lrscale ideol
	*Recodificar
tab ideol, nolabel
	*Comprobar
tab ideol

* Ideol_rec
gen ideol_rec=0
replace ideol_rec=. if ideol==. //perdidos
replace ideol_rec=0 if ideol>=0 & ideol<=2 //ext-izq
replace ideol_rec=1 if ideol>=3 & ideol<=4 //izq
replace ideol_rec=2 if ideol==5 //centro
replace ideol_rec=3 if ideol>=6 & ideol<=7 //derecha
replace ideol_rec=4 if ideol>=8 & ideol<=10 //ext-der
tab ideol_rec
	*Etiquetamos
label define ideol_recv 0"Ext.izq" 1"Izquierda" 2"Centro" ///
3"Derecha" 4"Ext.derecha"
label values ideol_rec ideol_recv
tab ideol_rec

* Estudios *
tab eisced
tab eisced, nolabel
	*Crear la variable 'educacion' a partir de 'eisced'
gen educacion=0
replace educacion=0 if eisced>=0 & eisced<=2 //primaria
replace educacion=1 if eisced>=3 & eisced<=4 //secundaria
replace educacion=2 if eisced>=5 & eisced<=7 //terciaria
	*Etiquetamos
label define educacionv 0"Primaria" 1"Secundaria" ///
2"Terciaria" 
label values educacion educacionv
tab educacion
	*Comprobar
tab educacion

* Satisfacción con el gobierno *
tab stfgov
tab stfgov, nolabel
	*Renombrar
rename stfgov satisfgob
	*Recodificar
tab satisfgob, nolabel
	*Comprobar
tab satisfgob

* Satisfgob_rec
gen satisfgob_rec=0
replace satisfgob_rec=0 if satisfgob>=0 & satisfgob<=2 //nada
replace satisfgob_rec=1 if satisfgob>=3 & satisfgob<=4 //poco
replace satisfgob_rec=2 if satisfgob==5 //satisfecho
replace satisfgob_rec=3 if satisfgob>=6 & satisfgob<=7 //mucho
replace satisfgob_rec=4 if satisfgob>=8 & satisfgob<=10 //totalmente
tab satisfgob_rec
	*Etiquetamos
label define satisfgob_recv 0"Nada satisfecho" 1"Poco satisfecho" ///
2"Satisfecho" 3"Muy satisfecho" 4"Totalmente satisfecho"
label values satisfgob_rec satisfgob_recv
tab satisfgob_rec
	*Comprobar 
tab satisfgob_rec

*********************************
* Test de comparación de medias *
*********************************
* Documentación: https://www.stata.com/manuals13/rttest.pdf

* Ejemplo 1: Están los jovenes significativa menos satisfechos ///
// con la democracia que las personas mayores?
* Joven
gen joven=0 
replace joven=1 if edad<35
tab joven
*ttest
ttest satisfgob_rec, by(joven) 
ttest satisfgob_rec, by(joven) level(99) //N.C. 99%

* Ejemplo 2: Y las mujeres en comparación con los hombres?
ttest satisfgob_rec, by(genero) 

* Ejemplo 3: y los trabajadores frente al resto?
* Variable de actividad profesional
tab  mnactic  // Actividad principal
rename mnactic actividad
* Creamos varibable trabaja
gen trabaja=0
replace trabaja=1 if actividad==1  //trabajadores
replace trabaja=. if actividad>8   //casos perdidos
tab trabaja
*Etiquetamos
label define trabajav 0"No trabaja" 1"Trabaja"
label values trabaja tabajav
tab trabaja
*ttest
ttest satisfgob_rec, by(trabaja)
*Si queremos añadir más condiciones (p.ej., que sea mujer y joven)
ttest satisfgob_rec if genero==0 & joven==1, by(trabaja)

/// Falta sesión con gráficos


******************
*** 13/03/2019 ***
******************

****************************
** CORRELACIÓN DE PEARSON **
****************************

*Nota: las dos variables han de ser numéricas

*Correlación entre ideología y satisfacción con el gobierno actual
pwcorr satisfgob ideol

pwcorr satisfgob ideol,sig

pwcorr satisfgob ideol, sig star(0.01)

*Se puede calcular la correlación parcial entre variables
pwcorr satisfgob ideol edad, sig star(0.01) obs

****************************
** TABLAS DE CONTINGENCIA **
****************************
*NOTA: las dos variables tienen que ser categóricas

* Ejemplo 1: examinar la relación entre categorías

** Ocupación
tab isco08
tab isco08, nolabel
** ISCO: International Standar Classification of Ocupation
** Grandes grupos ocupacionales

/*Creamos la variable categoría ocupacional (ocup_cat) con:
	1. Alto status (directivos o profesionales)
	2. Medio status (tecnicos, servicios, ventas, administrativos)
	3. Bajo status (ocupaciones de cuello azul)
Nota: recuerda excluir las categorías 6 y 0) */

gen ocup_cat=0
replace ocup_cat=1 if isco08<3000 // managers y profesionales
replace ocup_cat=2 if isco08>=3000 & isco08<6000 // technic, cleric, service
replace ocup_cat=3 if isco08>=7000 & isco08<10000 // 
replace ocup_cat=. if isco08<1000 // perdidos
replace ocup_cat=. if isco08>=6000 & isco08<7000 // perdidos
replace ocup_cat=. if isco08>10000 // perdidos
tab ocup_cat

label define ocup_catv 1"Alto estatus" 2"Medio estatus" 3"Bajo estatus"
label values ocup_cat ocup_catv
tab ocup_cat

* Tabla básica, solo con frecuencias
tab ocup_cat genero

* Añadimos % columna (col), % fila (row)
tab ocup_cat genero, col row cell

* Si queremos ver las frecuencias esperadas
tab ocup_cat genero, expected

* Y si queremos ver si existe 
tab ocup_cat genero, chi2

/* Si queremos ver si las diferencias en cada celda son estadísticamente 
significativas. necesitamos los residuos ajustados.
Hay que instalar tabchi*/
ssc install tab_chi
* Y ahora, usamos el comando
tabchi ocup_cat genero, adjust


*****************************
** REGRESIÓN LINEAL SIMPLE **
*****************************

** 03 de abril de 2019 **

* El efecto del género en la ideología (VI: dicotomica)
reg ideol genero

* El efecto en la edad en la ideología (VI: continua)
reg ideol edad

* El efecto de la ocupación en la ideología (VI: categórica)
reg ideol i.ocup_cat
reg ideol ib3.ocup_cat

* El efecto cuadratico
	//De manera descriptiva (no permite introducir controles)
twoway qfit ideol edad

	//Elevamos la variable al cuadrado
gen edad2=edad^2

	// Introducimos ambos terminos en la regresion
reg ideol edad edad2

	// Usar # para la cuadratica
reg ideol c.edad##c.edad
qui margins, at(edad=(18/80))
marginsplot

************************************
** REGRESION LINEAL MULTIVARIANTE **
************************************
* Qué da la felicidad? 
* Ho1: El dinero
* Ho2: El amor
* Ho3: La salud

*Variable Dependiente: Felicidad
replace happy=. if happy>10

* Variables independientes
* VI Dinero
tab hinctnta
rename hinctnta ingresosh
replace ingresosh=. if ingresosh>10
* VI amor
tab casado
* VI salud
tab health
g salud=0
replace salud=1 if health<=2
replace salud=2 if health==3
replace salud=3 if health>=4 & health<=5
replace salud=. if health>5

label define saludv 1"Muy buena/Buena" 2"Regular" 3"Mala/Muy mala"
label values salud saludv
tab salud

** SUMMARIZE
sum happy casado ingresosh ib3.salud 

** CORR
corr happy casado ingresosh genero edad 

** REGRESION SIMPLE **
reg happy casado 
reg happy ingresosh
reg happy salud
reg happy i.salud // para controlar todas las respuestas

** REGRESION MULTIVARIANTE **
reg happy casado ingresosh i.salud

** Regresion multivariada con controles
reg happy casado ingresosh i.salud genero edad

** Regresion multivariada con controles y efecto cuadratico
reg happy casado ingresosh i.salud genero c.edad##c.edad

** COEFPLOT (requiere instalacion)
ssc install coefplot
coefplot
coefplot, drop(_cons) xline(0) mlabel format(%6.2g) mlabposition(10) mlabgap(*3) 
coefplot, drop(_cons) xline(0) mlabel format(%6.2g) mlabposition(10) ///
mlabgap(*3) graphregion(fcolor(white))

** COEFICIENTES ESTANDARIZADOS
reg happy casado ingresosh i.salud genero c.edad##c.edad, beta

* NORMALIDAD DE LOS RESIDUOS
predict res, resid  //calculamos residuos
kdensity res, normal  // comparamos la distribucion cn la normal.
pnorm res

* HETEROCEDASTICIDAD
rvfplot, yline(0) // representaci‚àö‚â•n gr‚àö¬∞fica
hettest // test

* MULTICOLINEALIDAD
vif

* VALORES PREDICHOS
predict yhat
sum yhat

* EFECTOS MARGINALES
	* Variable continua
margins, at(ingresos=(1/10))
marginsplot

margins, at(edad=(18/100))
marginsplot
	* Variable discreta
margins, at(genero=(0,1))
marginsplot

margins, at(salud=(1,2,3))
marginsplot, recastci(rline) ciopts(lpattern(dash)) graphregion(fcolor(white))


/* EXTRAER TABLA (requiere instalación)
 * Opciones a la hora de hacer las tablas: http://repec.org/bocode/e/estout/esttab.html*/  
estimates store m1, title(Felicidad)

esttab m1
esttab m1, se ar2 
esttab m1, se ar2 varwidth(25) label
esttab m1, se ar2 varwidth(45) label nobaselevels interaction(" X ")
esttab m1, se ar2 varwidth(45)  nobaselevels interaction(" X ") label ///
    title(Tabla de regresion lineal) ///
    nonumbers mtitles("Felicidad")     ///
    addnote("Source: ESS ES Round 8")

* Extraer tabla a txt
esttab using m1, se ar2 varwidth(45)  nobaselevels interaction(" X ") label ///
    title(Tabla de regresion lineal)      ///
    nonumbers mtitles("Felicidad")          ///
    addnote("Source: ESS ES Round 8")	  ///	
	replace
	
* Extraer tabla a rtf
esttab using m1.rtf, se ar2 varwidth(45)  nobaselevels interaction(" X ") label ///
    title(Tabla de regresión lineal)      ///
    nonumbers mtitles("Model 1")          ///
    addnote("Source: ESS ES Round 8")	  ///	
	varlabels(casado Casado ingresosh Ingresos_del_hogar 1.salud CR:Salud_muy_buena 2.salud Regular 3.salud Mala genero Hombre edad Edad _cons Constante) ///
	replace

* Si tuviesemos varios modelos
reg happy casado 
estimates store m1
reg happy ingresosh
estimates store m2
reg happy i.salud
estimates store m3
reg happy casado ingresosh i.salud
estimates store m4
reg happy casado ingresosh i.salud genero c.edad##c.edad, beta
estimates store m5
	
* Extraer tabla a rtf
esttab m1 m2 m3 m4 m5, se ar2 varwidth(45)  nobaselevels interaction(" X ") label ///
    title(Tabla de regresión lineal)      ///
    nonumbers mtitles("Model 1")          ///
    addnote("Source: ESS ES Round 8")	  ///	
	varlabels(casado Casado ingresosh Ingresos_del_hogar 1.salud CR:Salud_muy_buena 2.salud Regular 3.salud Mala genero Hombre edad Edad _cons Constante) 
	
* Combinar modelos en coefplot
coefplot m4 m5, drop(_cons) xline(0) 
coefplot m4 m5, drop(_cons) xline(0) mlabel format(%6.2g) mlabposition(10) mlabgap(*3)



********************************************
* CINCO GRAFICOS SOBRE LOS VOTANTES DE VOX *
********************************************

** Post de Ariane Aumaitre en Piedras de Papel **

** DATOS: Preelectoral 2019
use "C:\Users\mario\Cosas\Universidad\Stata14\Preelectoral.dta",clear 
set more off


** VARIABLE DEPENDIENTE -----------------------------------------------  **
**  Intencion de voto -------------------------------------------------- **
tab p10r
tab p10r, nolabel          // vox=18
rename p10r int_voto

**  Dummy para voto_VOX (0-1) ----------------------------------------------- **
g voto_vox=0 if int_voto!=.
replace voto_vox=1 if int_voto==18 
/* Nota: lo correcto seria eliminar 
								      abstencionistas + indecisos*/

label define voto_voxv 0"No" 1"Si"
label values voto_vox voto_voxv
tab voto_vox


** PERFIL SOCIO-DEOMOGRAFICO DE LOS VOTANTES DE VOX ------------------------- **
** 1.Perfil de Genero --------------------------------------------------------- **
*  Hombre
tab p22                    
tab p22, nolabel
g hombre=p22
recode hombre 2=0             // 0 = mujer; 1 = hombre

label define hombrev 0"Mujer" 1"Hombre"
label values hombre hombrev
tab hombre

*  Porcentaje de votantes de Vox que son hombres/mujeres
tab voto_vox hombre, col

*  Figura 1: diferencia en la proporcion de votantes hombres y mujeres por partido
tab int_voto hombre, row    // la resta H-M nos da la diferencia


** 2.Perfil de Edad ----------------------------------------------------------- **
*  Edad
tab p23		             
generate edad_rec=0
replace edad_rec=1 if p23<=30
replace edad_rec=2 if p23>=31 & p23<=50
replace edad_rec=3 if p23>=51 & p23<=65
replace edad_rec=4 if p23>65
tab edad_rec

label define edad_recv 1"<=30" 2"31-50" 3"51-65" 4">65"
label values edad_rec edad_recv

*  Figura voto a vox por grupo de edad
graph bar voto_vox, over(edad_rec)


** 3.Preocupacion por la independencia entre los votantes de VOX -------------- **
g cat_problema=0
replace cat_problema=1 if p601==45 | p602==45 | p603==45
tab cat_problema
tab voto_vox cat_problema, col

label define cat_problemav 1"Si" 0"No"
label values cat_problema cat_problemav

* Figura
graph bar voto_vox, over(cat_problema)


** 4.Perfil ocupacional de los votantes de VOX  ------------------------------- **
tab p25a
rename p25a ocupacion
replace ocupacion=. if ocupacion>11
tab ocupacion

graph bar voto_vox, over(ocupacion, sort(1) descending) //ordenar
/* Las etiquetas son muy largas. Se pueden editar y poner en vertical. Tambien 
   reducir el tamanyo de la letra y/o seccionar el texto. Otra opcion es 
   puede optar por grafico de barras horizontal (hbar) */ 
 
ssc install splitvallabels
splitvallabels ocupacion
graph bar voto_vox, ///
over(ocupacion, sort(1) descending label(labsize(tiny)) relabel(`r(relabel)')) ///
ytitle("% Voto a Vox", size(vsmall)) ///
title("% Voto a Vox segun ocupacion")


** REGRESION LINEAL --------------------------------------------------------- **
*  Preparacion de variales independientes ----------------------------------- **
*  Edad
rename p23 edad
sum  edad

*  Preopcupacion por la independencia
sum cat_problema

*  Mujer
tab p22                    
tab p22, nolabel
g mujer=1
replace mujer=0 if p22==1
tab mujer 

label define mujerv 1"Mujer" 0"Hombre"
label values mujer mujerv

*  Estudios superiores
tab p24a
g estudios_superiores=0 
replace estudios_superiores=1 if p24a>=7 & p24a<=9
replace estudios_superiores=. if p24a>=10

label define estudiosv 0"Sin estudios superiores" 1"Con estudios superiores"
label values estudios_superiores estudiosv
tab estudios_superiores


*  Espanya vacia
tab tamuni
generate esp_vacia=0
replace esp_vacia=1 if tamuni<=2
tab esp_vacia

label define esp_vaciav 1">10.000" 0"<=10.000"
label values esp_vacia esp_vaciav

* Ocupacion
g trabajador_manual=0
replace trabajador_manual=1 if ocupacion>=7 & ocupacion<=9
replace trabajador_manual=. if ocupacion==.

label define manualv 1"Trabajador manual" 0"Otros"
label values trabajador_manual manualv

g profesion_militar=0
replace profesion_militar=1 if ocupacion==10
replace profesion_militar=. if ocupacion==.

label define militarv 1"Militar" 0"Otros"
label values profesion_militar militarv

g profesion_agraria=0
replace profesion_agraria=1 if ocupacion==6
replace profesion_agraria=. if ocupacion==.

label define agrariav 1"Prof. Agraria" 0"Otros"
label values profesion_agraria agrariav

* Regresion *
reg voto_vox mujer edad cat_problema trabajador_manual profesion_militar profesion_agraria estudios_superiores esp_vacia

* Extraer tabla *
estimates store m1
esttab m1, se ar2 varwidth(45)  nobaselevels interaction(" X ") label ///
    title(Tabla de regresión lineal)      ///
    nonumbers mtitles("Voto a Vox")          ///
    addnote("Source: CIS 3242")	  ///	
	varlabels(hombre Hombre edad Edad cat_problema Preocupacion_por_la_independencia trabajador_manual Trabajador_Manual ///
	profesion_militar Profesion_Militar profesion_agraria Profesion_Agraria estudios_superiores Estudios_Superiores ///
	esp_vacia Espanya_vacia _cons Constante) 

	
** Comparacion con el resto de partidos **
*  Creamos dummies para los diferentes partidos 
*  Voto PP        
g voto_pp=0 if int_voto!=.
replace voto_pp=1 if int_voto==1

* Voto PSOE
g voto_psoe=0 if int_voto!=.
replace voto_psoe=1 if int_voto==2

*  Voto Cs
g voto_cs=0 if int_voto!=.
replace voto_cs=1 if int_voto==4

*  Voto UP 	
g voto_up=0 if int_voto!=.
replace voto_up=1 if int_voto==3


* Regresiones para los diferentes partidos y guardamos resultados *
reg voto_pp mujer edad cat_problema trabajador_manual profesion_militar profesion_agraria estudios_superiores esp_vacia
estimates store m2
reg voto_psoe mujer edad cat_problema trabajador_manual profesion_militar profesion_agraria estudios_superiores esp_vacia
estimates store m3
reg voto_cs mujer edad cat_problema trabajador_manual profesion_militar profesion_agraria estudios_superiores esp_vacia
estimates store m4
reg voto_up mujer edad cat_problema trabajador_manual profesion_militar profesion_agraria estudios_superiores esp_vacia
estimates store m5


* Pintamos los coeficientes *
coefplot m1 m2 m3 m4 m5, drop(_cons) xline(0) mlabel format(%4.2g) mlabposition(10) mlabgap(*1)


** IMPROVING THE MODEL **	
** Posible efecto no lineal de la edad?  **
twoway qfit voto_vox edad

*  Introducimos edad al cuadrado en la regresion
reg voto_vox mujer c.edad##c.edad cat_problema trabajador_manual profesion_militar profesion_agraria estudios_superiores esp_vacia

*  Efectos marginales
qui margins, at(edad=(18/100))
marginsplot    // los resultados confirman que el efecto de la edad no es lineal

* Extraemos tabla
estimates store m1b
esttab m1b, se ar2 varwidth(45)  nobaselevels interaction(" X ") label ///
    title(Tabla de regresion lineal)      ///
    nonumbers mtitles("Voto a Vox (II)")          ///
    addnote("Source: CIS 3242")	  ///	
	varlabels(mujer Mujer edad Edad(cuadrado) c.edad#c.edad Edad2 cat_problema Preocupacion_por_la_independencia trabajador_manual Trabajador_Manual ///
	profesion_militar Profesion_Militar profesion_agraria Profesion_Agraria estudios_superiores Estudios_Superiores ///
	esp_vacia Espanya_vacia _cons Constante) 
	
	
** Recodificaci�n de la variable dependentiente **
* Eliminamos de la VD a los individuos que NO van a votar
tab int_voto, nolabel
replace int_voto=. if int_voto>=77

*  Dummy para voto_VOX (0-1) 
g voto_vox2=0 if int_voto!=.
replace voto_vox2=1 if int_voto==18  
replace voto_vox2=. if int_voto==.

* Estimamos la regresion con la nueva VD
reg voto_vox2 mujer c.edad##c.edad cat_problema trabajador_manual profesion_militar profesion_agraria estudios_superiores esp_vacia

* Extraemos tabla
estimates store m1c
esttab m1c, se ar2 varwidth(45)  nobaselevels interaction(" X ") label ///
    title(Tabla de regresion lineal)      ///
    nonumbers mtitles("Voto a Vox (II)")          ///
    addnote("Source: CIS 3242")	  ///	
	varlabels(mujer Mujer edad Edad(cuadrado) c.edad#c.edad Edad2 cat_problema Preocupacion_por_la_independencia trabajador_manual Trabajador_Manual ///
	profesion_militar Profesion_Militar profesion_agraria Profesion_Agraria estudios_superiores Estudios_Superiores ///
	esp_vacia Espanya_vacia _cons Constante) 
	
	

*************************
** COMBINING DATA SETS **
*************************

* Creamos dataset padres
clear
input famid str8 name inc
2 "Juan" 22000
1 "Pedro" 30000
3 "Pablo" 25000
4 "Jose" 27000
end
save padres, replace
list 

* Creamos datasets madres
clear  //sirve para cerrar el datset anterior
input famid str8 name inc
1 "Marta" 15000
3 "Paula" 50000
2 "Silvia" 18000
3 "Laura" 20000
end
save madres, replace
list 

*****************************
* APPEND: suma los datasets *
*****************************
use padres, clear 
append using madres
list 

//Si queremos crear una variable para diferenciar padres de madres
use padres, clear 
generate str5 madrepadre = "padre" 
save padres1 

use madres, clear 
generate str5 madrepadre= "madre" 
save madres1 

use padres1, clear 
append using madres1 

list 

*****************************
* MERGE                     *
*****************************

** ONE-TO-ONE **
*Atribuir a cada individuo del data set 1 un valor del data set 2

use padres, clear 
list  
 
clear
input famid str11 ingresosh96 ingresosh97 ingresosh98
3 75000 76000 77000
1 40000 40500 41000
2 65000 65400 65800
4 58200 58600 58000
end
save ingresosh, replace
list 

/* Queremos combinar ambos datasets, anyadiendo al 1 las variables del 2
Famid es la variable "identificadora", que nos va a servir para vincular ///
las observaciones del primer
dataset con las del segundo.
El proceso tiene 4 pasos:

1. Paso1: Ordenar el dataset "padres" por famid (identificador) y ///
guardar el dataset (padres_m)

2. Paso2: Ordenar el dataset "ingresosh" por famid (identificador) y ///
guardar el datset (ingresosh_m)

3. Paso3: Abrir el dataset padres_m

4. Paso4: "Mergear" el dataset padres_m con ingresosh_m ///
usando famid para emparejar las observaciones*/

* Paso 1
use padres, clear 
sort famid 
save padres_m 
 
*Paso 2
use ingresosh, clear 
sort famid 
save ingresosh_m

*Paso 3
use padres_m, clear 

*Paso 4
merge famid using ingresosh_m 
list
      
/*La variable _merge indica como ha funcionado el merge. 
S�lo puede tener 3 valores:
1: Habia informacion en el dataset1 pero no en el dataset2
2: Habia informacion en el dataset2 pero no en el dataset1
3: habia informacion en ambos dataset*/
 
	  
	  
** MANY-TO-ONE **

/* Tambien existen lo que se llamar one-to-many. Por ejemplo, ///
en el caso de que queramos mergear padres con hijos, ///
dado que cada padre puede tener m�ltiples hijos"

La estrategia es la misma que en el caso anterior:
1. Paso1: Ordenar el dataset "padres" por famid (identificador)///
y guardar el dataset (padres_m2)

2. Paso2: Ordenar el dataset "hijos" por famid (identificador) ///
y guardar el datset (hijos_m2)

3. Paso3: Abrir el dataset padres_m2

4. Paso4: "Mergear" el dataset padres_m con hijos_m2 ///
usando famid para emparejar las observaciones*/
 
* Paso 1
use padres, clear 
sort famid 
save padres_m3
list 

*Paso 2
 clear
 input famid str8 hijo_name orden edad cm str1 sexo
1 "Julia" 1 9 160 "m"
2 "Andres" 1 8 140 "h"
3 "Carla" 1 6 120 "m"
1 "Carlos" 2 6 180 "h"
1 "Cesar" 3 3 150 "h"
2 "Almudena" 2 6 120 "m"
2 "Marcos" 3 2 160 "h"
3 "Almudena" 2 14 40 "m"
3 "Felipe" 3 2 120 "h"
end

sort famid 
save hijos_m3, replace
list 
        
*Paso 3
use padres_m3, clear 

*Paso 4 
merge famid using hijos_m3
list famid name hijo_name orden edad _merge 

/* Para facilitar la visualizacion, podemos ordenar 
los datos por famid y orden de nacimiento */
sort famid orden
list 
