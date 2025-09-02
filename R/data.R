################################################################################
#
# (1/3) Données renseignées à la volée pour le fonctionnement du package
#
################################################################################

#' Plus petite année disponible
#'
#' @format Nombre
#' @encoding UTF-8
#' @export
cog_min <- 2008

#' Année de la base communale de référence
#'
#' @format Nombre
#' @encoding UTF-8
#' @export
cog_ref <- 2023

#' Table de passage entre les arrondissements municipaux et les communes de Paris, Lyon et Marseille
#'
#' @format Une data frame avec 2 variables :
#' \describe{
#'    \item{COM}{Code commune}
#'    \item{ARM}{Code arrondissement}
#' }
#'
#' Pour plus de détails sur le code officiel géographique \url{https://www.insee.fr/fr/information/2560452}
#'
#' @encoding UTF-8
#' @export
data_arm_com <- data.frame(
  COM = c("13055", "13055", "13055", "13055", "13055", "13055", "13055", "13055",
          "13055", "13055", "13055", "13055", "13055", "13055", "13055", "13055",
          "69123", "69123", "69123", "69123", "69123", "69123", "69123", "69123",
          "69123",
          "75056", "75056", "75056", "75056", "75056", "75056", "75056", "75056",
          "75056", "75056", "75056", "75056", "75056", "75056", "75056", "75056",
          "75056", "75056", "75056", "75056"),
  ARM = c("13201", "13202", "13203", "13204", "13205", "13206", "13207", "13208",
          "13209", "13210", "13211", "13212", "13213", "13214", "13215", "13216",
          "69381", "69382", "69383", "69384", "69385", "69386", "69387", "69388",
          "69389",
          "75101", "75102", "75103", "75104", "75105", "75106", "75107", "75108",
          "75109", "75110", "75111", "75112", "75113", "75114", "75115", "75116",
          "75117", "75118", "75119", "75120")
)

#' Table de passage entre les codes des départements et les codes des régions
#'
#' @format Une data frame avec 2 variables :
#' \describe{
#'    \item{REG}{Code région}
#'    \item{DEP}{Code département}
#' }
#'
#' Pour plus de détails sur le code officiel géographique \url{https://www.insee.fr/fr/information/2560452}
#'
#' @encoding UTF-8
#' @export
data_dep_reg <- data.frame(
  REG = c("84","32","84","93","93","93","84","44","76","44","76","76","93","28","84",
          "75","75","24","75","27","53","75","75","27","84","28","24","53","94","94",
          "76","76","76","75","76","53","24","24","84","27","75","24","84","84","52",
          "24","76","75","76","52","28","44","44","52","44","44","53","44","27","32",
          "32","28","32","84","75","76","76","44","44","84","27","27","52","84","84",
          "11","28","11","11","75","32","76","76","93","93","52","75","75","44","27",
          "27","11","11","11","11","11","01","02","03","04","06"),
  DEP = c("01","02","03","04","05","06","07","08","09","10","11","12","13","14","15",
          "16","17","18","19","21","22","23","24","25","26","27","28","29","2A","2B",
          "30","31","32","33","34","35","36","37","38","39","40","41","42","43","44",
          "45","46","47","48","49","50","51","52","53","54","55","56","57","58","59",
          "60","61","62","63","64","65","66","67","68","69","70","71","72","73","74",
          "75","76","77","78","79","80","81","82","83","84","85","86","87","88","89",
          "90","91","92","93","94","95","971","972","973","974","976")
)

################################################################################
#
# (2/3) Données du dossier data/ pour le fonctionnement du package
#
################################################################################

#' Plus grande année disponible
#'
#' @encoding UTF-8
#' @format Nombre
"cog_max"

#' Table de passage du code officiel géographique des communes
#'
#' Base intermédiaire utilisée pour le changement de géographie des communes.
#' Contient les communes qui ont changé de code officiel géographique depuis 2008.
#' La population des communes sert de pondération par défaut pour recalculer des variables.
#' Voir le découpage communal ([https://www.insee.fr/fr/information/2028028](https://www.insee.fr/fr/information/2028028))
#' et l'historique des populations légales ([https://www.insee.fr/fr/statistiques/2522602](https://www.insee.fr/fr/statistiques/2522602))
#' sur Insee.fr.
#'
#' @format Une data frame avec 2724 lignes et 34 variables :
#' \describe{
#'    \item{COM_2008}{Code géographique en 2008}
#'    \item{COM_2009}{Code géographique en 2009}
#'    \item{COM_2010}{Code géographique en 2010}
#'    \item{COM_2011}{Code géographique en 2011}
#'    \item{COM_2012}{Code géographique en 2012}
#'    \item{COM_2013}{Code géographique en 2013}
#'    \item{COM_2014}{Code géographique en 2014}
#'    \item{COM_2015}{Code géographique en 2015}
#'    \item{COM_2016}{Code géographique en 2016}
#'    \item{COM_2017}{Code géographique en 2017}
#'    \item{COM_2018}{Code géographique en 2018}
#'    \item{COM_2019}{Code géographique en 2019}
#'    \item{COM_2020}{Code géographique en 2020}
#'    \item{COM_2021}{Code géographique en 2021}
#'    \item{COM_2022}{Code géographique en 2022}
#'    \item{COM_2023}{Code géographique en 2023}
#'    \item{COM_2024}{Code géographique en 2024}
#'    \item{POP_GEO_2008}{Population de référence en géographie 2008}
#'    \item{POP_GEO_2009}{Population de référence en géographie 2009}
#'    \item{POP_GEO_2010}{Population de référence en géographie 2010}
#'    \item{POP_GEO_2011}{Population de référence en géographie 2011}
#'    \item{POP_GEO_2012}{Population de référence en géographie 2012}
#'    \item{POP_GEO_2013}{Population de référence en géographie 2013}
#'    \item{POP_GEO_2014}{Population de référence en géographie 2014}
#'    \item{POP_GEO_2015}{Population de référence en géographie 2015}
#'    \item{POP_GEO_2016}{Population de référence en géographie 2016}
#'    \item{POP_GEO_2017}{Population de référence en géographie 2017}
#'    \item{POP_GEO_2018}{Population de référence en géographie 2018}
#'    \item{POP_GEO_2019}{Population de référence en géographie 2019}
#'    \item{POP_GEO_2020}{Population de référence en géographie 2020}
#'    \item{POP_GEO_2021}{Population de référence en géographie 2021}
#'    \item{POP_GEO_2022}{Population de référence en géographie 2022}
#'    \item{POP_GEO_2023}{Population de référence en géographie 2023}
#'    \item{POP_GEO_2024}{Population de référence en géographie 2024}
#' }
#'
#'
#' @encoding UTF-8
"data_table_passage"

#' Base communale de référence
#'
#' Base intermédiaire utilisée par les bases communales antérieures.
#'
#' @format Une data frame avec 34945 lignes et 1 variable :
#' \describe{
#'    \item{COM}{Code géographique en 2023}
#' }
#'
#' Pour plus de détails sur le code officiel géographique \url{https://www.insee.fr/fr/information/2560452}
#'
#' @encoding UTF-8
"data_com_ref"


