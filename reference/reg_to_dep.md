# Convertit les régions en départements

Convertit les codes géographiques des régions en codes géographiques des
départements.

## Usage

``` r
reg_to_dep(data, from = "REG", to = "DEP", extra = c(`99` = "999", ZZ = "ZZZ"))
```

## Arguments

- data:

  Un objet de type data frame ou vecteur.

- from:

  [`<tidy-select>`](https://dplyr.tidyverse.org/reference/dplyr_tidy_select.html)
  Colonne initiale des régions. Par défaut, "REG". Sans objet si `data`
  est un vecteur.

- to:

  Colonne finale pour les départements. Par défaut, "DEP". Sans objet si
  `data` est un vecteur.

- extra:

  Autres codes géographiques : `NULL`, valeur unique, vecteur nommé ou
  fonction. Par défaut, collectivités d'outre-mer et étranger.

## Value

Un objet du même type que `data`.

- Pour une data frame, une data frame avec un nombre de lignes égal ou
  supérieur.

- Pour un vecteur, un vecteur de dimension égale ou supérieure.

## Examples

``` r
x <- c("94", "93", "ZZ", NA)

# data frame
data <- data.frame(ID = c(1:length(x)), CODE_REG = x)
reg_to_dep(data, from = CODE_REG,  to = "CODE_DEP")
#>    ID CODE_REG CODE_DEP
#> 1   1       94       2A
#> 2   1       94       2B
#> 3   2       93       04
#> 4   2       93       05
#> 5   2       93       06
#> 6   2       93       13
#> 7   2       93       83
#> 8   2       93       84
#> 9   3       ZZ      ZZZ
#> 10  4     <NA>     <NA>
# vecteur
reg_to_dep(x)
#>  [1] "2A"  "2B"  "04"  "05"  "06"  "13"  "83"  "84"  "ZZZ" NA   
reg_to_dep(x, extra = "?")
#>  [1] "2A" "2B" "04" "05" "06" "13" "83" "84" "?"  "?" 
```
