** Populismo y pasado autocrático **
** Pol. Comp II / Mayo 2021 **

	// Cambiar ruta
use "C:\Users\Álvaro\Dropbox\UC3M\4º\2º cuatrimestre\Política Comparada II\es_data-v3.dta", clear

* Ver variables a usar
tab country
tab legislative_type
tab year

** LIMPIEZA DE VARIABLES **

* Quedarnos con las variables necesarias
keep if year>=2010
keep if country=="Albania" | country=="Armenia" | country=="Argentina" ///
| country=="Austria" | country=="Belgium" | country=="Bolivia" ///
| country=="Brazil" | country=="Bulgaria" ///
| country=="Chile" | country=="Colombia" | country=="Costa Rica" ///
| country=="Croatia" | country=="Cuba" | country=="Czech Republic" ///
| country=="Denmark" | country=="Ecuador" | country=="El Salvador" ///
| country=="Estonia" | country=="Finland" | country=="France" ///
| country=="Georgia" | country=="Germany" | country=="Greece" ///
| country=="Greek Cyprus" | country=="Guatemala" | country=="Honduras" ///
| country=="Hungary" | country=="Italy" | country=="Ireland" ///
| country=="Iceland" | country=="Jamaica" | country=="Latvia" ///
| country=="Lithuania" | country=="Liechtenstein" | country=="Macedonia" ///
| country=="Malta" | country=="Mexico" | country=="Moldova" ///
| country=="Netherlands" | country=="Nicaragua" | country=="Norway" ///
| country=="Panama" | country=="Paraguay" | country=="Peru" ///
| country=="Poland" | country=="Portugal" | country=="Romania" ///
| country=="San Marino" | country=="Serbia" | country=="Slovakia" ///
| country=="Slovenia" | country=="Spain" | country=="Sweden" ///
| country=="Switzerland" | country=="Turkey" | country=="Ukraine" ///
| country=="United Kingdom" | country=="Uruguay" ///
| country=="Venezuela" | country=="San Marino"| country=="Luxembourg"

	// Reetiquetar sistema electoral
g sistelect=legislative_type
destring sistelect, replace ignore("NA")
tab sistelect

label define electoral 1"Mayoritario" 2"Proporcional" 3"Mixto"
label values sistelect electoral
tab sistelect, nolabel

g sistema=sistelect
replace sistema=0 if sistelect==1 | sistelect==3
replace sistema=1 if sistelect==2
tab sistema

label define elecdum 0"No proporcional" 1"Proporcional"
label values sistema elecdum
tab sistema

** GENERACIÓN DE VARIABLES **

* Variable % partidos populistas
g apoyopop=0
replace apoyopop=.6833 if country=="Hungary"
replace apoyopop=.336 if country=="Albania"
replace apoyopop=.0826 if country=="Armenia"
replace apoyopop=.221 if country=="Argentina"
replace apoyopop=.162 if country=="Austria"
replace apoyopop=.24 if country=="Belgium"
replace apoyopop=.14 if country=="Bolivia"
replace apoyopop=.404 if country=="Bosnia Herzegovina"
replace apoyopop=.224 if country=="Brazil"
replace apoyopop=.459 if country=="Bulgaria"
replace apoyopop=.458 if country=="Colombia"
replace apoyopop=.3451 if country=="Costa Rica"
replace apoyopop=.1315 if country=="Croatia"
replace apoyopop=.402 if country=="Czech Republic"
replace apoyopop=.111 if country=="Denmark"
replace apoyopop=.0769 if country=="Ecuador"
replace apoyopop=.1747 if country=="El Salvador"
replace apoyopop=.175 if country=="Finland"
replace apoyopop=.0885 if country=="France"
replace apoyopop=.126 if country=="Germany"
replace apoyopop=.037 if country=="Greece"
replace apoyopop=.089 if country=="Greek Cyprus"
replace apoyopop=.156 if country=="Guatemala"
replace apoyopop=.217 if country=="Italy"
replace apoyopop=.2220 if country=="Ireland"
replace apoyopop=.178 if country=="Iceland"
replace apoyopop=.0828 if country=="Luxembourg"
replace apoyopop=.4279 if country=="Jamaica"
replace apoyopop=.3517 if country=="Latvia"
replace apoyopop=.0485 if country=="Lithuania"
replace apoyopop=.1114 if country=="Liechtenstein"
replace apoyopop=.0895 if country=="Macedonia"
replace apoyopop=.024 if country=="Mexico"
replace apoyopop=.0957 if country=="Moldova"
replace apoyopop=.149 if country=="Netherlands"
replace apoyopop=.152 if country=="Norway"
replace apoyopop=.3975 if country=="Panama"
replace apoyopop=.35 if country=="Paraguay"
replace apoyopop=.3682 if country=="Peru"
replace apoyopop=.504 if country=="Poland"
replace apoyopop=.013 if country=="Portugal"
replace apoyopop=.0535 if country=="Romania"
replace apoyopop=.0383 if country=="Serbia"
replace apoyopop=.086 if country=="Slovakia"
replace apoyopop=.291 if country=="Slovenia"
replace apoyopop=.159 if country=="Spain"
replace apoyopop=.1753 if country=="Sweden"
replace apoyopop=.264 if country=="Switzerland"
replace apoyopop=.5366 if country=="Turkey"
replace apoyopop=.1219 if country=="Ukraine"
replace apoyopop=.0108 if country=="Uruguay"
tab apoyopop

g apoyopoprec=0
replace apoyopoprec=1 if apoyopop>=.01 & apoyopop<.10 // <10%
replace apoyopoprec=2 if apoyopop>=.10 & apoyopop<.15 // 10-15%
replace apoyopoprec=3 if apoyopop>=.15 & apoyopop<.20 // 15-20%
replace apoyopoprec=4 if apoyopop>=.20 & apoyopop<.25 // 20-25%
replace apoyopoprec=5 if apoyopop>=.25 // >25%
tab apoyopoprec

label define apoyo 0"No partpop" 1"<10% voto" 2"Entre 10-15% voto" ///
3"Entre 15-20% voto" 4"Entre 20-25% voto" 5">25% voto"
label values apoyopoprec apoyo
tab apoyopoprec

* Variable tipo circunscripción
g circuns=0
replace circuns=1 if country=="Serbia" | country=="Slovakia" ///
| country=="Ukraine" | country=="Uruguay"

label define circunsv 0"Múltiple" 1"Única"
label values circuns circunsv
tab circuns

* Variable pasado autocrático
g pasaut=0
replace pasaut=1 if country=="Armenia" | country=="Argentina" ///
| country=="Austria" | country=="Bolivia" | country=="Brazil" ///
| country=="Bulgaria" | country=="Chile" | country=="Colombia" ///
| country=="Costa Rica" | country=="Croatia" | country=="Cuba" ///
| country=="Czech Republic" | country=="Ecuador" | country=="El Salvador" ///
| country=="Estonia" | country=="Georgia" | country=="Germany" ///
| country=="Greece" | country=="Greek Cyprus" | country=="Guatemala" ///
| country=="Honduras" | country=="Hungary"| country=="Italy" ///
| country=="Jamaica" | country=="Latvia" | country=="Lithuania" ///
| country=="Macedonia" | country=="Malta" | country=="Mexico" ///
| country=="Moldova" | country=="Nicaragua" | country=="Panama" ///
| country=="Paraguay" | country=="Peru" | country=="Poland" ///
| country=="Portugal" | country=="Romania" | country=="Serbia" ///
| country=="Slovakia" | country=="Slovenia" | country=="Spain" ///
| country=="Turkey" | country=="Ukraine" | country=="Uruguay" ///
| country=="Venezuela" | country=="Albania"

label define past 0"Sin pasado aut" 1"Pasado autocrático"
label values pasaut past
tab pasaut

* Variable rol IIGM y reelaboración pasado
    // Generar variable dummy países solo Europa
g europadummy=0
replace europa=1 if country=="Albania" | country=="Armenia" ///
| country=="Austria" | country=="Belgium" | country=="Bulgaria" ///
| country=="Croatia" | country=="Czech Republic" | country=="Denmark" ///
| country=="Estonia" | country=="Finland" | country=="France" ///
| country=="Georgia" | country=="Germany" | country=="Greece" ///
| country=="Greek Cyprus" | country=="Hungary" | country=="Italy" ///
| country=="Ireland" | country=="Iceland" | country=="Latvia" ///
| country=="Lithuania" | country=="Liechtenstein" | country=="Luxembourg" ///
| country=="Macedonia" | country=="Malta" | country=="Moldova" ///
| country=="Netherlands" | country=="Norway" | country=="Poland" ///
| country=="Portugal" | country=="Romania" | country=="San Marino" ///
| country=="Serbia" | country=="Slovakia" | country=="Slovenia" ///
| country=="Spain" | country=="Sweden" | country=="Switzerland" ///
| country=="Turkey" | country=="United Kingdom"
tab europadummy

label define eudummy 0"Latinoamérica" 1"Europa"
label values europadummy eudummy
tab europadummy

    // Generar variable Europa
g europa=europadummy
replace europa=. if europadummy==0
tab europa

label define eu 1"Europa"
label values europa eu
tab europa

g eugm=europa
replace eugm=. if eugm==0
replace eugm=0 if europa==1
tab eugm

    // Generar variable reelaboración y pasado IIGM
g reelab=eugm
replace reelab=1 if country=="Albania" | country=="Armenia" ///
| country=="Georgia" | country=="Greek Cyprus" | country=="Moldava" ///
| country=="Portugal" | country=="United Kingdom"
replace reelab=2 if country=="Bulgaria" | country=="Croatia" ///
| country=="Ukraine"

label define reelabvv 0"Cancelación y victimización" ///
1"Culpabilizacion y heroización" 2"Heroización inversa"
label values reelab reelabvv
tab reelab

	// Crear otra para quitar Heroización inversa que rompe dummy
g reelabpas=reelab
replace reelabpas=1 if reelab==0
replace reelabpas=0 if reelab==1
replace reelabpas=. if reelab==2
tab reelabpas

label define reelabpasv 0"Culpabilización y heroización" ///
1"Cancelación y victimización"
label values reelabpas reelabpasv

** ANÁLISIS **
	* H1: pasado autoritario
tab apoyopoprec pasaut
ttest apoyopoprec, by(pasaut) // no significativo

	* H2: sistema electoral
tab apoyopoprec circuns
tab apoyopoprec sistema 
reg apoyopoprec circuns // significativo
reg apoyopoprec sistema // significativo

	* H3: rol IIGM y post
tab apoyopoprec reelabpas
reg apoyopoprec reelabpas // significativísimo




