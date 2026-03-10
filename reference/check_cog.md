# Vérifie le code géographique des communes

Compare les codes des communes au code officiel geographique (COG) pour
une année demandée. Les années vont de 2008 au dernier millésime
disponible.

## Usage

``` r
check_cog(
  data,
  cog,
  from = NULL,
  complete = FALSE,
  ignore_arm = TRUE,
  ignore_mayotte = FALSE,
  data_res = FALSE,
  message = TRUE
)
```

## Arguments

- data:

  Un objet de type data frame ou vecteur.

- cog:

  Année du code officiel géographique, à partir de 2008.

- from:

  [`<tidy-select>`](https://dplyr.tidyverse.org/reference/dplyr_tidy_select.html)
  Colonne initiale des communes. Par défaut, première colonne. Sans
  objet si `data` est un vecteur.

- complete:

  Vérifier que les données sont complète, c'est-à-dire que toutes les
  communes du COG sont représentées. Par défaut, `FALSE` : vérifie
  uniquement si toutes les communes sont dans le COG.

- ignore_arm:

  Ignorer les arrondissements municipaux de Paris, Lyon et Marseille.
  Par défaut, TRUE. Si `FALSE`, les arrondissements municipaux ne sont
  pas dans le COG.

- ignore_mayotte:

  Ignorer communes de Mayotte. Par défaut, `FALSE.` : les communes de
  Mayotte sont hors du COG avant 2012 et comprises dans le COG à partir
  de 2012.

- data_res:

  Renvoyer le resultat de la comparaison dans une data frame. Par
  défaut, `FALSE.`

- message:

  Générer un avertissement quand des différences avec le COG sont
  détectées. Par défaut, `TRUE`.

## Value

Un booléen (si `data_res` vaut `FALSE`) ou une data frame (si `data_res`
vaut `TRUE`).

## Examples

``` r
data <- data_com(2018)

# Pas d'erreurs
check_cog(data, cog = 2018)
#> [1] TRUE

# Messages d'erreur
check_cog(data, cog = 2019)
#> Warning: 
#> Les communes suivantes ne sont pas dans le COG de l'annee 2019 : 
#> 01059 01091 01097 01122 01154 01186 01205 01218 01221 01341 [...]
#> [1] FALSE

# Verifier aussi les communes manquantes
check_cog(data, cog = 2019, complete = TRUE)
#> Warning: 
#> Les communes suivantes ne sont pas dans le COG de l'annee 2019 : 
#> 01059 01091 01097 01122 01154 01186 01205 01218 01221 01341 [...]
#> [1] FALSE

# Ne pas ignorer les arrondissements municipaux
data <- com_to_arm(data, to = "CODE_ARM")
check_cog(data, cog = 2019, from = CODE_ARM, ignore_arm = FALSE)
#> Warning: 
#> Les communes suivantes ne sont pas dans le COG de l'annee 2019 : 
#> 01059 01091 01097 01122 01154 01186 01205 01218 01221 01341 [...]
#> [1] FALSE

# Renvoyer les resultats dans une base
data_errors <- data |>
   check_cog(cog = 2009, complete = TRUE, data_res = TRUE, message = FALSE)

# Pour un vecteur
x <- data$COM
check_cog(x, cog = 2018)
#> [1] TRUE
```
