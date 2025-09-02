#' Base des codes des communes selon l'année du code officiel géographique
#'
#' Renvoie une data frame avec les codes géographiques des communes françaises
#' selon l'année demandée du code officiel géographique (COG).
#'
#' @param cog Une année du code officiel géographique des communes (COG).
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

  # Base communale de référence
  data <- gescodgeo::data_com_ref

  # Changement de géographie
  if(cog != gescodgeo::cog_ref) {
    data <- data %>% change_cog(cog_from = gescodgeo::cog_ref, cog_to = cog)
  }

  # Suppression des doublons et prise en compte de Mayotte
  data <- data %>% distinct(.data$COM) %>% filter_mayotte(cog)

  return(data)
}
