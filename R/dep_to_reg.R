#' Convertit les departements en regions
#'
#' Convertit les codes geographiques des departements en codes geographiques des regions.
#'
#' @param data Un objet de type data frame ou vecteur.
#' @param from [`<tidy-select>`][dplyr::dplyr_tidy_select] Colonne initiale des departements.
#' Par defaut, "DEP". Sans objet si `data` est un vecteur.
#' @param to Colonne finale pour les regions.
#' Par defaut, "REG". Sans objet si `data` est un vecteur.
#' @param extra Autres codes geographiques : `NULL`, valeur unique, vecteur nomme ou fonction.
#' Par defaut, collectivites d'outre-mer et etranger.
#'
#' @return Un objet du meme type que `data`.
#'  * Pour une data frame, une data frame avec le meme nombre de lignes.
#'  * Pour un vecteur, un vecteur de dimension egale.
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

  # Methode codes_to_one pour une data frame ou un vecteur
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


