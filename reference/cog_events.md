# Évènements du code officiel géographique

Renvoie une data frame avec les évenements ayant eu lieu depuis 2008
pour un code géographique donné : fusions, scissions ou changement de
code.

## Usage

``` r
cog_events(x, message = TRUE)
```

## Arguments

- x:

  Code géographique.

- message:

  Générer un avertissement si aucun évènement n'a eu lieu depuis 2008 ou
  si le code demandé n'aparaît pas dans le code officel géographique.
  Par défaut, TRUE.

## Value

Une data frame

## Details

Colonnes de la data frame générée par la fonction `cog_events()` :

- `COG_INI` : Année initiale du code officiel géographique.

- `COG_FIN` : Année finale du code officiel géographique.

- `COM_INI` : Code initial de la commune.

- `COM_FIN` : Code final de la commune.

- `NB_COM_INI` : Nombre initial de communes, *supérieur à 1 pour une
  fusion*.

- `NB_COM_FIN` : Nombre final de communes, *supérieur à 1 pour une
  scission*.

## Examples

``` r
# Exemple d'une commune avec un changement de code et une fusion
cog_events("14472")
#>   COG_INI COG_FIN COM_INI COM_FIN NB_COM_INI NB_COM_FIN
#> 1    2015    2016   14697   14472          1          1
#> 2    2016    2017   14472   14654         13          1

# Exemple d'une commune avec une fusion et un retablissement (scission)
cog_events("14712")
#>   COG_INI COG_FIN COM_INI COM_FIN NB_COM_INI NB_COM_FIN
#> 1    2016    2017   14666   14712          2          1
#> 2    2016    2017   14712   14712          2          1
#> 3    2019    2020   14712   14666          1          2
#> 4    2019    2020   14712   14712          1          2

# Exemple d'une commune sans evenements dans le COG
cog_events("13001")
#> Warning: Pas d'evenement pour "13001" entre 2008 et 2026
#> [1] COG_INI    COG_FIN    COM_INI    COM_FIN    NB_COM_INI NB_COM_FIN
#> <0 rows> (or 0-length row.names)

# Exemple d'un code n'aparaissant pas dans le COG
cog_events("13999")
#> Warning: "13999" n'est pas dans le COG entre 2008 et 2026
#> [1] COG_INI    COG_FIN    COM_INI    COM_FIN    NB_COM_INI NB_COM_FIN
#> <0 rows> (or 0-length row.names)
```
