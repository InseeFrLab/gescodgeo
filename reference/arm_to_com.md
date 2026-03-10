# Convertit les arrondissements municipaux en communes

Convertit les codes géographiques des arrondissements municipaux de
Paris, Lyon et Marseille en codes de ces communes.

## Usage

``` r
arm_to_com(
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
  Colonne initiale des communes ou arrondissements municipaux. Par
  défaut, première colonne. Sans objet si `data` est un vecteur.

- to:

  Colonne finale pour les communes. Par défaut, même nom que la colonne
  initiale. Sans objet si `data` est un vecteur.

- extra:

  Autres codes géographiques : `NULL`, valeur unique, vecteur nommé ou
  fonction. Par défaut, les codes géographiques en dehors Paris, Lyon et
  Marseille ne sont pas changés.

## Value

Un objet du même type que `data`.

- Pour une data frame, une data frame avec le même nombre de lignes.

- Pour un vecteur, un vecteur de dimension égale.

## Examples

``` r
x <-  c("01123","13201","13202","75101")

# data frame
data <- data.frame(ID = c(1:4), CODE_ARM = x)
data |> arm_to_com(from = CODE_ARM, to = "CODE_COM")
#>   ID CODE_ARM CODE_COM
#> 1  1    01123    01123
#> 2  2    13201    13055
#> 3  3    13202    13055
#> 4  4    75101    75056

# vecteur
arm_to_com(x)
#> [1] "01123" "13055" "13055" "75056"
arm_to_com(x, extra = NULL)
#> [1] NA      "13055" "13055" "75056"
unique(arm_to_com(x))
#> [1] "01123" "13055" "75056"
```
