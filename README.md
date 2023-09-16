## DOLQ_app

### Description
L'application exploite les données du <em>Dictionnaire des oeuvres littéraires du Québec</em> (DOLQ), un ouvrage de référence de grande importance dans le domaine des études littéraires au Québec rédigé par des équpes d'experts depuis 1971. Pour l'instant, ne sont disponibles que les six premiers volumes couvrant les oeuvres littéraires publiées au Québec en lange française jusqu'en 1980. 

### Sources:
La numérisation des volumes et la construction des fichiers `xml` a été faite par [BAnQ](https://www.banq.qc.ca/accueil/). Les fichiers ont été transférés au Centre de recherche interuniversitaire sur la littérature et la culture québécoises et sont affichés [en libre accès sur son site](https://crilcq.org/publications/publications-numeriques/). L'application exploite les données contenues dans les fichiers `xml`.

### Corrections des données
Quelques corrections mineures ont été apportées à la table principale avec OpenRefine, telle la suppression de virgules, de points et d'espaces à la fin des chaines de caractères.

### Code de l'application
L'application a été écrite en langage R avec l'extension [Shiny](https://cran.r-project.org/web/packages/shiny/index.html) par Pascal Brissette (pascal.brissette\@mcgill.ca).

### Références

#### Volume 1
Lemire, Maurice (dir.), <em>Dictionnaire des œuvres littéraires du Québec – Tome I – Des origines à 1900</em>, Fides, Montréal, 1980, 1016 p. ISBN 2-7621-0972-8 CONTRIBUTEURS·RICES: Reine Bélanger, Jacques Blais, Aurélien Boivin, Odoric Bouffard, Guy Champagne, Denise Doré, Gilles Dorion, Jean Du Berger, Richard Houle, Yvan Lajoie, Kenneth Landry, Maurice Lemire, Odette Métayer, Marie-Claude R. Gagnon, André Vachon, Nive Voisine.


#### Volume 2
Lemire, Maurice (dir.), <em>Dictionnaire des œuvres littéraires du Québec – Tome II – 1900-1939</em>, Fides, Montréal, 1987, 1505 p. ISBN 2-7621-0998-1 CONTRIBUTEURS·RICES: Aurélien Boivin, Roger Chamberland, Guy Champagne, Denise Doré, Gilles Dorion, André Gaulin, Richard Houle, Kenneth Landry, Alonzo Le Blanc, Maurice Lemire, Suzanne Paradis, Lucie Robert.


#### Volume 3
Lemire, Maurice (dir.), <em>Dictionnaire des œuvres littéraires du Québec – Tome III – 1940-1959</em>, Fides, Montréal, 1995 [1982], 1382 p. ISBN 2-7621-1860-3 CONTRIBUTEURS·RICES: Aurélien Boivin, Roger Chamberland, Denise Doré, Gilles Dorion, André Gaulin, Kenneth Landry, Alonzo Le Blanc, Maurice Lemire, Lucie Robert.


#### Volume 4
Lemire, Maurice (dir.), <em>Dictionnaire des œuvres littéraires du Québec – Tome IV – 1960-1969</em>, Fides, Montréal, 1984, 1206 p. ISBN 2-7621-1059-9 CONTRIBUTEURS·RICES: Aurélien Boivin, Roger Chamberland, Denise Doré, Gilles Dorion, André Gaulin, Kenneth Landry, Alonzo Le Blanc, Maurice Lemire, Lucie Robert.


#### Volume 5
Lemire, Maurice (dir.), <em>Dictionnaire des œuvres littéraires du Québec – Tome V – 1970-1975</em>, Fides, Montréal, 1987, 1240 p. ISBN 2-7621-1398-9 CONTRIBUTEURS·RICES: Aurélien Boivin, Roger Chamberland, Denise Doré, Gilles Dorion, André Gaulin, Kenneth Landry, Alonzo Le Blanc, Maurice Lemire, Michel Lord, Marie-José des Rivières, Lucie Robert.


#### Volume 6
Dorion, Gilles (dir.), <em>Dictionnaire des œuvres littéraires du Québec – Tome VI – 1976-1980</em>, Fides, Montréal, 1994, 1152 p. ISBN 2-7621-1695-3 CONTRIBUTEURS·RICES: Aurélien Boivin, Marie-Josée Blais, Roger Chamberland, Gilles Dorion, Christine Dufour, Gilles Girard, Lucie Jacques, Hélène Laliberté, François Larocque, Jean Morency, Chantal Saint-Louis.

