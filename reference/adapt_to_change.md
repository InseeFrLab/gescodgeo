# Modifie une data frame pour prendre en compte les changements de géographie

La fonction `adapt_to_change()` adapte une data frame aux changements de
géographie, pour prendre en compte les zones qui ont fusionnées ou qui
se sont scindées.

- Pour des fusions : réduit le nombre de lignes en supprimant les
  doublons, recalcule des effectifs et des moyennes, détermine des
  catégories majoritaires.

- Pour des scissions : répartit les effectifs d'un parent entre ses
  descendants.

## Usage

``` r
adapt_to_change(
  data,
  from = NULL,
  to = NULL,
  sum_cols = NULL,
  mean_cols = NULL,
  cat_cols = NULL,
  weight_from = NULL,
  weight_to = NULL,
  id_cols = NULL,
  reduce = TRUE,
  infos = FALSE
)
```

## Arguments

- data:

  Une data frame.

- from:

  [`<tidy-select>`](https://dplyr.tidyverse.org/reference/dplyr_tidy_select.html)
  Colonne de la géographie initiale. Par défaut, `NULL` : les fusions ne
  sont pas traitées.

- to:

  [`<tidy-select>`](https://dplyr.tidyverse.org/reference/dplyr_tidy_select.html)
  Colonne de la géographie finale. Par défaut, `NULL` : les scissions ne
  sont pas traitées.

- sum_cols:

  [`<tidy-select>`](https://dplyr.tidyverse.org/reference/dplyr_tidy_select.html)
  Colonnes des sommes à recalculer. Par défaut, `NULL`.

- mean_cols:

  [`<tidy-select>`](https://dplyr.tidyverse.org/reference/dplyr_tidy_select.html)
  Colonnes de moyennes à recalculer. Par défaut, `NULL`.

- cat_cols:

  [`<tidy-select>`](https://dplyr.tidyverse.org/reference/dplyr_tidy_select.html)
  Colonnes des catégories pour lesquelles on détermine la modalité
  majoritaire. Par défaut, `NULL`.

- weight_from:

  [`<tidy-select>`](https://dplyr.tidyverse.org/reference/dplyr_tidy_select.html)
  Colonne pour la pondération les zones initiales, utilisée pour traiter
  les fusions. Par defaut, `NULL` : les zones ont le même poids.

- weight_to:

  [`<tidy-select>`](https://dplyr.tidyverse.org/reference/dplyr_tidy_select.html)
  Colonne pour la pondération les zones finales, utilisée pour traiter
  les scissions. Par defaut, `NULL` : les zones ont le même poids.

- id_cols:

  [`<tidy-select>`](https://dplyr.tidyverse.org/reference/dplyr_tidy_select.html)
  Colonnes identifiant de façon unique chaque observation. Pris en
  compte pour réduire la base (option `reduce`) ou recalculer les
  variables. Par défaut, `NULL`.

- reduce:

  Supprimer les lignes doublons en cas de fusion de zones. Par défaut,
  `TRUE`.

- infos:

  Ajouter les colonnes générées par la fonction pour les calculs
  intermédiaires. Par défaut, `FALSE`.

## Value

Une data frame avec un nombre de lignes égal ou inférieur.

## Details

Effectifs ou sommes à recalculer (paramètre `sum_cols`) : population,
nombre de logements, d'actifs...

- En cas de scission, les descendants se partagent l'effectif de leur
  ascendant, selon leurs poids respectifs (colonne `weight_to`).

- En cas de fusion, le descendant hérite de la somme des effectifs de
  ses ascendants.

Moyennes ou ratios a recalculer (paramètre `mean_cols`) : salaire moyen,
nombre de personnes par logement...

- En cas de scission, les descendants héritent de la moyenne de leur
  ascendant.

- en cas de fusion, le descendant hérite de la moyenne de ses
  ascendants, pondérée selon leurs poids respectifs (colonne
  `weight_from`).

Catégories à recalculer (paramètre `cat_cols`) :

- En cas de fusion, le descendant hérite de la catégorie majoritaire
  parmi ses ascendants, compte-tenu de leurs poids respectifs (colonne
  `weight_from`)

Si `infos` vaut `TRUE`, les colonnes intermédiaires suivantes, générées
par la fonction `adapt_to_change()`, sont conservées dans la data frame
:

- `NB_INI` : Nombre d'observations initiales pour des fusions

- `NB_FIN` : Nombre d'observation finales pour des scissions

- `RATIO_INI` : Poids relatif d'une ligne parmi celles qui vont
  fusionner

- `RATIo_FIN` : Poids relatif d'une ligne parmi celles qui résultent
  d'une scisson

## Examples

``` r
## Passer du departement a la region

# Superficie, population et densite par departement en Corse
dep_corse <- data.frame(
  DEP = c("2A", "2B"),
  REG = c("94", "94"),
  POP = c(160814, 182887),
  SUP = c(4014.2  , 4665.6),
  DENS = c(40.1,39.2)
)

# Recalcule les variables et fusionne les lignes
# La superficie (SUP) sert de ponderation pour la densite moyenne (DENS)
dep_corse |> adapt_to_change(
  from = DEP,
  to = REG,
  weight_from = SUP,
  sum_cols = c("POP","SUP"),
  mean_cols = DENS
)
#> # A tibble: 1 × 5
#>   DEP   REG      POP   SUP  DENS
#>   <chr> <chr>  <dbl> <dbl> <dbl>
#> 1 2A    94    343701 8680.  39.6

## Changer la geographie des communes

# Deplacements domicile-travail par commune en geographie 2023
data <- data.frame(
  COM23 = c("08053","08294", "60054"),
  IPONDI = c(855,57.1, 398),
  DIST = c(13.4, 22.3, 31.7),
  CO2_HEBDO = c(14478, 24279, 27536)
)

# Changement de geographie de 2023 à 2024
data <- data |> change_cog(
  from = COM23,
  to = "COM24",
  cog_from = 2023,
  cog_to = 2024,
  infos = TRUE
)

# Remarques :
# - les communes 08053 et 08294 fusionnent, la commune 60054 est scindee
# - L'argument infos = TRUE permet d'obtenir la population finale (POP_FIN),
#   qui servira de cle de repartition pour les communes scindees

# Recalcule les variables numeriques et fusionne les lignes
data |> adapt_to_change(
  from = COM23,
  to = COM24,
  sum_cols = c(IPONDI, CO2_HEBDO),
  mean_cols = DIST,

  #' Pondère les moyennes (mean_cols) pour les communes fusionees
  weight_from = IPONDI,

  #' Repartit les effectifs (sum_cols) pour les communes scindees
  weight_to = POP_FIN
)
#> # A tibble: 3 × 9
#>   COM23 COM24 IPONDI  DIST CO2_HEBDO POP_INI POP_FIN NB_COM_INI NB_COM_FIN
#>   <chr> <chr>  <dbl> <dbl>     <dbl>   <dbl>   <dbl>      <int>      <int>
#> 1 08053 08053   912.  14.0    38757     2405    2502          2          1
#> 2 60054 60054   152.  31.7    10506.     873     335          1          2
#> 3 60054 60694   246.  31.7    17030.     873     543          1          2

## Changer la geographie de communes avec une variable identifiante

## Commune 60054 par mode de trasnport (MODTRANS)
data <- data.frame(
  COM23 = c("60054","60054"),
  MODTRANS = c("5", "6"),
  IPONDI = c(374, 19.6),
  DIST = c(29.3, 69.1),
  CO2_HEBDO = c(28999, 2491)
)

# Changement de geographie de 2023 à 2024
data <- data |> change_cog(
  from = COM23,
  to = "COM24",
  cog_from = 2023,
  cog_to = 2024,
  infos = TRUE
)

# Recalcule les variables numeriques et fusionne les lignes
data |> adapt_to_change(
  from = COM23,
  to = COM24,
  sum_cols = c(IPONDI, CO2_HEBDO),
  mean_cols = DIST,

  #' Colonne(s) identifiante(s)
  id_cols = MODTRANS,

  #' Pondère les moyennes (mean_cols) pour les communes fusionées
  weight_from = IPONDI,

  #' Répartit les effectifs (sum_cols) pour les communes scindées
  weight_to = POP_FIN
)
#> # A tibble: 4 × 10
#>   COM23 COM24 MODTRANS IPONDI  DIST CO2_HEBDO POP_INI POP_FIN NB_COM_INI
#>   <chr> <chr> <chr>     <dbl> <dbl>     <dbl>   <dbl>   <dbl>      <int>
#> 1 60054 60054 5        143.    29.3    11065.     873     335          1
#> 2 60054 60694 5        231.    29.3    17934.     873     543          1
#> 3 60054 60054 6          7.48  69.1      950.     873     335          1
#> 4 60054 60694 6         12.1   69.1     1541.     873     543          1
#> # ℹ 1 more variable: NB_COM_FIN <int>
```
