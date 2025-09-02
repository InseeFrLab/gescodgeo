#' Convertit les communes en departements
#'
#' Convertit les codes geographiques des communes en codes geographiques des departements.
#'
#' @param data Un objet de type data frame ou vecteur.
#' @param from [`<tidy-select>`][dplyr::dplyr_tidy_select] Colonne initiale des communes.
#' Par defaut, "COM". Sans objet si `data` est un vecteur.
#' @param to Colonne finale pour les departements.
#' Par defaut, "DEP". Sans objet si `data` est un vecteur.
#' @param extra Autres codes geographiques : `NULL`, valeur unique, vecteur nomme ou fonction.
#' Par defaut, collectivites d'outre-mer et etranger.
#'
#' @return Un objet du meme type que `data`.
#'  * Pour une data frame, une data frame avec le meme nombre de lignes.
#'  * Pour un vecteur, un vecteur de dimension egale.
#'
#' @examples
#' x <-  c("84001", "75001", "75001", "97401", "98601", "YYYYY", "99999", "A1001", NA)
#'
#' # data frame
#' data <- data.frame(ID = c(1:length(x)), COM = x)
#' data |> com_to_dep(from = COM, to = "DEP")
#'
#' # Personalisation des codes extras
#' codes_extra <- c("977" = "ZZZ", "978" = "ZZZ", "986" = "ZZZ", "987" = "ZZZ",
#'  "988" = "ZZZ", "ZZ" = "ZZZ", "YY" = "YYY", "NA" = "999")
#'
#' data |> com_to_dep(from = COM, to = "DEP", extra = codes_extra)
#'
#' # Vecteur
#' com_to_dep(x)
#' com_to_dep(x, extra = NULL)
#' com_to_dep(x, extra = function(x) {return (x)})
#'
#' @encoding UTF-8
#' @export
#' @importFrom rlang enquo
#' @importFrom dplyr %>%
com_to_dep <- function (data,
                        from = "COM",
                        to = "DEP",
                        extra = c("977" = "977", "978" = "978",
                                  "986" = "986", "987" = "987", "988" = "988",
                                  "ZZ" = "ZZZ", "NA" = "999")
                        ) {

  # Pour une data frame
  if(is.data.frame(data)) {

    # tidy-select pour une data frame
    from <-  tidyselect::eval_select(
      expr = enquo(from),
      data = data[unique(names(data))],
      allow_rename = FALSE) %>%
      tidy_as_cols()

    data[[to]] <- x_com_to_dep(data[[from]], extra)

    return(data)
  }
  # Par defaut
  x_com_to_dep(data, extra)
}

# Input vector
x_com_to_dep <- function (x,
                          extra = c("977" = "977", "978" = "978",
                                          "986" = "986", "987" = "987", "988" = "988",
                                          "YY" = "YYY", "ZZ" = "ZZZ", "NA" = "999")
                          ) {

  # Codes departements (a mettre ailleurs)
  codes_dep <- c("01","02","03","04","05","06","07","08","09","10":"19","2A","2B","21":"95","971":"976")

  # Code sur 2 ou 3 position
  y <- substr(x, 1, 2)
  y[which(y %in% c("97","98"))] <- substr(x[which(y %in% c("97","98"))], 1, 3)

  # Codes valides
  z <- y
  z[which(!(y %in% codes_dep))] <- NA

  # extra est une fonction
  if(is.function(extra)) {
    z[is.na(z)] <- extra(y[is.na(z)])

    # extra est un vecteur nomme
  } else if(!is.null(names(extra))) {
    z[is.na(z)] <- extra[y[is.na(z)]]

    if("NA" %in% names(extra)) {
      z[is.na(z)] <- extra["NA"]
    }

    # Valeur par defaut pour les manquants
  } else if(!is.null(extra)) {
    z[is.na(z)] <- extra
  }

  return(z)
}


