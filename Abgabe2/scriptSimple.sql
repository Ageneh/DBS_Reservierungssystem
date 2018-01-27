DROP TABLE reservierung;
DROP TABLE vorstellung;
DROP TABLE kategorie;
DROP TABLE platz;
DROP TABLE saal;
DROP TABLE regBenutzer;

DROP TABLE speisen;
DROP TABLE film;
DROP TABLE plz;

CREATE TABLE speisen(
	    produktID VARCHAR(80) PRIMARY KEY,
	    produktBeschreibung VARCHAR(255)
);

CREATE TABLE plz(
	    plz NUMERIC(5,0) PRIMARY KEY,
	    ort VARCHAR(80)
);
INSERT INTO plz VALUES(65191, 'Wiesbaden');
INSERT INTO plz VALUES(65197, 'Wiesbaden');
INSERT INTO plz VALUES(65719, 'Hofheim am Taunus');

CREATE TABLE saal(
	    saalName VARCHAR(20) UNIQUE,
	    PRIMARY KEY (saalName)
);
INSERT INTO saal VALUES('Capitol');
INSERT INTO saal VALUES('Empire');
INSERT INTO saal VALUES('Atlantis');
INSERT INTO saal VALUES('Omnipa');
INSERT INTO saal VALUES('Lounge');

CREATE TABLE film(
	    titel VARCHAR(100) PRIMARY KEY,
	    hauptdarsteller VARCHAR(80),
	    genre VARCHAR(80),
	    spieldauer TIME(2)
);
INSERT INTO film VALUES('Shutter Island', 'Leonardo DiCaprio', 'Thriller', '01:20:12');

----mit references
-- + plz
CREATE TABLE regBenutzer(
    nutzerID CHAR(12) UNIQUE,
    email VARCHAR(80) UNIQUE,
    vorname VARCHAR(80) NOT NULL,
    nachname VARCHAR(80) NOT NULL,
    strasse VARCHAR(80) NOT NULL,
    hausNr SMALLINT,
    plz NUMERIC(5,0),

    PRIMARY KEY (nutzerID, email),

    FOREIGN KEY (plz) REFERENCES plz(plz)
);
INSERT INTO regBenutzer VALUES('RudiRud', 'rudi@ratlos.de', 'Rudi', 'Ratlos', 'Mainzerstr.', 4, 65191);
INSERT INTO regBenutzer VALUES('Simsala', 'susi@sinnlos.de', 'Susi', 'Sinnlos', 'Kleinaustr.', 11, 65191);
INSERT INTO regBenutzer VALUES('sagMAIster', 'sebi@sagmeister.de', 'Sebastian', 'Sagmeister', 'Jakobsgasse', 5, 65197);
INSERT INTO regBenutzer VALUES('Caro12', 'carolin@ratlos.de', 'Carolin', 'Ratlos', 'Weisenburgstr.', 24, 65191);
INSERT INTO regBenutzer VALUES('SteLos', 'steffan@sinnlos.de', 'Steffan', 'Sinnlos', 'Cohausenstr.', 17, 65719);

-- + saal
CREATE TABLE platz(
	    reihe NUMERIC(2,0),
	    platzNr NUMERIC(2,0),
	    saalName VARCHAR(20),

	    PRIMARY KEY (reihe, platzNr),
	    FOREIGN KEY (saalName) REFERENCES saal(saalName)
);

-- + platz -- + saal
CREATE TABLE kategorie(
	    name VARCHAR(80) PRIMARY KEY,
	    preis FLOAT(2),
	    saalName VARCHAR(20),
	    reihe NUMERIC(2,0),
	    platzNr NUMERIC(2,0),

	    FOREIGN KEY (saalName) REFERENCES saal(saalName),
	    FOREIGN KEY (reihe, platzNr) REFERENCES platz(reihe, platzNr)
);

-- + film, saal
CREATE TABLE vorstellung(
	    vorstellungID CHAR(6) UNIQUE,
	    datum_zeit TIMESTAMP NOT NULL,
	    ---PRIMARY KEY (datum_zeit, vorstellungID),
	    titel VARCHAR(100),
	    saalName VARCHAR(20),

	    FOREIGN KEY (titel) REFERENCES film(titel),
	    FOREIGN KEY (saalName) REFERENCES saal(saalName),

	    PRIMARY KEY(vorstellungID, datum_zeit, saalName)
);
INSERT INTO vorstellung VALUES('VSI001', '2018-01-28 15:00:00', 'Shutter Island', 'Capitol');
INSERT INTO vorstellung VALUES('VSI002', '2018-01-28 15:00:00', 'Shutter Island', 'Empire');
INSERT INTO vorstellung VALUES('VSI003', '2018-01-28 15:00:00', 'Shutter Island', 'Atlantis');
INSERT INTO vorstellung VALUES('VSI004', '2018-01-28 15:00:00', 'Shutter Island', 'Omnipa');
INSERT INTO vorstellung VALUES('VSI005', '2018-01-28 15:00:00', 'Shutter Island', 'Lounge');

-- + regBenutzer, vorstellung
CREATE TABLE reservierung(
    nutzerID CHAR(12),
    --email VARCHAR(80),
    reservierungsID CHAR(18),
    vorstellungID CHAR(6),

    reihe NUMERIC(2,0) NOT NULL,
    sitz NUMERIC(2,0) NOT NULL,
    produktID VARCHAR(80),
		rabatt FLOAT(2) CHECK(rabatt >= 0 AND rabatt <= 50),

		PRIMARY KEY (nutzerID, reservierungsID, vorstellungID, sitz, reihe),

    FOREIGN KEY (nutzerID) REFERENCES regBenutzer(nutzerID),
    FOREIGN KEY (vorstellungID) REFERENCES vorstellung(vorstellungID),
    FOREIGN KEY (produktID) REFERENCES speisen(produktID)
);
drop function reserviere(CHAR, CHAR, NUMERIC, NUMERIC, NUMERIC);
CREATE OR REPLACE FUNCTION reserviere(nID CHAR, vID CHAR, reihe NUMERIC, sitz NUMERIC, sitzENd NUMERIC)
RETURNS TEXT AS $$
  DECLARE
    id CHAR(18) = 'RES' || $2 || $1;
    reihe NUMERIC(2,0) = $3;
    sitz NUMERIC(2,0) = $4;
    delim CHAR(2) = ', ';
    max INT = $5;
    ret_str VARCHAR(80) = $1 || delim || id || delim || $2 || delim || $3 || delim || $4;
  BEGIN
  IF reihe IS NOT NULL AND sitz IS NOT NULL THEN
    IF max IS NOT NULL AND max > sitz THEN
      WHILE sitz <= max LOOP
        INSERT INTO reservierung(nutzerID, reservierungsID, vorstellungID, reihe, sitz) VALUES($1, id, $2, $3, sitz);
        sitz := sitz + 1;
      END LOOP;
    END IF;
  END IF;
  RETURN max;
  END
$$
LANGUAGE 'plpgsql';
drop function reserviere(CHAR, CHAR, NUMERIC, NUMERIC);
CREATE OR REPLACE FUNCTION reserviere(nID CHAR, vID CHAR, reihe NUMERIC, sitz NUMERIC)
RETURNS TEXT AS $$
  DECLARE
    id CHAR(18) = 'RES' || $2 || $1;
    reihe NUMERIC(2,0) = $3;
    sitz NUMERIC(2,0) = $4;
    delim CHAR(2) = ', ';
    max INT = $5;
    ret_str VARCHAR(80) = $1 || delim || id || delim || $2 || delim || $3 || delim || $4;
  BEGIN
  IF reihe IS NOT NULL AND sitz IS NOT NULL THEN
    IF max IS NOT NULL AND max > sitz THEN
      WHILE sitz <= max LOOP
        INSERT INTO reservierung(nutzerID, reservierungsID, vorstellungID, reihe, sitz) VALUES($1, id, $2, $3, sitz);
        sitz := sitz + 1;
      END LOOP;
    END IF;
    ELSE
      INSERT INTO reservierung(nutzerID, reservierungsID, vorstellungID, reihe, sitz) VALUES($1, id, $2, $3, $4);
  END IF;
  RETURN max;
  END
$$
LANGUAGE 'plpgsql';

SELECT * FROM reservierung;

---------reserviere(CHAR, CHAR, NUMERIC, NUMERIC)

SELECT * FROM regBenutzer;
SELECT reserviere('RudiRud', 'VSI005', 2,1, 7);
SELECT * FROM reservierung;
SELECT reserviere('SteLos', 'VSI003', 5,6);
SELECT * FROM reservierung;
SELECT reserviere('RudiRud', 'VSI002', 5,6, 7);
SELECT * FROM reservierung;

--------

-- storno
DROP FUNCTION storno(CHAR);
CREATE OR REPLACE FUNCTION storno(rID CHAR)
RETURNS VOID AS $$
  BEGIN
  DELETE FROM reservierung WHERE reservierungsID = $1;
  END
$$
LANGUAGE 'plpgsql';

select storno('RESVSI005RudiRud');
SELECT * FROM reservierung;
