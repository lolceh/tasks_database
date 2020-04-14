USE Tasks;

/*Vstavi osebe*/
INSERT INTO Oseba (`Ime`, `Priimek`) 
	VALUES	('Tine', 'Novak'),
			('Branko', 'Kodelja'), 
			('Anita', 'Kralj'), 
			('Janez', 'Bozic');

/*Vstavi mejnike in dodeli odgovorne osebe*/
INSERT INTO Mejnik(`Naziv`, `Datum_zakljucek`,`fk_Oseba`) 
	VALUES	('Dokoncanje projekta 1', '2020-04-20', 1),
			('Dokoncanje projekta 2', '2020-07-20', 3);

/*Dodaj naloge*/
INSERT INTO Zadolzitev VALUE();
INSERT INTO Naloga (`id_Naloga`, `Naziv`,`Datum_zacetek`, `Datum_konec`)
	VALUES (LAST_INSERT_ID(), 'Naloga 1', '2020-03-20', '2020-04-20');

INSERT INTO Zadolzitev VALUE();
INSERT INTO Naloga (`id_Naloga`, `Naziv`,`Datum_zacetek`, `Datum_konec`)
	VALUES (LAST_INSERT_ID(), 'Naloga 2', '2020-04-01', '2020-04-18');
    
INSERT INTO Zadolzitev VALUE();
INSERT INTO Naloga (`id_Naloga`, `Naziv`,`Datum_zacetek`, `Datum_konec`)
	VALUES (LAST_INSERT_ID(), 'Naloga 3', '2020-05-01', '2020-05-16');

/*Dodaj sestanke*/
INSERT INTO Zadolzitev VALUE();
INSERT INTO Sestanek (`id_Sestanek`, `Naziv`,`Datum`, `Ura_zacetek`, `Ura_konec`)
	VALUES (LAST_INSERT_ID(), 'Sestanek 1', '2020-05-20', '08:00:00', '09:00:00');

INSERT INTO Zadolzitev VALUE();
INSERT INTO Sestanek (`id_Sestanek`, `Naziv`,`Datum`, `Ura_zacetek`, `Ura_konec`)
	VALUES (LAST_INSERT_ID(), 'Sestanek 2', '2020-05-25', '11:00:00', '11:30:00');

INSERT INTO Zadolzitev VALUE();
INSERT INTO Sestanek (`id_Sestanek`, `Naziv`,`Datum`, `Ura_zacetek`, `Ura_konec`)
	VALUES (LAST_INSERT_ID(), 'Sestanek 3', '2020-04-13', '11:00:00', '15:00:00');


/*Zadolzi osebe*/
INSERT INTO Oseba_Zadolzitev (`Dodeljene_ure`, `fk_Zadolzitev`,`fk_Oseba`)
	VALUES	('03:00:00', 1,1),
			('05:00:00', 1,2),
			('02:10:00', 2,1),
            ('01:15:00', 2,4),
 			('06:00:00', 3,2),
            ('08:30:00', 3,3),
            ('02:30:00', 3,4),
			('', 4,1),
            ('', 4,2),
            ('', 4,3),
            ('', 4,4),
			('', 5,2),
            ('', 5,4);
            

/*Vstavi opravljene ure na zadolzitvah*/
INSERT INTO Zadolzitev_Ure (`Datum`, `Opravljene_ure`, `fk_Zadolzitev`, `fk_Oseba`) 
	VALUES ('2020-03-20', '02:00:00', 1, 1),
		   ('2020-03-21', '00:30:00', 1, 1),
		   ('2020-03-20', '03:00:00', 1, 2),
           ('2020-03-22', '02:00:00', 1, 2),
           ('2020-04-01', '00:45:00', 2, 1),
           ('2020-04-02', '02:00:00', 2, 1),
           ('2020-04-01', '01:00:00', 2, 4),
           ('2020-04-03', '00:15:00', 2, 4),
		   ('2020-05-01', '01:00:00', 3, 2),
           ('2020-05-02', '00:15:00', 3, 2),
		   ('2020-05-01', '06:00:00', 3, 3),
           ('2020-05-03', '02:15:00', 3, 3),		
		   ('2020-05-01', '01:00:00', 3, 4),
           ('2020-05-02', '00:30:00', 3, 4),
           ('2020-05-20', '01:00:00', 4, 1),
           ('2020-05-20', '01:00:00', 4, 2),
           ('2020-05-20', '01:00:00', 4, 3),
           ('2020-05-20', '01:00:00', 4, 4),
           ('2020-05-20', '00:30:00', 5, 2),
           ('2020-05-20', '00:30:00', 5, 4);
