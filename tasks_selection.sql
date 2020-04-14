 USE Tasks;
 /*Izpis vseh zadolzitev in dodeljenih ter opravljenih ur z zadolzenimi*/
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


/*
   - naziv (naloge,  mejnika, sestanka), skupaj dodeljene ure, skupaj opravljene ure
   - možno filtriranje po nazivu, dodeljenih urah, opravljenih urah in osebi
   - možno sortiranje po nazivu, dodeljenih urah in opravljenih urah*/


/*Naziv, in skupaj dodeljene ter skupaj opravljene ure ter oseba*/
Select * FROM Vsi_Podatki;

/*Filtriranje po nazivu*/
Select * FROM Vsi_Podatki HAVING Naziv ='Naloga 1';

/*Filtriranje po Dodeljenih urah*/
Select * FROM Vsi_Podatki HAVING Skupaj_dodeljene_ure > '02:00:00';

/*Filtriranje po osebi*/
Select * FROM Vsi_Podatki HAVING Polno_ime ='Anita Kralj';

/*Sortiranje po nazivu*/
Select * FROM Vsi_Podatki ORDER BY Naziv DESC;

/*Sortiranje po Dodeljenih urah*/
Select * FROM Vsi_Podatki ORDER BY Skupaj_dodeljene_ure DESC;

/*Sortiranje po Opravljenih urah*/
Select * FROM Vsi_Podatki ORDER BY Skupaj_opravljene_ure DESC;