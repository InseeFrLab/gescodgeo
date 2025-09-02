#' Enlève (ou pas) les communes de Mayotte, selon l'année du code officiel géographique
#'
#' Si `cog >= 2012`, les communes de Mayotte sont conservées.
#' Si `cog < 2012`, les communes de Mayotte sont supprimées.
#'
#' @param data Un objet de type data frame ou vecteur.
#' @param cog Année du cog. Par défaut, 2008 : les communes de Mayotte sont supprimées.
#' @param from [`<tidy-select>`][dplyr::dplyr_tidy_select] Colonne des communes.
#' Par défaut, première colonne. Sans objet si `data` est un vecteur.
#'
#' @return Un objet du même type que `data`.
#'  * Pour une data frame, une data frame avec un nombre de lignes inférieur ou égal.
#'  * Pour un vecteur, un vecteur de dimension inférieure ou égale.
#'
#' @encoding UTF-8
#' @export
#'
#' @examples
#' data <- data.frame(COM = c("97424", "97601"))
#'
#' # Par défaut les lignes des communes de Mayotte sont supprimées
#' data |> filter_mayotte(from = COM)
#'
#' # Si cog >= 2012 elles sont conservées
#' data |> filter_mayotte(cog = 2013, from = COM)
#'
#' # Pour un vecteur
#' filter_mayotte(c("97424", "97601"), from = COM)
#'
#' @importFrom rlang .data enquo
#' @importFrom dplyr %>% filter
filter_mayotte <- function(data, cog = 2008, from = NULL) {
  if(cog < 2012) {

    if(is.data.frame(data)) {

      # tidy-select pour une data frame
      from <-  tidyselect::eval_select(
        expr = enquo(from),
        data = data[unique(names(data))],
        allow_rename = FALSE) %>%
        tidy_as_cols()
      if(is.null(from)) { from <-  colnames(data)[1] }

      data <- data %>% filter(substr(.data[[from]],1,3) != "976")

    } else {
      data <- data[which(substr(data,1,3) != "976")]
    }

  }

  return(data)
}


