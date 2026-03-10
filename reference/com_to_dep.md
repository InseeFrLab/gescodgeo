# Convertit les communes en départements

Convertit les codes géographiques des communes en codes géographiques
des départements.

## Usage

``` r
com_to_dep(
  data,
  from = "COM",
  to = "DEP",
  extra = c(`977` = "977", `978` = "978", `986` = "986", `987` = "987", `988` = "988", ZZ
    = "ZZZ", `NA` = "999")
)
```

## Arguments

- data:

  Un objet de type data frame ou vecteur.

- from:

  [`<tidy-select>`](https://dplyr.tidyverse.org/reference/dplyr_tidy_select.html)
  Colonne initiale des communes. Par défaut, "COM". Sans objet si `data`
  est un vecteur.

- to:

  Colonne finale pour les départements. Par défaut, "DEP". Sans objet si
  `data` est un vecteur.

- extra:

  Autres codes géographiques : `NULL`, valeur unique, vecteur nommé ou
  fonction. Par défaut, collectivités d'outre-mer et étranger.

## Value

Un objet du même type que `data`.

- Pour une data frame, une data frame avec le même nombre de lignes.

- Pour un vecteur, un vecteur de dimension égale.

## Examples

``` r
x <-  c("84001", "75001", "75001", "97401", "98601", "YYYYY", "99999", "A1001", NA)

# data frame
data <- data.frame(ID = c(1:length(x)), COM = x)
data |> com_to_dep(from = COM, to = "DEP")
#>   ID   COM DEP
#> 1  1 84001  84
#> 2  2 75001  75
#> 3  3 75001  75
#> 4  4 97401 974
#> 5  5 98601 986
#> 6  6 YYYYY 999
#> 7  7 99999 999
#> 8  8 A1001 999
#> 9  9  <NA> 999

# Personalisation des codes extras
codes_extra <- c("977" = "ZZZ", "978" = "ZZZ", "986" = "ZZZ", "987" = "ZZZ",
 "988" = "ZZZ", "ZZ" = "ZZZ", "YY" = "YYY", "NA" = "999")

data |> com_to_dep(from = COM, to = "DEP", extra = codes_extra)
#>   ID   COM DEP
#> 1  1 84001  84
#> 2  2 75001  75
#> 3  3 75001  75
#> 4  4 97401 974
#> 5  5 98601 ZZZ
#> 6  6 YYYYY YYY
#> 7  7 99999 999
#> 8  8 A1001 999
#> 9  9  <NA> 999

# Vecteur
com_to_dep(x)
#> [1] "84"  "75"  "75"  "974" "986" "999" "999" "999" "999"
com_to_dep(x, extra = NULL)
#> [1] "84"  "75"  "75"  "974" NA    NA    NA    NA    NA   
com_to_dep(x, extra = function(x) {return (x)})
#> [1] "84"  "75"  "75"  "974" "986" "YY"  "99"  "A1"  NA   
```
