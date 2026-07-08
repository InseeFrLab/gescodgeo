# Adapter les données

Cette page présente des méthodes pour recalculer les moyennes et les
effectifs après un changement de géographie. Ces solutions sont valables
pour une base individuelle ou agrégée selon une ou plusieurs variables.
Elles s’appliquent aussi, par extension, pour une base communale.

Je pars d’une base individuelle sur les trajets domicile-travail et les
émissions de CO2 en géographie géographie 2019 (variable COM19), que je
souhaite passer en géographie 2020.

``` r
# Librairies utilisées dans cet exemple
library(dplyr)
library(gescodgeo)

# Déplacements domicile-travail dans quelques communes
data
#> # A tibble: 6 × 5
#>   PRENOM  COM19 IPONDI  DIST CO2_HEBDO
#>   <chr>   <chr>  <dbl> <dbl>     <dbl>
#> 1 Pierre  14001      4 13.6      13953
#> 2 Paul    14712      2 15.7      16325
#> 3 Jacques 21183      2  9.82     12183
#> 4 Livia   21507      4 16.2      16156
#> 5 Estelle 21183      2 12.2      12676
#> 6 Louise  21507      2 13.5       7801
```

Ces individus n’ont pas la même pondération (variable IPONDI). La
variable DIST représente la distance domicile-travail en km. La variable
CO2_HEBDO représente les émissions de gaz à effet de serre occasionés
par les trajets domicile-travail pour une semaine moyenne, exprimés en
équivalent CO2.

Je commence par changer la géographie, passant de 2019 à 2020.

``` r
# Change la géographie des communes
new <- data %>%
  change_cog(cog_from = 2019, cog_to = 2020, from = COM19, to = "COM20") 

# Nouvelle base
new
#> # A tibble: 7 × 6
#>   PRENOM  COM19 COM20 IPONDI  DIST CO2_HEBDO
#>   <chr>   <chr> <chr>  <dbl> <dbl>     <dbl>
#> 1 Pierre  14001 14001      4 13.6      13953
#> 2 Paul    14712 14666      2 15.7      16325
#> 3 Paul    14712 14712      2 15.7      16325
#> 4 Jacques 21183 21183      2  9.82     12183
#> 5 Livia   21507 21183      4 16.2      16156
#> 6 Estelle 21183 21183      2 12.2      12676
#> 7 Louise  21507 21183      2 13.5       7801
```

On remarque ci-dessus que Paul apparait deux fois dans la nouvelle base,
pour tenir compte de la scission de la commune 14712. À cause de cette
duplication, les moyennes et les effectifs totaux ne sont pas respectés
après le changement de géographie.

``` r
# Avant le changement de géographie
data %>% summarise(
  DIST = weighted.mean(DIST, IPONDI),
  CO2_HEBDO = weighted.mean(CO2_HEBDO, IPONDI),
  IPONDI = sum(IPONDI)
)
#> # A tibble: 1 × 3
#>    DIST CO2_HEBDO IPONDI
#>   <dbl>     <dbl>  <dbl>
#> 1  13.9    13650.     16
# Après le changement de géographie
new %>% summarise(
  DIST = weighted.mean(DIST, IPONDI),
  CO2_HEBDO = weighted.mean(CO2_HEBDO, IPONDI),
  IPONDI = sum(IPONDI)
)
#> # A tibble: 1 × 3
#>    DIST CO2_HEBDO IPONDI
#>   <dbl>     <dbl>  <dbl>
#> 1  14.1    13948.     18
```

## Utiliser une pondération issue de la table de passage

Pour rétablir des agrégats cohérents, il suffirait de diviser par deux
la pondération des individus vivant dans les communes 14666 et 14712 en
géographie 2020. Cette approximation est souvent suffisante. Cependant,
afin d’être plus précis, je souhaite tenir compte du poids relatif des
communes scindées d’après leur population finale.

``` r
# Table de passage entre 2019 et 2020
cog_transition(2019, 2020)
#> # A tibble: 8 × 7
#>   COM_INI COM_FIN POP_INI POP_FIN NB_COM_INI NB_COM_FIN SPLIT_RATIO
#>   <chr>   <chr>     <int>   <dbl>      <int>      <int>       <dbl>
#> 1 14712   14666      5428    1918          1          2       0.353
#> 2 14712   14712      5428    3510          1          2       0.647
#> 3 21183   21183       896    1037          2          1       1    
#> 4 21213   21452       807    2664          2          1       1    
#> 5 21452   21452      1857    2664          2          1       1    
#> 6 21507   21183       141    1037          2          1       1    
#> 7 45287   45307        97    1109          2          1       1    
#> 8 45307   45307      1012    1109          2          1       1
```

La fonction
[`change_cog()`](https://inseefrlab.github.io/gescodgeo/reference/change_cog.md)
permet d’ajouter un ratio qui donne directement une clé de répartition
(variable SPLIT_RATIO).

``` r
# Change la géographie des communes et ajoute la colonne SPLIT_RATIO
new <- data %>%
  change_cog(cog_from = 2019, cog_to = 2020, from = COM19, to = "COM20", 
             split_ratio = TRUE) 

# Utilise SPLIT_RATIO pour corriger la pondération des communes scindées
new <- new %>% mutate(IPONDI = SPLIT_RATIO * IPONDI)

# Nouvelle base
new
#> # A tibble: 7 × 7
#>   PRENOM  COM19 COM20 IPONDI  DIST CO2_HEBDO SPLIT_RATIO
#>   <chr>   <chr> <chr>  <dbl> <dbl>     <dbl>       <dbl>
#> 1 Pierre  14001 14001  4     13.6      13953       1    
#> 2 Paul    14712 14666  0.707 15.7      16325       0.353
#> 3 Paul    14712 14712  1.29  15.7      16325       0.647
#> 4 Jacques 21183 21183  2      9.82     12183       1    
#> 5 Livia   21507 21183  4     16.2      16156       1    
#> 6 Estelle 21183 21183  2     12.2      12676       1    
#> 7 Louise  21507 21183  2     13.5       7801       1
```

On peut vérifier que les agrégats sont corrects après le changement de
géographie et le recalcul des variables.

``` r
# Avant le changement de géographie
data %>% summarise(
  DIST = weighted.mean(DIST, IPONDI),
  CO2_HEBDO = weighted.mean(CO2_HEBDO, IPONDI),
  IPONDI = sum(IPONDI)
)
#> # A tibble: 1 × 3
#>    DIST CO2_HEBDO IPONDI
#>   <dbl>     <dbl>  <dbl>
#> 1  13.9    13650.     16
# Après le changement de géographie
new %>% summarise(
  DIST = weighted.mean(DIST, IPONDI),
  CO2_HEBDO = weighted.mean(CO2_HEBDO, IPONDI),
  IPONDI = sum(IPONDI)
)
#> # A tibble: 1 × 3
#>    DIST CO2_HEBDO IPONDI
#>   <dbl>     <dbl>  <dbl>
#> 1  13.9    13650.     16
```

## Ne pas dupliquer les lignes en cas de scission

Selon les analyses statistiques, on peut avoir besoin, ou pas, de
refléter l’exhaustivité du territoire dans la géographie finale, en
faisant aparaître toutes les communes qui ont défusionné.

L’alternative présentée ici correspond à une approche dans laquelle on
considère qu’il n’est pas utile de rendre visible ces communes issues
d’une scission. On perd en précision, mais cela rend plus simple le
recalcul des variables numériques après un changement de géographie.

L’argument `one_to_one` de la fonction
[`change_cog()`](https://inseefrlab.github.io/gescodgeo/reference/change_cog.md)
permet de ne garder qu’une seule commmune en cas de scission. Le code
est celui de la commune initiale s’il est présent dans l’une des
communes issues de la scission, sinon il correspond à celui de la
commune fille qui est la plus peuplée. Cette option permet d’éviter que
des lignes soient dupliquées en cas de scission. La base finale contient
donc le même nombre de ligne que la base initiale.

``` r
# Change la géographie de 2019 à 2020 avec une nouvelle variable COM20
new <- data %>% 
  change_cog(cog_from = 2019, 
             cog_to = 2020, 
             from = COM19, 
             to = "COM20",
             one_to_one = TRUE)
new
#> # A tibble: 6 × 6
#>   PRENOM  COM19 COM20 IPONDI  DIST CO2_HEBDO
#>   <chr>   <chr> <chr>  <dbl> <dbl>     <dbl>
#> 1 Pierre  14001 14001      4 13.6      13953
#> 2 Paul    14712 14712      2 15.7      16325
#> 3 Jacques 21183 21183      2  9.82     12183
#> 4 Livia   21507 21183      4 16.2      16156
#> 5 Estelle 21183 21183      2 12.2      12676
#> 6 Louise  21507 21183      2 13.5       7801
```

On peut vérifier que les agrégats sont bien respectés :

``` r
# Avant le changement de géographie
data %>% summarise(
  DIST = weighted.mean(DIST, IPONDI),
  CO2_HEBDO = weighted.mean(CO2_HEBDO, IPONDI),
  IPONDI = sum(IPONDI)
)
#> # A tibble: 1 × 3
#>    DIST CO2_HEBDO IPONDI
#>   <dbl>     <dbl>  <dbl>
#> 1  13.9    13650.     16
# Après le changement de géographie
new %>% summarise(
  DIST = weighted.mean(DIST, IPONDI),
  CO2_HEBDO = weighted.mean(CO2_HEBDO, IPONDI),
  IPONDI = sum(IPONDI)
)
#> # A tibble: 1 × 3
#>    DIST CO2_HEBDO IPONDI
#>   <dbl>     <dbl>  <dbl>
#> 1  13.9    13650.     16
```

## Cas d’une base bilocalisée

Dans cette exemple, je pars d’une base sur les trajets domicile-travail
contenant une ligne par commune de départ et d’arrivée. Ces communes
sont renseignées en géographie 2019 (variable RESID_19 et TRAV_19). Je
souhaite les passer en géographie 2020.

``` r
# Déplacements domicile-travail dans quelques communes
data
#> # A tibble: 6 × 5
#>   RESID_19 TRAV_19 IPONDI  DIST DUREE
#>   <chr>    <chr>    <dbl> <dbl> <dbl>
#> 1 14712    14712   12063.  18.0  18.1
#> 2 14001    14712    2266.  23.7  21.2
#> 3 21183    21001     385.  20.7  22.4
#> 4 21507    21507     125   20.9  23.2
#> 5 45287    45001     101   40.4  40.3
#> 6 45307    45307     418.  31.3  29.9
```

Je commence par changer la géographie de cette base, passant de 2019 à
2020.

``` r
# Change la géographie des communes
new <- data %>%
  change_cog(cog_from = 2019, cog_to = 2020, from = RESID_19, to = "RESID_20") %>%
  change_cog(cog_from = 2019, cog_to = 2020, from = TRAV_19, to = "TRAV_20") 

new
#> # A tibble: 10 × 7
#>    RESID_19 RESID_20 TRAV_19 TRAV_20 IPONDI  DIST DUREE
#>    <chr>    <chr>    <chr>   <chr>    <dbl> <dbl> <dbl>
#>  1 14712    14666    14712   14666   12063.  18.0  18.1
#>  2 14712    14666    14712   14712   12063.  18.0  18.1
#>  3 14712    14712    14712   14666   12063.  18.0  18.1
#>  4 14712    14712    14712   14712   12063.  18.0  18.1
#>  5 14001    14001    14712   14666    2266.  23.7  21.2
#>  6 14001    14001    14712   14712    2266.  23.7  21.2
#>  7 21183    21183    21001   21001     385.  20.7  22.4
#>  8 21507    21183    21507   21183     125   20.9  23.2
#>  9 45287    45307    45001   45001     101   40.4  40.3
#> 10 45307    45307    45307   45307     418.  31.3  29.9
```

Je souhaite revenir à une ligne par lieu de résidence et de travail
selon la géographie 2020. Je pourrais le faire directement avec la
fonction
[`summarise()`](https://dplyr.tidyverse.org/reference/summarise.html) de
`dplyr`.

``` r
# Agrège les moyennes DIST et DUREE et l'effectif IPONDI dans la nouvelle géographie
new <- new %>% 
  group_by(RESID_20, TRAV_20) %>%
  summarise(DIST = weighted.mean(DIST, IPONDI),
            DUREE = weighted.mean(DUREE, IPONDI),
            IPONDI = sum(IPONDI),
            .groups = "drop")

new
#> # A tibble: 10 × 5
#>    RESID_20 TRAV_20  DIST DUREE IPONDI
#>    <chr>    <chr>   <dbl> <dbl>  <dbl>
#>  1 14001    14666    23.7  21.2  2266.
#>  2 14001    14712    23.7  21.2  2266.
#>  3 14666    14666    18.0  18.1 12063.
#>  4 14666    14712    18.0  18.1 12063.
#>  5 14712    14666    18.0  18.1 12063.
#>  6 14712    14712    18.0  18.1 12063.
#>  7 21183    21001    20.7  22.4   385.
#>  8 21183    21183    20.9  23.2   125 
#>  9 45307    45001    40.4  40.3   101 
#> 10 45307    45307    31.3  29.9   418.
```

Toutefois, la transformation que j’ai effectuée ne respecte pas les
agrégats (effectif total, durée moyenne et durée totale), car les
communes scindées ont été dupliquées.

``` r
# Avant le changement de géographie
data %>% summarise(
  DIST = weighted.mean(DIST, IPONDI),
  DUREE = weighted.mean(DUREE, IPONDI),
  IPONDI = sum(IPONDI)
)
#> # A tibble: 1 × 3
#>    DIST DUREE IPONDI
#>   <dbl> <dbl>  <dbl>
#> 1  19.5  19.2 15358.

# Après le changement de géographie
new %>% summarise(
  DIST = weighted.mean(DIST, IPONDI),
  DUREE = weighted.mean(DUREE, IPONDI),
  IPONDI = sum(IPONDI)
)
#> # A tibble: 1 × 3
#>    DIST DUREE IPONDI
#>   <dbl> <dbl>  <dbl>
#> 1  18.7  18.5 53813.
```

Pour rétablir des agrégats cohérents, je pondère les lignes selon le
poids relatif des communes scindées, en comparant leurs populations
légales. Je peux m’appuyer pour cela sur la variable SPLIT_RATIO,
ajoutée par la fonction
[`change_cog()`](https://inseefrlab.github.io/gescodgeo/reference/change_cog.md).

``` r
# Change la géographie de la commune de résidence
new <- data %>% change_cog(cog_from = 2019, cog_to = 2020, 
                           from = RESID_19, to = "RESID_20",
                           split_ratio = TRUE)

# Modifie la pondération en utilisant une clé de répartition
new <- new %>% mutate(IPONDI = SPLIT_RATIO * IPONDI)

# Change la géographie de la commune de travail
new <- new %>% change_cog(cog_from = 2019, cog_to = 2020, 
                          from = TRAV_19, to = "TRAV_20", 
                          split_ratio = TRUE) 
#> Warning: Variable(s) ecrasee(s) : SPLIT_RATIO

# Modifie à nouveau la pondération en utilisant une clé de répartition
new <- new %>% mutate(IPONDI = SPLIT_RATIO * IPONDI)
```

Les pondérations sont maintenant corrigées pour les scissions. Afin de
n’avoir qu’une seule ligne par commune de départ et d’arrivée, la base
est agrégée avec les fonctions
[`group_by()`](https://dplyr.tidyverse.org/reference/group_by.html) et
[`summarise()`](https://dplyr.tidyverse.org/reference/summarise.html) de
dplyr.

``` r
# Agrège les moyennes DIST et DUREE et l'effectif IPONDI dans la nouvelle géographie
new <- new %>% 
  group_by(RESID_20, TRAV_20) %>%
  summarise(DIST = weighted.mean(DIST, IPONDI),
            DUREE = weighted.mean(DUREE, IPONDI),
            IPONDI = sum(IPONDI),
            .groups = "drop")

new
#> # A tibble: 10 × 5
#>    RESID_20 TRAV_20  DIST DUREE IPONDI
#>    <chr>    <chr>   <dbl> <dbl>  <dbl>
#>  1 14001    14666    23.7  21.2   801.
#>  2 14001    14712    23.7  21.2  1465.
#>  3 14666    14666    18.0  18.1  1506.
#>  4 14666    14712    18.0  18.1  2756.
#>  5 14712    14666    18.0  18.1  2756.
#>  6 14712    14712    18.0  18.1  5044.
#>  7 21183    21001    20.7  22.4   385.
#>  8 21183    21183    20.9  23.2   125 
#>  9 45307    45001    40.4  40.3   101 
#> 10 45307    45307    31.3  29.9   418.
```

Je vérifie que les agrégats sont bien respectés.

``` r
# Avant le changement de géographie
data %>% summarise(
  DIST = weighted.mean(DIST, IPONDI),
  DUREE = weighted.mean(DUREE, IPONDI),
  IPONDI = sum(IPONDI)
)
#> # A tibble: 1 × 3
#>    DIST DUREE IPONDI
#>   <dbl> <dbl>  <dbl>
#> 1  19.5  19.2 15358.

# Après le changement de géographie
new %>% summarise(
  DIST = weighted.mean(DIST, IPONDI),
  DUREE = weighted.mean(DUREE, IPONDI),
  IPONDI = sum(IPONDI)
)
#> # A tibble: 1 × 3
#>    DIST DUREE IPONDI
#>   <dbl> <dbl>  <dbl>
#> 1  19.5  19.2 15358.
```

## Utiliser une fonction dédiée

Quand une base contient une seule ligne par commune, la fonction
[`adapt_to_change()`](https://inseefrlab.github.io/gescodgeo/reference/adapt_to_change.md)
permet de recalculer les moyennes et le effectifs pour tenir compte du
changement de géographie. Il est aussi possible de déterminer des
catégories majoritaires pour les communes fusionnées en utilisant
l’argument `cat_cols`. C’est notamment utile pour transposer un zonage
dans une autre géographie.

La fonction
[`adapt_to_change()`](https://inseefrlab.github.io/gescodgeo/reference/adapt_to_change.md)
s’applique aussi à une base semi-agrégée, en précisant les différentes
variables identifiantes avec l’argument `id_cols`. Toutefois, si la base
est trop complexe, il est souvant plus facile de revenir aux méthodes
présentées plus ci-dessus.

Dans cet exemple, les communes sont renseignées en géographie 2019
(variable COM19). Je souhaite les passer en géographie 2020.

``` r
# Déplacements domicile-travail dans quelques communes
data
#> # A tibble: 6 × 4
#>   COM19 IPONDI  DIST DUREE
#>   <chr>  <dbl> <dbl> <dbl>
#> 1 14001 12063.  18.0  18.1
#> 2 14712  2266.  23.7  21.2
#> 3 21183   385.  20.7  22.4
#> 4 21507   125   20.9  23.2
#> 5 45287   101   40.4  40.3
#> 6 45307   418.  31.3  29.9
```

Je commence par changer la géographie, passant de 2019 à 2020.

``` r
# Change la géographie des communes
new <- data %>%
  change_cog(cog_from = 2019, cog_to = 2020, from = COM19, to = "COM20") 
```

Je souhaite maintenant adapter la pondération (variable IPONDI), les
distances moyennes (DIST) et les durées moyennes (DUREE) pour tenir
compte du nouveau découpage des communes.

Dans la fonction
[`adapt_to_change()`](https://inseefrlab.github.io/gescodgeo/reference/adapt_to_change.md),
je mentionne la géographie initiale, la géographie finale, ainsi que les
variables que je souhaite recalculer. Je précise également que la
variable IPONDI correspond au poids de mes observations dans la base
initiale. Cette pondération est prise en compte pour recalculer les
moyennes dans les fusions.

``` r
# Adapte les variables aux changements de géographie
new <- new %>% adapt_to_change(
  
    # Géographie initiale et géographie finale
    from = COM19, 
    to = COM20,
    
    # Moyennes et sommes à recalculer
    mean_cols = c(DIST, DUREE), 
    sum_cols = IPONDI,
    
    # Pondération dans la base initiale
    weight_from = IPONDI
)
new
#> # A tibble: 5 × 5
#>   COM19 COM20 IPONDI  DIST DUREE
#>   <chr> <chr>  <dbl> <dbl> <dbl>
#> 1 21183 21183   510.  20.7  22.6
#> 2 45287 45307   519.  33.1  31.9
#> 3 14001 14001 12063.  18.0  18.1
#> 4 14712 14666  1133.  23.7  21.2
#> 5 14712 14712  1133.  23.7  21.2
```

Je vérifie que mes agrégats sont bien respectés.

``` r
# Avant le changement de géographie
data %>% summarise(
  DIST = weighted.mean(DIST, IPONDI),
  DUREE = weighted.mean(DUREE, IPONDI),
  IPONDI = sum(IPONDI)
)
#> # A tibble: 1 × 3
#>    DIST DUREE IPONDI
#>   <dbl> <dbl>  <dbl>
#> 1  19.5  19.2 15358.
# Après le changement de géographie
new %>% summarise(
  DIST = weighted.mean(DIST, IPONDI),
  DUREE = weighted.mean(DUREE, IPONDI),
  IPONDI = sum(IPONDI)
)
#> # A tibble: 1 × 3
#>    DIST DUREE IPONDI
#>   <dbl> <dbl>  <dbl>
#> 1  19.5  19.2 15358.
```

### Utiliser une pondération issue de la table de passage

Avec la scission de la commune 14712, les effectifs ont implicitement
été répartis entre les deux communes filles 14712 et 14666, qui
présentent un nombre de navetteurs identique. Pourtant, dans la table de
passage, on voit que la commune 14712 est dotée d’une population finale
plus importante que la commune 14666.

``` r
cog_transition(2019, 2020)
#> # A tibble: 8 × 7
#>   COM_INI COM_FIN POP_INI POP_FIN NB_COM_INI NB_COM_FIN SPLIT_RATIO
#>   <chr>   <chr>     <int>   <dbl>      <int>      <int>       <dbl>
#> 1 14712   14666      5428    1918          1          2       0.353
#> 2 14712   14712      5428    3510          1          2       0.647
#> 3 21183   21183       896    1037          2          1       1    
#> 4 21213   21452       807    2664          2          1       1    
#> 5 21452   21452      1857    2664          2          1       1    
#> 6 21507   21183       141    1037          2          1       1    
#> 7 45287   45307        97    1109          2          1       1    
#> 8 45307   45307      1012    1109          2          1       1
```

On peut utiliser cette clé de répartition pour attribuer plus finement
les effectifs après la scission. D’abord, j’indique que je souhaite
conserver les informations issues de la table de passage dans la
fonction
[`change_cog()`](https://inseefrlab.github.io/gescodgeo/reference/change_cog.md).
Ensuite, j’utilise la population finale pour pondérer les observations
après transformation dans la fonction
[`adapt_to_change()`](https://inseefrlab.github.io/gescodgeo/reference/adapt_to_change.md).

``` r
# Change la géographie et ajoute les informations de la table de passage
new <- data %>% change_cog(
  cog_from = 2019, cog_to = 2020, 
  from = COM19, to = "COM20",
  infos = TRUE
)
new
#> # A tibble: 7 × 9
#>   COM19 COM20 IPONDI  DIST DUREE POP_INI POP_FIN NB_COM_INI NB_COM_FIN
#>   <chr> <chr>  <dbl> <dbl> <dbl>   <int>   <dbl>      <int>      <int>
#> 1 14001 14001 12063.  18.0  18.1      NA      NA         NA         NA
#> 2 14712 14666  2266.  23.7  21.2    5428    1918          1          2
#> 3 14712 14712  2266.  23.7  21.2    5428    3510          1          2
#> 4 21183 21183   385.  20.7  22.4     896    1037          2          1
#> 5 21507 21183   125   20.9  23.2     141    1037          2          1
#> 6 45287 45307   101   40.4  40.3      97    1109          2          1
#> 7 45307 45307   418.  31.3  29.9    1012    1109          2          1
# Recalcule les variables avec une pondération initiale et une pondération finale
new <- new %>% adapt_to_change(
  from = COM19, to = COM20,
  mean_cols = c(DIST, DUREE), sum_cols = IPONDI,
  weight_from = IPONDI, weight_to = POP_FIN
)
new
#> # A tibble: 5 × 9
#>   COM19 COM20 IPONDI  DIST DUREE POP_INI POP_FIN NB_COM_INI NB_COM_FIN
#>   <chr> <chr>  <dbl> <dbl> <dbl>   <int>   <dbl>      <int>      <int>
#> 1 21183 21183   510.  20.7  22.6     896    1037          2          1
#> 2 45287 45307   519.  33.1  31.9      97    1109          2          1
#> 3 14712 14666   801.  23.7  21.2    5428    1918          1          2
#> 4 14712 14712  1465.  23.7  21.2    5428    3510          1          2
#> 5 14001 14001 12063.  18.0  18.1      NA      NA         NA         NA
```

Comme précédemment, je vérifie que mes agrégats sont bien respectés.

``` r
# Avant le changement de géographie
data %>% summarise(
  DIST = weighted.mean(DIST, IPONDI),
  DUREE = weighted.mean(DUREE, IPONDI),
  IPONDI = sum(IPONDI)
)
#> # A tibble: 1 × 3
#>    DIST DUREE IPONDI
#>   <dbl> <dbl>  <dbl>
#> 1  19.5  19.2 15358.
# Après le changement de géographie
new %>% summarise(
  DIST = weighted.mean(DIST, IPONDI),
  DUREE = weighted.mean(DUREE, IPONDI),
  IPONDI = sum(IPONDI)
)
#> # A tibble: 1 × 3
#>    DIST DUREE IPONDI
#>   <dbl> <dbl>  <dbl>
#> 1  19.5  19.2 15358.
```

### Cas d’une base semi-agrégée avec plusieurs variables identifiantes

Je pars maintenant d’une base sur les trajets domicile-travail contenant
une ligne par commune et par mode de transport. Le cas pourrait
s’étendre à toute forme de base semi-agrégée, par exemple contenant une
ligne par commune, mode de transport, sexe et catégorie socio-
professionnelle.

``` r
# Base semi-agrégée par commune et par mode de transport
data
#> # A tibble: 6 × 5
#>   COM19 MODTRANS IPONDI  DIST DUREE
#>   <chr> <chr>     <dbl> <dbl> <dbl>
#> 1 14712 voiture   12062 18.0   18.1
#> 2 14712 vélo        266  7.67  10.2
#> 3 14001 voiture     384 20.7   22.4
#> 4 14001 vélo         52  8.90  13.2
#> 5 45287 voiture     101 40.4   40.3
#> 6 45307 voiture     418 31.3   29.9
# Change la géographie et ajoute les informations de la table de passage
new <- data %>% change_cog(
  cog_from = 2019, cog_to = 2020, 
  from = COM19, to = "COM20",
  infos = TRUE
)
new
#> # A tibble: 8 × 10
#>   COM19 COM20 MODTRANS IPONDI  DIST DUREE POP_INI POP_FIN NB_COM_INI NB_COM_FIN
#>   <chr> <chr> <chr>     <dbl> <dbl> <dbl>   <int>   <dbl>      <int>      <int>
#> 1 14712 14666 voiture   12062 18.0   18.1    5428    1918          1          2
#> 2 14712 14712 voiture   12062 18.0   18.1    5428    3510          1          2
#> 3 14712 14666 vélo        266  7.67  10.2    5428    1918          1          2
#> 4 14712 14712 vélo        266  7.67  10.2    5428    3510          1          2
#> 5 14001 14001 voiture     384 20.7   22.4      NA      NA         NA         NA
#> 6 14001 14001 vélo         52  8.90  13.2      NA      NA         NA         NA
#> 7 45287 45307 voiture     101 40.4   40.3      97    1109          2          1
#> 8 45307 45307 voiture     418 31.3   29.9    1012    1109          2          1
```

Pour recalculer les variables, je précise qu’il faut ajouter la colonne
identifiante MODTRANS.

``` r
# Recalcule les variables avec une pondération initiale et une pondération finale
new <- new %>% adapt_to_change(
  from = COM19, to = COM20,
  id_cols = MODTRANS,
  mean_cols = c(DIST, DUREE), sum_cols = IPONDI,
  weight_from = IPONDI, weight_to = POP_FIN
)
new
#> # A tibble: 7 × 10
#>   COM19 COM20 MODTRANS IPONDI  DIST DUREE POP_INI POP_FIN NB_COM_INI NB_COM_FIN
#>   <chr> <chr> <chr>     <dbl> <dbl> <dbl>   <int>   <dbl>      <int>      <int>
#> 1 45287 45307 voiture   519   33.1   31.9      97    1109          2          1
#> 2 14712 14666 voiture  4262.  18.0   18.1    5428    1918          1          2
#> 3 14712 14712 voiture  7800.  18.0   18.1    5428    3510          1          2
#> 4 14712 14666 vélo       94.0  7.67  10.2    5428    1918          1          2
#> 5 14712 14712 vélo      172.   7.67  10.2    5428    3510          1          2
#> 6 14001 14001 voiture   384   20.7   22.4      NA      NA         NA         NA
#> 7 14001 14001 vélo       52    8.90  13.2      NA      NA         NA         NA
```

Je vérifie que mes agrégats sont bien respectés.

``` r
# Avant le changement de géographie
data %>% summarise(
  DIST = weighted.mean(DIST, IPONDI),
  DUREE = weighted.mean(DUREE, IPONDI),
  IPONDI = sum(IPONDI)
)
#> # A tibble: 1 × 3
#>    DIST DUREE IPONDI
#>   <dbl> <dbl>  <dbl>
#> 1  18.4  18.6  13283
# Après le changement de géographie
new %>% summarise(
  DIST = weighted.mean(DIST, IPONDI),
  DUREE = weighted.mean(DUREE, IPONDI),
  IPONDI = sum(IPONDI)
)
#> # A tibble: 1 × 3
#>    DIST DUREE IPONDI
#>   <dbl> <dbl>  <dbl>
#> 1  18.4  18.6  13283
```

Remarque : si j’ai plusieurs autres colonnes identifiantes, je les
ajoute de la même façon.

``` r
# Si j'ai initialement une ligne par COM19, MODTRANS, SEXE et CS1
new <- new %>% adapt_to_change(
  from = COM19, to = COM20,
  id_cols = c("MODTRANS", "SEXE", "CS1"),
  mean_cols = c(DIST, DUREE), sum_cols = IPONDI,
  weight_from = IPONDI, weight_to = POP_FIN
)
```
