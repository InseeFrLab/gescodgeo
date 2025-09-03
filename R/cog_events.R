#' Évènements du code officiel géographique
#'
#' Renvoie une data frame avec les évenements ayant eu lieu depuis 2008 pour un
#' code géographique donné : fusions, scissions ou changement de code.
#'
#' @param x Code géographique.
#' @param message Générer un avertissement si aucun évènement n'a eu lieu
#' depuis 2008 ou si le code demandé n'aparaît pas dans le code officel
#' géographique. Par défaut, TRUE.
#'
#' @return Une data frame
#'
#' @details
#' Colonnes de la data frame générée par la fonction `cog_events()` :
#'  * `COG_INI` : Année initiale du code officiel géographique.
#'  * `COG_FIN` : Année finale du code officiel géographique.
#'  * `COM_INI` : Code initial de la commune.
#'  * `COM_FIN` : Code final de la commune.
#'  * `NB_COM_INI` : Nombre initial de communes, _supérieur à 1 pour une fusion_.
#'  * `NB_COM_FIN` : Nombre final de communes, _supérieur à 1 pour une scission_.
#' @export
#'
#' @examples
#' # Exemple d'une commune avec un changement de code et une fusion
#' cog_events("14472")
#'
#' # Exemple d'une commune avec une fusion et un retablissement (scission)
#' cog_events("14712")
#'
#' # Exemple d'une commune sans evenements dans le COG
#' cog_events("13001")
#'
#' # Exemple d'un code n'aparaissant pas dans le COG
#' cog_events("13999")
#'
#' @encoding UTF-8
#' @export
#' @importFrom rlang .data
#' @importFrom dplyr %>% bind_rows filter mutate mutate
cog_events <- function(x, message = TRUE) {

  # Un seul code
  x <- as.character(x[1])

  # Initialisation
  data <- data.frame(COG_INI = c(), COG_FIN = c())

  # Boucle sur les années du cog
  for(i in c(gescodgeo::cog_min:(gescodgeo::cog_max-1))) {

    # Cog i+1
    j <- i + 1

    # Occurence de x dans la table de passage
    table_passage <- cog_transition(i, j) %>%
      filter(.data$COM_INI == {x} | .data$COM_FIN == {x}) %>%
      mutate(COG_INI = {i}, COG_FIN = {j})

    # Empilement
    data <- bind_rows(data, table_passage)
  }

  data <- bind_rows(data, table_passage) %>%
    select("COG_INI", "COG_FIN", "COM_INI", "COM_FIN", "NB_COM_INI", "NB_COM_FIN")

  # Avertissements si 0 occurences
  if(nrow(data)==0 & message) {
    if(x %in% gescodgeo::data_com_ref[[1]]) {
      warning("Pas d'evenement pour \"", x,"\" entre ",gescodgeo::cog_min,
              " et ", gescodgeo::cog_max,
              call. =FALSE, immediate. = TRUE)
    } else {
      warning("\"", x, "\" n'est pas dans le COG entre ",gescodgeo::cog_min,
              " et ", gescodgeo::cog_max,
              call. =FALSE, immediate. = TRUE)
    }
  }

  return(data)

}
