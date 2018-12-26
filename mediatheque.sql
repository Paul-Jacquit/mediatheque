/*------
STRUCTURE

1 - TYPE & TABLE ARTISTE

2 - TYPE ABONNEMENT

3 - TYPE ABONNE

4 - TYPE SOCIETE / PUBLIC / PARTICULIER

5 - TABLE SOCIETE / PUBLIC / PARTICULIER

6 - TYPE & TABLE EMPRUNT

------*/

/*----------------------------------------
1 - TYPE & TABLE ARTISTE
-----------------------------------------*/

CREATE OR REPLACE TYPE ARTISTE_TYPE AS OBJECT
(
  REF_ARTISTE NUMBER(6),
  NOM         VARCHAR(20),
  PRENOM      VARCHAR(20)
);

CREATE TABLE ARTISTES OF ARTISTE_TYPE
(
  PRIMARY KEY (REF_ARTISTE)
);

/*----------------------------------------
2 - TYPE ABONNEMENT
-----------------------------------------*/


-- TODO OPTIMISATION TYPE_ABONNEMENT

CREATE OR REPLACE TYPE ABONNEMENT_TYPE AS OBJECT
(
  REF_ABO_TYPE   NUMBER,
  TYPE_ABONNE    VARCHAR(50),
  MONTANT_ANNUEL NUMBER(4, 2),
);

CREATE TABLE ABONNEMENT_TYPES OF ABONNEMENT_TYPE
(
  PRIMARY KEY (REF_ABO_TYPE)
);

CREATE OR REPLACE TYPE ABONNEMENT AS OBJECT
(
  REF_ABONNEMENT           NUMBER,
  ABONNE                   ABONNE,
  DATE_DEBUT               DATE,
  DATE_PROCHAIN_ABONNEMENT DATE,
  EST_REGLE                BOOLEAN,
  TYPE_ABONNEMENT          ABONNEMENT_TYPE
);

CREATE TABLE ABONNEMENTS OF ABONNEMENT_TYPE
(
  PRIMARY KEY (REF_ABONNEMENT),
  FOREIGN KEY (ABONNE.REF_ABONNE) REFERENCES ABONNES(REF_ABONNE),
  FOREIGN KEY (TYPE_ABONNEMENT.REF_ABO_TYPE) REFERENCES ABONNEMENT_TYPES(REF_ABO_TYPE)
);

/*----------------------------------------
3 - TYPE ABONNE
-----------------------------------------*/

CREATE OR REPLACE TYPE ABONNE AS OBJECT
(
  REF_ABONNE NUMBER,
  ADRESSE    VARCHAR(255),
  EMAIL      VARCHAR(240),
  TELEPHONE  VARCHAR(13),
  ABONNEMENT ABONNEMENT,
  HISTORIQUE HISTORIQUE_TYPE
) NOT FINAL NOT INSTANTIABLE;


/*----------------------------------------
4 - TYPE SOCIETE / PUBLIC / PARTICULIER
-----------------------------------------*/

CREATE OR REPLACE TYPE SOCIETE UNDER ABONNE
(
  NOM_SOCIETE VARCHAR(255)
);


CREATE OR REPLACE TYPE PARTICULIER UNDER ABONNE
(
  NOM    VARCHAR(255),
  PRENOM VARCHAR(255)
);

CREATE OR REPLACE TYPE ETABLISSEMENT_PUBLIC UNDER ABONNE
(
  NOM_ETABLISSEMENT VARCHAR(255)
);

/*----------------------------------------
5 - TABLE SOCIETE / PUBLIC / PARTICULIER
-----------------------------------------*/

CREATE TABLE ABONNES OF ABONNE
(
  PRIMARY KEY (REF_ABONNE),
  FOREIGN KEY (ABONNEMENT.REF_ABONNEMENT) REFERENCES ABONNEMENTS(REF_ABONNEMENT)
);
/*----------------------------------------
6 - TYPE & TABLE EMPRUNT
-----------------------------------------*/

CREATE OR REPLACE TYPE EMPRUNT AS OBJECT
(
  REF_EMPRUNT  NUMBER,
  DATE_EMPRUNT DATE,
  DATE_RETOUR  DATE,
  OEUVRE   OEUVRE,
  ABONNE   ABONNE
);

CREATE TABLE EMPRUNTS OF EMPRUNT
(
  PRIMARY KEY (REF_EMPRUNT),
  FOREIGN KEY (ABONNE.REF_ABONNE) REFERENCES ABONNES(REF_ABONNE),
  FOREIGN KEY (OEUVRE.REF_OEUVRE) REFERENCES OEUVRE(REF_OEUVRE)
);

/*----------------------------------------
7 - TYPE CRITIQUE
-----------------------------------------*/

CREATE OR REPLACE TYPE CRITIQUE AS OBJECT
(
  AUTEUR   VARCHAR(255),
  CRITIQUE VARCHAR(1024)
);

CREATE OR REPLACE TYPE CRITIQUE_LIST AS TABLE OF CRITIQUE_TYPE;

CREATE OR REPLACE TYPE HISTORIQUE AS TABLE OF EMPRUNT;

/*----------------------------------------
8 - TYPE & TABLE OEUVRE, GENRE et SUPPORT
-----------------------------------------*/
CREATE OR REPLACE TYPE GENRE AS OBJECT
(
  REF_GENRE  NUMBER,
  DESCRIPTION  VARCHAR(30),
);

CREATE OR REPLACE TYPE SUPPORT AS OBJECT
(
  REF_SUPPORT  NUMBER,
  DESCRIPTION  VARCHAR(30),
);

CREATE TABLE GENRES OF GENRE
(
  PRIMARY KEY (REF_GENRE)
);

CREATE TABLE SUPPORTS OF SUPPORT
(
  PRIMARY KEY (REF_SUPPORT)
);

CREATE OR REPLACE TYPE OEUVRE AS OBJECT
(
  REF_OEUVRE  NUMBER,
  TITRE       VARCHAR(255),
  PRIX        NUMBER(4, 2),
  SUPPORT     SUPPORT,
  GENRE       GENRE,
  DESCRIPTION varchar(1024),
  CRITIQUE    CRITIQUE_LIST
);

CREATE TABLE OEUVRES OF OEUVRE
(
  PRIMARY KEY (REF_OEUVRE),
  FOREIGN KEY (SUPPORT.REF_SUPPORT) REFERENCES SUPPORTS(REF_SUPPORT),
  FOREIGN KEY (GENRE.REF_GENRE) REFERENCES GENRES(REF_GENRE)
);

/*----------------------------------------
9 - TABLE OEUVRE_ARTISTE

Permet la recherche rapide d'association oeuvre / artiste

-----------------------------------------*/

CREATE TABLE OEUVRE_ARTISTE
(
  OEUVRE  OEUVRE,
  ARTISTE ARTISTE,
  
  PRIMARY KEY (OEUVRE.REF_OEUVRE,ARTISTE.REF_ARTISTE) 
  CONSTRAINT FK_OEUVRE FOREIGN KEY (OEUVRE.REF_OEUVRE) REFERENCES OEUVRES (REF_OEUVRE),
  CONSTRAINT FK_ARTISTE FOREIGN KEY (ARTISTE.REF_ARTISTE) REFERENCES ARTISTES (REF_ARTISTE)
)
