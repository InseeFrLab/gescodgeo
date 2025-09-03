# gescodgeo <img src="man/figures/logo.png" align="right" height="139" alt="gescodgeo icon" />

Le package gescodgeo propose des fonctions pour la gestion des codes
géographiques des communes. Ses principales utilisations sont les
suivantes :

- Changer l’année du code officiel géographique des communes :
  - apparier deux sources dont la géographie est différente,
  - fournir des résultats avec un millésime plus récent,
  - utiliser un zonage qui n’est pas disponible dans la géographie
    initiale des données.
- Vérifier le code officiel géographique des communes :
  - détecter la géographie des communes avant de la changer,
  - repérer des communes mal codées.
- Passer des arrondissements municipaux à la commune et réciproquement
  pour Paris, Lyon et Marseille.

Les années disponibles du code officiel géographique vont de 2008 à
2025.

Voir le [code officiel géographique (COG)](https://www.insee.fr/fr/information/2560452) 
des communes sur Insee.fr.


## Installation

Installer la dernière version stable depuis github :

``` r
remotes::install_github("thomasmorin-insee/gescodgeo")
```

## Exemples

``` r
library(gescodgeo)
```

Un exemple de Data frame avec quelques communes

``` r
data <- data.frame(COM = c("14712", "53239", "53249", "53274", "13201"))
```

Les communes sont dans le COG de l'annee 2019
``` r
data |> check_cog(cog = 2019) 
#> [1] TRUE
```

Mais pas dans celui de l'annee 2021
``` r
data |> check_cog(cog = 2021) 
#> Warning: 
#> Les communes suivantes ne sont pas dans le COG de l'annee 2021 : 
#> 53239 53274
#> [1] FALSE
```

Change l'année de la géographie
``` r
data |> change_cog(from = COM, to = "COM_2021", cog_from = 2019, cog_to = 2021)
#>     COM COM_2021
#> 1 14712    14666
#> 2 14712    14712
#> 3 53239    53249
#> 4 53249    53249
#> 5 53274    53249
#> 6 13201    13201
```

Renvoie la table de passage entre 2019 et 2021
``` r
cog_transition(cog_from = 2019, cog_to = 2021) |> head()
#> # A tibble: 6 x 7
#>   COM_INI COM_FIN POP_INI POP_FIN NB_COM_INI NB_COM_FIN SPLIT_RATIO
#>   <chr>   <chr>     <int>   <dbl>      <int>      <int>       <dbl>
#> 1 14712   14666      5428    1912          1          2       0.355
#> 2 14712   14712      5428    3481          1          2       0.645
#> 3 16233   16233       451    1026          2          1       1    
#> 4 16351   16233       594    1026          2          1       1    
#> 5 21183   21183       896    1046          2          1       1    
#> 6 21213   21452       807    2789          2          1       1
```

Évènements pour un code géographique donné
``` r
cog_events("14712")
#>   COG_INI COG_FIN COM_INI COM_FIN NB_COM_INI NB_COM_FIN
#> 1    2016    2017   14666   14712          2          1
#> 2    2016    2017   14712   14712          2          1
#> 3    2019    2020   14712   14666          1          2
#> 4    2019    2020   14712   14712          1          2
```

Passe de l'arrondissement municipal à la commune
``` r
data |> arm_to_com()
#>     COM
#> 1 14712
#> 2 53239
#> 3 53249
#> 4 53274
#> 5 13055
``` 

Passe de la commune à l'arrondissement municipal (exemple pour un vecteur)
``` r
c("13001", "13055") |> com_to_arm()
#> [1] "13001" "13201" "13202" "13203" "13204" "13205" "13206" "13207" "13208"
#> [10] "13209" "13210" "13211" "13212" "13213" "13214" "13215" "13216"
```

Passe aux départements et aux régions
``` r
data |> com_to_dep(from = COM, to = "DEP") |> dep_to_reg(from = DEP, to = "REG")
#>     COM DEP REG
#> 1 14712  14  28
#> 2 53239  53  52
#> 3 53249  53  52
#> 4 53274  53  52
#> 5 13201  13  93
```
