#' Base des codes des communes selon l'annee du code officiel geographique
#'
#' Renvoie une data frame avec les codes geographiques des communes françaises
#' selon l'annee demandee du code officiel geographique (COG).
#'
#' @param cog Une annee du code officiel geographique des communes (COG).
#'
#' @return Une data frame.
#'
#' @examples
#' data_com_2018 <- data_com(cog = 2018)
#'
#' @encoding UTF-8
#' @export
#' @importFrom rlang .data
#' @importFrom dplyr %>% distinct
data_com <- function(cog) {

  # Base communale de reference
  data <- gescodgeo::data_com_ref

  # Changement de geographie
  if(cog != gescodgeo::cog_ref) {
    data <- data %>% change_cog(cog_from = gescodgeo::cog_ref, cog_to = cog)
  }

  # Suppression des doublons et prise en compte de Mayotte
  data <- data %>% distinct(.data$COM) %>% filter_mayotte(cog)

  return(data)
}
