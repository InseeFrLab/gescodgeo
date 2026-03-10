# Base des codes des communes selon l'année du code officiel géographique

Renvoie une data frame avec les codes géographiques des communes
françaises selon l'année demandée du code officiel géographique (COG).

## Usage

``` r
data_com(cog)
```

## Arguments

- cog:

  Une année du code officiel géographique des communes (COG).

## Value

Une data frame.

## Examples

``` r
data_com_2018 <- data_com(cog = 2018)
```
