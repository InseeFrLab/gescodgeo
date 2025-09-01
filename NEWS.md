# gescodgeo 2025.1
_Juin 2025_

* Mise à jour de la population de référence dans la table de passage à partir de la population légale pour l'année 2025.

# gescodgeo 2025.0
_Février 2025_

* Ajout du code officiel géographique 2025.
* La population de référence 2025 est une estimation temporaire d'après la population légale 2024, car la population légale 2025 n'est pas encore disponible.

# gescodgeo 2024.2
_Décembre 2024_

  - Fonction `cog_events()` : renvoie une data frame avec les évenements ayant eu lieu depuis 2008 pour un code géographique donné : fusions, scissions ou changement de code.

# gescodgeo 2024.1
_Novembre 2024_

* Mise à jour de la population de référence dans la table de passage à partir de la population légale pour l'année 2024.
* Suppression des fonctions obsolètes depuis la version 3.0 : 
  - `change_annee_com()` remplacée par `change_cog()`,
  - `recalcule()` remplacée par `adapt_to_change()`,
  - `verifie_cog()` remplacée par `check_cog()`,
  - `table_passage()` remplacée par `cog_transition()`,
  - `hors_mayotte()` remplacée par `filter_mayotte()`.
* Suppression des bases qui ne servaient que pour des exemples : 
  - `dordogne_2020`,
  - `dordogne_modtrans_2020`,
  - `marseille_2020`.

# gescodgeo 2024.0
_Mars 2024_

* Ajout du code officiel géographique 2024.
* La population de référence 2024 est une estimation temporaire d'après la population légale 2023, car la population légale 2024 n'est pas encore disponible.
* Modification de la fonction `change_cog()` : argument `split_ratio` pour ajouter une clé de répartition qui peut être utilisée pour répartir des effectifs quand des communes sont scindées.
