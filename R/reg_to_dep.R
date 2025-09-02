#' Convertit les regions en departements
#'
#' Convertit les codes geographiques des regions en codes geographiques des departements.
#'
#' @param data Un objet de type data frame ou vecteur.
#' @param from [`<tidy-select>`][dplyr::dplyr_tidy_select] Colonne initiale des regions.
#' Par defaut, "REG". Sans objet si `data` est un vecteur.
#' @param to Colonne finale pour les departements.
#' Par defaut, "DEP". Sans objet si `data` est un vecteur.
#' @param extra Autres codes geographiques : `NULL`, valeur unique, vecteur nomme ou fonction.
#' Par defaut, collectivites d'outre-mer et etranger.
#'
#' @return Un objet du meme type que `data`.
#'  * Pour une data frame, une data frame avec un nombre de lignes egal ou superieur.
#'  * Pour un vecteur, un vecteur de dimension egale ou superieure.
#'
#' @examples
#' x <- c("94", "93", "ZZ", NA)
#'
#' # data frame
#' data <- data.frame(ID = c(1:length(x)), CODE_REG = x)
#' reg_to_dep(data, from = CODE_REG,  to = "CODE_DEP")

#' # vecteur
#' reg_to_dep(x)
#' reg_to_dep(x, extra = "?")
#' @encoding UTF-8
#' @export
#' @importFrom rlang .data enquo
#' @importFrom dplyr %>% filter
reg_to_dep <- function (data, from = "REG", to = "DEP", extra = c("99" = "999", "ZZ" = "ZZZ")) {

  # tidy-select pour une data frame
  if(is.data.frame(data)) {
    from <-  tidyselect::eval_select(
      expr = enquo(from),
      data = data[unique(names(data))],
      allow_rename = FALSE) %>%
      tidy_as_cols()
  }

  # Methode codes_to_many pour une data frame ou un vecteur
  data <- codes_to_many(
    data = data,
    from = from,
    to = to,
    codes_ini = gescodgeo::data_dep_reg$REG,
    codes_fin = gescodgeo::data_dep_reg$DEP,
    extra = extra
  )
  return(data)

}
