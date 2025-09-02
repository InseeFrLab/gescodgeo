#' Convertit les arrondissements municipaux en communes
#'
#' Convertit les codes géographiques des arrondissements municipaux de Paris,
#' Lyon et Marseille en codes de ces communes.
#'
#' @param data Un objet de type data frame ou vecteur.
#' @param from [`<tidy-select>`][dplyr::dplyr_tidy_select] Colonne initiale des
#' communes ou  arrondissements municipaux.
#' Par défaut, première colonne. Sans objet si `data` est un vecteur.
#' @param to Colonne finale pour les communes.
#' Par défaut, même nom que la colonne initiale. Sans objet si `data` est un vecteur.
#' @param extra Autres codes géographiques : `NULL`, valeur unique, vecteur nommé ou fonction.
#' Par défaut, les codes géographiques en dehors Paris, Lyon et Marseille ne sont pas changés.
#'
#' @return Un objet du même type que `data`.
#'  * Pour une data frame, une data frame avec le même nombre de lignes.
#'  * Pour un vecteur, un vecteur de dimension égale.
#'
#' @examples
#' x <-  c("01123","13201","13202","75101")
#'
#' # data frame
#' data <- data.frame(ID = c(1:4), CODE_ARM = x)
#' data |> arm_to_com(from = CODE_ARM, to = "CODE_COM")
#'
#' # vecteur
#' arm_to_com(x)
#' arm_to_com(x, extra = NULL)
#' unique(arm_to_com(x))
#' @encoding UTF-8
#' @export
arm_to_com <- function(data, from = NULL, to = NULL, extra = function(x) {return(x)}) {

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

  # Méthode codes_to_many pour une data frame ou un vecteur
  data <- codes_to_one(
    data = data,
    from = from,
    to = to,
    codes_ini = gescodgeo::data_arm_com$ARM,
    codes_fin = gescodgeo::data_arm_com$COM,
    extra = extra
  )

  return(data)

}

