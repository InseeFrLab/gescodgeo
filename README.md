
<!-- README.md is generated from README.Rmd. Please edit that file -->

# <img src="man/figures/logo.png" class="logo" alt=""/> gescodgeo

Le package gescodgeo propose des fonctions pour la gestion des codes
géographiques des communes. Ses principales utilisations sont les
suivantes :

- Changer l’année du code officiel géographique des communes :
  - apparier deux sources dont la géographie est différente,
  - fournir des résultats avec un millésime plus récent,
  - utiliser un zonage qui n’est pas disponible dans la géographie
    initiale des données.
- Vérifier le code officiel géographique des communes :
  - détecter la géographie des communes avant de la changer,
  - repérer des communes mal codées.
- Passer des arrondissements municipaux à la commune et réciproquement
  pour Paris, Lyon et Marseille.

Le package est développé sur AUS par le PSAR - Analyses territoriales.
Le pôle Offre de Données Locales et le pôle national référentiels
géographiques fournissent la table de passage pour les mises à jour
annuelles. Ce groupe de travail autour du COG est piloté par la division
Méthodes et référentiels géographiques.

Les années disponibles du code officiel géographique vont de 2008 à
2025.

<!-- Sur ces sujets, d’autres ressources plus complètes sont disponibles :  -->
<!-- - API DonneesLocales et Métadonnées de l'Insee (https://api.insee.fr/catalogue/) -->
<!-- - Package `CogR` (https://gitlab.insee.fr/kmb8un/cogr) -->
<!-- - Package `COGugaison` (https://github.com/antuki/COGugaison) -->
<!-- Le package s'appuie sur des données du site Insee.fr :  -->
<!-- -  Tables d’appartenance et de passage (https://www.insee.fr/fr/information/2028028) -->
<!-- -  Historique des populations légales (https://www.insee.fr/fr/statistiques/2522602) -->

## Installation

Le package gescodgeo est mis à disposition sur le dépôt R local de
nexus.insee.fr.

``` r
# Installation de gescodgeo et de ses dépendances depuis le dépôt r-local
```

Cette instruction permet également de mettre à jour le package, ce qui
permet notamment d’obtenir le dernier millésime du code officiel
géographique disponible (voir [changements](./news/index.html)).

Vous pouvez aussi installer la version en cours de développement en
utilisant les instructions ci-dessous dans RStudio :

``` r
# install.packages("remotes")
remotes::install_git("https://gitlab.insee.fr/psar-at/gescodgeo",
                     dependencies = TRUE)
```

## Un exemple simple

Pour un exemple plus détaillé sur la gestion du code géographique des
communes, voir `vignette("prise-en-main")`.

``` r
library(gescodgeo)
# Un exemple de Data frame avec quelques communes :
data <- data.frame(COM = c("14712", "53239", "53249", "53274", "13201"))
# Les communes sont dans le COG de l'annee 2019 :
data |> check_cog(cog = 2019) 
#> [1] TRUE
```

``` r
# Mais pas dans celui de l'annee 2021 :
data |> check_cog(cog = 2021) 
#> Warning: 
#> Les communes suivantes ne sont pas dans le COG de l'annee 2021 : 
#> 53239 53274
#> [1] FALSE
```

``` r
# Change l'année de la géographie
data |> change_cog(from = COM, to = "COM_2021", cog_from = 2019, cog_to = 2021)
#>     COM COM_2021
#> 1 14712    14666
#> 2 14712    14712
#> 3 53239    53249
#> 4 53249    53249
#> 5 53274    53249
#> 6 13201    13201
```

``` r
# Renvoie la table de passage entre 2019 et 2021 :
cog_transition(cog_from = 2019, cog_to = 2021) |> head()
#> # A tibble: 6 x 7
#>   COM_INI COM_FIN POP_INI POP_FIN NB_COM_INI NB_COM_FIN SPLIT_RATIO
#>   <chr>   <chr>     <int>   <dbl>      <int>      <int>       <dbl>
#> 1 14712   14666      5428    1912          1          2       0.355
#> 2 14712   14712      5428    3481          1          2       0.645
#> 3 16233   16233       451    1026          2          1       1    
#> 4 16351   16233       594    1026          2          1       1    
#> 5 21183   21183       896    1046          2          1       1    
#> 6 21213   21452       807    2789          2          1       1
```
