/*
    1. Nombre de biens immobiliers vendus par mois, pour chaque mois de l’année.

    Nombre de lines attendues: 6 lignes

    | mois    |	nb_ventes |
    |---------|-----------|
    | 2020-06 | 	| 243 |
    | 2020-05 | 	| 187 |
    | 2020-04 | 	| 76  |
    | 2020-03 | 	| 118 |
    | 2020-02 | 	| 184 |
    | 2020-01 | 	| 239 |
*/
SELECT DATE_FORMAT(date_vente, '%Y-%m') AS mois, COUNT(*) AS nb_ventes 
    FROM transactions
    WHERE MONTH(date_vente) = '01'
    GROUP BY mois
    ORDER BY mois DESC;

/*
    2. Créer une Union de données entre 2 tables
   
    Un client demande de lui fournir une liste de tous les biens immobiliers disponibles à la vente. 
    Pour cela, je lui fourni la liste de tous les biens immobiliers disponibles à la vente, qu’ils soient dans la table bien_immo ou dans la table nouvelles_donnees.

    Nombre de lines attendues: 1109 lignes

    | valeur_fonciere_actuelle  | commune           | surface    | type        |
    |---------------------------|-------------------|------------|-------------|
    | 157500                    | ABBEVILLE         | 92.07      | Appartement |
*/
SELECT valeur_fonciere_actuelle, commune, ROUND(surface, 2) AS surface, type 
   FROM bien_immo 
      UNION 
SELECT valeur_fonciere_actuelle, commune, ROUND(surface, 2) AS surface, type 
   FROM nouvelles_donnees
   ORDER BY commune ASC
   LIMIT 10;

/*
    3. Calcule le nombre de biens immobiliers vendus par commune, le prix moyen au m2 et la valeur foncière totale pour chaque commune.

    Nombre de lines attendues: 467

    | code_departement | commune        |  nombre_de_biens  | valeur_fonciere  | surface  | prix_m2  |
    |------------------|----------------|-------------------|------------------|----------|----------|
    |       4 	       |SALLANCHES 	    |       3 	        |   415590 	       |  156.16  | 2661.31  |
	|       59 	       |LILLE 	        |       8 	        |   1069753 	   |  423.61  | 2525.33  |
	|       31 	       |TOULOUSE        | 	    8 	        |   1366462 	   |  400.87  |	3408.74  |
	|       13 	       |MARSEILLE 1ER 	|       2 	        |   299000 	       |  100.47  |	2976.01  |
	|       13 	       |MARSEILLE 3EME 	|       1 	        |   48500 	       |  35.77   |	1355.88  |
     etc...
*/
SELECT
    code_departement,
    commune,
    count(*) AS nombre_de_biens,
    ROUND(sum(valeur_fonciere_actuelle), 2) AS valeur_fonciere,
    ROUND(sum(surface), 2) AS surface,
    ROUND(sum(valeur_fonciere_actuelle) / sum(surface),2) AS prix_m2
FROM
    bien_immo
GROUP BY
    code_departement,
    commune

/*
    4. Prix des logements au m2 < 1300 pour le département 31
    Il y a 4 entrées dans la table bien_immo pour le département 31 mais aucune n’a un prix au m2 inférieur à 1300€.

    Nombre de lines attendues: 0

    Prix au metre carré > 1300 pour le département 31
    | code_departement | commune              | prix_m2   |
    |------------------|----------------------|-----------|
    | 31               | LACROIX FALGARDE     | 2384.21   |
    | 31               | RAMONVILLE ST AGNE   | 2892.07   |
    | 31               | TOULOUSE             | 3562.56   |
    | 31               | TOURNEFEUILLE        | 2142.16   |

*/
SELECT 
   code_departement,
   commune, 
   ROUND(AVG(valeur_fonciere_actuelle / surface),2) as prix_m2 
FROM 
    bien_immo 
WHERE 
    code_departement = '31'
GROUP BY 
    commune
HAVING 
    AVG(valeur_fonciere_actuelle / surface) < 1300;

/*
    5. Prix des logements au m2 < 1300 pour chaque commune trié par ordre alphabétique de la commune
    Nombre de lines attendues: 46

    | code_departement | commune      | prix_m2 |
    |------------------|--------------|---------|
    | 47               | AGEN         | 1135.27 |
    | 62               | AVION        | 1155.78 |
    | 51               | AY-CHAMPAGNE | 1092.80 |
*/
SELECT 
   code_departement,
   commune,
   ROUND(AVG(valeur_fonciere_actuelle / surface), 2) as prix_m2 
FROM 
    bien_immo
GROUP BY 
    code_departement, commune
HAVING 
    prix_m2 < 1300
ORDER BY 
    commune ASC;


/*
    6. Prix moyen au m2 des logements groupé par commune et code département trié par ordre alphabétique de commune

    Nombre de lines attendues: 467

    | code_departement | commune                 | prix_m2 |
    |------------------|-------------------------|---------|
    | 47               | AGEN                    | 1135.27 |
    | 62               | AVION                   | 1155.78 |
    | 51               | AY-CHAMPAGNE            | 1092.80 |
    | 33               | BEGLES                  | 1146.99 |
    | 62               | BETHUNE                 |  904.23 |
    | 26               | BOURG-DE-PEAGE          | 1094.95 |
    | 18               | BOURGES                 | 1225.01 |
    | 29               | BREST                   | 1272.44 |
*/
SELECT 
   code_departement,
   commune,
   ROUND(AVG(valeur_fonciere_actuelle/surface),2) as prix_m2 
FROM 
    bien_immo
GROUP BY 
    code_departement, commune
    ORDER BY commune ASC;

/*
   7. Valeur moyenne au m2 des logements

    Nombre de lines attendues: 1

    | prix_m2 |
    |---------|
    | 4166.43 |
*/
SELECT 
   ROUND(AVG(valeur_fonciere_actuelle/surface),2) as prix_m2 
FROM 
      bien_immo;



/*
   8. Date de vente des logment ordonés par date de vente desc et limité à 10

   * Sans la clause LIMIT 10, la requête retourne 130 lignes

    +------------+
    | date_vente |
    +------------+
    | 2020-06-30 |
    | 2020-06-29 |
    | 2020-06-26 |
    | 2020-06-25 |
    | 2020-06-24 |
    | 2020-06-23 |
    | 2020-06-22 |
    | 2020-06-20 |
    | 2020-06-19 |
    | 2020-06-18 |
    +------------+
*/
SELECT DISTINCT date_vente FROM transactions
ORDER BY date_vente DESC
LIMIT 10;


/*
    9. Prix des logments pour la rue: "ANNA POLITKOVSKAIA" à TOULOUSE

    +---------+-----------------+------------+----------+--------------------+
    | id_bien | valeur_fonciere | date_vente | commune  | voie               |
    +---------+-----------------+------------+----------+--------------------+
    |       5 |           56700 | 2020-05-07 | TOULOUSE | ANNA-POLITKOVSKAIA |
    |       6 |           60275 | 2020-02-10 | TOULOUSE | Anna POLITKOVSKAIA |
    +---------+-----------------+------------+----------+--------------------+

*/
SELECT 
    id_bien, 
    valeur_fonciere, 
    date_vente, 
    commune,
    voie
FROM 
    bien_immo
LEFT JOIN 
    transactions 
ON 
    bien_immo.id_bien = transactions.bien_immobilier
WHERE 
    lower(voie) LIKE '%POLITKOVSKAIA%'
AND 
    commune = 'TOULOUSE';

/*
    10. Rechercher les biens ayant la plus grande surface dans chaque commune

    Nombre de lines attendues: 467

    +---------------------------+-------------+
    | commune                   | surface_max |
    +---------------------------+-------------+
    | LYON 2EME                 |      320.92 |
    | PARIS 07                  |      320.20 |
    | NEUILLY-SUR-SEINE         |      271.85 |
    | NANTERRE                  |      217.93 |
    | ROANNE                    |      217.02 |
    | PARIS 17                  |      212.71 |
    | CHAMPIGNY-SUR-MARNE       |      209.87 |

*/
SELECT 
    commune, 
    MAX(surface) AS surface_max 
FROM 
    bien_immo 
GROUP BY 
    commune
ORDER BY 
    surface_max DESC;

/*
    11. Calculer la moyenne des surfaces par type de bien (appartement ou maison)

    Nombre de lines attendues: 2

    +-------------+-----------------+
    | type        | surface_moyenne |
    +-------------+-----------------+
    | Appartement |           56.15 |
    | Maison      |           95.08 |
    +-------------+-----------------+

*/
SELECT 
    type, 
    ROUND(AVG(surface), 2) AS surface_moyenne 
FROM 
    bien_immo 
GROUP BY 
    type;

/*
    12. Lister les biens immobiliers dont la surface est supérieure à la moyenne pour la commune

    Nombre de lines attendues: 500

    +---------------------------+---------+---------+
    | commune                   | id_bien | surface |
    +---------------------------+---------+---------+
    | ABBEVILLE                 |      41 |   92.07 |
    | ALLAUCH                   |     388 |   67.92 |
    | AMBERIEU-EN-BUGEY         |     723 |   70.45 |
    | AMBERIEU-EN-BUGEY         |     722 |  164.87 |
    | AMIENS                    |     400 |   65.60 |
    | AMIENS                    |     399 |  100.24 |
    | ANNECY                    |      43 |   63.29 |
    | ANTIBES                   |     726 |   60.00 |
    | ANTIBES                   |     725 |   66.01 |

*/
SELECT 
    commune, 
    id_bien, 
    surface 
FROM 
    bien_immo 
WHERE 
    surface > (
        SELECT 
            AVG(surface) 
        FROM 
            bien_immo 
        WHERE 
            commune = bien_immo.commune
    )
ORDER BY 
    commune ASC;
