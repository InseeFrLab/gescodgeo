#' Convertit les régions en départements
#'
#' Convertit les codes géographiques des régions en codes géographiques des départements.
#'
#' @param data Un objet de type data frame ou vecteur.
#' @param from [`<tidy-select>`][dplyr::dplyr_tidy_select] Colonne initiale des régions.
#' Par défaut, "REG". Sans objet si `data` est un vecteur.
#' @param to Colonne finale pour les départements.
#' Par défaut, "DEP". Sans objet si `data` est un vecteur.
#' @param extra Autres codes géographiques : `NULL`, valeur unique, vecteur nommé ou fonction.
#' Par défaut, collectivités d'outre-mer et étranger.
#'
#' @return Un objet du même type que `data`.
#'  * Pour une data frame, une data frame avec un nombre de lignes égal ou supérieur.
#'  * Pour un vecteur, un vecteur de dimension égale ou supérieure.
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

  # Méthode codes_to_many pour une data frame ou un vecteur
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
