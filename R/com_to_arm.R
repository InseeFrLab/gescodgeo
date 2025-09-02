#' Convertit les communes en arrondissements municipaux
#'
#' Convertit les codes geographiques des communes de Paris, Lyon et Marseille
#' en codes geographiques d'arrondissements municipaux.
#'
#' @param data Un objet de type data frame ou vecteur.
#' @param from [`<tidy-select>`][dplyr::dplyr_tidy_select] Colonne initiale des communes.
#' Par defaut, premiere colonne. Sans objet si `data` est un vecteur.
#' @param to Colonne finale pour les communes ou arrondissements municipaux.
#' Par defaut, meme nom que la colonne initiale. Sans objet si `data` est un vecteur.
#' @param extra Autres codes geographiques : valeur unique, paires de cles et de valeurs ou fonction.
#' Par defaut, les codes geographiques en dehors Paris, Lyon et Marseille ne sont pas changes.
#'
#' @return Un objet du meme type que `data`.
#'  * Pour une data frame, une data frame avec un nombre de lignes egal ou superieur.
#'  * Pour un vecteur, un vecteur de dimension egale ou superieure.
#'
#' @examples
#' x <- c("01123","13055","75056")
#'
#' # data frame
#' data <- data.frame(ID = c(1:3), CODE_COM = x)
#' data |> com_to_arm(from = CODE_COM, to = "CODE_ARM") |> head()
#'
#' data |> com_to_arm(from = CODE_COM) |> head()
#'
#' # vecteur
#' com_to_arm(x)
#' com_to_arm(x, extra = "?")
#' @encoding UTF-8
#' @export
#' @importFrom rlang enquo
#' @importFrom dplyr %>%
com_to_arm <- function(data, from = NULL, to = NULL, extra = function(x) {return(x)}) {

  # tidy-select pour une data frame
  if(is.data.frame(data)) {
    from <-  tidyselect::eval_select(
      expr = enquo(from),
      data = data[unique(names(data))],
      allow_rename = FALSE) %>%
      tidy_as_cols()
    if(is.null(from)) { from <-  colnames(data)[1] }
    if(is.null(to)) { to <-  from }
  }

  # Methode codes_to_many pour une data frame ou un vecteur
  data <- codes_to_many(
    data = data,
    from = from,
    to = to,
    codes_ini = gescodgeo::data_arm_com$COM,
    codes_fin = gescodgeo::data_arm_com$ARM,
    extra = extra
  )
  return(data)

}
