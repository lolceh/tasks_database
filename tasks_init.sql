DROP DATABASE IF EXISTS Arctur;
CREATE DATABASE Arctur;
USE Arctur;

CREATE TABLE Oseba (
    id_Oseba int NOT NULL PRIMARY KEY AUTO_INCREMENT,
    Ime varchar(255) NOT NULL,
    Priimek varchar(255) NOT NULL
); 

CREATE TABLE Mejnik (
	id_Mejnik int NOT NULL PRIMARY KEY AUTO_INCREMENT,
    Naziv varchar(255) NOT NULL,
    Datum_zakljucek DATE,
    fk_Oseba int,
    CONSTRAINT fk_Mejnik_Oseba FOREIGN KEY (fk_Oseba) REFERENCES Oseba(id_Oseba) ON DELETE SET NULL ON UPDATE CASCADE
    );
    
CREATE TABLE Zadolzitev (
	id_Zadolzitev int NOT NULL PRIMARY KEY AUTO_INCREMENT
	);

CREATE TABLE Oseba_Zadolzitev (
	id_Oseba_Zadolzitev int NOT NULL PRIMARY KEY AUTO_INCREMENT,
    Dodeljene_ure TIME NOT NULL,
    fk_Zadolzitev int NOT NULL,
    fk_Oseba int NOT NULL,
    CONSTRAINT fk_Oseba_Zadolzitev_Oseba FOREIGN KEY (fk_Oseba) REFERENCES Oseba(id_Oseba) ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT fk_Oseba_Zadolzitev_Zadolzitev FOREIGN KEY (fk_Zadolzitev) REFERENCES Zadolzitev(id_Zadolzitev) ON DELETE CASCADE ON UPDATE CASCADE
    );

CREATE TABLE Zadolzitev_Ure (
	id_Zadolzitev_Ure int NOT NULL PRIMARY KEY AUTO_INCREMENT,
    Datum DATE NOT NULL,
    Opravljene_ure TIME NOT NULL,
    fk_Zadolzitev int,
    fk_Oseba int,
    CONSTRAINT fk_Zadolzitev_Ure_Zadolzitev FOREIGN KEY (fk_Zadolzitev) REFERENCES Zadolzitev(id_Zadolzitev) ON DELETE SET NULL ON UPDATE CASCADE,
    CONSTRAINT fk_Zadolzitev_Ure_Oseba FOREIGN KEY (fk_Oseba) REFERENCES Oseba(id_Oseba) ON DELETE SET NULL ON UPDATE CASCADE
    );
 
  
CREATE TABLE Naloga(
	id_Naloga int NOT NULL PRIMARY KEY,
    Naziv varchar(255) NOT NULL,
    Datum_zacetek DATE NOT NULL,
    Datum_konec DATE NOT NULL,
    CONSTRAINT fk_Naloga_Zadolzitev FOREIGN KEY (id_Naloga) REFERENCES Zadolzitev(id_Zadolzitev) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE Sestanek(
	id_Sestanek int NOT NULL PRIMARY KEY,
    Naziv varchar(255) NOT NULL,
    Datum DATE NOT NULL,
    Ura_zacetek TIME NOT NULL,
    Ura_konec TIME NOT NULL,
    CONSTRAINT fk_Sestanek_Zadolzitev FOREIGN KEY (id_Sestanek) REFERENCES Zadolzitev(id_Zadolzitev) ON DELETE CASCADE ON UPDATE CASCADE
);


/*Trigerji*/

/*Triger za Zadolzitve in izracun ur ce je dodana zadolzitev sestanek*/
DELIMITER //
CREATE TRIGGER `Oseba_Zadolzitev_BEFORE_INSERT` BEFORE INSERT ON `Oseba_Zadolzitev` FOR EACH ROW

BEGIN
	DECLARE Ure Time;
    IF EXISTS (SELECT * FROM Sestanek WHERE id_Sestanek = NEW.fk_Zadolzitev Limit 1) THEN
		SELECT timediff(Ura_konec, Ura_zacetek) FROM Sestanek WHERE id_Sestanek = NEW.fk_Zadolzitev INTO Ure;
		SET NEW.Dodeljene_ure = Ure;
    END IF;
END; //
DELIMITER ;


USE `Arctur`;
CREATE  OR REPLACE VIEW `Vsi_Podatki` AS
SELECT *	
    FROM(
    SELECT z.Naziv,CONCAT(o.Ime,' ', o.Priimek) as Polno_ime, SEC_TO_TIME(SUM(TIME_TO_SEC(oz.Dodeljene_ure))) as Skupaj_dodeljene_ure, zu.Skupaj_opravljene_ure
	FROM Oseba_Zadolzitev oz
	LEFT JOIN (SELECT z.id_Zadolzitev, COALESCE(n.Naziv, s.Naziv) AS Naziv 
		FROM Zadolzitev z 
		LEFT JOIN Naloga n ON z.id_Zadolzitev = n.id_Naloga
		LEFT JOIN Sestanek s ON z.id_Zadolzitev = s.id_Sestanek) as z
		ON z.id_Zadolzitev = oz.fk_Zadolzitev
    LEFT JOIN Oseba o ON o.id_Oseba = oz.fk_Oseba
    INNER JOIN (SELECT fk_Zadolzitev, fk_Oseba, SEC_TO_TIME(SUM(TIME_TO_SEC(Opravljene_ure))) as Skupaj_opravljene_ure
				FROM Zadolzitev_Ure
				GROUP BY fk_Zadolzitev, fk_Oseba) as zu
                ON oz.fk_Oseba = zu.fk_Oseba AND oz.fk_Zadolzitev = zu.fk_Zadolzitev
    GROUP BY oz.fk_Zadolzitev, oz.fk_Oseba
    UNION
		SELECT m.Naziv, CONCAT(o.Ime,' ', o.Priimek) as Polno_Ime, '00:00:00','00:00:00'
		FROM Mejnik m
		LEFT JOIN Oseba o ON o.id_Oseba = m.fk_Oseba) as U
		;
    