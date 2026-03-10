# Convertit les départements en régions

Convertit les codes géographiques des départements en codes
géographiques des régions.

## Usage

``` r
dep_to_reg(data, from = "DEP", to = "REG", extra = c(`999` = "99", ZZZ = "ZZ"))
```

## Arguments

- data:

  Un objet de type data frame ou vecteur.

- from:

  [`<tidy-select>`](https://dplyr.tidyverse.org/reference/dplyr_tidy_select.html)
  Colonne initiale des départements. Par défaut, "DEP". Sans objet si
  `data` est un vecteur.

- to:

  Colonne finale pour les régions. Par défaut, "REG". Sans objet si
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
x <-  c("13", "84", "75", "75", "999", "ZZZ","YYY", NA)

# data frame
data <- data.frame(ID = c(1:length(x)), CODE_DEP = x)
data |> dep_to_reg(from = CODE_DEP, to = "CODE_REG")
#>   ID CODE_DEP CODE_REG
#> 1  1       13       93
#> 2  2       84       93
#> 3  3       75       11
#> 4  4       75       11
#> 5  5      999       99
#> 6  6      ZZZ       ZZ
#> 7  7      YYY     <NA>
#> 8  8     <NA>     <NA>

# vecteur
dep_to_reg(x)
#> [1] "93" "93" "11" "11" "99" "ZZ" NA   NA  
dep_to_reg(x, extra = c("YYY"="YY"))
#> [1] "93" "93" "11" "11" NA   NA   "YY" NA  
unique(dep_to_reg(x))
#> [1] "93" "11" "99" "ZZ" NA  
```
