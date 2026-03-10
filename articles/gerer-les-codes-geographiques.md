# Gérer les codes géographiques

Le code géographique des communes (COG) est modifié chaque année, avec
des fusions et des défusions de commune. Pour apparier des sources
statistiques qui n’ont pas le même COG, ou encore pour présenter des
résultats statistiques dans un découpage communal plus récent, il faut
tenir compte de ces changements. Cette page présente un exemple de
gestion des codes géographiques des communes avec gescodgeo.

Je pars d’une data frame sur les trajets domicile-travail dans quelques
communes.

``` r
# Librairies utilisées dans cet exemple
library(dplyr)
library(gescodgeo)

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

Le nombre de navetteurs (variable IPONDI) provient du millésime 2017 de
l’exploitation complémentaire du recensement de la population, dont le
code des communes est en géographie 2019 (variable COM19). Les distances
(DIST) et durées moyennes (DUREE) proviennent de Metric-OSRM et de
l’investissement AT27. Je souhaite convertir cette base en géographie
2020, par exemple pour l’apparier avec un nouveau millésime du
recensement.

## Vérifier le COG des communes

La fonction [`check_cog()`](../reference/check_cog.md) permet de
détecter des codes communes qui ne sont pas conformes au code officiel
géographique d’une année donnée.

``` r
data %>% check_cog(cog = 2019)
#> [1] TRUE
data %>% check_cog(cog = 2020)
#> Warning: 
#> Les communes suivantes ne sont pas dans le COG de l'annee 2020 : 
#> 21507 45287
#> [1] FALSE
```

Tous les codes des communes sont bien dans le code officiel géographique
2019. En revanche, les communes 21507 et 45287 ne sont pas dans le code
officiel géographique 2020.

En cas de doute sur un code géographique particulier, la fonction
[`cog_events()`](../reference/cog_events.md) renvoie l’historique des
évenements du COG concernant la commune depuis 2008.

``` r
cog_events("21507")
#>   COG_INI COG_FIN COM_INI COM_FIN NB_COM_INI NB_COM_FIN
#> 1    2019    2020   21507   21183          2          1
```

Cela permet notamment d’identifier des fusions de communes quand la
colonne NB_COM_INI est supérieure à 1 ou des scissions de communes quand
la colonne NB_COM_FIN est supérieure à 1.

## Voir la table de passage entre deux années

La fonction [`cog_transition()`](../reference/cog_transition.md) renvoie
la table de passage des communes entre deux années du code officiel
géographique.

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

Entre 2019 et 2020, la commune 14712 s’est scindée pour former les
communes 14666 et 14712. Les communes 45287 et 45307 ont fusionné pour
former la commune 45307. Cela explique pourquoi le code 45287 n’est pas
conforme au code officiel géographique 2020.

## Changer le COG des communes

Avec la fonction [`change_cog()`](../reference/change_cog.md), j’ajoute
une colonne COM20 contenant les codes des communes convertis dans le
code officiel géographique 2020.

``` r
# Change la géographie de 2019 à 2020 avec une nouvelle variable COM20
new <- data %>% 
  change_cog(cog_from = 2019, cog_to = 2020, from = COM19, to = "COM20")
```

Pour tenir compte de la scission de la commune 14712, la ligne est
dupliquée avec les nouveaux codes 14712 et 14666. Pour tenir compte de
la fusion des communes 21183 et 45307, les deux lignes présentent le
nouveau code 45307.

## Répartir les effectifs dans les communes scindées

La nouvelle base ne respecte pas le nombre total de navetteurs, car la
ligne de la commune 14712 est dupliquée. Une manière simple de rétablir
les effectifs consiste à appliquer un ratio selon le nombre de commune
fille.

``` r
# Répartit le nombre de navetteur (IPONDI) dans les communes scindées
new <- new %>%
  group_by(COM19) %>%
  mutate(IPONDI = IPONDI / n()) %>%
  ungroup()
new
#> # A tibble: 7 × 5
#>   COM19 COM20 IPONDI  DIST DUREE
#>   <chr> <chr>  <dbl> <dbl> <dbl>
#> 1 14001 14001 12063.  18.0  18.1
#> 2 14712 14666  1133.  23.7  21.2
#> 3 14712 14712  1133.  23.7  21.2
#> 4 21183 21183   385.  20.7  22.4
#> 5 21507 21183   125   20.9  23.2
#> 6 45287 45307   101   40.4  40.3
#> 7 45307 45307   418.  31.3  29.9
```

Pour aller plus loin, on peut utiliser une clé de répartition issue de
la table de passage pour tenir compte des poids respectifs des communes
filles : voir
[`vignette("adapter-les-donnees")`](../articles/adapter-les-donnees.md).

## Revenir à une seule ligne par commune

Pour revenir à une base individuelle, je dois agrégeger les effectifs et
recalculer les moyennes dans les communes qui ont fusionnées.

``` r
# Agrège selon le code géographique 2020 et recalcule les variables numériques
new <- new %>%
  group_by(COM20) %>%
  summarise(DIST = weighted.mean(DIST, IPONDI),
            DUREE = weighted.mean(DUREE, IPONDI),
            IPONDI = sum(IPONDI),
            .groups = "drop")
new
#> # A tibble: 5 × 4
#>   COM20  DIST DUREE IPONDI
#>   <chr> <dbl> <dbl>  <dbl>
#> 1 14001  18.0  18.1 12063.
#> 2 14666  23.7  21.2  1133.
#> 3 14712  23.7  21.2  1133.
#> 4 21183  20.7  22.6   510.
#> 5 45307  33.1  31.9   519.
```

On peut vérifier que les agrégats sont bien respectés :

``` r
# Avant le changement de géographie
data %>% summarise(DIST = weighted.mean(DIST, IPONDI),
                   DUREE = weighted.mean(DUREE, IPONDI),
                   IPONDI = sum(IPONDI))
#> # A tibble: 1 × 3
#>    DIST DUREE IPONDI
#>   <dbl> <dbl>  <dbl>
#> 1  19.5  19.2 15358.
# Après le changement de géographie
new %>% summarise(DIST = weighted.mean(DIST, IPONDI),
                  DUREE = weighted.mean(DUREE, IPONDI),
                  IPONDI = sum(IPONDI))
#> # A tibble: 1 × 3
#>    DIST DUREE IPONDI
#>   <dbl> <dbl>  <dbl>
#> 1  19.5  19.2 15358.
```

Si on n’a pas besoin de disposer de l’exhaustivité des communes dans la
base finale, on peut aussi utiliser l’option `one_to_one` dans la
fonction [`change_cog()`](../reference/change_cog.md), qui permet de ne
pas dupliquer les communes scindées, voir la deuxième méthode de la
[`vignette("adapter-les-donnees")`](../articles/adapter-les-donnees.md).

## Gérer les arrondissements municipaux

Selon les sources statistiques, les communes de Paris, Lyon et Marseille
peuvent être (ou ne pas être) découpées en arrondissements municipaux.
Les fonctions [`com_to_arm()`](../reference/com_to_arm.md) et
[`arm_to_com()`](../reference/arm_to_com.md) permettent de gérer ces
situations.

``` r
# Passer de l'arrondissement municipal à la commune (le cas échéant)
data.frame(ARM = c("75101", "75102", "13201", "13202", "13001")) %>% 
  # Conversion des arrondissments municipaux en communes
  arm_to_com(from = ARM, to = "COM")
#>     ARM   COM
#> 1 75101 75056
#> 2 75102 75056
#> 3 13201 13055
#> 4 13202 13055
#> 5 13001 13001
```

## Compléter les départements et les régions

D’autres fonctions de gescodgeo permettent de compléter les informations
géographiques au niveau départemental ou régional.

``` r
data.frame(COM = c("75101", "75102", "13201", "13202", "13001")) %>% 
  # Ajout des départements
  com_to_dep(from = COM, to = "DEP") %>% 
  # Ajout des régions
  dep_to_reg(from = DEP, to = "REG") 
#>     COM DEP REG
#> 1 75101  75  11
#> 2 75102  75  11
#> 3 13201  13  93
#> 4 13202  13  93
#> 5 13001  13  93
```

La plupart de ces méthodes contiennent leur réciproque (par exemple
[`reg_to_dep()`](../reference/reg_to_dep.md)) et peuvent s’appliquer
indifférement à une data frame ou à un vecteur.

``` r
# Arrondissements de Lyon
com_to_arm("69123")
#> [1] "69381" "69382" "69383" "69384" "69385" "69386" "69387" "69388" "69389"
# Départements de Corse et de PACA
reg_to_dep(c("93","94")) 
#> [1] "04" "05" "06" "13" "83" "84" "2A" "2B"
# Pour une data frame, les méthodes com_to_arm() et reg_to_dep() ajoutent des lignes
data.frame(REG = "94") %>% reg_to_dep()
#>   REG DEP
#> 1  94  2A
#> 2  94  2B
```
