# Enlève (ou pas) les communes de Mayotte, selon l'année du code officiel géographique

Si `cog >= 2012`, les communes de Mayotte sont conservées. Si
`cog < 2012`, les communes de Mayotte sont supprimées.

## Usage

``` r
filter_mayotte(data, cog = 2008, from = NULL)
```

## Arguments

- data:

  Un objet de type data frame ou vecteur.

- cog:

  Année du cog. Par défaut, 2008 : les communes de Mayotte sont
  supprimées.

- from:

  [`<tidy-select>`](https://dplyr.tidyverse.org/reference/dplyr_tidy_select.html)
  Colonne des communes. Par défaut, première colonne. Sans objet si
  `data` est un vecteur.

## Value

Un objet du même type que `data`.

- Pour une data frame, une data frame avec un nombre de lignes inférieur
  ou égal.

- Pour un vecteur, un vecteur de dimension inférieure ou égale.

## Examples

``` r
data <- data.frame(COM = c("97424", "97601"))

# Par défaut les lignes des communes de Mayotte sont supprimées
data |> filter_mayotte(from = COM)
#>     COM
#> 1 97424

# Si cog >= 2012 elles sont conservées
data |> filter_mayotte(cog = 2013, from = COM)
#>     COM
#> 1 97424
#> 2 97601

# Pour un vecteur
filter_mayotte(c("97424", "97601"), from = COM)
#> [1] "97424"
```
