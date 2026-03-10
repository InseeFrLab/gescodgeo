# Changelog

## gescodgeo 2026.0

*Mars 2026*

- Ajout du code officiel géographique 2026. La géographie communale est
  similaire à 2025, pour des raisons légales (élections municipales).
- La population de référence 2026 est une estimation temporaire d’après
  la population légale 2025, car la population légale 2026 n’est pas
  encore disponible.

## gescodgeo 2025.1

*Juin 2025*

- Mise à jour de la population de référence dans la table de passage à
  partir de la population légale pour l’année 2025.

## gescodgeo 2025.0

*Février 2025*

- Ajout du code officiel géographique 2025.
- La population de référence 2025 est une estimation temporaire d’après
  la population légale 2024, car la population légale 2025 n’est pas
  encore disponible.

## gescodgeo 2024.2

*Décembre 2024*

- Fonction [`cog_events()`](../reference/cog_events.md) : renvoie une
  data frame avec les évenements ayant eu lieu depuis 2008 pour un code
  géographique donné : fusions, scissions ou changement de code.

## gescodgeo 2024.1

*Novembre 2024*

- Mise à jour de la population de référence dans la table de passage à
  partir de la population légale pour l’année 2024.
- Suppression des fonctions obsolètes depuis la version 3.0 :
  - `change_annee_com()` remplacée par
    [`change_cog()`](../reference/change_cog.md),
  - `recalcule()` remplacée par
    [`adapt_to_change()`](../reference/adapt_to_change.md),
  - `verifie_cog()` remplacée par
    [`check_cog()`](../reference/check_cog.md),
  - `table_passage()` remplacée par
    [`cog_transition()`](../reference/cog_transition.md),
  - `hors_mayotte()` remplacée par
    [`filter_mayotte()`](../reference/filter_mayotte.md).
- Suppression des bases qui ne servaient que pour des exemples :
  - `dordogne_2020`,
  - `dordogne_modtrans_2020`,
  - `marseille_2020`.

## gescodgeo 2024.0

*Mars 2024*

- Ajout du code officiel géographique 2024.
- La population de référence 2024 est une estimation temporaire d’après
  la population légale 2023, car la population légale 2024 n’est pas
  encore disponible.
- Modification de la fonction
  [`change_cog()`](../reference/change_cog.md) : argument `split_ratio`
  pour ajouter une clé de répartition qui peut être utilisée pour
  répartir des effectifs quand des communes sont scindées.
