# Historique des modifications des communes

La table de passage de gescodgeo permet d’obtenir des codes
géographiques cohérents avec ceux des fichiers annuels du code officiel
géographique (COG), des populations légales ou encore des principales
sources statistiques, comme le recensement de la population.

À cette fin, deux changements de géographie sont décalés par rapport à
l’année d’enregistrement dans le COG.

- 55298 devient 55298 et 55138 en 2015 et non en 2014,
- 14697 devient 14472 en 2016 et non en 2015.

Les tableaux ci-dessous présentent les fusions et les scissions de
commune, ainsi que les autres changements de code géographique survenus
depuis 2008, d’après la table de passage de gescodgeo.

Afficher/masquer le détail du code

``` r
library(dplyr)
library(gescodgeo)

output <- function() {

  for(cog_ini in c((gescodgeo::cog_max-1):gescodgeo::cog_min)) {
    
    cog_fin <- cog_ini + 1 
    
    table_passage <- cog_transition(cog_ini, cog_fin) %>%
      mutate(PERIODE = paste0("", {cog_ini}, " - ", {cog_fin}), .after = 0)

    fusions <- table_passage %>%
      filter(NB_COM_INI > NB_COM_FIN) %>%
      group_by(PERIODE, COM_FIN, NB_COM_INI) %>%
      summarise(COM_INI = paste(COM_INI, collapse = ", "), .groups = "drop") %>%
      arrange(COM_FIN)

    scissions <- table_passage %>%
      filter(NB_COM_INI < NB_COM_FIN)  %>%
      group_by(PERIODE, COM_INI, NB_COM_FIN) %>%
      summarise(COM_FIN = paste(COM_FIN, collapse = ", "), .groups = "drop") %>%
      arrange(COM_INI)
    
    autre <- table_passage %>% 
      filter(NB_COM_INI == NB_COM_FIN, COM_INI != COM_FIN)  %>%
      arrange(COM_INI)
    
    if(nrow(table_passage) > 0) {

      cat("\n## Modifications en ", cog_ini, "\n")
      
      cat(":::{.fw-normal .fs-6}\n")
      
      bind_rows(
        fusions %>% mutate(CHANG = paste0("Fusion de ", NB_COM_INI, " communes")),
        scissions %>% mutate(CHANG =  paste0("Scission vers ", NB_COM_FIN, " communes")),
        autre %>% mutate(CHANG =  "Autre changement")
      ) %>%
        
      select(CHANG, COM_INI, COM_FIN) %>%
            knitr::kable(col.names = c("Évènement", "Code initial", "Code final")) %>%
            print()
      
       cat("\n:::\n")
       
    } else {
        cat("\n## Pas de modification en ", cog_ini, "\n")
    }
  }
}
```

## Pas de modification en 2025

## Modifications en 2024

| Évènement                | Code initial                      | Code final                        |
|:-------------------------|:----------------------------------|:----------------------------------|
| Fusion de 2 communes     | 01187, 01330                      | 01187                             |
| Fusion de 2 communes     | 02311, 02589                      | 02589                             |
| Fusion de 2 communes     | 08300, 08439                      | 08439                             |
| Fusion de 2 communes     | 09088, 09287                      | 09088                             |
| Fusion de 2 communes     | 14408, 14623                      | 14408                             |
| Fusion de 2 communes     | 14300, 14743                      | 14743                             |
| Fusion de 2 communes     | 16023, 16238                      | 16023                             |
| Fusion de 2 communes     | 16147, 16198                      | 16198                             |
| Fusion de 2 communes     | 16226, 16393                      | 16393                             |
| Fusion de 2 communes     | 17268, 17334                      | 17268                             |
| Fusion de 3 communes     | 19223, 19230, 19248               | 19248                             |
| Fusion de 2 communes     | 22147, 22309                      | 22147                             |
| Fusion de 2 communes     | 22200, 22237                      | 22237                             |
| Fusion de 3 communes     | 22027, 22043, 22241               | 22241                             |
| Fusion de 2 communes     | 23023, 23149                      | 23149                             |
| Fusion de 2 communes     | 25223, 25533                      | 25223                             |
| Fusion de 2 communes     | 25297, 25364                      | 25364                             |
| Fusion de 5 communes     | 25303, 25347, 25390, 25398, 25620 | 25390                             |
| Fusion de 2 communes     | 26289, 26371                      | 26289                             |
| Fusion de 3 communes     | 28025, 28276, 28319               | 28319                             |
| Fusion de 2 communes     | 30094, 30329                      | 30329                             |
| Fusion de 4 communes     | 32067, 32260, 32365, 32413        | 32365                             |
| Fusion de 2 communes     | 33008, 33409                      | 33008                             |
| Fusion de 2 communes     | 34093, 34144                      | 34144                             |
| Fusion de 2 communes     | 39434, 39548                      | 39434                             |
| Fusion de 2 communes     | 39576, 39474                      | 39576                             |
| Fusion de 3 communes     | 42084, 42109, 42252               | 42084                             |
| Fusion de 2 communes     | 42072, 42217                      | 42217                             |
| Fusion de 2 communes     | 46172, 46217                      | 46172                             |
| Fusion de 2 communes     | 51205, 51485                      | 51485                             |
| Fusion de 2 communes     | 59006, 59070                      | 59006                             |
| Fusion de 5 communes     | 61017, 61188, 61192, 61275, 61310 | 61275                             |
| Fusion de 4 communes     | 62447, 62461, 62549, 62743        | 62447                             |
| Fusion de 2 communes     | 63109, 63330                      | 63109                             |
| Fusion de 2 communes     | 70152, 70557                      | 70152                             |
| Fusion de 3 communes     | 70180, 70264, 70530               | 70180                             |
| Fusion de 2 communes     | 71131, 71566                      | 71566                             |
| Fusion de 2 communes     | 72155, 72287                      | 72155                             |
| Fusion de 2 communes     | 72298, 72382                      | 72382                             |
| Fusion de 2 communes     | 76358, 76455                      | 76455                             |
| Fusion de 5 communes     | 79060, 79180, 79205, 79212, 79307 | 79307                             |
| Fusion de 2 communes     | 80155, 80830                      | 80155                             |
| Fusion de 2 communes     | 85021, 85076                      | 85076                             |
| Fusion de 2 communes     | 85223, 85233                      | 85223                             |
| Fusion de 2 communes     | 88321, 88393                      | 88321                             |
| Fusion de 2 communes     | 93059, 93066                      | 93066                             |
| Scission vers 5 communes | 15141                             | 15031, 15035, 15047, 15141, 15171 |
| Autre changement         | 12076                             | 12218                             |
| Autre changement         | 14011                             | 14581                             |
| Autre changement         | 49069                             | 49126                             |
| Autre changement         | 69159                             | 69114                             |

## Modifications en 2023

| Évènement                | Code initial        | Code final          |
|:-------------------------|:--------------------|:--------------------|
| Fusion de 2 communes     | 08053, 08294        | 08053               |
| Fusion de 2 communes     | 16097, 16355        | 16097               |
| Fusion de 2 communes     | 18131, 18173        | 18173               |
| Fusion de 3 communes     | 25060, 25282, 25549 | 25060               |
| Fusion de 2 communes     | 35062, 35112        | 35062               |
| Fusion de 2 communes     | 49160, 49321        | 49160               |
| Fusion de 2 communes     | 64300, 64541        | 64300               |
| Fusion de 2 communes     | 69149, 69152        | 69149               |
| Fusion de 3 communes     | 85041, 85271, 85292 | 85292               |
| Fusion de 2 communes     | 86231, 86247        | 86247               |
| Fusion de 2 communes     | 95169, 95282        | 95169               |
| Scission vers 2 communes | 60054               | 60054, 60694        |
| Scission vers 3 communes | 85084               | 85084, 85165, 85212 |

## Modifications en 2022

| Évènement            | Code initial        | Code final |
|:---------------------|:--------------------|:-----------|
| Fusion de 2 communes | 01039, 01138        | 01138      |
| Fusion de 2 communes | 02077, 02564        | 02564      |
| Fusion de 2 communes | 09056, 09255        | 09056      |
| Fusion de 2 communes | 16140, 16206        | 16206      |
| Fusion de 2 communes | 50015, 50272        | 50272      |
| Fusion de 3 communes | 51063, 51457, 51637 | 51457      |
| Fusion de 2 communes | 71042, 71492        | 71042      |
| Fusion de 3 communes | 85037, 85053, 85289 | 85289      |
| Autre changement     | 27058               | 27676      |

## Modifications en 2021

| Évènement            | Code initial        | Code final |
|:---------------------|:--------------------|:-----------|
| Fusion de 2 communes | 02054, 02695        | 02054      |
| Fusion de 2 communes | 16010, 16186        | 16186      |
| Fusion de 2 communes | 19092, 19143        | 19143      |
| Fusion de 3 communes | 24089, 24314, 24325 | 24325      |
| Fusion de 2 communes | 25134, 25185        | 25185      |
| Fusion de 2 communes | 25375, 25628        | 25375      |
| Fusion de 2 communes | 26216, 26219        | 26216      |
| Fusion de 2 communes | 56049, 56213        | 56213      |
| Fusion de 2 communes | 85001, 85307        | 85001      |

## Modifications en 2020

| Évènement            | Code initial        | Code final |
|:---------------------|:--------------------|:-----------|
| Fusion de 2 communes | 16233, 16351        | 16233      |
| Fusion de 3 communes | 53239, 53249, 53274 | 53249      |
| Autre changement     | 27676               | 27058      |

## Modifications en 2019

| Évènement                | Code initial | Code final   |
|:-------------------------|:-------------|:-------------|
| Fusion de 2 communes     | 21183, 21507 | 21183        |
| Fusion de 2 communes     | 21213, 21452 | 21452        |
| Fusion de 2 communes     | 45287, 45307 | 45307        |
| Scission vers 2 communes | 14712        | 14666, 14712 |

## Modifications en 2018

| Évènement            | Code initial                                    | Code final |
|:---------------------|:------------------------------------------------|:-----------|
| Fusion de 3 communes | 01033, 01091, 01205                             | 01033      |
| Fusion de 4 communes | 01036, 01221, 01414, 01442                      | 01036      |
| Fusion de 2 communes | 01130, 01154                                    | 01130      |
| Fusion de 4 communes | 01122, 01185, 01186, 01417                      | 01185      |
| Fusion de 2 communes | 01215, 01413                                    | 01215      |
| Fusion de 2 communes | 01227, 01341                                    | 01227      |
| Fusion de 4 communes | 01059, 01097, 01218, 01453                      | 01453      |
| Fusion de 3 communes | 02018, 02301, 02434                             | 02018      |
| Fusion de 2 communes | 02153, 02733                                    | 02153      |
| Fusion de 2 communes | 02360, 02475                                    | 02360      |
| Fusion de 2 communes | 05001, 05120                                    | 05001      |
| Fusion de 2 communes | 07011, 07016                                    | 07011      |
| Fusion de 2 communes | 07103, 07252                                    | 07103      |
| Fusion de 2 communes | 07165, 07256                                    | 07165      |
| Fusion de 2 communes | 07135, 07262                                    | 07262      |
| Fusion de 4 communes | 08042, 08079, 08152, 08173                      | 08173      |
| Fusion de 2 communes | 09028, 09296                                    | 09296      |
| Fusion de 4 communes | 09135, 09286, 09302, 09334                      | 09334      |
| Fusion de 2 communes | 11131, 11329                                    | 11131      |
| Fusion de 2 communes | 11251, 11298                                    | 11251      |
| Fusion de 2 communes | 11097, 11323                                    | 11323      |
| Fusion de 2 communes | 14126, 14604                                    | 14126      |
| Fusion de 5 communes | 14002, 14013, 14150, 14505, 14703               | 14150      |
| Fusion de 2 communes | 14185, 14514                                    | 14514      |
| Fusion de 3 communes | 14339, 14538, 14691                             | 14538      |
| Fusion de 2 communes | 14294, 14554                                    | 14554      |
| Fusion de 2 communes | 14307, 14713                                    | 14713      |
| Fusion de 2 communes | 15027, 15136                                    | 15027      |
| Fusion de 2 communes | 16005, 16411                                    | 16005      |
| Fusion de 2 communes | 16046, 16332                                    | 16046      |
| Fusion de 3 communes | 16110, 16391, 16410                             | 16110      |
| Fusion de 2 communes | 16153, 16202                                    | 16153      |
| Fusion de 5 communes | 16149, 16192, 16214, 16259, 16376               | 16192      |
| Fusion de 2 communes | 16281, 16344                                    | 16281      |
| Fusion de 2 communes | 16156, 16286                                    | 16286      |
| Fusion de 4 communes | 16017, 16051, 16228, 16339                      | 16339      |
| Fusion de 2 communes | 16274, 16406                                    | 16406      |
| Fusion de 2 communes | 17189, 17219                                    | 17219      |
| Fusion de 2 communes | 17272, 17340                                    | 17340      |
| Fusion de 2 communes | 17169, 17344                                    | 17344      |
| Fusion de 3 communes | 18023, 18123, 18239                             | 18023      |
| Fusion de 2 communes | 18073, 18222                                    | 18073      |
| Fusion de 2 communes | 19019, 19032                                    | 19019      |
| Fusion de 2 communes | 19098, 19127                                    | 19098      |
| Fusion de 2 communes | 19101, 19185                                    | 19101      |
| Fusion de 2 communes | 21178, 21513                                    | 21178      |
| Fusion de 2 communes | 21073, 21272                                    | 21272      |
| Fusion de 2 communes | 21352, 21486                                    | 21352      |
| Fusion de 2 communes | 21621, 21623                                    | 21623      |
| Fusion de 3 communes | 22093, 22154, 22173                             | 22093      |
| Fusion de 2 communes | 22038, 22206                                    | 22206      |
| Fusion de 2 communes | 22100, 22219                                    | 22219      |
| Fusion de 4 communes | 22078, 22247, 22253, 22264                      | 22264      |
| Fusion de 2 communes | 23109, 23121                                    | 23109      |
| Fusion de 2 communes | 23126, 23189                                    | 23189      |
| Fusion de 7 communes | 24064, 24079, 24170, 24198, 24391, 24530, 24561 | 24064      |
| Fusion de 3 communes | 24172, 24249, 24389                             | 24172      |
| Fusion de 4 communes | 24233, 24259, 24427, 24431                      | 24259      |
| Fusion de 2 communes | 24127, 24364                                    | 24364      |
| Fusion de 3 communes | 24402, 24423, 24433                             | 24423      |
| Fusion de 2 communes | 24181, 24534                                    | 24534      |
| Fusion de 2 communes | 25140, 25156                                    | 25156      |
| Fusion de 2 communes | 25027, 25245                                    | 25245      |
| Fusion de 2 communes | 25250, 25558                                    | 25558      |
| Fusion de 2 communes | 26086, 26354                                    | 26086      |
| Fusion de 3 communes | 26184, 26210, 26297                             | 26210      |
| Fusion de 3 communes | 27070, 27175, 27270                             | 27070      |
| Fusion de 4 communes | 27198, 27297, 27416, 27491                      | 27198      |
| Fusion de 3 communes | 27263, 27581, 27607                             | 27263      |
| Fusion de 3 communes | 27516, 27523, 27600                             | 27516      |
| Fusion de 2 communes | 27541, 27551                                    | 27541      |
| Fusion de 2 communes | 27143, 27685                                    | 27685      |
| Fusion de 2 communes | 28018, 28376                                    | 28018      |
| Fusion de 3 communes | 28002, 28199, 28311                             | 28199      |
| Fusion de 3 communes | 28063, 28112, 28236                             | 28236      |
| Fusion de 2 communes | 28165, 28331                                    | 28331      |
| Fusion de 2 communes | 28205, 28334                                    | 28334      |
| Fusion de 2 communes | 28406, 28412                                    | 28406      |
| Fusion de 2 communes | 29199, 29219                                    | 29199      |
| Fusion de 2 communes | 29129, 29227                                    | 29227      |
| Fusion de 2 communes | 30052, 30157                                    | 30052      |
| Fusion de 2 communes | 30190, 30339                                    | 30339      |
| Fusion de 2 communes | 31298, 31471                                    | 31471      |
| Fusion de 2 communes | 32074, 32344                                    | 32344      |
| Fusion de 2 communes | 33008, 33092                                    | 33008      |
| Fusion de 2 communes | 33055, 33338                                    | 33055      |
| Fusion de 2 communes | 33267, 33380                                    | 33380      |
| Fusion de 2 communes | 34246, 34330                                    | 34246      |
| Fusion de 4 communes | 35004, 35113, 35303, 35341                      | 35004      |
| Fusion de 2 communes | 35100, 35163                                    | 35163      |
| Fusion de 2 communes | 35184, 35301                                    | 35184      |
| Fusion de 2 communes | 35053, 35220                                    | 35220      |
| Fusion de 4 communes | 35269, 35282, 35293, 35348                      | 35282      |
| Fusion de 2 communes | 35011, 35292                                    | 35292      |
| Fusion de 3 communes | 35147, 35308, 35344                             | 35308      |
| Fusion de 2 communes | 36093, 36206                                    | 36093      |
| Fusion de 2 communes | 36072, 36244                                    | 36244      |
| Fusion de 2 communes | 38073, 38302                                    | 38073      |
| Fusion de 2 communes | 38163, 38306                                    | 38163      |
| Fusion de 2 communes | 38025, 38284                                    | 38284      |
| Fusion de 3 communes | 38367, 38395, 38435                             | 38395      |
| Fusion de 4 communes | 38016, 38121, 38274, 38479                      | 38479      |
| Fusion de 2 communes | 38293, 38560                                    | 38560      |
| Fusion de 2 communes | 39043, 39395                                    | 39043      |
| Fusion de 3 communes | 39130, 39417, 39562                             | 39130      |
| Fusion de 4 communes | 39089, 39137, 39287, 39483                      | 39137      |
| Fusion de 2 communes | 39190, 39414                                    | 39190      |
| Fusion de 2 communes | 39075, 39199                                    | 39199      |
| Fusion de 2 communes | 39115, 39258                                    | 39258      |
| Fusion de 2 communes | 39286, 39440                                    | 39286      |
| Fusion de 2 communes | 39113, 39339                                    | 39339      |
| Fusion de 2 communes | 39378, 39484                                    | 39378      |
| Fusion de 4 communes | 40009, 40107, 40197, 40302                      | 40197      |
| Fusion de 5 communes | 41059, 41082, 41092, 41170, 41257               | 41059      |
| Fusion de 2 communes | 41070, 41263                                    | 41070      |
| Fusion de 2 communes | 42245, 42291                                    | 42245      |
| Fusion de 3 communes | 42004, 42082, 42268                             | 42268      |
| Fusion de 2 communes | 44003, 44160                                    | 44003      |
| Fusion de 4 communes | 46033, 46099, 46278, 46300                      | 46033      |
| Fusion de 2 communes | 46083, 46298                                    | 46083      |
| Fusion de 2 communes | 46067, 46232                                    | 46232      |
| Fusion de 3 communes | 46014, 46263, 46285                             | 46263      |
| Fusion de 2 communes | 48038, 48184                                    | 48038      |
| Fusion de 2 communes | 48078, 48126                                    | 48126      |
| Fusion de 5 communes | 48057, 48127, 48133, 48189, 48197               | 48127      |
| Fusion de 3 communes | 49046, 49060, 49274                             | 49060      |
| Fusion de 2 communes | 49065, 49080                                    | 49080      |
| Fusion de 2 communes | 49159, 49174                                    | 49174      |
| Fusion de 2 communes | 49289, 49298                                    | 49298      |
| Fusion de 2 communes | 49337, 49377                                    | 49377      |
| Fusion de 2 communes | 50025, 50516                                    | 50025      |
| Fusion de 6 communes | 50099, 50089, 50107, 50348, 50485, 50636        | 50099      |
| Fusion de 4 communes | 50197, 50301, 50320, 50583                      | 50197      |
| Fusion de 4 communes | 50014, 50215, 50354, 50573                      | 50215      |
| Fusion de 3 communes | 50160, 50412, 50503                             | 50412      |
| Fusion de 2 communes | 50358, 50417                                    | 50417      |
| Fusion de 5 communes | 50140, 50223, 50244, 50419, 50605               | 50419      |
| Fusion de 3 communes | 50523, 50103, 50427                             | 50523      |
| Fusion de 3 communes | 50546, 50313, 50581                             | 50546      |
| Fusion de 7 communes | 50007, 50308, 50438, 50449, 50524, 50550, 50622 | 50550      |
| Fusion de 2 communes | 50206, 50597                                    | 50597      |
| Fusion de 2 communes | 52064, 52225                                    | 52064      |
| Fusion de 4 communes | 53006, 53029, 53231, 53241                      | 53029      |
| Fusion de 3 communes | 53014, 53062, 53215                             | 53062      |
| Fusion de 3 communes | 53065, 53097, 53207                             | 53097      |
| Fusion de 2 communes | 53104, 53138                                    | 53104      |
| Fusion de 2 communes | 53136, 53254                                    | 53136      |
| Fusion de 4 communes | 53092, 53159, 53161, 53244                      | 53161      |
| Fusion de 2 communes | 54506, 54557                                    | 54557      |
| Fusion de 2 communes | 55030, 55150                                    | 55150      |
| Fusion de 2 communes | 55164, 55537                                    | 55537      |
| Fusion de 2 communes | 56059, 56102                                    | 56102      |
| Fusion de 2 communes | 56138, 56165                                    | 56165      |
| Fusion de 2 communes | 56016, 56173                                    | 56173      |
| Fusion de 2 communes | 57439, 57585                                    | 57439      |
| Fusion de 2 communes | 57578, 57722                                    | 57578      |
| Fusion de 3 communes | 60054, 60455, 60694                             | 60054      |
| Fusion de 3 communes | 60080, 60209, 60300                             | 60209      |
| Fusion de 2 communes | 60096, 60245                                    | 60245      |
| Fusion de 2 communes | 60038, 60256                                    | 60256      |
| Fusion de 2 communes | 60475, 60682                                    | 60682      |
| Fusion de 4 communes | 61172, 61228, 61231, 61383                      | 61228      |
| Fusion de 2 communes | 61294, 61403                                    | 61294      |
| Fusion de 2 communes | 62154, 62210                                    | 62154      |
| Fusion de 2 communes | 63133, 63226                                    | 63226      |
| Fusion de 2 communes | 63127, 63335                                    | 63335      |
| Fusion de 2 communes | 63078, 63448                                    | 63448      |
| Fusion de 2 communes | 65092, 65122                                    | 65092      |
| Fusion de 2 communes | 67372, 67402                                    | 67372      |
| Fusion de 2 communes | 67014, 67418                                    | 67418      |
| Fusion de 2 communes | 69019, 69211                                    | 69019      |
| Fusion de 7 communes | 69015, 69135, 69150, 69185, 69210, 69224, 69251 | 69135      |
| Fusion de 4 communes | 69073, 69147, 69157, 69223                      | 69157      |
| Fusion de 2 communes | 69101, 69159                                    | 69159      |
| Fusion de 2 communes | 70245, 70475                                    | 70245      |
| Fusion de 2 communes | 70285, 70497                                    | 70285      |
| Fusion de 2 communes | 70375, 70491                                    | 70491      |
| Fusion de 3 communes | 71055, 71134, 71304                             | 71134      |
| Fusion de 2 communes | 72080, 72081                                    | 72080      |
| Fusion de 2 communes | 72128, 72304                                    | 72128      |
| Fusion de 3 communes | 72097, 72138, 72284                             | 72138      |
| Fusion de 2 communes | 72116, 72189                                    | 72189      |
| Fusion de 2 communes | 72033, 72219                                    | 72219      |
| Fusion de 3 communes | 73003, 73045, 73266                             | 73003      |
| Fusion de 3 communes | 73080, 73135, 73203                             | 73135      |
| Fusion de 2 communes | 73118, 73151                                    | 73151      |
| Fusion de 3 communes | 73046, 73112, 73187                             | 73187      |
| Fusion de 2 communes | 73002, 73212                                    | 73212      |
| Fusion de 2 communes | 73111, 73215                                    | 73215      |
| Fusion de 3 communes | 73127, 73236, 73260                             | 73236      |
| Fusion de 2 communes | 73244, 73257                                    | 73257      |
| Fusion de 2 communes | 74110, 74212                                    | 74212      |
| Fusion de 2 communes | 74274, 74289                                    | 74289      |
| Fusion de 3 communes | 76034, 76191, 76674                             | 76034      |
| Fusion de 2 communes | 76041, 76729                                    | 76041      |
| Fusion de 2 communes | 77109, 77149                                    | 77109      |
| Fusion de 2 communes | 77028, 77433                                    | 77433      |
| Fusion de 2 communes | 77399, 77504                                    | 77504      |
| Fusion de 2 communes | 78158, 78524                                    | 78158      |
| Fusion de 2 communes | 78320, 78503                                    | 78320      |
| Fusion de 2 communes | 78251, 78551                                    | 78551      |
| Fusion de 2 communes | 79005, 79325                                    | 79005      |
| Fusion de 2 communes | 79014, 79043                                    | 79014      |
| Fusion de 2 communes | 79061, 79282                                    | 79061      |
| Fusion de 2 communes | 79064, 79314                                    | 79064      |
| Fusion de 2 communes | 79035, 79077                                    | 79077      |
| Fusion de 4 communes | 79027, 79083, 79107, 79330                      | 79083      |
| Fusion de 2 communes | 79068, 79105                                    | 79105      |
| Fusion de 4 communes | 79011, 79045, 79140, 79211                      | 79140      |
| Fusion de 5 communes | 79173, 79174, 79199, 79264, 79279               | 79174      |
| Fusion de 6 communes | 79051, 79075, 79179, 79188, 79222, 79261        | 79179      |
| Fusion de 3 communes | 79004, 79185, 79240                             | 79185      |
| Fusion de 4 communes | 79054, 79196, 79260, 79321                      | 79196      |
| Fusion de 2 communes | 79098, 79217                                    | 79217      |
| Fusion de 2 communes | 79214, 79251                                    | 79251      |
| Fusion de 2 communes | 79285, 79318                                    | 79285      |
| Fusion de 4 communes | 79171, 79178, 79292, 79329                      | 79329      |
| Fusion de 3 communes | 79219, 79328, 79334                             | 79334      |
| Fusion de 2 communes | 80389, 80442                                    | 80442      |
| Fusion de 3 communes | 80485, 80594, 80761                             | 80485      |
| Fusion de 2 communes | 80175, 80505                                    | 80505      |
| Fusion de 2 communes | 80509, 80551                                    | 80509      |
| Fusion de 3 communes | 80209, 80419, 80625                             | 80625      |
| Fusion de 6 communes | 81226, 81233, 81241, 81260, 81296, 81301        | 81233      |
| Fusion de 5 communes | 85027, 85107, 85146, 85217, 85224               | 85146      |
| Fusion de 2 communes | 85162, 85168                                    | 85162      |
| Fusion de 2 communes | 85177, 85299                                    | 85177      |
| Fusion de 3 communes | 85060, 85166, 85194                             | 85194      |
| Fusion de 2 communes | 85048, 85302                                    | 85302      |
| Fusion de 5 communes | 86043, 86067, 86082, 86188, 86278               | 86082      |
| Fusion de 4 communes | 86021, 86056, 86123, 86166                      | 86123      |
| Fusion de 2 communes | 86281, 86277                                    | 86281      |
| Fusion de 4 communes | 87028, 87055, 87136, 87196                      | 87028      |
| Fusion de 3 communes | 87128, 87173, 87184                             | 87128      |
| Fusion de 5 communes | 89109, 89197, 89381, 89421, 89448               | 89197      |
| Fusion de 2 communes | 89340, 89420                                    | 89420      |
| Fusion de 2 communes | 90068, 90073                                    | 90068      |
| Fusion de 2 communes | 91182, 91228                                    | 91228      |
| Fusion de 2 communes | 91222, 91390                                    | 91390      |

## Modifications en 2017

| Évènement            | Code initial                             | Code final |
|:---------------------|:-----------------------------------------|:-----------|
| Fusion de 2 communes | 01025, 01144                             | 01025      |
| Fusion de 3 communes | 05024, 05088, 05150                      | 05024      |
| Fusion de 3 communes | 05039, 05043, 05141                      | 05039      |
| Fusion de 3 communes | 16296, 16300, 16309                      | 16300      |
| Fusion de 2 communes | 17160, 17392                             | 17160      |
| Fusion de 3 communes | 17103, 17352, 17457                      | 17457      |
| Fusion de 2 communes | 22050, 22123                             | 22050      |
| Fusion de 2 communes | 25078, 25587                             | 25078      |
| Fusion de 2 communes | 25137, 25368                             | 25368      |
| Fusion de 2 communes | 27089, 27657                             | 27089      |
| Fusion de 2 communes | 27290, 27642                             | 27290      |
| Fusion de 3 communes | 27268, 27402, 27447                      | 27447      |
| Fusion de 2 communes | 27467, 27549                             | 27467      |
| Fusion de 2 communes | 27471, 27651                             | 27471      |
| Fusion de 3 communes | 28066, 28127, 28250                      | 28127      |
| Fusion de 2 communes | 31277, 31438                             | 31277      |
| Fusion de 2 communes | 37209, 37254                             | 37254      |
| Fusion de 2 communes | 39016, 39148                             | 39016      |
| Fusion de 2 communes | 39036, 39209                             | 39209      |
| Fusion de 2 communes | 39542, 39583                             | 39583      |
| Fusion de 5 communes | 41005, 41165, 41197, 41202, 41248        | 41248      |
| Fusion de 6 communes | 44017, 44093, 44180, 44191, 44219, 49144 | 44180      |
| Fusion de 3 communes | 46158, 46262, 46274                      | 46262      |
| Fusion de 3 communes | 49149, 49261, 49304                      | 49261      |
| Fusion de 2 communes | 50248, 50409                             | 50409      |
| Fusion de 2 communes | 14513, 50592                             | 50592      |
| Fusion de 4 communes | 51271, 51411, 51612, 51651               | 51612      |
| Fusion de 2 communes | 53004, 53124                             | 53124      |
| Fusion de 2 communes | 60644, 60690                             | 60644      |
| Fusion de 2 communes | 61153, 61173                             | 61153      |
| Fusion de 3 communes | 61194, 61285, 61468                      | 61194      |
| Fusion de 3 communes | 61299, 61311, 61429                      | 61429      |
| Fusion de 2 communes | 67153, 67560                             | 67153      |
| Fusion de 3 communes | 69048, 69179, 69213                      | 69179      |
| Fusion de 2 communes | 72117, 72176                             | 72176      |
| Fusion de 4 communes | 79033, 79039, 79078, 79247               | 79078      |
| Fusion de 2 communes | 95040, 95259                             | 95040      |

## Modifications en 2016

| Évènement                | Code initial                                                                                                                        | Code final   |
|:-------------------------|:------------------------------------------------------------------------------------------------------------------------------------|:-------------|
| Fusion de 2 communes     | 01095, 01172                                                                                                                        | 01095        |
| Fusion de 2 communes     | 01098, 01316                                                                                                                        | 01098        |
| Fusion de 2 communes     | 03168, 03318                                                                                                                        | 03168        |
| Fusion de 2 communes     | 04033, 04198                                                                                                                        | 04033        |
| Fusion de 2 communes     | 05101, 05175                                                                                                                        | 05101        |
| Fusion de 3 communes     | 08053, 08371, 08475                                                                                                                 | 08053        |
| Fusion de 3 communes     | 08443, 08490, 08493                                                                                                                 | 08490        |
| Fusion de 2 communes     | 08072, 08491                                                                                                                        | 08491        |
| Fusion de 2 communes     | 09062, 09317                                                                                                                        | 09062        |
| Fusion de 2 communes     | 12020, 12090                                                                                                                        | 12090        |
| Fusion de 5 communes     | 14005, 14074, 14176, 14268, 14517                                                                                                   | 14005        |
| Fusion de 4 communes     | 14011, 14376, 14581, 14695                                                                                                          | 14011        |
| Fusion de 7 communes     | 14027, 14056, 14128, 14219, 14477, 14508, 14544                                                                                     | 14027        |
| Fusion de 6 communes     | 14098, 14109, 14157, 14423, 14525, 14568                                                                                            | 14098        |
| Fusion de 3 communes     | 14143, 14372, 14722                                                                                                                 | 14143        |
| Fusion de 3 communes     | 14200, 14577, 14757                                                                                                                 | 14200        |
| Fusion de 4 communes     | 14004, 14235, 14281, 14382                                                                                                          | 14281        |
| Fusion de 5 communes     | 14142, 14342, 14462, 14481, 14763                                                                                                   | 14342        |
| Fusion de 2 communes     | 14347, 14413                                                                                                                        | 14347        |
| Fusion de 2 communes     | 14164, 14349                                                                                                                        | 14349        |
| Fusion de 3 communes     | 14008, 14355, 14690                                                                                                                 | 14355        |
| Fusion de 3 communes     | 14357, 14597, 14662                                                                                                                 | 14357        |
| Fusion de 4 communes     | 14186, 14212, 14406, 14548                                                                                                          | 14406        |
| Fusion de 2 communes     | 14075, 14410                                                                                                                        | 14410        |
| Fusion de 14 communes    | 14031, 14189, 14201, 14208, 14313, 14359, 14386, 14387, 14422, 14431, 14444, 14493, 14600, 14749                                    | 14431        |
| Fusion de 2 communes     | 14158, 14456                                                                                                                        | 14456        |
| Fusion de 3 communes     | 14373, 14475, 14702                                                                                                                 | 14475        |
| Fusion de 2 communes     | 14527, 14608                                                                                                                        | 14527        |
| Fusion de 2 communes     | 14073, 14579                                                                                                                        | 14579        |
| Fusion de 2 communes     | 14551, 14591                                                                                                                        | 14591        |
| Fusion de 13 communes    | 14081, 14099, 14331, 14433, 14450, 14489, 14580, 14616, 14654, 14688, 14472, 14729, 14750                                           | 14654        |
| Fusion de 10 communes    | 14151, 14192, 14279, 14296, 14415, 14416, 14417, 14611, 14658, 14671                                                                | 14658        |
| Fusion de 4 communes     | 14217, 14350, 14596, 14672                                                                                                          | 14672        |
| Fusion de 2 communes     | 14666, 14712                                                                                                                        | 14712        |
| Fusion de 2 communes     | 15044, 15138                                                                                                                        | 15138        |
| Fusion de 5 communes     | 15031, 15035, 15047, 15141, 15171                                                                                                   | 15141        |
| Fusion de 4 communes     | 15099, 15142, 15145, 15227                                                                                                          | 15142        |
| Fusion de 3 communes     | 16023, 16033, 16094                                                                                                                 | 16023        |
| Fusion de 2 communes     | 16046, 16115                                                                                                                        | 16046        |
| Fusion de 5 communes     | 16129, 16204, 16247, 16386, 16417                                                                                                   | 16204        |
| Fusion de 5 communes     | 16004, 16230, 16294, 16314, 16328                                                                                                   | 16230        |
| Fusion de 2 communes     | 19010, 19183                                                                                                                        | 19010        |
| Fusion de 2 communes     | 19218, 19252                                                                                                                        | 19252        |
| Fusion de 2 communes     | 21195, 21658                                                                                                                        | 21195        |
| Fusion de 2 communes     | 22007, 22055                                                                                                                        | 22055        |
| Fusion de 3 communes     | 22107, 22167, 22290                                                                                                                 | 22107        |
| Fusion de 2 communes     | 22158, 22298                                                                                                                        | 22158        |
| Fusion de 3 communes     | 22192, 22209, 22357                                                                                                                 | 22209        |
| Fusion de 2 communes     | 23192, 23231                                                                                                                        | 23192        |
| Fusion de 6 communes     | 24026, 24044, 24103, 24166, 24270, 24369                                                                                            | 24026        |
| Fusion de 2 communes     | 24053, 24447                                                                                                                        | 24053        |
| Fusion de 2 communes     | 24041, 24087                                                                                                                        | 24087        |
| Fusion de 2 communes     | 24117, 24204                                                                                                                        | 24117        |
| Fusion de 3 communes     | 24047, 24147, 24475                                                                                                                 | 24147        |
| Fusion de 2 communes     | 24216, 24333                                                                                                                        | 24216        |
| Fusion de 9 communes     | 24033, 24099, 24203, 24235, 24253, 24283, 24344, 24503, 24579                                                                       | 24253        |
| Fusion de 3 communes     | 24065, 24258, 24312                                                                                                                 | 24312        |
| Fusion de 2 communes     | 24092, 24362                                                                                                                        | 24362        |
| Fusion de 3 communes     | 24178, 24368, 24490                                                                                                                 | 24490        |
| Fusion de 2 communes     | 24093, 24554                                                                                                                        | 24554        |
| Fusion de 2 communes     | 25147, 25593                                                                                                                        | 25147        |
| Fusion de 2 communes     | 25156, 25531                                                                                                                        | 25156        |
| Fusion de 3 communes     | 25123, 25222, 25610                                                                                                                 | 25222        |
| Fusion de 2 communes     | 25319, 25334                                                                                                                        | 25334        |
| Fusion de 2 communes     | 25399, 25460                                                                                                                        | 25460        |
| Fusion de 2 communes     | 25575, 25576                                                                                                                        | 25575        |
| Fusion de 3 communes     | 27062, 27092, 27344                                                                                                                 | 27062        |
| Fusion de 2 communes     | 27089, 27626                                                                                                                        | 27089        |
| Fusion de 2 communes     | 27090, 27093                                                                                                                        | 27090        |
| Fusion de 2 communes     | 27274, 27294                                                                                                                        | 27294        |
| Fusion de 2 communes     | 27412, 27648                                                                                                                        | 27412        |
| Fusion de 4 communes     | 27131, 27253, 27425, 27452                                                                                                          | 27425        |
| Fusion de 2 communes     | 27448, 27510                                                                                                                        | 27448        |
| Fusion de 3 communes     | 27150, 27554, 27588                                                                                                                 | 27554        |
| Fusion de 3 communes     | 27058, 27647, 27676                                                                                                                 | 27676        |
| Fusion de 2 communes     | 27265, 27679                                                                                                                        | 27679        |
| Fusion de 6 communes     | 28012, 28044, 28093, 28115, 28204, 28356                                                                                            | 28012        |
| Fusion de 9 communes     | 28017, 28083, 28103, 28133, 28150, 28241, 28262, 28318, 28340                                                                       | 28103        |
| Fusion de 4 communes     | 28101, 28224, 28295, 28330                                                                                                          | 28330        |
| Fusion de 2 communes     | 29021, 29203                                                                                                                        | 29021        |
| Fusion de 2 communes     | 29076, 29149                                                                                                                        | 29076        |
| Fusion de 2 communes     | 31307, 31412                                                                                                                        | 31412        |
| Fusion de 2 communes     | 33106, 33107                                                                                                                        | 33106        |
| Fusion de 2 communes     | 33091, 33268                                                                                                                        | 33268        |
| Fusion de 3 communes     | 35069, 35209, 35254                                                                                                                 | 35069        |
| Fusion de 2 communes     | 35048, 35168                                                                                                                        | 35168        |
| Fusion de 3 communes     | 35083, 35191, 35323                                                                                                                 | 35191        |
| Fusion de 2 communes     | 35257, 35267                                                                                                                        | 35257        |
| Fusion de 2 communes     | 37021, 37135                                                                                                                        | 37021        |
| Fusion de 2 communes     | 37102, 37123                                                                                                                        | 37123        |
| Fusion de 3 communes     | 37120, 37227, 37232                                                                                                                 | 37232        |
| Fusion de 2 communes     | 38253, 38534                                                                                                                        | 38253        |
| Fusion de 2 communes     | 38292, 38305                                                                                                                        | 38292        |
| Fusion de 2 communes     | 38014, 38297                                                                                                                        | 38297        |
| Fusion de 2 communes     | 38312, 38407                                                                                                                        | 38407        |
| Fusion de 2 communes     | 38125, 38456                                                                                                                        | 38456        |
| Fusion de 2 communes     | 39018, 39566                                                                                                                        | 39018        |
| Fusion de 3 communes     | 39195, 39273, 39347                                                                                                                 | 39273        |
| Fusion de 4 communes     | 39123, 39224, 39290, 39506                                                                                                          | 39290        |
| Fusion de 3 communes     | 39023, 39135, 39378                                                                                                                 | 39378        |
| Fusion de 4 communes     | 39069, 39303, 39485, 39564                                                                                                          | 39485        |
| Fusion de 2 communes     | 39186, 39491                                                                                                                        | 39491        |
| Fusion de 2 communes     | 39341, 39510                                                                                                                        | 39510        |
| Fusion de 2 communes     | 39158, 39530                                                                                                                        | 39530        |
| Fusion de 2 communes     | 39309, 39537                                                                                                                        | 39537        |
| Fusion de 4 communes     | 39064, 39264, 39549, 39576                                                                                                          | 39576        |
| Fusion de 2 communes     | 39243, 39577                                                                                                                        | 39577        |
| Fusion de 2 communes     | 40048, 40243                                                                                                                        | 40243        |
| Fusion de 3 communes     | 41055, 41064, 41240                                                                                                                 | 41055        |
| Fusion de 2 communes     | 41033, 41142                                                                                                                        | 41142        |
| Fusion de 2 communes     | 41167, 41272                                                                                                                        | 41167        |
| Fusion de 4 communes     | 41011, 41015, 41171, 41210                                                                                                          | 41171        |
| Fusion de 2 communes     | 43176, 43221                                                                                                                        | 43221        |
| Fusion de 2 communes     | 45051, 45267                                                                                                                        | 45051        |
| Fusion de 2 communes     | 46063, 46248                                                                                                                        | 46063        |
| Fusion de 3 communes     | 46077, 46156, 46327                                                                                                                 | 46156        |
| Fusion de 2 communes     | 46268, 46331                                                                                                                        | 46268        |
| Fusion de 6 communes     | 48009, 48047, 48060, 48076, 48142, 48183                                                                                            | 48009        |
| Fusion de 6 communes     | 48014, 48023, 48027, 48040, 48093, 48164                                                                                            | 48027        |
| Fusion de 2 communes     | 48087, 48120                                                                                                                        | 48087        |
| Fusion de 5 communes     | 48094, 48125, 48154, 48180, 48195                                                                                                   | 48094        |
| Fusion de 2 communes     | 48084, 48139                                                                                                                        | 48139        |
| Fusion de 3 communes     | 48101, 48122, 48146                                                                                                                 | 48146        |
| Fusion de 10 communes    | 49001, 49050, 49078, 49091, 49115, 49186, 49317, 49318, 49327, 49363                                                                | 49050        |
| Fusion de 7 communes     | 49051, 49065, 49096, 49105, 49189, 49254, 49335                                                                                     | 49065        |
| Fusion de 3 communes     | 49086, 49191, 49227                                                                                                                 | 49086        |
| Fusion de 8 communes     | 49047, 49104, 49125, 49141, 49198, 49207, 49282, 49365                                                                              | 49125        |
| Fusion de 2 communes     | 49167, 49290                                                                                                                        | 49167        |
| Fusion de 3 communes     | 49108, 49183, 49376                                                                                                                 | 49183        |
| Fusion de 2 communes     | 49220, 49119                                                                                                                        | 49220        |
| Fusion de 14 communes    | 49013, 49044, 49052, 49062, 49087, 49098, 49122, 49150, 49173, 49175, 49197, 49202, 49228, 49234                                    | 49228        |
| Fusion de 10 communes    | 49073, 49088, 49103, 49156, 49226, 49248, 49250, 49309, 49354, 49366                                                                | 49248        |
| Fusion de 15 communes    | 49014, 49037, 49077, 49081, 49136, 49158, 49184, 49187, 49208, 49229, 49233, 49277, 49305, 49319, 49331                             | 49331        |
| Fusion de 19 communes    | 50001, 50020, 50041, 50057, 50073, 50163, 50171, 50187, 50220, 50242, 50257, 50385, 50386, 50460, 50477, 50600, 50611, 50620, 50623 | 50041        |
| Fusion de 2 communes     | 50095, 50465                                                                                                                        | 50095        |
| Fusion de 4 communes     | 50099, 50080, 50534, 50631                                                                                                          | 50099        |
| Fusion de 2 communes     | 50139, 50608                                                                                                                        | 50139        |
| Fusion de 7 communes     | 50037, 50043, 50125, 50131, 50260, 50318, 50323                                                                                     | 50260        |
| Fusion de 2 communes     | 50400, 50333                                                                                                                        | 50400        |
| Fusion de 3 communes     | 50119, 50325, 50431                                                                                                                 | 50431        |
| Fusion de 2 communes     | 50404, 50444                                                                                                                        | 50444        |
| Fusion de 7 communes     | 50018, 50100, 50154, 50337, 50487, 50627, 50640                                                                                     | 50487        |
| Fusion de 2 communes     | 51075, 51261                                                                                                                        | 51075        |
| Fusion de 2 communes     | 02344, 51171                                                                                                                        | 51171        |
| Fusion de 2 communes     | 52064, 52351                                                                                                                        | 52064        |
| Fusion de 2 communes     | 52140, 52262                                                                                                                        | 52140        |
| Fusion de 2 communes     | 53017, 53095                                                                                                                        | 53017        |
| Fusion de 2 communes     | 53161, 53205                                                                                                                        | 53161        |
| Fusion de 2 communes     | 53032, 53228                                                                                                                        | 53228        |
| Fusion de 3 communes     | 54099, 54341, 54342                                                                                                                 | 54099        |
| Fusion de 2 communes     | 56033, 56183                                                                                                                        | 56033        |
| Fusion de 3 communes     | 56038, 56061, 56064                                                                                                                 | 56061        |
| Fusion de 2 communes     | 57148, 57432                                                                                                                        | 57148        |
| Fusion de 2 communes     | 57482, 57523                                                                                                                        | 57482        |
| Fusion de 2 communes     | 58022, 58204                                                                                                                        | 58204        |
| Fusion de 2 communes     | 60029, 60649                                                                                                                        | 60029        |
| Fusion de 3 communes     | 60196, 60453, 60532                                                                                                                 | 60196        |
| Fusion de 2 communes     | 61004, 61168                                                                                                                        | 61168        |
| Fusion de 6 communes     | 61154, 61196, 61318, 61325, 61437, 61471                                                                                            | 61196        |
| Fusion de 14 communes    | 61009, 61019, 61057, 61083, 61110, 61131, 61157, 61161, 61315, 61449, 61474, 61477, 61496, 61504                                    | 61474        |
| Fusion de 2 communes     | 62294, 62295                                                                                                                        | 62295        |
| Fusion de 2 communes     | 62431, 62471                                                                                                                        | 62471        |
| Fusion de 2 communes     | 64020, 64225                                                                                                                        | 64225        |
| Fusion de 2 communes     | 65081, 65312                                                                                                                        | 65081        |
| Fusion de 2 communes     | 65399, 65480                                                                                                                        | 65399        |
| Fusion de 2 communes     | 67202, 67439                                                                                                                        | 67202        |
| Fusion de 3 communes     | 69024, 69146, 69222                                                                                                                 | 69024        |
| Fusion de 2 communes     | 69114, 69159                                                                                                                        | 69159        |
| Fusion de 3 communes     | 69195, 69228, 69237                                                                                                                 | 69228        |
| Fusion de 2 communes     | 70345, 70489                                                                                                                        | 70489        |
| Fusion de 4 communes     | 71180, 71288, 71582, 71587                                                                                                          | 71582        |
| Fusion de 2 communes     | 72025, 72108                                                                                                                        | 72025        |
| Fusion de 3 communes     | 72071, 72203, 72384                                                                                                                 | 72071        |
| Fusion de 4 communes     | 72063, 72159, 72240, 72262                                                                                                          | 72262        |
| Fusion de 2 communes     | 72082, 72308                                                                                                                        | 72308        |
| Fusion de 2 communes     | 73198, 73227                                                                                                                        | 73227        |
| Fusion de 3 communes     | 73163, 73167, 73235                                                                                                                 | 73235        |
| Fusion de 5 communes     | 73056, 73143, 73144, 73287, 73290                                                                                                   | 73290        |
| Fusion de 6 communes     | 74010, 74011, 74093, 74182, 74217, 74268                                                                                            | 74010        |
| Fusion de 5 communes     | 74022, 74120, 74204, 74245, 74282                                                                                                   | 74282        |
| Fusion de 3 communes     | 76127, 76146, 76248                                                                                                                 | 76146        |
| Fusion de 7 communes     | 76044, 76078, 76080, 76258, 76525, 76607, 76639                                                                                     | 76258        |
| Fusion de 2 communes     | 77316, 77491                                                                                                                        | 77316        |
| Fusion de 3 communes     | 79044, 79063, 79168                                                                                                                 | 79063        |
| Fusion de 2 communes     | 79006, 79136                                                                                                                        | 79136        |
| Fusion de 2 communes     | 79185, 79327                                                                                                                        | 79185        |
| Fusion de 2 communes     | 80295, 80532                                                                                                                        | 80295        |
| Fusion de 3 communes     | 80447, 80608, 80621                                                                                                                 | 80621        |
| Fusion de 2 communes     | 81113, 81218                                                                                                                        | 81218        |
| Fusion de 2 communes     | 85009, 85044                                                                                                                        | 85009        |
| Fusion de 2 communes     | 85052, 85152                                                                                                                        | 85152        |
| Fusion de 2 communes     | 86019, 86219                                                                                                                        | 86019        |
| Fusion de 2 communes     | 86053, 86208                                                                                                                        | 86053        |
| Fusion de 2 communes     | 86115, 86146                                                                                                                        | 86115        |
| Fusion de 4 communes     | 86030, 86060, 86071, 86281                                                                                                          | 86281        |
| Fusion de 3 communes     | 88029, 88234, 88235                                                                                                                 | 88029        |
| Fusion de 2 communes     | 88392, 88475                                                                                                                        | 88475        |
| Fusion de 4 communes     | 89003, 89078, 89473, 89484                                                                                                          | 89003        |
| Fusion de 2 communes     | 89001, 89130                                                                                                                        | 89130        |
| Fusion de 3 communes     | 89174, 89260, 89405                                                                                                                 | 89405        |
| Scission vers 2 communes | 76676                                                                                                                               | 76601, 76676 |

## Modifications en 2015

| Évènement             | Code initial                                                                                                                                             | Code final |
|:----------------------|:---------------------------------------------------------------------------------------------------------------------------------------------------------|:-----------|
| Fusion de 2 communes  | 01015, 01340                                                                                                                                             | 01015      |
| Fusion de 2 communes  | 01080, 01119                                                                                                                                             | 01080      |
| Fusion de 4 communes  | 01176, 01187, 01292, 01409                                                                                                                               | 01187      |
| Fusion de 2 communes  | 01204, 01300                                                                                                                                             | 01204      |
| Fusion de 2 communes  | 01271, 01286                                                                                                                                             | 01286      |
| Fusion de 2 communes  | 01182, 01338                                                                                                                                             | 01338      |
| Fusion de 2 communes  | 01312, 01426                                                                                                                                             | 01426      |
| Fusion de 3 communes  | 02053, 02161, 02669                                                                                                                                      | 02053      |
| Fusion de 7 communes  | 02348, 02439, 02479, 02597, 02646, 02771, 02811                                                                                                          | 02439      |
| Fusion de 4 communes  | 02026, 02147, 02325, 02458                                                                                                                               | 02458      |
| Fusion de 3 communes  | 03123, 03153, 03158                                                                                                                                      | 03158      |
| Fusion de 2 communes  | 04100, 04120                                                                                                                                             | 04120      |
| Fusion de 3 communes  | 05053, 05069, 05143                                                                                                                                      | 05053      |
| Fusion de 3 communes  | 05005, 05034, 05118                                                                                                                                      | 05118      |
| Fusion de 2 communes  | 08114, 08115                                                                                                                                             | 08115      |
| Fusion de 3 communes  | 08007, 08116, 08261                                                                                                                                      | 08116      |
| Fusion de 2 communes  | 08145, 08267                                                                                                                                             | 08145      |
| Fusion de 2 communes  | 08198, 08441                                                                                                                                             | 08198      |
| Fusion de 2 communes  | 08009, 08311                                                                                                                                             | 08311      |
| Fusion de 3 communes  | 10003, 10277, 10415                                                                                                                                      | 10003      |
| Fusion de 2 communes  | 11080, 11171                                                                                                                                             | 11080      |
| Fusion de 2 communes  | 11050, 11304                                                                                                                                             | 11304      |
| Fusion de 3 communes  | 12021, 12245, 12285                                                                                                                                      | 12021      |
| Fusion de 4 communes  | 12076, 12114, 12173, 12218                                                                                                                               | 12076      |
| Fusion de 2 communes  | 12120, 12271                                                                                                                                             | 12120      |
| Fusion de 3 communes  | 12081, 12087, 12177                                                                                                                                      | 12177      |
| Fusion de 6 communes  | 12005, 12112, 12117, 12223, 12279, 12304                                                                                                                 | 12223      |
| Fusion de 2 communes  | 12014, 12224                                                                                                                                             | 12224      |
| Fusion de 5 communes  | 12040, 12123, 12126, 12196, 12270                                                                                                                        | 12270      |
| Fusion de 2 communes  | 14014, 14170                                                                                                                                             | 14014      |
| Fusion de 2 communes  | 14035, 14727                                                                                                                                             | 14035      |
| Fusion de 2 communes  | 14037, 14553                                                                                                                                             | 14037      |
| Fusion de 20 communes | 14052, 14061, 14115, 14129, 14139, 14255, 14264, 14317, 14395, 14440, 14441, 14443, 14532, 14573, 14618, 14629, 14632, 14636, 14655, 14704               | 14061      |
| Fusion de 6 communes  | 14152, 14174, 14361, 14523, 14585, 14653                                                                                                                 | 14174      |
| Fusion de 22 communes | 14028, 14029, 14058, 14148, 14155, 14210, 14259, 14265, 14330, 14371, 14414, 14418, 14420, 14429, 14459, 14471, 14518, 14615, 14633, 14634, 14638, 14696 | 14371      |
| Fusion de 2 communes  | 14432, 14475                                                                                                                                             | 14475      |
| Fusion de 3 communes  | 14356, 14543, 14670                                                                                                                                      | 14543      |
| Fusion de 5 communes  | 14154, 14570, 14599, 14647, 14693                                                                                                                        | 14570      |
| Fusion de 4 communes  | 14105, 14153, 14576, 14583                                                                                                                               | 14576      |
| Fusion de 2 communes  | 14188, 14579                                                                                                                                             | 14579      |
| Fusion de 5 communes  | 14144, 14213, 14324, 14628, 14689                                                                                                                        | 14689      |
| Fusion de 14 communes | 14065, 14113, 14156, 14222, 14253, 14442, 14503, 14521, 14539, 14549, 14564, 14686, 14726, 14746                                                         | 14726      |
| Fusion de 2 communes  | 14292, 14740                                                                                                                                             | 14740      |
| Fusion de 8 communes  | 14187, 14388, 14545, 14584, 14717, 14718, 14730, 14762                                                                                                   | 14762      |
| Fusion de 4 communes  | 15068, 15108, 15195, 15197                                                                                                                               | 15108      |
| Fusion de 2 communes  | 15071, 15181                                                                                                                                             | 15181      |
| Fusion de 2 communes  | 15150, 15268                                                                                                                                             | 15268      |
| Fusion de 3 communes  | 16082, 16092, 16172                                                                                                                                      | 16082      |
| Fusion de 2 communes  | 16106, 16322                                                                                                                                             | 16106      |
| Fusion de 2 communes  | 16043, 16148                                                                                                                                             | 16148      |
| Fusion de 4 communes  | 16021, 16175, 16201, 16257                                                                                                                               | 16175      |
| Fusion de 2 communes  | 16179, 16224                                                                                                                                             | 16224      |
| Fusion de 3 communes  | 16262, 16286, 16371                                                                                                                                      | 16286      |
| Fusion de 2 communes  | 17040, 17277                                                                                                                                             | 17277      |
| Fusion de 3 communes  | 17238, 17295, 17371                                                                                                                                      | 17295      |
| Fusion de 2 communes  | 19123, 19282                                                                                                                                             | 19123      |
| Fusion de 2 communes  | 21318, 21327                                                                                                                                             | 21327      |
| Fusion de 7 communes  | 22046, 22066, 22102, 22191, 22292, 22297, 22303                                                                                                          | 22046      |
| Fusion de 2 communes  | 22051, 22084                                                                                                                                             | 22084      |
| Fusion de 2 communes  | 22093, 22151                                                                                                                                             | 22093      |
| Fusion de 2 communes  | 22058, 22183                                                                                                                                             | 22183      |
| Fusion de 2 communes  | 22080, 22203                                                                                                                                             | 22203      |
| Fusion de 2 communes  | 22251, 22367                                                                                                                                             | 22251      |
| Fusion de 2 communes  | 23149, 23161                                                                                                                                             | 23149      |
| Fusion de 4 communes  | 24028, 24219, 24310, 24497                                                                                                                               | 24028      |
| Fusion de 2 communes  | 24035, 24363                                                                                                                                             | 24035      |
| Fusion de 3 communes  | 24013, 24053, 24439                                                                                                                                      | 24053      |
| Fusion de 2 communes  | 24064, 24430                                                                                                                                             | 24064      |
| Fusion de 2 communes  | 24142, 24298                                                                                                                                             | 24142      |
| Fusion de 2 communes  | 24118, 24316                                                                                                                                             | 24316      |
| Fusion de 2 communes  | 24362, 24435                                                                                                                                             | 24362      |
| Fusion de 2 communes  | 24343, 24376                                                                                                                                             | 24376      |
| Fusion de 2 communes  | 24239, 24540                                                                                                                                             | 24540      |
| Fusion de 6 communes  | 25028, 25128, 25302, 25424, 25480, 25585                                                                                                                 | 25424      |
| Fusion de 2 communes  | 25076, 25434                                                                                                                                             | 25434      |
| Fusion de 2 communes  | 25438, 25509                                                                                                                                             | 25438      |
| Fusion de 2 communes  | 25529, 25530                                                                                                                                             | 25529      |
| Fusion de 2 communes  | 26001, 26187                                                                                                                                             | 26001      |
| Fusion de 2 communes  | 26179, 26366                                                                                                                                             | 26179      |
| Fusion de 2 communes  | 27011, 27506                                                                                                                                             | 27011      |
| Fusion de 3 communes  | 27022, 27519, 27687                                                                                                                                      | 27022      |
| Fusion de 3 communes  | 27032, 27172, 27634                                                                                                                                      | 27032      |
| Fusion de 16 communes | 27007, 27041, 27049, 27088, 27221, 27283, 27292, 27296, 27356, 27362, 27499, 27513, 27515, 27566, 27596, 27628                                           | 27049      |
| Fusion de 3 communes  | 27085, 27223, 27244                                                                                                                                      | 27085      |
| Fusion de 3 communes  | 27084, 27105, 27637                                                                                                                                      | 27105      |
| Fusion de 2 communes  | 27107, 27526                                                                                                                                             | 27107      |
| Fusion de 3 communes  | 27112, 27159, 27305                                                                                                                                      | 27112      |
| Fusion de 4 communes  | 27145, 27157, 27225, 27532                                                                                                                               | 27157      |
| Fusion de 3 communes  | 27191, 27211, 27250                                                                                                                                      | 27191      |
| Fusion de 6 communes  | 27024, 27166, 27198, 27293, 27387, 27503                                                                                                                 | 27198      |
| Fusion de 14 communes | 27060, 27121, 27122, 27128, 27160, 27197, 27213, 27255, 27257, 27262, 27264, 27308, 27449, 27653                                                         | 27213      |
| Fusion de 2 communes  | 27277, 27484                                                                                                                                             | 27277      |
| Fusion de 2 communes  | 27302, 27574                                                                                                                                             | 27302      |
| Fusion de 2 communes  | 27303, 27565                                                                                                                                             | 27565      |
| Fusion de 3 communes  | 27195, 27573, 27578                                                                                                                                      | 27578      |
| Fusion de 3 communes  | 27636, 27638, 27639                                                                                                                                      | 27638      |
| Fusion de 2 communes  | 27688, 27693                                                                                                                                             | 27693      |
| Fusion de 2 communes  | 28015, 28361                                                                                                                                             | 28015      |
| Fusion de 2 communes  | 28183, 28288                                                                                                                                             | 28183      |
| Fusion de 2 communes  | 28254, 28402                                                                                                                                             | 28254      |
| Fusion de 2 communes  | 28297, 28383                                                                                                                                             | 28383      |
| Fusion de 4 communes  | 28020, 28145, 28179, 28406                                                                                                                               | 28406      |
| Fusion de 4 communes  | 28258, 28320, 28416, 28422                                                                                                                               | 28422      |
| Fusion de 2 communes  | 29003, 29052                                                                                                                                             | 29003      |
| Fusion de 2 communes  | 29127, 29266                                                                                                                                             | 29266      |
| Fusion de 2 communes  | 32079, 32168                                                                                                                                             | 32079      |
| Fusion de 3 communes  | 33018, 33371, 33495                                                                                                                                      | 33018      |
| Fusion de 2 communes  | 35060, 35158                                                                                                                                             | 35060      |
| Fusion de 2 communes  | 35129, 35176                                                                                                                                             | 35176      |
| Fusion de 2 communes  | 36093, 36201                                                                                                                                             | 36093      |
| Fusion de 2 communes  | 36202, 36245                                                                                                                                             | 36202      |
| Fusion de 3 communes  | 36151, 36183, 36229                                                                                                                                      | 36229      |
| Fusion de 3 communes  | 38001, 38028, 38165                                                                                                                                      | 38001      |
| Fusion de 2 communes  | 38022, 38541                                                                                                                                             | 38022      |
| Fusion de 2 communes  | 38021, 38225                                                                                                                                             | 38225      |
| Fusion de 2 communes  | 38145, 38359                                                                                                                                             | 38359      |
| Fusion de 2 communes  | 38262, 38439                                                                                                                                             | 38439      |
| Fusion de 2 communes  | 39017, 39482                                                                                                                                             | 39017      |
| Fusion de 4 communes  | 39021, 39215, 39488, 39544                                                                                                                               | 39021      |
| Fusion de 2 communes  | 39130, 39442                                                                                                                                             | 39130      |
| Fusion de 3 communes  | 39177, 39260, 39332                                                                                                                                      | 39177      |
| Fusion de 4 communes  | 39209, 39226, 39382, 39509                                                                                                                               | 39209      |
| Fusion de 2 communes  | 39286, 39438                                                                                                                                             | 39286      |
| Fusion de 3 communes  | 39213, 39329, 39340                                                                                                                                      | 39329      |
| Fusion de 2 communes  | 39161, 39331                                                                                                                                             | 39331      |
| Fusion de 3 communes  | 39294, 39368, 39371                                                                                                                                      | 39368      |
| Fusion de 2 communes  | 41142, 41169                                                                                                                                             | 41142      |
| Fusion de 2 communes  | 41023, 41151                                                                                                                                             | 41151      |
| Fusion de 7 communes  | 41056, 41133, 41173, 41183, 41244, 41264, 41270                                                                                                          | 41173      |
| Fusion de 2 communes  | 42039, 42114                                                                                                                                             | 42039      |
| Fusion de 2 communes  | 43090, 43255                                                                                                                                             | 43090      |
| Fusion de 2 communes  | 43081, 43245                                                                                                                                             | 43245      |
| Fusion de 2 communes  | 44005, 44040                                                                                                                                             | 44005      |
| Fusion de 2 communes  | 44021, 44059                                                                                                                                             | 44021      |
| Fusion de 2 communes  | 44008, 44029                                                                                                                                             | 44029      |
| Fusion de 2 communes  | 44087, 44181                                                                                                                                             | 44087      |
| Fusion de 2 communes  | 44004, 44163                                                                                                                                             | 44163      |
| Fusion de 4 communes  | 44011, 44034, 44147, 44213                                                                                                                               | 44213      |
| Fusion de 2 communes  | 45129, 45211                                                                                                                                             | 45129      |
| Fusion de 7 communes  | 45057, 45106, 45190, 45191, 45192, 45221, 45236                                                                                                          | 45191      |
| Fusion de 2 communes  | 46103, 46287                                                                                                                                             | 46103      |
| Fusion de 5 communes  | 46019, 46110, 46138, 46291, 46325                                                                                                                        | 46138      |
| Fusion de 5 communes  | 46025, 46166, 46201, 46261, 46326                                                                                                                        | 46201      |
| Fusion de 2 communes  | 46252, 46275                                                                                                                                             | 46252      |
| Fusion de 5 communes  | 46048, 46071, 46141, 46150, 46311                                                                                                                        | 46311      |
| Fusion de 2 communes  | 48017, 48033                                                                                                                                             | 48017      |
| Fusion de 2 communes  | 48022, 48050                                                                                                                                             | 48050      |
| Fusion de 2 communes  | 48061, 48186                                                                                                                                             | 48061      |
| Fusion de 2 communes  | 48049, 48099                                                                                                                                             | 48099      |
| Fusion de 2 communes  | 48062, 48105                                                                                                                                             | 48105      |
| Fusion de 3 communes  | 48066, 48116, 48172                                                                                                                                      | 48116      |
| Fusion de 2 communes  | 48134, 48152                                                                                                                                             | 48152      |
| Fusion de 2 communes  | 48162, 48166                                                                                                                                             | 48166      |
| Fusion de 3 communes  | 49003, 49181, 49230                                                                                                                                      | 49003      |
| Fusion de 10 communes | 49018, 49031, 49079, 49097, 49101, 49116, 49128, 49143, 49157, 49315                                                                                     | 49018      |
| Fusion de 2 communes  | 49021, 49147                                                                                                                                             | 49021      |
| Fusion de 10 communes | 49006, 49023, 49072, 49151, 49162, 49165, 49239, 49243, 49312, 49375                                                                                     | 49023      |
| Fusion de 2 communes  | 49029, 49322                                                                                                                                             | 49029      |
| Fusion de 2 communes  | 49067, 49095                                                                                                                                             | 49067      |
| Fusion de 9 communes  | 49040, 49069, 49126, 49172, 49177, 49270, 49296, 49320, 49360                                                                                            | 49069      |
| Fusion de 12 communes | 49071, 49074, 49092, 49111, 49153, 49169, 49225, 49268, 49281, 49300, 49325, 49351                                                                       | 49092      |
| Fusion de 3 communes  | 49049, 49138, 49280                                                                                                                                      | 49138      |
| Fusion de 5 communes  | 49094, 49149, 49154, 49279, 49346                                                                                                                        | 49149      |
| Fusion de 2 communes  | 44060, 49160                                                                                                                                             | 49160      |
| Fusion de 4 communes  | 49025, 49084, 49163, 49185                                                                                                                               | 49163      |
| Fusion de 2 communes  | 49005, 49176                                                                                                                                             | 49176      |
| Fusion de 2 communes  | 49139, 49194                                                                                                                                             | 49194      |
| Fusion de 4 communes  | 49196, 49200, 49242, 49251                                                                                                                               | 49200      |
| Fusion de 11 communes | 49033, 49083, 49085, 49137, 49145, 49218, 49252, 49313, 49314, 49316, 49324                                                                              | 49218      |
| Fusion de 2 communes  | 49093, 49220                                                                                                                                             | 49220      |
| Fusion de 11 communes | 49024, 49034, 49039, 49075, 49190, 49204, 49212, 49244, 49276, 49295, 49297                                                                              | 49244      |
| Fusion de 2 communes  | 49265, 49292                                                                                                                                             | 49292      |
| Fusion de 10 communes | 49179, 49206, 49258, 49263, 49264, 49273, 49285, 49301, 49349, 49350                                                                                     | 49301      |
| Fusion de 7 communes  | 49004, 49019, 49032, 49042, 49106, 49117, 49307                                                                                                          | 49307      |
| Fusion de 2 communes  | 49238, 49323                                                                                                                                             | 49323      |
| Fusion de 5 communes  | 49066, 49133, 49134, 49256, 49345                                                                                                                        | 49345      |
| Fusion de 4 communes  | 49043, 49148, 49249, 49367                                                                                                                               | 49367      |
| Fusion de 7 communes  | 49059, 49142, 49232, 49342, 49348, 49356, 49373                                                                                                          | 49373      |
| Fusion de 6 communes  | 50082, 50396, 50418, 50520, 50614, 50646                                                                                                                 | 50082      |
| Fusion de 2 communes  | 50090, 50557                                                                                                                                             | 50090      |
| Fusion de 4 communes  | 50010, 50099, 50249, 50458                                                                                                                               | 50099      |
| Fusion de 2 communes  | 50114, 50115                                                                                                                                             | 50115      |
| Fusion de 5 communes  | 50129, 50173, 50203, 50416, 50602                                                                                                                        | 50129      |
| Fusion de 2 communes  | 50139, 50319                                                                                                                                             | 50139      |
| Fusion de 4 communes  | 50142, 50211, 50375, 50432                                                                                                                               | 50142      |
| Fusion de 2 communes  | 50132, 50168                                                                                                                                             | 50168      |
| Fusion de 2 communes  | 50209, 50595                                                                                                                                             | 50209      |
| Fusion de 2 communes  | 50061, 50215                                                                                                                                             | 50215      |
| Fusion de 9 communes  | 50035, 50063, 50204, 50236, 50330, 50343, 50544, 50558, 50586                                                                                            | 50236      |
| Fusion de 2 communes  | 50123, 50239                                                                                                                                             | 50239      |
| Fusion de 2 communes  | 50012, 50267                                                                                                                                             | 50267      |
| Fusion de 4 communes  | 50136, 50273, 50415, 50497                                                                                                                               | 50273      |
| Fusion de 2 communes  | 50280, 50292                                                                                                                                             | 50292      |
| Fusion de 5 communes  | 50056, 50359, 50381, 50494, 50638                                                                                                                        | 50359      |
| Fusion de 3 communes  | 50134, 50316, 50363                                                                                                                                      | 50363      |
| Fusion de 2 communes  | 50339, 50388                                                                                                                                             | 50388      |
| Fusion de 4 communes  | 50133, 50293, 50329, 50391                                                                                                                               | 50391      |
| Fusion de 2 communes  | 50128, 50393                                                                                                                                             | 50393      |
| Fusion de 6 communes  | 50005, 50153, 50212, 50250, 50400, 50642                                                                                                                 | 50400      |
| Fusion de 3 communes  | 50284, 50410, 50630                                                                                                                                      | 50410      |
| Fusion de 2 communes  | 50255, 50419                                                                                                                                             | 50419      |
| Fusion de 2 communes  | 50189, 50436                                                                                                                                             | 50436      |
| Fusion de 3 communes  | 50484, 50515, 50644                                                                                                                                      | 50484      |
| Fusion de 5 communes  | 50380, 50414, 50441, 50492, 50635                                                                                                                        | 50492      |
| Fusion de 5 communes  | 50051, 50127, 50170, 50191, 50523                                                                                                                        | 50523      |
| Fusion de 3 communes  | 50071, 50406, 50535                                                                                                                                      | 50535      |
| Fusion de 4 communes  | 50213, 50287, 50545, 50546                                                                                                                               | 50546      |
| Fusion de 2 communes  | 50470, 50564                                                                                                                                             | 50564      |
| Fusion de 5 communes  | 50009, 50116, 50355, 50434, 50565                                                                                                                        | 50565      |
| Fusion de 2 communes  | 50582, 50625                                                                                                                                             | 50582      |
| Fusion de 5 communes  | 50179, 50245, 50254, 50508, 50591                                                                                                                        | 50591      |
| Fusion de 2 communes  | 50180, 50592                                                                                                                                             | 50592      |
| Fusion de 4 communes  | 50075, 50202, 50224, 50601                                                                                                                               | 50601      |
| Fusion de 2 communes  | 50440, 50639                                                                                                                                             | 50639      |
| Fusion de 3 communes  | 51030, 51064, 51347                                                                                                                                      | 51030      |
| Fusion de 2 communes  | 51331, 51564                                                                                                                                             | 51564      |
| Fusion de 2 communes  | 52331, 52427                                                                                                                                             | 52331      |
| Fusion de 3 communes  | 52340, 52405, 52509                                                                                                                                      | 52405      |
| Fusion de 4 communes  | 52180, 52293, 52296, 52411                                                                                                                               | 52411      |
| Fusion de 2 communes  | 52036, 52449                                                                                                                                             | 52449      |
| Fusion de 2 communes  | 52239, 52529                                                                                                                                             | 52529      |
| Fusion de 2 communes  | 53137, 53194                                                                                                                                             | 53137      |
| Fusion de 2 communes  | 53185, 53252                                                                                                                                             | 53185      |
| Fusion de 2 communes  | 53050, 53255                                                                                                                                             | 53255      |
| Fusion de 3 communes  | 56142, 56144, 56192                                                                                                                                      | 56144      |
| Fusion de 3 communes  | 56037, 56187, 56197                                                                                                                                      | 56197      |
| Fusion de 2 communes  | 56150, 56251                                                                                                                                             | 56251      |
| Fusion de 2 communes  | 57021, 57184                                                                                                                                             | 57021      |
| Fusion de 3 communes  | 58026, 58100, 58167                                                                                                                                      | 58026      |
| Fusion de 2 communes  | 59260, 59404                                                                                                                                             | 59260      |
| Fusion de 2 communes  | 59154, 59588                                                                                                                                             | 59588      |
| Fusion de 3 communes  | 60018, 60088, 60246                                                                                                                                      | 60088      |
| Fusion de 8 communes  | 61007, 61058, 61073, 61313, 61353, 61465, 61478, 61489                                                                                                   | 61007      |
| Fusion de 4 communes  | 61050, 61128, 61245, 61430                                                                                                                               | 61050      |
| Fusion de 3 communes  | 61081, 61253, 61306                                                                                                                                      | 61081      |
| Fusion de 4 communes  | 61096, 61135, 61186, 61200                                                                                                                               | 61096      |
| Fusion de 3 communes  | 61115, 61116, 61125                                                                                                                                      | 61116      |
| Fusion de 3 communes  | 61145, 61201, 61355                                                                                                                                      | 61145      |
| Fusion de 6 communes  | 61027, 61127, 61153, 61236, 61441, 61470                                                                                                                 | 61153      |
| Fusion de 10 communes | 61003, 61047, 61136, 61167, 61184, 61191, 61205, 61282, 61434, 61506                                                                                     | 61167      |
| Fusion de 7 communes  | 61025, 61033, 61211, 61235, 61239, 61380, 61469                                                                                                          | 61211      |
| Fusion de 8 communes  | 61220, 61230, 61247, 61250, 61280, 61296, 61305, 61458                                                                                                   | 61230      |
| Fusion de 6 communes  | 61112, 61144, 61309, 61337, 61368, 61409                                                                                                                 | 61309      |
| Fusion de 3 communes  | 61155, 61324, 61455                                                                                                                                      | 61324      |
| Fusion de 9 communes  | 61106, 61174, 61179, 61270, 61339, 61340, 61354, 61364, 61378                                                                                            | 61339      |
| Fusion de 3 communes  | 61175, 61341, 61509                                                                                                                                      | 61341      |
| Fusion de 3 communes  | 61042, 61147, 61345                                                                                                                                      | 61345      |
| Fusion de 2 communes  | 61320, 61460                                                                                                                                             | 61460      |
| Fusion de 2 communes  | 61428, 61463                                                                                                                                             | 61463      |
| Fusion de 2 communes  | 61431, 61483                                                                                                                                             | 61483      |
| Fusion de 6 communes  | 61185, 61204, 61246, 61356, 61359, 61484                                                                                                                 | 61484      |
| Fusion de 10 communes | 61016, 61045, 61059, 61065, 61090, 61226, 61335, 61338, 61343, 61491                                                                                     | 61491      |
| Fusion de 2 communes  | 62226, 62691                                                                                                                                             | 62691      |
| Fusion de 2 communes  | 62757, 62807                                                                                                                                             | 62757      |
| Fusion de 2 communes  | 63018, 63160                                                                                                                                             | 63160      |
| Fusion de 2 communes  | 63068, 63244                                                                                                                                             | 63244      |
| Fusion de 2 communes  | 63255, 63266                                                                                                                                             | 63255      |
| Fusion de 2 communes  | 65188, 65192                                                                                                                                             | 65192      |
| Fusion de 2 communes  | 65027, 65282                                                                                                                                             | 65282      |
| Fusion de 4 communes  | 67004, 67041, 67431, 67469                                                                                                                               | 67004      |
| Fusion de 3 communes  | 67372, 67496, 67512                                                                                                                                      | 67372      |
| Fusion de 2 communes  | 67374, 67495                                                                                                                                             | 67495      |
| Fusion de 4 communes  | 67158, 67207, 67297, 67539                                                                                                                               | 67539      |
| Fusion de 2 communes  | 68006, 68031                                                                                                                                             | 68006      |
| Fusion de 2 communes  | 68012, 68206                                                                                                                                             | 68012      |
| Fusion de 2 communes  | 68056, 68070                                                                                                                                             | 68056      |
| Fusion de 2 communes  | 68143, 68272                                                                                                                                             | 68143      |
| Fusion de 3 communes  | 68162, 68164, 68310                                                                                                                                      | 68162      |
| Fusion de 2 communes  | 68201, 68233                                                                                                                                             | 68201      |
| Fusion de 2 communes  | 68219, 68314                                                                                                                                             | 68219      |
| Fusion de 3 communes  | 68108, 68133, 68240                                                                                                                                      | 68240      |
| Fusion de 2 communes  | 68319, 68320                                                                                                                                             | 68320      |
| Fusion de 3 communes  | 69066, 69158, 69247                                                                                                                                      | 69066      |
| Fusion de 3 communes  | 70281, 70418, 70551                                                                                                                                      | 70418      |
| Fusion de 2 communes  | 71204, 71265                                                                                                                                             | 71204      |
| Fusion de 2 communes  | 71279, 71375                                                                                                                                             | 71279      |
| Fusion de 2 communes  | 72023, 72301                                                                                                                                             | 72023      |
| Fusion de 2 communes  | 72288, 72363                                                                                                                                             | 72363      |
| Fusion de 3 communes  | 73006, 73126, 73169                                                                                                                                      | 73006      |
| Fusion de 6 communes  | 73010, 73062, 73108, 73158, 73238, 73239                                                                                                                 | 73010      |
| Fusion de 4 communes  | 73038, 73093, 73150, 73305                                                                                                                               | 73150      |
| Fusion de 2 communes  | 73257, 73321                                                                                                                                             | 73257      |
| Fusion de 2 communes  | 73115, 73284                                                                                                                                             | 73284      |
| Fusion de 2 communes  | 74112, 74181                                                                                                                                             | 74112      |
| Fusion de 2 communes  | 74123, 74270                                                                                                                                             | 74123      |
| Fusion de 2 communes  | 74084, 74167                                                                                                                                             | 74167      |
| Fusion de 2 communes  | 74187, 74275                                                                                                                                             | 74275      |
| Fusion de 3 communes  | 76164, 76659, 76742                                                                                                                                      | 76164      |
| Fusion de 2 communes  | 76276, 76277                                                                                                                                             | 76276      |
| Fusion de 4 communes  | 76089, 76267, 76289, 76444                                                                                                                               | 76289      |
| Fusion de 2 communes  | 76401, 76625                                                                                                                                             | 76401      |
| Fusion de 4 communes  | 76031, 76476, 76701, 76713                                                                                                                               | 76476      |
| Fusion de 18 communes | 76027, 76037, 76073, 76081, 76098, 76137, 76145, 76215, 76301, 76310, 76326, 76337, 76376, 76496, 76618, 76643, 76696, 76704                             | 76618      |
| Fusion de 3 communes  | 77316, 77170, 77299                                                                                                                                      | 77316      |
| Fusion de 6 communes  | 79013, 79053, 79072, 79099, 79187, 79333                                                                                                                 | 79013      |
| Fusion de 2 communes  | 79113, 79280                                                                                                                                             | 79280      |
| Fusion de 2 communes  | 81026, 81155                                                                                                                                             | 81026      |
| Fusion de 3 communes  | 81062, 81091, 81153                                                                                                                                      | 81062      |
| Fusion de 2 communes  | 85008, 85069                                                                                                                                             | 85008      |
| Fusion de 2 communes  | 85019, 85279                                                                                                                                             | 85019      |
| Fusion de 2 communes  | 85080, 85091                                                                                                                                             | 85080      |
| Fusion de 4 communes  | 85030, 85084, 85165, 85212                                                                                                                               | 85084      |
| Fusion de 4 communes  | 85063, 85090, 85180, 85257                                                                                                                               | 85090      |
| Fusion de 2 communes  | 85154, 85219                                                                                                                                             | 85154      |
| Fusion de 3 communes  | 85150, 85197, 85272                                                                                                                                      | 85197      |
| Fusion de 2 communes  | 85043, 85213                                                                                                                                             | 85213      |
| Fusion de 2 communes  | 86245, 86259                                                                                                                                             | 86245      |
| Fusion de 2 communes  | 87026, 87097                                                                                                                                             | 87097      |
| Fusion de 2 communes  | 88018, 88218                                                                                                                                             | 88218      |
| Fusion de 2 communes  | 88112, 88361                                                                                                                                             | 88361      |
| Fusion de 3 communes  | 88204, 88337, 88465                                                                                                                                      | 88465      |
| Fusion de 14 communes | 89070, 89086, 89097, 89103, 89138, 89178, 89192, 89241, 89243, 89294, 89317, 89343, 89358, 89454                                                         | 89086      |
| Fusion de 4 communes  | 89196, 89213, 89275, 89457                                                                                                                               | 89196      |
| Fusion de 2 communes  | 89334, 89356                                                                                                                                             | 89334      |
| Fusion de 2 communes  | 89366, 89388                                                                                                                                             | 89388      |
| Fusion de 3 communes  | 89107, 89411, 89429                                                                                                                                      | 89411      |
| Fusion de 2 communes  | 89330, 89441                                                                                                                                             | 89441      |
| Autre changement      | 14697                                                                                                                                                    | 14472      |

## Modifications en 2014

| Évènement                | Code initial                                    | Code final   |
|:-------------------------|:------------------------------------------------|:-------------|
| Fusion de 2 communes     | 14178, 14474                                    | 14474        |
| Fusion de 2 communes     | 25034, 25035                                    | 25035        |
| Fusion de 2 communes     | 28069, 28185                                    | 28185        |
| Fusion de 2 communes     | 38024, 38152                                    | 38152        |
| Fusion de 2 communes     | 60417, 60570                                    | 60570        |
| Fusion de 2 communes     | 61109, 61292                                    | 61292        |
| Fusion de 4 communes     | 61249, 61375, 61417, 61511                      | 61375        |
| Fusion de 7 communes     | 61031, 61177, 61223, 61377, 61410, 61486, 61513 | 61486        |
| Fusion de 2 communes     | 69221, 69255                                    | 69255        |
| Fusion de 2 communes     | 71138, 71578                                    | 71578        |
| Fusion de 6 communes     | 72069, 72137, 72162, 72207, 72258, 72318        | 72137        |
| Fusion de 2 communes     | 73263, 73264                                    | 73263        |
| Fusion de 2 communes     | 77166, 77316                                    | 77316        |
| Scission vers 2 communes | 55298                                           | 55138, 55298 |

## Modifications en 2013

| Évènement                | Code initial | Code final   |
|:-------------------------|:-------------|:-------------|
| Fusion de 2 communes     | 52187, 52379 | 52187        |
| Scission vers 2 communes | 76108        | 76095, 76108 |

## Modifications en 2012

| Évènement            | Code initial                      | Code final |
|:---------------------|:----------------------------------|:-----------|
| Fusion de 3 communes | 05020, 05067, 05132               | 05132      |
| Fusion de 4 communes | 05002, 05042, 05138, 05139        | 05139      |
| Fusion de 5 communes | 49018, 49213, 49245, 49303, 49372 | 49018      |
| Fusion de 2 communes | 49092, 49199                      | 49092      |
| Fusion de 2 communes | 49101, 49380                      | 49101      |
| Fusion de 2 communes | 69144, 69208                      | 69208      |
| Fusion de 5 communes | 69025, 69041, 69128, 69129, 69248 | 69248      |
| Fusion de 2 communes | 79030, 79353                      | 79030      |
| Fusion de 2 communes | 79242, 79356                      | 79242      |
| Fusion de 2 communes | 88176, 88282                      | 88176      |

## Modifications en 2011

| Évènement                | Code initial | Code final          |
|:-------------------------|:-------------|:--------------------|
| Fusion de 2 communes     | 28042, 28361 | 28361               |
| Fusion de 2 communes     | 76095, 76108 | 76108               |
| Scission vers 2 communes | 52031        | 52031, 52278        |
| Scission vers 3 communes | 52332        | 52465, 52033, 52332 |
| Scission vers 2 communes | 52427        | 52266, 52427        |
| Scission vers 2 communes | 52504        | 52124, 52504        |

## Modifications en 2010

| Évènement            | Code initial        | Code final |
|:---------------------|:--------------------|:-----------|
| Fusion de 3 communes | 59183, 59248, 59540 | 59183      |

## Pas de modification en 2009

## Modifications en 2008

| Évènement                | Code initial | Code final   |
|:-------------------------|:-------------|:-------------|
| Fusion de 2 communes     | 21084, 21551 | 21084        |
| Scission vers 2 communes | 31483        | 31300, 31483 |
| Scission vers 2 communes | 89387        | 89326, 89387 |
