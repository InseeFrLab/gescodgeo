# Change l'année du code officiel géographique des communes

Convertit les codes géographiques des communes dans une autre année du
code officiel géographique (COG). Les années vont de 2008 au dernier
millésime disponible.

## Usage

``` r
change_cog(
  data,
  cog_from,
  cog_to,
  from = NULL,
  to = NULL,
  infos = FALSE,
  split_ratio = FALSE,
  one_to_one = FALSE
)
```

## Arguments

- data:

  Un objet de type data frame ou vecteur.

- cog_from:

  Année initiale du code officiel géographique, à partir de 2008.

- cog_to:

  Année finale du code officiel géographique, à partir de 2008.

- from:

  [`<tidy-select>`](https://dplyr.tidyverse.org/reference/dplyr_tidy_select.html)
  Colonne initiale des communes. Par défaut, première colonne. Sans
  objet si `data` est un vecteur.

- to:

  Colonne finale pour les communes. Par défaut, même nom que la colonne
  initiale. Sans objet si `data` est un vecteur.

- infos:

  Ajouter les informations de la table de passage. Par défaut, FALSE.
  Sans objet si `data` est un vecteur.

- split_ratio:

  Ajouter une clé de répartition pour la réaffectation des effectifs
  quand des communes sont scindées. Par défaut, FALSE. Sans objet si
  `data` est un vecteur.

- one_to_one:

  Ne garder qu'une seule commmune en cas de scission. Le code est celui
  de la commune initiale s'il est présent dans l'une des communes issues
  de la scission, sinon il correspond à celui de la commune fille qui
  est la plus peuplée. Cette option permet d'éviter que des lignes
  soient dupliquées en cas de scission. Par défaut, FALSE.

## Value

Un objet du même type que `data`.

- Pour une data frame, une data frame avec un nombre de lignes égal ou
  supérieur. Le nombre de ligne est toujours égal si
  `one_to_one = TRUE`.

- Pour un vecteur, un vecteur de dimension égale ou supérieure. La
  dimension est toujours égale si `one_to_one = TRUE`.

## Examples

``` r
# Un exemple de data frame avec quelques communes
data <- data.frame(COM=c("14712", "16233", "16351", "53239", "53249", "53274"))

# Change l'annee du code officiel geographique des communes
data |> change_cog(from = "COM", cog_from = 2019, cog_to = 2021)
#>     COM
#> 1 14666
#> 2 14712
#> 3 16233
#> 4 16233
#> 5 53249
#> 6 53249
#> 7 53249

# Variante : ne retient qu'une commune apres scission
data |> change_cog(
  from = "COM",
  to = "COM_21",
  cog_from = 2019,
  cog_to = 2021,
  one_to_one = TRUE
)
#>     COM COM_21
#> 1 14712  14712
#> 2 16233  16233
#> 3 16351  16233
#> 4 53239  53249
#> 5 53249  53249
#> 6 53274  53249

# Informations de la table de passage
data |> change_cog(
  from = "COM",
  to = "COM_21",
  cog_from = 2019,
  cog_to = 2021,
  infos = TRUE
)
#>     COM COM_21 POP_INI POP_FIN NB_COM_INI NB_COM_FIN
#> 1 14712  14666    5428    1912          1          2
#> 2 14712  14712    5428    3481          1          2
#> 3 16233  16233     451    1026          2          1
#> 4 16351  16233     594    1026          2          1
#> 5 53239  53249     421    1121          3          1
#> 6 53249  53249     463    1121          3          1
#> 7 53274  53249     237    1121          3          1

# Cle de repartition pour les scissions
data |> change_cog(
  from = "COM",
  to = "COM_21",
  cog_from = 2019,
  cog_to = 2021,
  split_ratio = TRUE
)
#>     COM COM_21 SPLIT_RATIO
#> 1 14712  14666   0.3545337
#> 2 14712  14712   0.6454663
#> 3 16233  16233   1.0000000
#> 4 16351  16233   1.0000000
#> 5 53239  53249   1.0000000
#> 6 53249  53249   1.0000000
#> 7 53274  53249   1.0000000

# Pour un vecteur
change_cog(data = c("14712", "16233", "16351"), cog_from = 2019, cog_to = 2021)
#> [1] "14666" "14712" "16233" "16233"
```
