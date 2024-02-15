/* ------------------------------------------------------------------------------
Nombre de la base de datos: BD_corrupcion
-------------------------------------------------------------------------------*/


/*------------------------------------------------------------------------------ 
Definición de la estructura de la base de datos
-------------------------------------------------------------------------------*/

--- Creación BD

BEGIN
	USE MASTER
	DROP DATABASE IF EXISTS BD_corrupcion
END
GO
 
CREATE DATABASE BD_corrupcion
GO

USE BD_corrupcion
GO

--- Borrar tablas

DROP TABLE IF EXISTS persona;
DROP TABLE IF EXISTS juez;
DROP TABLE IF EXISTS implicado;
DROP TABLE IF EXISTS periodico;
DROP TABLE IF EXISTS ambito_caso;
DROP TABLE IF EXISTS caso_corrupcion;
DROP TABLE IF EXISTS dictamen;
DROP TABLE IF EXISTS partido_politico;
DROP TABLE IF EXISTS telefono;
DROP TABLE IF EXISTS afinidad;
DROP TABLE IF EXISTS pertenece;
DROP TABLE IF EXISTS es_pariente;
DROP TABLE IF EXISTS cargo;
DROP TABLE IF EXISTS imputacion;
DROP TABLE IF EXISTS caso_juez_update;


--- Creación de tablas

/*TABLE PERSONA*/
CREATE TABLE persona
(
    id_persona int not null,
    nombre varchar(50) not null,
    apellido1 varchar(50) not null,
    apellido2 varchar(50),
    calle varchar(50) not null,
    numero smallint not null,
    piso smallint,
    puerta char(2),
    ciudad varchar(30) not null,
    PRIMARY KEY(id_persona)
);

/*TABLE JUEZ*/
CREATE TABLE juez
(
    id_juez int not null,
    id_persona int UNIQUE not null,
    fecha_nacimiento date not null,
    fecha_inicio date not null,
    PRIMARY KEY(id_juez),
    FOREIGN KEY(id_persona)REFERENCES persona(id_persona)
);


/*TABLE IMPLICADO*/
CREATE TABLE implicado
(
    dni char(9) not null,
    id_persona int UNIQUE not null,
    patrimonio bigint not null,
    PRIMARY KEY(dni),
    FOREIGN KEY(id_persona)REFERENCES persona(id_persona)
);

/*TABLE PERIODICO
En el campo formato y ambito_periodico se usara el constraint CHECK para limitar el rango de valores que pueden colocarse en las respectivas columnas.*/
CREATE TABLE periodico
(
    id_periodico varchar(30) not null,
    calle varchar(50) not null,
    numero smallint not null,
    piso smallint,
    puerta char(2),
    ciudad varchar(30) not null,
    formato varchar(7) not null CHECK(formato IN('papel','digital')) ,
    pagina_web varchar(255),
    ambito_periodico varchar(13) not null CHECK(ambito_periodico IN('local','comarcal','nacional','internacional')),
    PRIMARY KEY(id_periodico)
);

/*TABLE CASO_CORRUPCION*/
CREATE TABLE caso_corrupcion
(
    id_caso varchar(50) not null,
    descripcion varchar(255) not null,
    desvio_mll bigint not null,
    fecha_descubre date not null,
    id_juez int not null,
    id_periodico varchar(30) not null,
    PRIMARY KEY(id_caso),
    FOREIGN KEY(id_juez)REFERENCES juez(id_juez),
    FOREIGN KEY(id_periodico)REFERENCES periodico(id_periodico)    
);

/*TABLE AMBITO_CASO*/
CREATE TABLE ambito_caso
(
    id_ambito int not null,
    id_caso varchar(50) not null,
    ambito varchar(20) not null,
    PRIMARY KEY(id_ambito),
    FOREIGN KEY(id_caso) REFERENCES caso_corrupcion(id_caso)
);

/*TABLE DICTAMEN*/
CREATE TABLE dictamen
(
    id_dictamen varchar(30) not null,
    fecha_dictamen date not null,
    documento_dictamen varchar(255) not null,
    id_juez int not null,
    id_caso varchar(50) not null,
    PRIMARY KEY(id_dictamen),
    FOREIGN KEY(id_juez)REFERENCES juez(id_juez),
    FOREIGN KEY(id_caso)REFERENCES caso_corrupcion(id_caso)
);

/*TABLE PARTIDO_POLITICO*/
CREATE TABLE partido_politico
(
    id_partido varchar(50) not null,
    calle varchar(50) not null,
    numero smallint not null,
    piso smallint,
    puerta char(2),
    ciudad varchar(30) not null,
	PRIMARY KEY(id_partido)
);

/*TABLE TELEFONO*/
CREATE TABLE telefono
(
    id_numero int not null,
    id_partido varchar(50) not null,
    telefono varchar(9)
    PRIMARY KEY(id_numero),
    FOREIGN KEY(id_partido)REFERENCES partido_politico(id_partido)
);

/*TABLE AFINIDAD*/
CREATE TABLE afinidad
(
    id_partido varchar(50) not null,
    id_periodico varchar(30) not null,
    PRIMARY KEY(id_partido, id_periodico),
    FOREIGN KEY(id_partido)REFERENCES partido_politico(id_partido),
    FOREIGN KEY(id_periodico)REFERENCES periodico(id_periodico)
);

/*TABLE PERTENECE 
De la relacion entre las entidades partido_politico e implicado*/
CREATE TABLE pertenece
(
    dni char(9) not null,
    id_partido varchar(50) not null,
    puesto varchar(50) not null,
    PRIMARY KEY(dni,id_partido),
    FOREIGN KEY(dni)REFERENCES implicado(dni),
    FOREIGN KEY(id_partido)REFERENCES partido_politico(id_partido)
);

/*TABLE ES_PARIENTE*/
CREATE TABLE es_pariente
(
    id_relacion int not null,
    id_implicado char(9) not null,
    id_implicado_pariente char(9) not null,
    tipo_relacion varchar(20) not null,
    PRIMARY KEY(id_relacion),
    FOREIGN KEY(id_implicado)REFERENCES implicado(dni),
    FOREIGN KEY(id_implicado_pariente)REFERENCES implicado(dni)
);

/*TABLE CARGO valores del cargo imputado a un implicado en un caso*/
CREATE TABLE cargo
(
    id_cargo int not null,
    tipo_cargo varchar(30) not null,
    PRIMARY KEY(id_cargo)
);

/*TABLE IMPUTACION deonde se guarda la información del dni del implicado, el caso en el que está involucrado y el cargo imputado*/
CREATE TABLE imputacion
(
    dni char(9) not null,
    id_caso varchar(50) not null,
    id_cargo int not null,
    PRIMARY KEY(dni,id_caso),
    FOREIGN KEY(dni)REFERENCES implicado(dni),
    FOREIGN KEY(id_caso) REFERENCES caso_corrupcion(id_caso),
    FOREIGN KEY(id_cargo) REFERENCES cargo(id_cargo)
);

/*Inserción de datos
------------------------------------------------------------------------------*/

/*TABLE PERSONA acepta valores NULL*/

INSERT INTO persona(id_persona,nombre,apellido1,apellido2,calle,numero,piso,puerta,ciudad) VALUES ('1000','Maria del Pilar','Albujar','Sanchez','Calle nombre','12','1','1D','Barcelona');
INSERT INTO persona(id_persona,nombre,apellido1,apellido2,calle,numero,piso,puerta,ciudad) VALUES ('1001','Juan Carlos','Alia','Pino','Calle nombre','734','3','3B','Sevilla');
INSERT INTO persona(id_persona,nombre,apellido1,apellido2,calle,numero,piso,puerta,ciudad) VALUES ('1002','Maria Paz','Andrades',NULL,'Calle nombre','899',NULL,NULL,'Madrid');
INSERT INTO persona(id_persona,nombre,apellido1,apellido2,calle,numero,piso,puerta,ciudad) VALUES ('1003','Jose Luis','Baltar','Pumar','Calle nombre','836',NULL,NULL,'Barcelona');
INSERT INTO persona(id_persona,nombre,apellido1,apellido2,calle,numero,piso,puerta,ciudad) VALUES ('1004','Luis Francisco','Barcenas','Gutierrez','Calle nombre','977',NULL,NULL,'Madrid');
INSERT INTO persona(id_persona,nombre,apellido1,apellido2,calle,numero,piso,puerta,ciudad) VALUES ('1005','Antonio','Barrientos','Gonzalez','Calle nombre','696',NULL,NULL,'Madrid');
INSERT INTO persona(id_persona,nombre,apellido1,apellido2,calle,numero,piso,puerta,ciudad) VALUES ('1006','Fernando','Blanco','Ortiz','Calle nombre','912',NULL,NULL,'Tenerife');
INSERT INTO persona(id_persona,nombre,apellido1,apellido2,calle,numero,piso,puerta,ciudad) VALUES ('1007','Miguel Angel','Bonet','Fiol','Calle nombre','721',NULL,NULL,'Sevilla');
INSERT INTO persona(id_persona,nombre,apellido1,apellido2,calle,numero,piso,puerta,ciudad) VALUES ('1008','Maria Margarita','Borbon Dos Sicilias','Lubomirska','Calle nombre','839',NULL,NULL,'Madrid');
INSERT INTO persona(id_persona,nombre,apellido1,apellido2,calle,numero,piso,puerta,ciudad) VALUES ('1009','Maria Inmaculada','Borbon Dos Sicilias','Lubomirska','Calle nombre','948',NULL,NULL,'Madrid');
INSERT INTO persona(id_persona,nombre,apellido1,apellido2,calle,numero,piso,puerta,ciudad) VALUES ('1010','Luis Antonio','Botella','de las Heras','Calle nombre','513',NULL,NULL,'Galicia');
INSERT INTO persona(id_persona,nombre,apellido1,apellido2,calle,numero,piso,puerta,ciudad) VALUES ('1011','Andres','Carrillo','Arana','Calle nombre','567','10','D','Sevilla');
INSERT INTO persona(id_persona,nombre,apellido1,apellido2,calle,numero,piso,puerta,ciudad) VALUES ('1012','Sonia','Castedo','Ramos','Calle nombre','553',NULL,NULL,'Sevilla');
INSERT INTO persona(id_persona,nombre,apellido1,apellido2,calle,numero,piso,puerta,ciudad) VALUES ('1013','Ivan','Castillo','Gonzales','Calle nombre','666','7','C','Andalucia');
INSERT INTO persona(id_persona,nombre,apellido1,apellido2,calle,numero,piso,puerta,ciudad) VALUES ('1014','Manuel','Chaves',NULL,'Calle nombre','574',NULL,NULL,'Madrid');
INSERT INTO persona(id_persona,nombre,apellido1,apellido2,calle,numero,piso,puerta,ciudad) VALUES ('1015','Paula','Chaves',NULL,'Calle nombre','900',NULL,NULL,'Madrid');
INSERT INTO persona(id_persona,nombre,apellido1,apellido2,calle,numero,piso,puerta,ciudad) VALUES ('1016','Susana','Coloma','Rios','Calle nombre','234','2','2A','Madrid');
INSERT INTO persona(id_persona,nombre,apellido1,apellido2,calle,numero,piso,puerta,ciudad) VALUES ('1017','Gerardo Jesus','Conde','Roa','Calle nombre','835',NULL,NULL,'Barcelona');
INSERT INTO persona(id_persona,nombre,apellido1,apellido2,calle,numero,piso,puerta,ciudad) VALUES ('1018','Francisco','Correa','Sanchez','Calle nombre','844',NULL,NULL,'Madrid');
INSERT INTO persona(id_persona,nombre,apellido1,apellido2,calle,numero,piso,puerta,ciudad) VALUES ('1019','Jose Ignacio','Crespo','De Lucas','Calle nombre','795',NULL,NULL,'Madrid');
INSERT INTO persona(id_persona,nombre,apellido1,apellido2,calle,numero,piso,puerta,ciudad) VALUES ('1020','Cristina','de Borbon','y Grecia','Calle nombre','714',NULL,NULL,'Sevilla');
INSERT INTO persona(id_persona,nombre,apellido1,apellido2,calle,numero,piso,puerta,ciudad) VALUES ('1021','Pedro','de Gea',NULL,'Calle nombre','881',NULL,NULL,'Asturias');
INSERT INTO persona(id_persona,nombre,apellido1,apellido2,calle,numero,piso,puerta,ciudad) VALUES ('1022','Juan','Diaz','Perez','Calle nombre','529',NULL,NULL,'Madrid');
INSERT INTO persona(id_persona,nombre,apellido1,apellido2,calle,numero,piso,puerta,ciudad) VALUES ('1023','Lalo','Diez',NULL,'Calle nombre','610',NULL,NULL,'Asturias');
INSERT INTO persona(id_persona,nombre,apellido1,apellido2,calle,numero,piso,puerta,ciudad) VALUES ('1024','Jorge','Dorribo','Gude','Calle nombre','788',NULL,NULL,'Barcelona');
INSERT INTO persona(id_persona,nombre,apellido1,apellido2,calle,numero,piso,puerta,ciudad) VALUES ('1025','Gabriel','Echevarri','Fernandez','Calle nombre','612',NULL,NULL,'Asturias');
INSERT INTO persona(id_persona,nombre,apellido1,apellido2,calle,numero,piso,puerta,ciudad) VALUES ('1026','Jose Luis','Febres','Arriaga','Calle nombre','815','2','F','Murcia');
INSERT INTO persona(id_persona,nombre,apellido1,apellido2,calle,numero,piso,puerta,ciudad) VALUES ('1027','Pablo Cobian','Fernandez','de la Fuente','Calle nombre','522',NULL,NULL,'Barcelona');
INSERT INTO persona(id_persona,nombre,apellido1,apellido2,calle,numero,piso,puerta,ciudad) VALUES ('1028','Sebastian','Fernandez','Rabal','Calle nombre','558',NULL,NULL,'Murcia');
INSERT INTO persona(id_persona,nombre,apellido1,apellido2,calle,numero,piso,puerta,ciudad) VALUES ('1029','Francisco','Fernandez','Liñares','Calle nombre','569',NULL,NULL,'Madrid');
INSERT INTO persona(id_persona,nombre,apellido1,apellido2,calle,numero,piso,puerta,ciudad) VALUES ('1030','Jose','Flores','Simon','Calle nombre','687','10','E','Madrid');
INSERT INTO persona(id_persona,nombre,apellido1,apellido2,calle,numero,piso,puerta,ciudad) VALUES ('1031','Maria Paz','Garcia','Martinez','Calle nombre','768',NULL,NULL,'Galicia');
INSERT INTO persona(id_persona,nombre,apellido1,apellido2,calle,numero,piso,puerta,ciudad) VALUES ('1032','Maria Ilia','Garcia','de Saez','Calle nombre','618',NULL,NULL,'Madrid');
INSERT INTO persona(id_persona,nombre,apellido1,apellido2,calle,numero,piso,puerta,ciudad) VALUES ('1033','Patxi','Garmendia',NULL,'Calle nombre','523',NULL,NULL,'Madrid');
INSERT INTO persona(id_persona,nombre,apellido1,apellido2,calle,numero,piso,puerta,ciudad) VALUES ('1034','Francisco','Gil','Eguino','Calle nombre','543','15','A','Murcia');
INSERT INTO persona(id_persona,nombre,apellido1,apellido2,calle,numero,piso,puerta,ciudad) VALUES ('1035','Antonio','Gomez','Rosa','Calle nombre','746',NULL,NULL,'Madrid');
INSERT INTO persona(id_persona,nombre,apellido1,apellido2,calle,numero,piso,puerta,ciudad) VALUES ('1036','Maria Tabata','Gonzalez','Florentin','Calle nombre','682',NULL,NULL,'Madrid');
INSERT INTO persona(id_persona,nombre,apellido1,apellido2,calle,numero,piso,puerta,ciudad) VALUES ('1037','Ignacio','Gonzalez','Martinez','Calle nombre','928',NULL,NULL,'Tenerife');
INSERT INTO persona(id_persona,nombre,apellido1,apellido2,calle,numero,piso,puerta,ciudad) VALUES ('1038','David','Gonzalez','Florentin','Calle nombre','949',NULL,NULL,'Madrid');
INSERT INTO persona(id_persona,nombre,apellido1,apellido2,calle,numero,piso,puerta,ciudad) VALUES ('1039','Francisco','Gordillo','Suarez','Calle nombre','774',NULL,NULL,'Barcelona');
INSERT INTO persona(id_persona,nombre,apellido1,apellido2,calle,numero,piso,puerta,ciudad) VALUES ('1040','Francisco Jose','Granados','Lerena','Calle nombre','557',NULL,NULL,'Barcelona');
INSERT INTO persona(id_persona,nombre,apellido1,apellido2,calle,numero,piso,puerta,ciudad) VALUES ('1041','Eugenio','Hidalgo',NULL,'Calle nombre','852',NULL,NULL,'Barcelona');
INSERT INTO persona(id_persona,nombre,apellido1,apellido2,calle,numero,piso,puerta,ciudad) VALUES ('1042','Andrea','Hinojosa','Lozano','Calle nombre','123','11','B','Barcelona');
INSERT INTO persona(id_persona,nombre,apellido1,apellido2,calle,numero,piso,puerta,ciudad) VALUES ('1043','Agustina','Huarte','Silva','Calle nombre','1437',NULL,NULL,'Madrid');
INSERT INTO persona(id_persona,nombre,apellido1,apellido2,calle,numero,piso,puerta,ciudad) VALUES ('1044','Luis','Huete','Morillo','Calle nombre','707',NULL,NULL,'Barcelona');
INSERT INTO persona(id_persona,nombre,apellido1,apellido2,calle,numero,piso,puerta,ciudad) VALUES ('1045','Mateo','Leon','Vert','Calle nombre','682',NULL,NULL,'Asturias');
INSERT INTO persona(id_persona,nombre,apellido1,apellido2,calle,numero,piso,puerta,ciudad) VALUES ('1046','Monica','Llorente','Ramon','Calle nombre','731',NULL,NULL,'Sevilla');
INSERT INTO persona(id_persona,nombre,apellido1,apellido2,calle,numero,piso,puerta,ciudad) VALUES ('1047','Nicolas','Lopez','de Coca','Calle nombre','658',NULL,NULL,'Andalucia');
INSERT INTO persona(id_persona,nombre,apellido1,apellido2,calle,numero,piso,puerta,ciudad) VALUES ('1048','Guadalupe','Lopez','Perez','Calle nombre','959',NULL,NULL,'Barcelona');
INSERT INTO persona(id_persona,nombre,apellido1,apellido2,calle,numero,piso,puerta,ciudad) VALUES ('1049','Jose Antonio','Macias',NULL,'Calle nombre','889',NULL,NULL,'Madrid');
INSERT INTO persona(id_persona,nombre,apellido1,apellido2,calle,numero,piso,puerta,ciudad) VALUES ('1050','David','Marjaliza','Villaseñor','Calle nombre','605',NULL,NULL,'Barcelona');
INSERT INTO persona(id_persona,nombre,apellido1,apellido2,calle,numero,piso,puerta,ciudad) VALUES ('1051','Jose','Martinez','Garcia','Calle nombre','635',NULL,NULL,'Sevilla');
INSERT INTO persona(id_persona,nombre,apellido1,apellido2,calle,numero,piso,puerta,ciudad) VALUES ('1052','Pedro','Martinez','Muñoz','Calle nombre','780',NULL,NULL,'Sevilla');
INSERT INTO persona(id_persona,nombre,apellido1,apellido2,calle,numero,piso,puerta,ciudad) VALUES ('1053','Jaume','Massot',NULL,'Calle nombre','817','10','C','Barcelona');
INSERT INTO persona(id_persona,nombre,apellido1,apellido2,calle,numero,piso,puerta,ciudad) VALUES ('1054','Jose Manuel','Medina',NULL,'Calle nombre','973',NULL,NULL,'Sevilla');
INSERT INTO persona(id_persona,nombre,apellido1,apellido2,calle,numero,piso,puerta,ciudad) VALUES ('1055','Miguel','Miras','Garcia','Calle nombre','909',NULL,NULL,'Murcia');
INSERT INTO persona(id_persona,nombre,apellido1,apellido2,calle,numero,piso,puerta,ciudad) VALUES ('1056','Jose Manuel','Molina','Garcia','Calle nombre','721',NULL,NULL,'Madrid');
INSERT INTO persona(id_persona,nombre,apellido1,apellido2,calle,numero,piso,puerta,ciudad) VALUES ('1057','Jose Juan','Morenilla','Martinez','Calle nombre','706',NULL,NULL,'Galicia');
INSERT INTO persona(id_persona,nombre,apellido1,apellido2,calle,numero,piso,puerta,ciudad) VALUES ('1058','Francisco','Navarro','Warren','Calle nombre','628',NULL,NULL,'Sevilla');
INSERT INTO persona(id_persona,nombre,apellido1,apellido2,calle,numero,piso,puerta,ciudad) VALUES ('1059','Bruna','Neyra','San Miguel','Calle nombre','673',NULL,NULL,'Madrid');
INSERT INTO persona(id_persona,nombre,apellido1,apellido2,calle,numero,piso,puerta,ciudad) VALUES ('1060','Enrique','Orts','Herrera','Calle nombre','540',NULL,NULL,'Barcelona');
INSERT INTO persona(id_persona,nombre,apellido1,apellido2,calle,numero,piso,puerta,ciudad) VALUES ('1061','Manuel','Parejo','Alonso','Calle nombre','698',NULL,NULL,'Tenerife');
INSERT INTO persona(id_persona,nombre,apellido1,apellido2,calle,numero,piso,puerta,ciudad) VALUES ('1062','Mark','Payne','Phillips','Calle nombre','561',NULL,NULL,'Barcelona');
INSERT INTO persona(id_persona,nombre,apellido1,apellido2,calle,numero,piso,puerta,ciudad) VALUES ('1063','Jose Maria','Perez','Torrecillas','Calle nombre','517',NULL,NULL,'Madrid');
INSERT INTO persona(id_persona,nombre,apellido1,apellido2,calle,numero,piso,puerta,ciudad) VALUES ('1064','Juan Antonio','Perez','Torrecillas','Calle nombre','957',NULL,NULL,'Madrid');
INSERT INTO persona(id_persona,nombre,apellido1,apellido2,calle,numero,piso,puerta,ciudad) VALUES ('1065','Martin','Pino','Suarez','Calle nombre','177','8','D','Madrid');
INSERT INTO persona(id_persona,nombre,apellido1,apellido2,calle,numero,piso,puerta,ciudad) VALUES ('1066','Maria Teresa','Piqueras','Agudo','Calle nombre','25',NULL,NULL,'Asturias');
INSERT INTO persona(id_persona,nombre,apellido1,apellido2,calle,numero,piso,puerta,ciudad) VALUES ('1067','Joan Pol','Pujol',NULL,'Calle nombre','815',NULL,NULL,'Madrid');
INSERT INTO persona(id_persona,nombre,apellido1,apellido2,calle,numero,piso,puerta,ciudad) VALUES ('1068','Carmen','Quintana','Mejia','Calle nombre','897',NULL,NULL,'Galicia');
INSERT INTO persona(id_persona,nombre,apellido1,apellido2,calle,numero,piso,puerta,ciudad) VALUES ('1069','Lluis Angel','Ramis de Ayreflor','Cardell','Calle nombre','568',NULL,NULL,'Madrid');
INSERT INTO persona(id_persona,nombre,apellido1,apellido2,calle,numero,piso,puerta,ciudad) VALUES ('1070','Javier','Reguera',NULL,'Calle nombre','598',NULL,NULL,'Madrid');
INSERT INTO persona(id_persona,nombre,apellido1,apellido2,calle,numero,piso,puerta,ciudad) VALUES ('1071','Manuel','Reina','Contreras','Calle nombre','828',NULL,NULL,'Madrid');
INSERT INTO persona(id_persona,nombre,apellido1,apellido2,calle,numero,piso,puerta,ciudad) VALUES ('1072','Italo','Rivadeneyra','Hernandez','Calle nombre','258',NULL,NULL,'Barcelona');
INSERT INTO persona(id_persona,nombre,apellido1,apellido2,calle,numero,piso,puerta,ciudad) VALUES ('1073','Favio','Sanchez','Coloma','Calle nombre','703',NULL,NULL,'Madrid');
INSERT INTO persona(id_persona,nombre,apellido1,apellido2,calle,numero,piso,puerta,ciudad) VALUES ('1074','Rafael','Santano','Cañete','Calle nombre','860',NULL,NULL,'Madrid');
INSERT INTO persona(id_persona,nombre,apellido1,apellido2,calle,numero,piso,puerta,ciudad) VALUES ('1075','Isabel','Segui',NULL,'Calle nombre','704',NULL,NULL,'Barcelona');
INSERT INTO persona(id_persona,nombre,apellido1,apellido2,calle,numero,piso,puerta,ciudad) VALUES ('1076','Alfonso','Servia',NULL,'Calle nombre','887',NULL,NULL,'Madrid');
INSERT INTO persona(id_persona,nombre,apellido1,apellido2,calle,numero,piso,puerta,ciudad) VALUES ('1077','Carlos','Silva','Liste','Calle nombre','841',NULL,NULL,'Barcelona');
INSERT INTO persona(id_persona,nombre,apellido1,apellido2,calle,numero,piso,puerta,ciudad) VALUES ('1078','Marta','Solis',NULL,'Calle nombre','767',NULL,NULL,'Madrid');
INSERT INTO persona(id_persona,nombre,apellido1,apellido2,calle,numero,piso,puerta,ciudad) VALUES ('1079','Miguel Angel','Subiran','Colls','Calle nombre','678','9','F','Madrid');
INSERT INTO persona(id_persona,nombre,apellido1,apellido2,calle,numero,piso,puerta,ciudad) VALUES ('1080','Ana Maria','Tejeiro','Losada','Calle nombre','654','5','D','Sevilla');
INSERT INTO persona(id_persona,nombre,apellido1,apellido2,calle,numero,piso,puerta,ciudad) VALUES ('1081','Jesus','Torres','Baca','Calle nombre','456','1','C','Madrid');
INSERT INTO persona(id_persona,nombre,apellido1,apellido2,calle,numero,piso,puerta,ciudad) VALUES ('1082','Iñaki','Urdangarin','Liebaert','Calle nombre','835',NULL,NULL,'Sevilla');
INSERT INTO persona(id_persona,nombre,apellido1,apellido2,calle,numero,piso,puerta,ciudad) VALUES ('1083','Francisco','Valido','Sanchez','Calle nombre','746',NULL,NULL,'Barcelona');
INSERT INTO persona(id_persona,nombre,apellido1,apellido2,calle,numero,piso,puerta,ciudad) VALUES ('1084','Joaquin','Varela de Limia','de Comingues','Calle nombre','819',NULL,NULL,'Barcelona');
INSERT INTO persona(id_persona,nombre,apellido1,apellido2,calle,numero,piso,puerta,ciudad) VALUES ('1085','Damia','Vidal','Rodriguez','Calle nombre','795',NULL,NULL,'Asturias');
INSERT INTO persona(id_persona,nombre,apellido1,apellido2,calle,numero,piso,puerta,ciudad) VALUES ('1086','Nacho','Vidal',NULL,'Calle nombre','961','2','2E','Madrid');
INSERT INTO persona(id_persona,nombre,apellido1,apellido2,calle,numero,piso,puerta,ciudad) VALUES ('1087','Joan','Villadelprat',NULL,'Calle nombre','748',NULL,NULL,'Barcelona');
INSERT INTO persona(id_persona,nombre,apellido1,apellido2,calle,numero,piso,puerta,ciudad) VALUES ('1088','Narcisa','Vizuete',NULL,'Calle nombre','796','4','F','Madrid');
INSERT INTO persona(id_persona,nombre,apellido1,apellido2,calle,numero,piso,puerta,ciudad) VALUES ('1089','Francisco','Zamorano','Vasquez','Calle nombre','896','7','E','Madrid');
INSERT INTO persona(id_persona,nombre,apellido1,apellido2,calle,numero,piso,puerta,ciudad) VALUES ('1090','Miguel','Zerolo','Aguilar','Calle nombre','613',NULL,NULL,'Tenerife');

/*TABLE JUEZ*/

INSERT INTO juez(id_juez,id_persona,fecha_nacimiento,fecha_inicio) VALUES (10000,1000,CAST(N'12/10/1950'AS Date),CAST(N'1/01/1987'AS Date));
INSERT INTO juez(id_juez,id_persona,fecha_nacimiento,fecha_inicio) VALUES (10001,1006,CAST(N'11/11/1970'AS Date),CAST(N'05/14/2010'AS Date));
INSERT INTO juez(id_juez,id_persona,fecha_nacimiento,fecha_inicio) VALUES (10002,1011,CAST(N'02/25/1968'AS Date),CAST(N'12/15/2002'AS Date));
INSERT INTO juez(id_juez,id_persona,fecha_nacimiento,fecha_inicio) VALUES (10003,1013,CAST(N'03/14/1961'AS Date),CAST(N'12/11/1996'AS Date));
INSERT INTO juez(id_juez,id_persona,fecha_nacimiento,fecha_inicio) VALUES (10004,1016,CAST(N'10/12/1969'AS Date),CAST(N'12/09/2009'AS Date));
INSERT INTO juez(id_juez,id_persona,fecha_nacimiento,fecha_inicio) VALUES (10005,1026,CAST(N'03/03/1966'AS Date),CAST(N'06/20/2005'AS Date));
INSERT INTO juez(id_juez,id_persona,fecha_nacimiento,fecha_inicio) VALUES (10006,1042,CAST(N'04/13/1959'AS Date),CAST(N'02/04/2001'AS Date));
INSERT INTO juez(id_juez,id_persona,fecha_nacimiento,fecha_inicio) VALUES (10007,1043,CAST(N'08/29/1963'AS Date),CAST(N'10/11/2003'AS Date));
INSERT INTO juez(id_juez,id_persona,fecha_nacimiento,fecha_inicio) VALUES (10008,1045,CAST(N'01/01/1970'AS Date),CAST(N'01/01/2010'AS Date));
INSERT INTO juez(id_juez,id_persona,fecha_nacimiento,fecha_inicio) VALUES (10009,1059,CAST(N'06/16/1965'AS Date),CAST(N'05/05/2005'AS Date));
INSERT INTO juez(id_juez,id_persona,fecha_nacimiento,fecha_inicio) VALUES (10010,1065,CAST(N'04/23/1964'AS Date),CAST(N'08/08/2004'AS Date));
INSERT INTO juez(id_juez,id_persona,fecha_nacimiento,fecha_inicio) VALUES (10011,1066,CAST(N'07/22/1960'AS Date),CAST(N'01/09/2020'AS Date));
INSERT INTO juez(id_juez,id_persona,fecha_nacimiento,fecha_inicio) VALUES (10012,1068,CAST(N'07/28/1968'AS Date),CAST(N'08/30/2005'AS Date));
INSERT INTO juez(id_juez,id_persona,fecha_nacimiento,fecha_inicio) VALUES (10013,1072,CAST(N'09/28/1965'AS Date),CAST(N'04/17/2006'AS Date));
INSERT INTO juez(id_juez,id_persona,fecha_nacimiento,fecha_inicio) VALUES (10014,1073,CAST(N'06/24/1952'AS Date),CAST(N'02/20/1998'AS Date));
INSERT INTO juez(id_juez,id_persona,fecha_nacimiento,fecha_inicio) VALUES (10015,1079,CAST(N'02/04/1967'AS Date),CAST(N'06/15/2005'AS Date));
INSERT INTO juez(id_juez,id_persona,fecha_nacimiento,fecha_inicio) VALUES (10016,1081,CAST(N'10/18/1963'AS Date),CAST(N'07/14/2002'AS Date));

/*TABLE IMPLICADO*/

INSERT INTO implicado(dni,id_persona,patrimonio) VALUES (511135658,1001,367807);
INSERT INTO implicado(dni,id_persona,patrimonio) VALUES (852995725,1002,628614);
INSERT INTO implicado(dni,id_persona,patrimonio) VALUES (781805968,1003,528910);
INSERT INTO implicado(dni,id_persona,patrimonio) VALUES (633466243,1004,153205);
INSERT INTO implicado(dni,id_persona,patrimonio) VALUES (408901568,1005,904465);
INSERT INTO implicado(dni,id_persona,patrimonio) VALUES (423498578,1007,637407);
INSERT INTO implicado(dni,id_persona,patrimonio) VALUES (924410279,1008,275755);
INSERT INTO implicado(dni,id_persona,patrimonio) VALUES (629634811,1009,287080);
INSERT INTO implicado(dni,id_persona,patrimonio) VALUES (778413783,1010,754231);
INSERT INTO implicado(dni,id_persona,patrimonio) VALUES (396505953,1012,985464);
INSERT INTO implicado(dni,id_persona,patrimonio) VALUES (412156105,1014,132793);
INSERT INTO implicado(dni,id_persona,patrimonio) VALUES (146634260,1015,912674);
INSERT INTO implicado(dni,id_persona,patrimonio) VALUES (863672955,1017,257688);
INSERT INTO implicado(dni,id_persona,patrimonio) VALUES (850375737,1018,240105);
INSERT INTO implicado(dni,id_persona,patrimonio) VALUES (347135192,1019,402272);
INSERT INTO implicado(dni,id_persona,patrimonio) VALUES (665528372,1020,493096);
INSERT INTO implicado(dni,id_persona,patrimonio) VALUES (123219906,1021,948467);
INSERT INTO implicado(dni,id_persona,patrimonio) VALUES (535718972,1022,727398);
INSERT INTO implicado(dni,id_persona,patrimonio) VALUES (636589477,1023,403254);
INSERT INTO implicado(dni,id_persona,patrimonio) VALUES (279112707,1024,981230);
INSERT INTO implicado(dni,id_persona,patrimonio) VALUES (509175796,1025,917206);
INSERT INTO implicado(dni,id_persona,patrimonio) VALUES (700922149,1027,600458);
INSERT INTO implicado(dni,id_persona,patrimonio) VALUES (411931838,1028,908919);
INSERT INTO implicado(dni,id_persona,patrimonio) VALUES (850490701,1029,262419);
INSERT INTO implicado(dni,id_persona,patrimonio) VALUES (340653853,1030,971577);
INSERT INTO implicado(dni,id_persona,patrimonio) VALUES (895269868,1031,562367);
INSERT INTO implicado(dni,id_persona,patrimonio) VALUES (594575716,1032,622085);
INSERT INTO implicado(dni,id_persona,patrimonio) VALUES (194516123,1033,153713);
INSERT INTO implicado(dni,id_persona,patrimonio) VALUES (850742740,1034,192939);
INSERT INTO implicado(dni,id_persona,patrimonio) VALUES (659343310,1035,553154);
INSERT INTO implicado(dni,id_persona,patrimonio) VALUES (478244435,1036,382924);
INSERT INTO implicado(dni,id_persona,patrimonio) VALUES (959775487,1037,70123);
INSERT INTO implicado(dni,id_persona,patrimonio) VALUES (859590641,1038,429129);
INSERT INTO implicado(dni,id_persona,patrimonio) VALUES (265827488,1039,674948);
INSERT INTO implicado(dni,id_persona,patrimonio) VALUES (572581666,1040,43906);
INSERT INTO implicado(dni,id_persona,patrimonio) VALUES (224383833,1041,855051);
INSERT INTO implicado(dni,id_persona,patrimonio) VALUES (925106525,1044,828342);
INSERT INTO implicado(dni,id_persona,patrimonio) VALUES (535250423,1046,396254);
INSERT INTO implicado(dni,id_persona,patrimonio) VALUES (593677414,1047,642384);
INSERT INTO implicado(dni,id_persona,patrimonio) VALUES (216738657,1048,909217);
INSERT INTO implicado(dni,id_persona,patrimonio) VALUES (416308007,1049,41784);
INSERT INTO implicado(dni,id_persona,patrimonio) VALUES (518589736,1050,24173);
INSERT INTO implicado(dni,id_persona,patrimonio) VALUES (164874459,1051,451726);
INSERT INTO implicado(dni,id_persona,patrimonio) VALUES (202069769,1052,315809);
INSERT INTO implicado(dni,id_persona,patrimonio) VALUES (585742717,1053,602833);
INSERT INTO implicado(dni,id_persona,patrimonio) VALUES (268997842,1054,418003);
INSERT INTO implicado(dni,id_persona,patrimonio) VALUES (288743807,1055,754679);
INSERT INTO implicado(dni,id_persona,patrimonio) VALUES (264204262,1056,754787);
INSERT INTO implicado(dni,id_persona,patrimonio) VALUES (501324713,1057,140147);
INSERT INTO implicado(dni,id_persona,patrimonio) VALUES (116887926,1058,916782);
INSERT INTO implicado(dni,id_persona,patrimonio) VALUES (866348075,1060,997392);
INSERT INTO implicado(dni,id_persona,patrimonio) VALUES (942055237,1061,944959);
INSERT INTO implicado(dni,id_persona,patrimonio) VALUES (478052256,1062,852817);
INSERT INTO implicado(dni,id_persona,patrimonio) VALUES (699933695,1063,483728);
INSERT INTO implicado(dni,id_persona,patrimonio) VALUES (380592118,1064,69096);
INSERT INTO implicado(dni,id_persona,patrimonio) VALUES (772727641,1067,311576);
INSERT INTO implicado(dni,id_persona,patrimonio) VALUES (643295351,1069,582443);
INSERT INTO implicado(dni,id_persona,patrimonio) VALUES (627128892,1070,769889);
INSERT INTO implicado(dni,id_persona,patrimonio) VALUES (144778942,1071,692638);
INSERT INTO implicado(dni,id_persona,patrimonio) VALUES (642205233,1074,584313);
INSERT INTO implicado(dni,id_persona,patrimonio) VALUES (235668684,1075,460915);
INSERT INTO implicado(dni,id_persona,patrimonio) VALUES (426470461,1076,591554);
INSERT INTO implicado(dni,id_persona,patrimonio) VALUES (667513218,1077,315740);
INSERT INTO implicado(dni,id_persona,patrimonio) VALUES (933652209,1078,932290);
INSERT INTO implicado(dni,id_persona,patrimonio) VALUES (108238770,1080,144624);
INSERT INTO implicado(dni,id_persona,patrimonio) VALUES (478401867,1082,416337);
INSERT INTO implicado(dni,id_persona,patrimonio) VALUES (384084428,1083,646020);
INSERT INTO implicado(dni,id_persona,patrimonio) VALUES (114746239,1084,69156);
INSERT INTO implicado(dni,id_persona,patrimonio) VALUES (928721337,1085,133191);
INSERT INTO implicado(dni,id_persona,patrimonio) VALUES (281528471,1086,205668);
INSERT INTO implicado(dni,id_persona,patrimonio) VALUES (299942472,1087,654646);
INSERT INTO implicado(dni,id_persona,patrimonio) VALUES (823728554,1088,238041);
INSERT INTO implicado(dni,id_persona,patrimonio) VALUES (886129055,1089,838677);
INSERT INTO implicado(dni,id_persona,patrimonio) VALUES (294923763,1090,16479);

/*TABLE PERIODICO acepta valores NULL en direccion*/

INSERT INTO periodico(id_periodico,calle,numero,piso,puerta,ciudad,formato,pagina_web,ambito_periodico) VALUES ('20minutos','Calle nombre',123,5,'5F','Galicia','Digital','https://www.20minutos.es/','Local');
INSERT INTO periodico(id_periodico,calle,numero,piso,puerta,ciudad,formato,pagina_web,ambito_periodico) VALUES ('ABC','Calle nombre',456,1,'A','Barcelona','Digital','https://www.abc.es/','Nacional');
INSERT INTO periodico(id_periodico,calle,numero,piso,puerta,ciudad,formato,pagina_web,ambito_periodico) VALUES ('El Confidencial','Calle nombre',789,6,'6C','Sevilla','Digital','https://www.elconfidencial.com/','Comarcal');
INSERT INTO periodico(id_periodico,calle,numero,piso,puerta,ciudad,formato,pagina_web,ambito_periodico) VALUES ('El Mundo','Calle nombre',101,8,'8A','Madrid','Digital','https://www.elmundo.es/','Nacional');
INSERT INTO periodico(id_periodico,calle,numero,piso,puerta,ciudad,formato,pagina_web,ambito_periodico) VALUES ('El Observador','Calle nombre',138,10,'E','Montevideo','Digital','https://www.elobservador.com.uy/','Internacional');
INSERT INTO periodico(id_periodico,calle,numero,piso,puerta,ciudad,formato,pagina_web,ambito_periodico) VALUES ('El Pais','Calle nombre',25,8,'B','Madrid','Digital','https://elpais.com','Nacional');
INSERT INTO periodico(id_periodico,calle,numero,piso,puerta,ciudad,formato,pagina_web,ambito_periodico) VALUES ('La Razon','Calle nombre',19,NULL,NULL,'Castilla','Digital','https://www.larazon.es/','Local');
INSERT INTO periodico(id_periodico,calle,numero,piso,puerta,ciudad,formato,pagina_web,ambito_periodico) VALUES ('La Vanguardia','Calle nombre',270,4,'4D','Catalunya','Digital','https://www.lavanguardia.com/','Comarcal');


/*TABLE CASO_CORRUPCION*/

INSERT INTO caso_corrupcion(id_caso,descripcion,desvio_mll,fecha_descubre,id_juez,id_periodico) VALUES ('Caso Andratx','Primera gran causa de corrupcion urbanistica en Mallorca',740.000,CAST(N'11/27/2006'AS Date),10006,'El Pais');
INSERT INTO caso_corrupcion(id_caso,descripcion,desvio_mll,fecha_descubre,id_juez,id_periodico) VALUES ('Caso Astapa','Corrupcion en el Ayuntamiento de Estepona',63.000,CAST(N'06/17/2008'AS Date),10016,'El Pais');
INSERT INTO caso_corrupcion(id_caso,descripcion,desvio_mll,fecha_descubre,id_juez,id_periodico) VALUES ('Caso Baltar','Presunta contratacion irregular de 115 personas',697.000,CAST(N'01/20/2013'AS Date),10006,'El Mundo');
INSERT INTO caso_corrupcion(id_caso,descripcion,desvio_mll,fecha_descubre,id_juez,id_periodico) VALUES ('Caso Biblioteca','Adjudicacion a dedo de contratos de obras por el Ayuntamiento de Librilla',300.000,CAST(N'12/20/2008'AS Date),10002,'ABC');
INSERT INTO caso_corrupcion(id_caso,descripcion,desvio_mll,fecha_descubre,id_juez,id_periodico) VALUES ('Caso Bitel','Espionaje del correo electronico del fallecido dirigente socialista Francesc Quetglas',700.000,CAST(N'08/03/2007'AS Date),10011,'La Razon');
INSERT INTO caso_corrupcion(id_caso,descripcion,desvio_mll,fecha_descubre,id_juez,id_periodico) VALUES ('Caso Bomsai','Adjudicacion de contratos de asesoria',568.000,CAST(N'04/25/2008'AS Date),10015,'La Razon');
INSERT INTO caso_corrupcion(id_caso,descripcion,desvio_mll,fecha_descubre,id_juez,id_periodico) VALUES ('Caso Brugal','Delitos de soborno, extorsion y trafico de influencias en la adjudicacion de contratos publicos en concursos de gestion de los servicios de recogida de basuras en varias localidades gobernadas por el Partido Popular en la provincia de Alicante',813.300,CAST(N'03/14/2006'AS Date),10002,'El Pais');
INSERT INTO caso_corrupcion(id_caso,descripcion,desvio_mll,fecha_descubre,id_juez,id_periodico) VALUES ('Caso Barcenas','Suiza comunica a la Audiencia Nacional que el extesorero del PP habia llegado a tener 22 millones en cuentas de ese pais',56.000,CAST(N'11/11/2013'AS Date),10004,'El Pais');
INSERT INTO caso_corrupcion(id_caso,descripcion,desvio_mll,fecha_descubre,id_juez,id_periodico) VALUES ('Caso Campeon','Trafico de influencias y negociaciones prohibidas a funcionarios',2.009,CAST(N'10/10/2010'AS Date),10013,'La Vanguardia');
INSERT INTO caso_corrupcion(id_caso,descripcion,desvio_mll,fecha_descubre,id_juez,id_periodico) VALUES ('Caso Comercio','Presuntos delitos de prevaricacion',190.000,CAST(N'08/16/2016'AS Date),10008,'20minutos');
INSERT INTO caso_corrupcion(id_caso,descripcion,desvio_mll,fecha_descubre,id_juez,id_periodico) VALUES ('Caso Conde Roa','Fraude fiscal de 291.000 euros en la venta de una promocion de viviendas',291.000,CAST(N'08/25/2011'AS Date),10006,'El Mundo');
INSERT INTO caso_corrupcion(id_caso,descripcion,desvio_mll,fecha_descubre,id_juez,id_periodico) VALUES ('Caso del Lino','Caso del supuesto fraude en el cobro de subvenciones europeas en el sector del lino textil',134.000,CAST(N'02/08/1999'AS Date),10003,'ABC');
INSERT INTO caso_corrupcion(id_caso,descripcion,desvio_mll,fecha_descubre,id_juez,id_periodico) VALUES ('Caso Emarsa','Los gestores de Emarsa pagaron presuntamente cantidades millonarias por servicios y suministros inexistentes, unos 40 millones de euros pagados a unas 35 empresas, algunas de ellas vinculadas a directivos de Emarsa',23.500,CAST(N'05/12/2011'AS Date),10012,'El Mundo');
INSERT INTO caso_corrupcion(id_caso,descripcion,desvio_mll,fecha_descubre,id_juez,id_periodico) VALUES ('Caso Emperador','Blanqueo de capitales que realizaba la trama china dirigida por el empresario Gao Ping a traves de cuentas bancarias en Suiza gestionadas por la rama hebrea de la organizacion',1.200,CAST(N'04/17/2007'AS Date),10007,'El Pais');
INSERT INTO caso_corrupcion(id_caso,descripcion,desvio_mll,fecha_descubre,id_juez,id_periodico) VALUES ('Caso Epsilon','Subvenciones recibidas por la escuderia automovilistica Epsilon',50.000,CAST(N'06/24/2012'AS Date),10013,'El Pais');
INSERT INTO caso_corrupcion(id_caso,descripcion,desvio_mll,fecha_descubre,id_juez,id_periodico) VALUES ('Caso Facturas','Trama de facturas falsas en el Ayuntamiento de Baena',24.549,CAST(N'06/13/2005'AS Date),10014,'ABC');
INSERT INTO caso_corrupcion(id_caso,descripcion,desvio_mll,fecha_descubre,id_juez,id_periodico) VALUES ('Caso Faycan','Presunta trama de corrupcion urbanistica en el municipio grancanario de Telde que implica a cerca de treinta imputados entre politicos, funcionarios del Ayuntamiento y empresarios.',9.000,CAST(N'06/29/2007'AS Date),10006,'El Mundo');
INSERT INTO caso_corrupcion(id_caso,descripcion,desvio_mll,fecha_descubre,id_juez,id_periodico) VALUES ('Caso Funeraria','Presunto escandalo de corrupcion relacionado con la gestion de la Empresa Funeraria Municipal del ayuntamiento de Palma de Mallorca.',7.400,CAST(N'04/20/1992'AS Date),10000,'El Observador');
INSERT INTO caso_corrupcion(id_caso,descripcion,desvio_mll,fecha_descubre,id_juez,id_periodico) VALUES ('Caso Gurtel','Red de corrupcion politica vinculada al Partido Popular, que funcionaba principalmente en las comunidades de Madrid y Valencia.',201.400,CAST(N'12/11/2007'AS Date),10010,'El Mundo');
INSERT INTO caso_corrupcion(id_caso,descripcion,desvio_mll,fecha_descubre,id_juez,id_periodico) VALUES ('Caso Las Teresitas','Trama delictiva orquestada para malversar mas de 50 millones con la compra del frente de la principal playa de la capital tinerfena',50.000,CAST(N'05/23/2007'AS Date),10001,'ABC');
INSERT INTO caso_corrupcion(id_caso,descripcion,desvio_mll,fecha_descubre,id_juez,id_periodico) VALUES ('Caso Limusa','Fraude fiscal millonario, que se habria cometido con negocios inmobiliarios en los municipios de Lorca y Aguilas',2.900,CAST(N'05/05/2009'AS Date),10005,'El Confidencial');
INSERT INTO caso_corrupcion(id_caso,descripcion,desvio_mll,fecha_descubre,id_juez,id_periodico) VALUES ('Caso Matsa','Incentivo de casi 10,1 millones de euros que en 2009 el entonces presidente del Gobierno andaluz, Manuel Chaves, concedio a la empresa Minas de Aguas Teñidas, Matsa',16.000,CAST(N'09/21/2009'AS Date),10009,'El Mundo');
INSERT INTO caso_corrupcion(id_caso,descripcion,desvio_mll,fecha_descubre,id_juez,id_periodico) VALUES ('Caso Noos','Convenios firmados durante 2005 y 2006 por el Gobierno balear y el Instituto Noos',6.100,CAST(N'09/01/2010'AS Date),10002,'El Pais');
INSERT INTO caso_corrupcion(id_caso,descripcion,desvio_mll,fecha_descubre,id_juez,id_periodico) VALUES ('Caso Pokemon','Macrocausa contra la presunta corrupcion en distintos ayuntamientos gallegos coordinada desde el Juzgado de Instruccion no1 de Lugo',1.882,CAST(N'05/15/2012'AS Date),10010,'ABC');
INSERT INTO caso_corrupcion(id_caso,descripcion,desvio_mll,fecha_descubre,id_juez,id_periodico) VALUES ('Caso Punica','Trama de corrupcion que adjudico servicios publicos por valor de 250 millones de euros en dos años. Supuestamente se cobraban comisiones ilegales,del 2-3 % del volumen del contrato,que posteriormente eran blanqueados a traves de un entramado societario',500.000,CAST(N'08/23/2004'AS Date),10000,'El Confidencial');

/*TABLE AMBITO_CASO*/

INSERT INTO ambito_caso(id_ambito,id_caso,ambito) VALUES (100,'Caso Andratx','Municipio');
INSERT INTO ambito_caso(id_ambito,id_caso,ambito) VALUES (101,'Caso Astapa','Ayuntamiento');
INSERT INTO ambito_caso(id_ambito,id_caso,ambito) VALUES (102,'Caso Baltar','Estado');
INSERT INTO ambito_caso(id_ambito,id_caso,ambito) VALUES (103,'Caso Biblioteca','Ayuntamiento');
INSERT INTO ambito_caso(id_ambito,id_caso,ambito) VALUES (104,'Caso Bitel','Estado');
INSERT INTO ambito_caso(id_ambito,id_caso,ambito) VALUES (105,'Caso Bomsai','Ayuntamiento');
INSERT INTO ambito_caso(id_ambito,id_caso,ambito) VALUES (106,'Caso Brugal','Municipio');
INSERT INTO ambito_caso(id_ambito,id_caso,ambito) VALUES (107,'Caso Barcenas','Estado');
INSERT INTO ambito_caso(id_ambito,id_caso,ambito) VALUES (108,'Caso Campeon','Estado');
INSERT INTO ambito_caso(id_ambito,id_caso,ambito) VALUES (109,'Caso Comercio','Municipio');
INSERT INTO ambito_caso(id_ambito,id_caso,ambito) VALUES (110,'Caso Conde Roa','Municipio');
INSERT INTO ambito_caso(id_ambito,id_caso,ambito) VALUES (111,'Caso del Lino','Estado');
INSERT INTO ambito_caso(id_ambito,id_caso,ambito) VALUES (112,'Caso del Lino','Union Europea');
INSERT INTO ambito_caso(id_ambito,id_caso,ambito) VALUES (113,'Caso Emarsa','Estado');
INSERT INTO ambito_caso(id_ambito,id_caso,ambito) VALUES (114,'Caso Emarsa','Entidad Metropolitana');
INSERT INTO ambito_caso(id_ambito,id_caso,ambito) VALUES (115,'Caso Emperador','Estado');
INSERT INTO ambito_caso(id_ambito,id_caso,ambito) VALUES (116,'Caso Emperador','Familia Real');
INSERT INTO ambito_caso(id_ambito,id_caso,ambito) VALUES (117,'Caso Epsilon','Comunidad Autonoma');
INSERT INTO ambito_caso(id_ambito,id_caso,ambito) VALUES (118,'Caso Facturas','Ayuntamiento');
INSERT INTO ambito_caso(id_ambito,id_caso,ambito) VALUES (119,'Caso Faycan','Ayuntamiento');
INSERT INTO ambito_caso(id_ambito,id_caso,ambito) VALUES (120,'Caso Faycan','Empresa privada');
INSERT INTO ambito_caso(id_ambito,id_caso,ambito) VALUES (121,'Caso Funeraria','Ayuntamiento');
INSERT INTO ambito_caso(id_ambito,id_caso,ambito) VALUES (122,'Caso Funeraria','Empresa privada');
INSERT INTO ambito_caso(id_ambito,id_caso,ambito) VALUES (123,'Caso Gurtel','Partido politico');
INSERT INTO ambito_caso(id_ambito,id_caso,ambito) VALUES (124,'Caso Gurtel','Comunidades');
INSERT INTO ambito_caso(id_ambito,id_caso,ambito) VALUES (125,'Caso Las Teresitas','Municipio');
INSERT INTO ambito_caso(id_ambito,id_caso,ambito) VALUES (126,'Caso Limusa','Municipio');
INSERT INTO ambito_caso(id_ambito,id_caso,ambito) VALUES (127,'Caso Matsa','Gobierno');
INSERT INTO ambito_caso(id_ambito,id_caso,ambito) VALUES (128,'Caso Noos','Familia Real');
INSERT INTO ambito_caso(id_ambito,id_caso,ambito) VALUES (129,'Caso Pokemon','Ayuntamiento');
INSERT INTO ambito_caso(id_ambito,id_caso,ambito) VALUES (130,'Caso Punica','Estado');

/*TABLE DICTAMEN*/

INSERT INTO dictamen(id_dictamen,fecha_dictamen,documento_dictamen,id_juez,id_caso) VALUES ('DICT0001','12/12/2008','www.juzgado.com/dictamen_caso1',10006,'Caso Andratx');
INSERT INTO dictamen(id_dictamen,fecha_dictamen,documento_dictamen,id_juez,id_caso) VALUES ('DICT0002','10/24/2010','www.juzgado.com/dictamen_caso2',10006,'Caso Baltar');
INSERT INTO dictamen(id_dictamen,fecha_dictamen,documento_dictamen,id_juez,id_caso) VALUES ('DICT0003','06/15/2017','www.juzgado.com/dictamen_caso3',10000,'Caso Punica');
INSERT INTO dictamen(id_dictamen,fecha_dictamen,documento_dictamen,id_juez,id_caso) VALUES ('DICT0004','11/10/2018','www.juzgado.com/dictamen_caso4',10010,'Caso Gurtel');
INSERT INTO dictamen(id_dictamen,fecha_dictamen,documento_dictamen,id_juez,id_caso) VALUES ('DICT0005','10/29/2019','www.juzgado.com/dictamen_caso5',10008,'Caso Comercio');

/*TABLE PARTIDO_POLITICO acepta valores NULL en direccion*/

INSERT INTO partido_politico(id_partido,calle,numero,piso,puerta,ciudad) VALUES ('Bloque Nacionalista Galego','Avda. Rodriguez de Viguri','16',NULL,NULL,'Galicia');
INSERT INTO partido_politico(id_partido,calle,numero,piso,puerta,ciudad) VALUES ('Coalicion Canaria','Buenos Aires','24',NULL,NULL,'Las Palmas de Gran Canaria');
INSERT INTO partido_politico(id_partido,calle,numero,piso,puerta,ciudad) VALUES ('Compromis','Playa del Pilar','1',NULL,NULL,'Valencia');
INSERT INTO partido_politico(id_partido,calle,numero,piso,puerta,ciudad) VALUES ('Esquerra Republicana de Catalunya','Calabria','166',NULL,NULL,'Barcelona');
INSERT INTO partido_politico(id_partido,calle,numero,piso,puerta,ciudad) VALUES ('Partido Nacionalista Vasco','Ibañez de Bilbao','16',NULL,NULL,'Bizkaia');
INSERT INTO partido_politico(id_partido,calle,numero,piso,puerta,ciudad) VALUES ('Partido Popular','Genova','13',NULL,NULL,'Madrid');
INSERT INTO partido_politico(id_partido,calle,numero,piso,puerta,ciudad) VALUES ('Partido Socialista Obrero Español','Calle Ferraz','6870',NULL,NULL,'Madrid');
INSERT INTO partido_politico(id_partido,calle,numero,piso,puerta,ciudad) VALUES ('Partit dels Socialistes de Catalunya','Pallars','191',NULL,NULL,'Barcelona');
INSERT INTO partido_politico(id_partido,calle,numero,piso,puerta,ciudad) VALUES ('Union del Pueblo Navarro','Plaza Principe de Viana','1',4,'B','Navarra');

/*TABLE TELEFONO*/

INSERT INTO telefono(id_numero,id_partido,telefono) VALUES (1,'Bloque Nacionalista Galego','981555850');
INSERT INTO telefono(id_numero,id_partido,telefono) VALUES (2,'Coalicion Canaria','928363142');
INSERT INTO telefono(id_numero,id_partido,telefono) VALUES (3,'Coalicion Canaria','922279702');
INSERT INTO telefono(id_numero,id_partido,telefono) VALUES (4,'Coalicion Canaria','651955000');
INSERT INTO telefono(id_numero,id_partido,telefono) VALUES (5,'Coalicion Canaria','928850798');
INSERT INTO telefono(id_numero,id_partido,telefono) VALUES (6,'Coalicion Canaria','922871953');
INSERT INTO telefono(id_numero,id_partido,telefono) VALUES (7,'Coalicion Canaria','922411060');
INSERT INTO telefono(id_numero,id_partido,telefono) VALUES (8,'Coalicion Canaria','649794980');
INSERT INTO telefono(id_numero,id_partido,telefono) VALUES (9,'Coalicion Canaria','922551134');
INSERT INTO telefono(id_numero,id_partido,telefono) VALUES (10,'Coalicion Canaria','696949373');
INSERT INTO telefono(id_numero,id_partido,telefono) VALUES (11,'Compromis','963826606');
INSERT INTO telefono(id_numero,id_partido,telefono) VALUES (12,'Esquerra Republicana de Catalunya','934536005');
INSERT INTO telefono(id_numero,id_partido,telefono) VALUES (13,'Partido Nacionalista Vasco','944039400');
INSERT INTO telefono(id_numero,id_partido,telefono) VALUES (14,'Partido Nacionalista Vasco','945011600');
INSERT INTO telefono(id_numero,id_partido,telefono) VALUES (15,'Partido Nacionalista Vasco','944039400');
INSERT INTO telefono(id_numero,id_partido,telefono) VALUES (16,'Partido Nacionalista Vasco','943118888');
INSERT INTO telefono(id_numero,id_partido,telefono) VALUES (17,'Partido Socialista Obrero Español','915820444');
INSERT INTO telefono(id_numero,id_partido,telefono) VALUES (18,'Partido Socialista Obrero Español','983457335');
INSERT INTO telefono(id_numero,id_partido,telefono) VALUES (19,'Partido Socialista Obrero Español','925284148');
INSERT INTO telefono(id_numero,id_partido,telefono) VALUES (20,'Partido Socialista Obrero Español','944242142');
INSERT INTO telefono(id_numero,id_partido,telefono) VALUES (21,'Partit dels Socialistes de Catalunya','934955400');
INSERT INTO telefono(id_numero,id_partido,telefono) VALUES (22,'Partit dels Socialistes de Catalunya','938902626');
INSERT INTO telefono(id_numero,id_partido,telefono) VALUES (23,'Partit dels Socialistes de Catalunya','938035662');
INSERT INTO telefono(id_numero,id_partido,telefono) VALUES (24,'Union del Pueblo Navarro','948223402');

/*TABLE AFINIDAD*/

INSERT INTO afinidad(id_partido,id_periodico) VALUES ('Partido Popular','El Mundo');
INSERT INTO afinidad(id_partido,id_periodico) VALUES ('Coalicion Canaria','El Mundo');
INSERT INTO afinidad(id_partido,id_periodico) VALUES ('Partido Socialista Obrero Español','El Pais');

/*TABLE PERTENECE registra valores del dni del implicado, el partido al que pertenece y el puesto que desempeña en él*/

INSERT INTO pertenece(dni,id_partido,puesto) VALUES (164874459,'Partido Popular','Secretario');
INSERT INTO pertenece(dni,id_partido,puesto) VALUES (202069769,'Partido Popular','Vicepresidente');
INSERT INTO pertenece(dni,id_partido,puesto) VALUES (852995725,'Partido Socialista Obrero Español','Tesorera');
INSERT INTO pertenece(dni,id_partido,puesto) VALUES (408901568,'Partido Socialista Obrero Español','Dirigente');
INSERT INTO pertenece(dni,id_partido,puesto) VALUES (347135192,'Partido Socialista Obrero Español','Secretario');
INSERT INTO pertenece(dni,id_partido,puesto) VALUES (340653853,'Partido Socialista Obrero Español','Vicepresidente');
INSERT INTO pertenece(dni,id_partido,puesto) VALUES (823728554,'Partido Socialista Obrero Español','Comunicaciones');
INSERT INTO pertenece(dni,id_partido,puesto) VALUES (886129055,'Partido Socialista Obrero Español','Especialista');
INSERT INTO pertenece(dni,id_partido,puesto) VALUES (959775487,'Coalicion Canaria','Especialista');
INSERT INTO pertenece(dni,id_partido,puesto) VALUES (942055237,'Coalicion Canaria','Comunicaciones');
INSERT INTO pertenece(dni,id_partido,puesto) VALUES (294923763,'Coalicion Canaria','Secretario');

/*TABLE ES_PARIENTE*/

INSERT INTO es_pariente(id_relacion,id_implicado,id_implicado_pariente,tipo_relacion) VALUES (3000,924410279,629634811,'hermana');
INSERT INTO es_pariente(id_relacion,id_implicado,id_implicado_pariente,tipo_relacion) VALUES (3001,412156105,146634260,'padre');
INSERT INTO es_pariente(id_relacion,id_implicado,id_implicado_pariente,tipo_relacion) VALUES (3002,665528372,478401867,'esposa');
INSERT INTO es_pariente(id_relacion,id_implicado,id_implicado_pariente,tipo_relacion) VALUES (3003,478244435,859590641,'hermana');
INSERT INTO es_pariente(id_relacion,id_implicado,id_implicado_pariente,tipo_relacion) VALUES (3004,164874459,202069769,'primo');
INSERT INTO es_pariente(id_relacion,id_implicado,id_implicado_pariente,tipo_relacion) VALUES (3005,699933695,380592118,'hermano');

/*TABLE CARGO*/

INSERT INTO cargo(id_cargo,tipo_cargo) VALUES (200,'Blanqueo de capitales');
INSERT INTO cargo(id_cargo,tipo_cargo) VALUES (201,'Cohecho');
INSERT INTO cargo(id_cargo,tipo_cargo) VALUES (202,'Falsedad contable');
INSERT INTO cargo(id_cargo,tipo_cargo) VALUES (203,'Prevaricacion');
INSERT INTO cargo(id_cargo,tipo_cargo) VALUES (204,'Trafico de influencias');
INSERT INTO cargo(id_cargo,tipo_cargo) VALUES (205,'Usurpacion de funciones');

/*TABLE IMPUTACION*/

INSERT INTO imputacion(dni,id_caso,id_cargo) VALUES (224383833,'Caso Andratx',202);
INSERT INTO imputacion(dni,id_caso,id_cargo) VALUES (585742717,'Caso Andratx',204);
INSERT INTO imputacion(dni,id_caso,id_cargo) VALUES (235668684,'Caso Andratx',200);
INSERT INTO imputacion(dni,id_caso,id_cargo) VALUES (852995725,'Caso Astapa',201);
INSERT INTO imputacion(dni,id_caso,id_cargo) VALUES (408901568,'Caso Astapa',205);
INSERT INTO imputacion(dni,id_caso,id_cargo) VALUES (347135192,'Caso Astapa',202);
INSERT INTO imputacion(dni,id_caso,id_cargo) VALUES (340653853,'Caso Astapa',204);
INSERT INTO imputacion(dni,id_caso,id_cargo) VALUES (859590641,'Caso Astapa',201);
INSERT INTO imputacion(dni,id_caso,id_cargo) VALUES (416308007,'Caso Astapa',203);
INSERT INTO imputacion(dni,id_caso,id_cargo) VALUES (699933695,'Caso Astapa',202);
INSERT INTO imputacion(dni,id_caso,id_cargo) VALUES (380592118,'Caso Astapa',205);
INSERT INTO imputacion(dni,id_caso,id_cargo) VALUES (144778942,'Caso Astapa',205);
INSERT INTO imputacion(dni,id_caso,id_cargo) VALUES (426470461,'Caso Astapa',201);
INSERT INTO imputacion(dni,id_caso,id_cargo) VALUES (933652209,'Caso Astapa',202);
INSERT INTO imputacion(dni,id_caso,id_cargo) VALUES (823728554,'Caso Astapa',203);
INSERT INTO imputacion(dni,id_caso,id_cargo) VALUES (886129055,'Caso Astapa',205);
INSERT INTO imputacion(dni,id_caso,id_cargo) VALUES (781805968,'Caso Baltar',205);
INSERT INTO imputacion(dni,id_caso,id_cargo) VALUES (164874459,'Caso Biblioteca',205);
INSERT INTO imputacion(dni,id_caso,id_cargo) VALUES (202069769,'Caso Biblioteca',201);
INSERT INTO imputacion(dni,id_caso,id_cargo) VALUES (116887926,'Caso Biblioteca',203);
INSERT INTO imputacion(dni,id_caso,id_cargo) VALUES (928721337,'Caso Bitel',202);
INSERT INTO imputacion(dni,id_caso,id_cargo) VALUES (772727641,'Caso Bomsai',200);
INSERT INTO imputacion(dni,id_caso,id_cargo) VALUES (643295351,'Caso Bomsai',204);
INSERT INTO imputacion(dni,id_caso,id_cargo) VALUES (396505953,'Caso Brugal',201);
INSERT INTO imputacion(dni,id_caso,id_cargo) VALUES (535250423,'Caso Brugal',201);
INSERT INTO imputacion(dni,id_caso,id_cargo) VALUES (268997842,'Caso Brugal',201);
INSERT INTO imputacion(dni,id_caso,id_cargo) VALUES (633466243,'Caso Barcenas',204);
INSERT INTO imputacion(dni,id_caso,id_cargo) VALUES (264204262,'Caso Barcenas',205);
INSERT INTO imputacion(dni,id_caso,id_cargo) VALUES (279112707,'Caso Campeon',204);
INSERT INTO imputacion(dni,id_caso,id_cargo) VALUES (700922149,'Caso Campeon',201);
INSERT INTO imputacion(dni,id_caso,id_cargo) VALUES (667513218,'Caso Campeon',200);
INSERT INTO imputacion(dni,id_caso,id_cargo) VALUES (114746239,'Caso Campeon',203);
INSERT INTO imputacion(dni,id_caso,id_cargo) VALUES (123219906,'Caso Comercio',204);
INSERT INTO imputacion(dni,id_caso,id_cargo) VALUES (636589477,'Caso Comercio',202);
INSERT INTO imputacion(dni,id_caso,id_cargo) VALUES (509175796,'Caso Comercio',202);
INSERT INTO imputacion(dni,id_caso,id_cargo) VALUES (863672955,'Caso Conde Roa',204);
INSERT INTO imputacion(dni,id_caso,id_cargo) VALUES (593677414,'Caso del Lino',201);
INSERT INTO imputacion(dni,id_caso,id_cargo) VALUES (778413783,'Caso Emarsa',203);
INSERT INTO imputacion(dni,id_caso,id_cargo) VALUES (895269868,'Caso Emarsa',202);
INSERT INTO imputacion(dni,id_caso,id_cargo) VALUES (501324713,'Caso Emarsa',203);
INSERT INTO imputacion(dni,id_caso,id_cargo) VALUES (924410279,'Caso Emperador',203);
INSERT INTO imputacion(dni,id_caso,id_cargo) VALUES (629634811,'Caso Emperador',203);
INSERT INTO imputacion(dni,id_caso,id_cargo) VALUES (594575716,'Caso Emperador',202);
INSERT INTO imputacion(dni,id_caso,id_cargo) VALUES (194516123,'Caso Emperador',200);
INSERT INTO imputacion(dni,id_caso,id_cargo) VALUES (281528471,'Caso Emperador',204);
INSERT INTO imputacion(dni,id_caso,id_cargo) VALUES (478052256,'Caso Epsilon',202);
INSERT INTO imputacion(dni,id_caso,id_cargo) VALUES (299942472,'Caso Epsilon',202);
INSERT INTO imputacion(dni,id_caso,id_cargo) VALUES (535718972,'Caso Facturas',201);
INSERT INTO imputacion(dni,id_caso,id_cargo) VALUES (659343310,'Caso Facturas',205);
INSERT INTO imputacion(dni,id_caso,id_cargo) VALUES (642205233,'Caso Facturas',204);
INSERT INTO imputacion(dni,id_caso,id_cargo) VALUES (265827488,'Caso Faycn',201);
INSERT INTO imputacion(dni,id_caso,id_cargo) VALUES (216738657,'Caso Faycan',204);
INSERT INTO imputacion(dni,id_caso,id_cargo) VALUES (866348075,'Caso Faycan',202);
INSERT INTO imputacion(dni,id_caso,id_cargo) VALUES (384084428,'Caso Faycan',202);
INSERT INTO imputacion(dni,id_caso,id_cargo) VALUES (925106525,'Caso Funeraria',200);
INSERT INTO imputacion(dni,id_caso,id_cargo) VALUES (850375737,'Caso Gurtel',203);
INSERT INTO imputacion(dni,id_caso,id_cargo) VALUES (959775487,'Caso Las Teresitas',201);
INSERT INTO imputacion(dni,id_caso,id_cargo) VALUES (942055237,'Caso Las Teresitas',203);
INSERT INTO imputacion(dni,id_caso,id_cargo) VALUES (294923763,'Caso Las Teresitas',205);
INSERT INTO imputacion(dni,id_caso,id_cargo) VALUES (411931838,'Caso Limusa',200);
INSERT INTO imputacion(dni,id_caso,id_cargo) VALUES (850742740,'Caso Limusa',205);
INSERT INTO imputacion(dni,id_caso,id_cargo) VALUES (288743807,'Caso Limusa',204);
INSERT INTO imputacion(dni,id_caso,id_cargo) VALUES (412156105,'Caso Matsa',201);
INSERT INTO imputacion(dni,id_caso,id_cargo) VALUES (146634260,'Caso Matsa',200);
INSERT INTO imputacion(dni,id_caso,id_cargo) VALUES (511135658,'Caso Noos',200);
INSERT INTO imputacion(dni,id_caso,id_cargo) VALUES (423498578,'Caso Noos',201);
INSERT INTO imputacion(dni,id_caso,id_cargo) VALUES (665528372,'Caso Noos',200);
INSERT INTO imputacion(dni,id_caso,id_cargo) VALUES (108238770,'Caso Noos',200);
INSERT INTO imputacion(dni,id_caso,id_cargo) VALUES (478401867,'Caso Noos',200);
INSERT INTO imputacion(dni,id_caso,id_cargo) VALUES (850490701,'Caso Pokemon',204);
INSERT INTO imputacion(dni,id_caso,id_cargo) VALUES (627128892,'Caso Pokemon',202);
INSERT INTO imputacion(dni,id_caso,id_cargo) VALUES (572581666,'Caso Punica',204);
INSERT INTO imputacion(dni,id_caso,id_cargo) VALUES (518589736,'Caso Punica',202);
GO

/*Consultas
------------------------------------------------------------------------------*/

--- 1. CONSULTA En qué ciudad hay el máximo número de corruptos. Usamos TOP 1 para retornar el numero de registros. En este caso queremos solo que se nos devuelva solo el registro con el numero maximo.
SELECT TOP 1
	COUNT(*) AS No_Corruptos,
    P.ciudad
 FROM persona P
	 JOIN implicado I
		 ON (I.id_persona = P.id_persona)
 GROUP BY P.ciudad
 ORDER BY No_Corruptos DESC
 GO

 --- 2. CONSULTA Total del dinero defraudado por partido político (se contará si y sólo si la persona está afiliada al partido)
SELECT COUNT(*) AS Personas_Afiliadas,
       O.id_partido, 
	   C.desvio_mll
FROM persona P
	JOIN implicado I 
		ON (I.id_persona =P.id_persona)
	JOIN pertenece E 
		ON (E.dni = I.dni)
	JOIN partido_politico O 
		ON (O.id_partido=E.id_partido)
	JOIN imputacion M 
		ON (I.dni=M.dni)
	JOIN caso_corrupcion C 
		ON (M.id_caso=C.id_caso)
GROUP BY O.id_partido, 
		 C.desvio_mll
GO

--- 3. CONSULTA Número de personas implicadas en cada caso
SELECT COUNT(*) AS No_Personas,
       M.id_caso
FROM persona P
	JOIN implicado I 
		ON (I.id_persona = P.id_persona)
	JOIN imputacion M 
		ON (I.dni=M.dni)
GROUP BY M.id_caso
GO

--- 4. VISTA Tabla virtual que permite ver todos los implicados que son parientes de los casos con ambito "Familia Real".
---En este caso se hace un SELF JOIN ya que ambas personas de la relacion pariente son implicados 
--- por eso tanto las tablas implicado, imputacion y persona tienen 2 alias diferentes.
CREATE VIEW FamReal 
AS
SELECT REPLACE(CONCAT(P.nombre+' ',P.apellido1+' ',P.apellido2+' '),'',' ') AS Implicado,
	   R.tipo_relacion AS es,
	   REPLACE(CONCAT(C.nombre+' ',C.apellido1+' ',C.apellido2+' '),'',' ') AS Pariente,
	   CC.id_caso AS Caso
FROM es_pariente R
	JOIN implicado I 
		ON (I.dni = R.id_implicado)
	JOIN implicado T 
		ON (T.dni= R.id_implicado_pariente)
    JOIN imputacion IMP
		ON (IMP.dni =I.dni)
	JOIN imputacion IMPT 
		ON (IMPT.dni =T.dni)
	JOIN caso_corrupcion CC 
		ON (CC.id_caso=IMP.id_caso)
	JOIN ambito_caso AC 
		ON (AC.id_caso=CC.id_caso)
	JOIN persona P 
		ON (P.id_persona = I.id_persona)
	JOIN persona C 
		ON (C.id_persona = T.id_persona)
WHERE AC.ambito= 'Familia Real'
GO

SELECT* FROM FamReal

---DROP VIEW FamReal;
SELECT * FROM es_pariente

--- 5. TRIGGER de actualizacion 
/*TABLE CASO_JUEZ_UPDATE  NO EXPRESADO EN LA MODELIZACION  CREACION DE TABLA*/

CREATE TABLE caso_juez_update
(
    id_update int identity(1,1)not null,
    id_juez int not null,
    id_juez_update int not null,
    id_caso varchar(50) not null,
    fecha_update datetime DEFAULT GETDATE(),
    usuario varchar(50) DEFAULT SUSER_SNAME(),
    PRIMARY KEY (id_update)    
);
GO
/*TRIGGER Actualizar_Juez, una vez se actualiza el juez en un caso, el valor antiguo y el nuevo se guardan en la tabla caso_juez_update */

CREATE TRIGGER Actualizar_Juez
ON caso_corrupcion 
AFTER update  
AS
INSERT INTO caso_juez_update
(
	id_juez, 
	id_juez_update,
	id_caso
)
SELECT D.id_juez, 
	   I.id_juez, 
	   I.id_caso
FROM INSERTED I 
	INNER JOIN DELETED D 
		ON (I.id_caso =D.id_caso)
GO

UPDATE caso_corrupcion
SET id_juez= 10006
WHERE id_caso= 'Caso Astapa';
GO

SELECT * FROM caso_corrupcion
GO

SELECT * FROM caso_juez_update
GO

--DROP TRIGGER Actualizar_Juez

--- 6. CONSULTA ANIDADA Mostrar los jueces que estan jubilados , edad mayor o igual a 65
SELECT *
FROM
(
	SELECT REPLACE(CONCAT(P.nombre+' ',P.apellido1+' ',P.apellido2+' '),'',' ') AS Juez,
		   DATEDIFF(YEAR, J.fecha_nacimiento, GETDATE()) AS Edad
	FROM juez J
		JOIN persona P 
			ON (P.id_persona=J.id_persona)
) AS miTabla
WHERE edad >=65 
GO

--- 7. CONSULTA CON EXPRESION CASE Clasificar los desvios en 3 categorias
SELECT C.id_caso, 
	   C.desvio_mll,
	   CASE 
		   WHEN desvio_mll <= 100 THEN 
			   'BAJO'
		   WHEN desvio_mll >= 500 THEN 
		       'ALTO'
		   ELSE 
		       'MEDIO'
	   END AS Clasificacion
FROM caso_corrupcion C;
GO

--- 8. VISTA Tabla virtual que permite ver todos los implicados de los casos con dictamen (D.id_dicatmen is not null)
CREATE VIEW Implicado_caso
AS
SELECT REPLACE(CONCAT(P.nombre+' ',P.apellido1+' ',P.apellido2+' '),'',' ') AS Implicado,
	   C.fecha_descubre AS Fecha_caso,
	   C.id_caso AS Caso
FROM persona P
	JOIN implicado I ON (I.id_persona = P.id_persona)
	JOIN imputacion IMP ON (IMP.dni = I.dni)
	JOIN caso_corrupcion C ON (C.id_caso = IMP.id_caso)
	JOIN dictamen D ON (D.id_caso = C.id_caso)
WHERE D.id_dictamen IS NOT NULL
GO

---DROP VIEW Implicado_caso
SELECT* FROM Implicado_caso
GO
--- 9. STORED PROCEDURE que permite efectuar la transaccion de ingresar nuevas personas. Solo se ingresa una nueva persona si no tiene un id_persona igual a otra, si es asi se deshace la transaccion 
CREATE PROCEDURE Insertar_Persona
	@CODIGO INT,
	@NOMBRE VARCHAR(50),
	@APELLIDO1 VARCHAR(50),
	@APELLIDO2 VARCHAR(50),
	@CALLE VARCHAR(50),
	@NUMERO SMALLINT,
	@PISO SMALLINT,
	@PUERTA CHAR(2),
	@CIUDAD VARCHAR(30)
AS
BEGIN
	BEGIN TRAN Transaccion_Insertar_Persona
	INSERT persona
	VALUES 
	(@CODIGO, @NOMBRE, @APELLIDO1, @APELLIDO2, @CALLE, @NUMERO, @PISO, @PUERTA, @CIUDAD)
	IF EXISTS(SELECT * FROM persona WHERE id_persona = @CODIGO)
		COMMIT TRAN TRANSACCIONINSERTAR
	ELSE
		ROLLBACK TRAN TRANSACCIONINSERTAR
END
GO

EXECUTE Insertar_Persona 1091,'NOMBRE','APELLIDO1','APELLIDO2','CALLE1',431,3,'3D', 'CIUDAD'
GO

SELECT * FROM persona
GO
--- 10. STORED PROCEDURE que permite conocer el periódico que más casos ha descubierto
CREATE PROCEDURE Periodico_caso
AS
SELECT TOP 1 
	COUNT(*) AS No_Casos,
    C.id_periodico
FROM caso_corrupcion C
GROUP BY C.id_periodico
ORDER BY No_Casos DESC
GO

EXEC Periodico_caso;
GO

--- 11. Obtener los años de servicio de juez activo (donde edad menor o igual a 65 años)
--- Creamos una FUNCTION para calcular la edad a partir del parametro fecha_nacimiento 
CREATE FUNCTION dbo.Edad(@FECNAC DATE)
RETURNS INT
AS 
BEGIN
	DECLARE @EDAD AS INT
	SET @EDAD= DATEDIFF(YEAR, @FECNAC, GETDATE())
	RETURN @EDAD
END;
GO
---En este SELECT anidado usamos la funcion creada dbo.Edad y pasamos el parametro fecha_nacimiento de la tabla Juez
SELECT *
FROM
(
	SELECT REPLACE(CONCAT(P.nombre+' ',P.apellido1+' ',P.apellido2+' '),'',' ') AS Juez,
		   DATEDIFF(YEAR, J.fecha_inicio, GETDATE()) AS servicio,
		   dbo.Edad(CAST(J.fecha_nacimiento as Date)) AS Edad 
	FROM juez J
		JOIN persona P ON (P.id_persona=J.id_persona)
) AS Tabla
WHERE Edad <=65
GO

---SELECT  dbo.Edad (CAST(N'1/01/1987'AS Date))
---SELECT  * from juez
---DROP FUNCTION Edad

--- 12. PROCEDURE para calcular el promedio de desvio de millones de casos donde el juez reside en determinada ciudad, siendo @ciudad el parametro
CREATE PROCEDURE Prom_desvio_ciudad
@CIUDAD varchar(30)
AS
BEGIN
    SELECT AVG(C.desvio_mll)
    FROM caso_corrupcion C
		JOIN juez J 
			ON (C.id_juez = J.id_juez)
		JOIN persona P 
			ON (J.id_persona = P.id_persona)
    WHERE P.ciudad = @CIUDAD;
END

EXEC Prom_desvio_ciudad 'Barcelona'
EXEC Prom_desvio_ciudad 'Madrid'
GO
---DROP procedure Prom_desvio_ciudad

--- 13. PROCEDURE para listar todos los implicados con determinado cargo solo si tienen afiliacion a un partido politico, siendo @cargo el parametro
CREATE PROCEDURE Implicados_cargo_partido
@CARGO varchar(30)
AS
BEGIN
    SELECT I.dni,
		   REPLACE(CONCAT(P.nombre+' ',P.apellido1+' ',P.apellido2+' '),'',' ') AS Implicado
    FROM implicado I
		JOIN imputacion N
			ON (N.dni=I.dni)
		JOIN cargo C 
			ON (C.id_cargo=N.id_cargo)
		JOIN persona P 
			ON (P.id_persona = I.id_persona)
		JOIN pertenece PT 
			ON (PT.dni = I.dni)
    WHERE C.tipo_cargo = @CARGO
		  AND pt.id_partido IS NOT NULL;
END
GO
---DROP procedure Implicados_cargo_partido
EXEC Implicados_cargo_partido 'Usurpacion de funciones'
EXEC Implicados_cargo_partido 'Prevaricacion'
GO
--- 14. TRIGGER DELETE PERSONA que se ejecutara cuando elimine una fila de la tabla persona borrando también los registros de las tablas relacionadas
CREATE TRIGGER Eliminar_persona
ON persona
AFTER DELETE
AS
BEGIN
    SET NOCOUNT ON;
--- Eliminar los registros relacionados de la tabla "implicado"
    DELETE FROM implicado
    WHERE id_persona IN (
							SELECT deleted.id_persona FROM DELETED
						);

--- Eliminar los registros relacionados de la tabla "es_pariente"
	DELETE FROM es_pariente
    WHERE id_implicado IN (
							SELECT deleted.id_persona FROM DELETED
						  );

--- Eliminar los registros relacionados de la tabla "juez"
    DELETE FROM juez
    WHERE id_persona IN (
							SELECT deleted.id_persona FROM DELETED
						);

--- Eliminar los registros relacionados de la tabla "dictamen"
	DELETE FROM dictamen
    WHERE id_juez IN (
							SELECT juez.id_juez 
							FROM juez
							WHERE juez.id_persona IN (
														SELECT deleted.id_persona FROM DELETED
													  )
		             );

--- Eliminar los registros relacionados de la tabla "imputacion"
    DELETE FROM imputacion
    WHERE dni IN (
							SELECT implicado.dni 
							FROM implicado
							WHERE implicado.id_persona IN (
														SELECT deleted.id_persona FROM DELETED
														   )
				 );

--- Eliminar los registros relacionados de la tabla "corrupcion"
    DELETE FROM caso_corrupcion
    WHERE id_juez IN (
							SELECT juez.id_juez 
							FROM juez
							WHERE juez.id_persona IN (
														SELECT deleted.id_persona FROM DELETED
													  )
					 );

--- Eliminar los registros relacionados de la tabla "pertenece"
	DELETE FROM pertenece
    WHERE dni IN (
							SELECT implicado.dni 
							FROM implicado
							WHERE implicado.id_persona IN (
														    SELECT deleted.id_persona FROM DELETED
														   )
				 );
END
GO

DELETE FROM persona WHERE id_persona = 1091
SELECT * FROM persona
GO

--- 15. La suma de PATRIMONIO de los implicados en determinado caso 
CREATE FUNCTION Patrimonio_caso(@IDCASO varchar(50))
RETURNS INT
AS
BEGIN
	DECLARE @PATRIMONIOT INT;
	SELECT @PATRIMONIOT= SUM(I.patrimonio)
	FROM implicado I
		JOIN imputacion IMP 
			ON (I.dni = IMP.dni)
		JOIN caso_corrupcion C 
			ON (IMP.id_caso = C.id_caso)
	WHERE c.id_caso = @IDCASO;
	RETURN @PATRIMONIOT;
END
GO
--- Declaramos la variable y le asignamos un valor, en este caso int porque el resultado es la suma de los patrimonios de los implicados.
--- Indicamos que el valor de la variable declarada es igual a la funcion creada arriba pasando como parametro el id del caso.
DECLARE @PATRIMONIOT INT;
SET @PATRIMONIOT = dbo.Patrimonio_caso('Caso Faycan');
SELECT @PATRIMONIOT;

