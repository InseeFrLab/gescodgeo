# Convertit les communes en arrondissements municipaux

Convertit les codes géographiques des communes de Paris, Lyon et
Marseille en codes géographiques d'arrondissements municipaux.

## Usage

``` r
com_to_arm(
  data,
  from = NULL,
  to = NULL,
  extra = function(x) {
     return(x)
 }
)
```

## Arguments

- data:

  Un objet de type data frame ou vecteur.

- from:

  [`<tidy-select>`](https://dplyr.tidyverse.org/reference/dplyr_tidy_select.html)
  Colonne initiale des communes. Par défaut, première colonne. Sans
  objet si `data` est un vecteur.

- to:

  Colonne finale pour les communes ou arrondissements municipaux. Par
  défaut, même nom que la colonne initiale. Sans objet si `data` est un
  vecteur.

- extra:

  Autres codes géographiques : valeur unique, paires de clés et de
  valeurs ou fonction. Par défaut, les codes géographiques en dehors
  Paris, Lyon et Marseille ne sont pas changés.

## Value

Un objet du même type que `data`.

- Pour une data frame, une data frame avec un nombre de lignes égal ou
  supérieur.

- Pour un vecteur, un vecteur de dimension égale ou supérieure.

## Examples

``` r
x <- c("01123","13055","75056")

# data frame
data <- data.frame(ID = c(1:3), CODE_COM = x)
data |> com_to_arm(from = CODE_COM, to = "CODE_ARM") |> head()
#>   ID CODE_COM CODE_ARM
#> 1  1    01123    01123
#> 2  2    13055    13201
#> 3  2    13055    13202
#> 4  2    13055    13203
#> 5  2    13055    13204
#> 6  2    13055    13205

data |> com_to_arm(from = CODE_COM) |> head()
#>   ID CODE_COM
#> 1  1    01123
#> 2  2    13201
#> 3  2    13202
#> 4  2    13203
#> 5  2    13204
#> 6  2    13205

# vecteur
com_to_arm(x)
#>  [1] "01123" "13201" "13202" "13203" "13204" "13205" "13206" "13207" "13208"
#> [10] "13209" "13210" "13211" "13212" "13213" "13214" "13215" "13216" "75101"
#> [19] "75102" "75103" "75104" "75105" "75106" "75107" "75108" "75109" "75110"
#> [28] "75111" "75112" "75113" "75114" "75115" "75116" "75117" "75118" "75119"
#> [37] "75120"
com_to_arm(x, extra = "?")
#>  [1] "?"     "13201" "13202" "13203" "13204" "13205" "13206" "13207" "13208"
#> [10] "13209" "13210" "13211" "13212" "13213" "13214" "13215" "13216" "75101"
#> [19] "75102" "75103" "75104" "75105" "75106" "75107" "75108" "75109" "75110"
#> [28] "75111" "75112" "75113" "75114" "75115" "75116" "75117" "75118" "75119"
#> [37] "75120"
```
