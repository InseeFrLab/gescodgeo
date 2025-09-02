#' Table de passage entre deux annees du code officiel geographique des communes
#'
#' Renvoie la table de passage des communes qui sont modifiees entre deux annees du code officiel geographique (COG).
#'
#' @param cog_from Annee du code officiel geographique des communes initiales dans la table de passage
#' @param cog_to Annee du code officiel geographique des communes finales dans la table de passage
#'
#' @return Une data frame
#'
#' @details
#' Colonnes de la data frame generee par la fonction `cog_transition()` :
#'  * `COM_INI` : Code commune initial
#'  * `COM_FIN` : Code commune final
#'  * `POP_INI` : Population initiale, pouvant servir de ponderation pour la fonction `adapt_to_change()`
#'  * `POP_FIN` : Population finale, pouvant servir de ponderation pour la fonction `adapt_to_change()`
#'  * `NB_COM_INI` : Nombre de communes initial
#'  * `NB_COM_FIN` : Nombre de communes final
#'
#' @examples
#' cog_transition(cog_from = 2019, cog_to = 2020)
#'
#' @encoding UTF-8
#' @importFrom rlang .data
#' @importFrom dplyr %>% distinct group_by mutate ungroup filter n
#' @export
cog_transition <- function(cog_from, cog_to) {

  # Verifie que les annees sont disponibles
  controles_annees_dispo(cog_from)
  controles_annees_dispo(cog_to)

  # Base tab_passage du package gescodgeo
  tp <- gescodgeo::data_table_passage

  # Ne garde que les variables utiles
  tp <- tp[,c(paste0("COM_", cog_from), paste0("COM_", cog_to),
              paste0("POP_GEO_", cog_from), paste0("POP_GEO_", cog_to)
  )]

  # Renomme
  names(tp) <- c("COM_INI", "COM_FIN", "POP_INI", "POP_FIN")

  # Supprime les doublons
  tp <- tp %>% distinct(.data$COM_INI , .data$COM_FIN, .keep_all=TRUE) %>%

    # Nombre de communes fusisonnees
    group_by(.data$COM_FIN) %>% mutate(NB_COM_INI = n()) %>% ungroup() %>%

    # Nombre de communes scindees et "split ratio"
    group_by(.data$COM_INI) %>%
    mutate(NB_COM_FIN = n(), SPLIT_RATIO = .data$POP_FIN / sum(.data$POP_FIN)) %>%
    ungroup() %>%

    # Au moins une modification
    filter(.data$NB_COM_INI + .data$NB_COM_FIN  > 2 | .data$COM_INI != .data$COM_FIN)

  return(tp)

}
