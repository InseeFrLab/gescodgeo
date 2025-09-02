#' Convertit les départements en régions
#'
#' Convertit les codes géographiques des départements en codes géographiques des régions.
#'
#' @param data Un objet de type data frame ou vecteur.
#' @param from [`<tidy-select>`][dplyr::dplyr_tidy_select] Colonne initiale des départements.
#' Par défaut, "DEP". Sans objet si `data` est un vecteur.
#' @param to Colonne finale pour les régions.
#' Par défaut, "REG". Sans objet si `data` est un vecteur.
#' @param extra Autres codes géographiques : `NULL`, valeur unique, vecteur nommé ou fonction.
#' Par défaut, collectivités d'outre-mer et étranger.
#'
#' @return Un objet du même type que `data`.
#'  * Pour une data frame, une data frame avec le même nombre de lignes.
#'  * Pour un vecteur, un vecteur de dimension égale.
#'
#' @examples
#' x <-  c("13", "84", "75", "75", "999", "ZZZ","YYY", NA)
#'
#' # data frame
#' data <- data.frame(ID = c(1:length(x)), CODE_DEP = x)
#' data |> dep_to_reg(from = CODE_DEP, to = "CODE_REG")
#'
#' # vecteur
#' dep_to_reg(x)
#' dep_to_reg(x, extra = c("YYY"="YY"))
#' unique(dep_to_reg(x))
#'
#' @encoding UTF-8
#' @export
#' @importFrom rlang enquo
#' @importFrom dplyr %>%
dep_to_reg <- function(data, from = "DEP", to = "REG", extra = c("999" = "99", "ZZZ" = "ZZ")) {

  # tidy-select pour une data frame
  if(is.data.frame(data)) {
    from <-  tidyselect::eval_select(
      expr = enquo(from),
      data = data[unique(names(data))],
      allow_rename = FALSE) %>%
      tidy_as_cols()
  }

  # Méthode codes_to_one pour une data frame ou un vecteur
  data <- codes_to_one(
    data = data,
    from = from,
    to = to,
    codes_ini = gescodgeo::data_dep_reg$DEP,
    codes_fin = gescodgeo::data_dep_reg$REG,
    extra = extra
  )

  return(data)

}


