# Table de passage entre deux années du code officiel géographique des communes

Renvoie la table de passage des communes qui sont modifiées entre deux
années du code officiel géographique (COG).

## Usage

``` r
cog_transition(cog_from, cog_to)
```

## Arguments

- cog_from:

  Année du code officiel géographique des communes initiales dans la
  table de passage

- cog_to:

  Année du code officiel géographique des communes finales dans la table
  de passage

## Value

Une data frame

## Details

Colonnes de la data frame générée par la fonction `cog_transition()` :

- `COM_INI` : Code commune initial

- `COM_FIN` : Code commune final

- `POP_INI` : Population initiale, pouvant servir de pondération pour la
  fonction [`adapt_to_change()`](adapt_to_change.md)

- `POP_FIN` : Population finale, pouvant servir de pondération pour la
  fonction [`adapt_to_change()`](adapt_to_change.md)

- `NB_COM_INI` : Nombre de communes initial

- `NB_COM_FIN` : Nombre de communes final

## Examples

``` r
cog_transition(cog_from = 2019, cog_to = 2020)
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
