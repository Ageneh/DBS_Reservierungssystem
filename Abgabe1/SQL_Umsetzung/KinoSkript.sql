DROP TABLE reservierung_enthaelt CASCADE;
DROP TABLE speisen CASCADE;
DROP TABLE reservierung CASCADE;
DROP TABLE vorstellung CASCADE;
DROP TABLE film CASCADE;
DROP TABLE platz CASCADE;
DROP TABLE saal CASCADE;
DROP TABLE regBenutzer CASCADE;
DROP TABLE plz CASCADE;

CREATE TABLE speisen(
    produktID VARCHAR(80) PRIMARY KEY,
    produktBeschreibung VARCHAR(255)
);

CREATE TABLE plz(
    plz NUMERIC(5,0) PRIMARY KEY,
    ort VARCHAR(80)
);

CREATE TABLE regBenutzer(
    ID NUMERIC(10,0) NOT NULL UNIQUE,
    email VARCHAR(80) PRIMARY KEY,
    vorname VARCHAR(80),
    nachname VARCHAR(80),
    strasse VARCHAR(80),
    hausNr SMALLINT,
    plz NUMERIC(5,0),
    FOREIGN KEY (plz) REFERENCES plz(plz)
);

CREATE TABLE saal(
    saalName VARCHAR(20) PRIMARY KEY,
    plaetze int CHECK(plaetze >= 25 AND plaetze <= 80)
);

CREATE TABLE platz(
    reihe NUMERIC(2,0),
    platzNr NUMERIC(2,0),
    PRIMARY KEY (reihe, platzNr),
    saalName VARCHAR(20),
    FOREIGN KEY (saalName) REFERENCES saal(saalName)
);

DROP TABLE kategorie CASCADE;
CREATE TABLE kategorie(
    name VARCHAR(80) PRIMARY KEY,
    preis FLOAT(2),
    reihe NUMERIC(2,0),
    platzNr NUMERIC(2,0),
    FOREIGN KEY (reihe, platzNr) REFERENCES platz(reihe, platzNr)
);

CREATE TABLE film(
    titel VARCHAR(100) PRIMARY KEY,
    hauptdarsteller VARCHAR(80),
    genre VARCHAR(80),
    spieldauer FLOAT(3)
);

CREATE TABLE vorstellung(
    datum_zeit TIMESTAMP PRIMARY KEY,
    titel VARCHAR(100),
    FOREIGN KEY (titel) REFERENCES film(titel),
    saalName VARCHAR(20),
    FOREIGN KEY (saalName) REFERENCES saal(saalName)
);

CREATE TABLE reservierung(
    reservierungsID VARCHAR(10) PRIMARY KEY,
    email VARCHAR(80),
    FOREIGN KEY (email) REFERENCES regBenutzer(email),
    rabatt FLOAT(2) CHECK(rabatt >= 0 AND rabatt <= 50)
);

CREATE TABLE reservierung_enthaelt(
    reservierungsID VARCHAR(10),
    FOREIGN KEY (reservierungsID) REFERENCES reservierung(reservierungsID),
    datum_zeit TIMESTAMP,
    FOREIGN KEY (datum_zeit) REFERENCES vorstellung(datum_zeit),
    reihe NUMERIC(2,0),
    platzNr NUMERIC(2,0),
    FOREIGN KEY (reihe, platzNr) REFERENCES platz(reihe, platzNr),
    produktID VARCHAR(80),
    FOREIGN KEY (produktID) REFERENCES speisen(produktID)
);


-- inserts

INSERT INTO saal VALUES('Capitol', 50);
INSERT INTO saal VALUES('Empire', 60);
INSERT INTO saal VALUES('Atlantis', 75);
INSERT INTO saal VALUES('Omnipa', 54);
INSERT INTO saal VALUES('Lounge', 25);

INSERT INTO plz VALUES(65191, 'Wiesbaden');
INSERT INTO plz VALUES(65197, 'Wiesbaden');
INSERT INTO plz VALUES(65719, 'Hofheim am Taunus');

INSERT INTO regBenutzer VALUES(5196209399, 'rudi.ratlos@ratloses-web.de', 'Rudi', 'Ratlos', 'Mainzerstr.', 4, 65191);
INSERT INTO regBenutzer VALUES(5011446320, 'susi.sinnlos@sinnloses-web.de', 'Susi', 'Sinnlos', 'Kleinaustr.', 11, 65191);
INSERT INTO regBenutzer VALUES(1059460234, 'seb32@seb-netz.de', 'Sebastian', 'Sagmeister', 'Jakobsgasse', 5, 65197);
INSERT INTO regBenutzer VALUES(7138702962, 'car0.l1n@line.de', 'Carolin', 'Ratlos', 'Weißenburgstr.', 24, 65191);
INSERT INTO regBenutzer VALUES(3497734641, 'steffan.sinnlos@sinnloses-web.de', 'Steffan', 'Sinnlos', 'Cohausenstr.', 17, 65719);
