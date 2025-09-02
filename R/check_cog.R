#' Vérifie le code géographique des communes
#'
#' Compare les codes des communes au code officiel geographique (COG) pour une année demandée.
#' Les années vont de 2008 au dernier millésime disponible.
#'
#' @param data Un objet de type data frame ou vecteur.
#' @param cog  Année du code officiel géographique, à partir de 2008.
#' @param from [`<tidy-select>`][dplyr::dplyr_tidy_select] Colonne initiale des communes.
#' Par défaut, première colonne. Sans objet si `data` est un vecteur.
#' @param complete Vérifier que les données sont complète,
#' c'est-à-dire que toutes les communes du COG sont représentées.
#' Par défaut, `FALSE` : vérifie uniquement si toutes les communes sont dans le COG.
#' @param ignore_arm Ignorer les arrondissements municipaux de Paris, Lyon et Marseille.
#' Par défaut, TRUE. Si `FALSE`, les arrondissements municipaux ne sont pas dans le COG.
#' @param ignore_mayotte Ignorer communes de Mayotte.
#' Par défaut, `FALSE.` : les communes de Mayotte sont hors du COG avant 2012 et
#' comprises dans le COG à partir de 2012.
#' @param data_res Renvoyer le resultat de la comparaison dans
#' une data frame. Par défaut, `FALSE.`
#' @param message Générer un avertissement quand des différences
#' avec le COG sont détectées. Par défaut, `TRUE`.
#'
#' @return Un booléen (si `data_res` vaut `FALSE`) ou une data frame (si `data_res` vaut `TRUE`).
#'
#' @examples
#' data <- data_com(2018)
#'
#' # Pas d'erreurs
#' check_cog(data, cog = 2018)
#'
#' # Messages d'erreur
#' check_cog(data, cog = 2019)
#'
#' # Verifier aussi les communes manquantes
#' check_cog(data, cog = 2019, complete = TRUE)
#'
#' # Ne pas ignorer les arrondissements municipaux
#' data <- com_to_arm(data, to = "CODE_ARM")
#' check_cog(data, cog = 2019, from = CODE_ARM, ignore_arm = FALSE)
#'
#' # Renvoyer les resultats dans une base
#' data_errors <- data |>
#'    check_cog(cog = 2009, complete = TRUE, data_res = TRUE, message = FALSE)
#'
#' # Pour un vecteur
#' x <- data$COM
#' check_cog(x, cog = 2018)
#'
#' @encoding UTF-8
#' @importFrom rlang .data
#' @importFrom dplyr %>% anti_join arrange bind_rows distinct mutate slice
#' @export
check_cog <- function(data,
                        cog,
                        from = NULL,
                        complete = FALSE,
                        ignore_arm = TRUE,
                        ignore_mayotte = FALSE,
                        data_res = FALSE,
                        message = TRUE) {

  # Compatibilité pour un vecteur
  if(!is.data.frame(data)) {
    if(is.atomic(data)) {
      data <- data.frame(COM = data)
      from <- "COM"
    } else {
      stop("Objet de type", typeof(data), " incompatible")
    }
  } else {
    # tidy-select pour une data frame
    from <-  tidyselect::eval_select(
      expr = enquo(from),
      data = data[unique(names(data))],
      allow_rename = FALSE) %>%
      tidy_as_cols()
    if(is.null(from)) { from <-  colnames(data)[1] }
  }

  # Garde la variable COM au format charactère
  data <- data %>% distinct(.data[[from]]) %>%
    mutate("{from}" := as.character(.data[[from]]))

  # Ne tient pas compte des arrondissements :
  if(ignore_arm) { data <- data %>%  filter(
    .data[[from]] %not_in% c("13201":"13216","69381":"69389","75101":"75120")
  )}

  # Chargement de la table du COG
  data_cog <-  data_com(cog)
  colnames(data_cog)[1] <- from

  # Ne tient pas compte de Mayotte :
  if(ignore_mayotte) {
    data_cog <- data_cog %>% filter_mayotte(cog = 0)
    data <- data %>% filter_mayotte(cog = 0)
  }

  # La difference, c'est Paris, et des Collectivites d'outre mer
  intrus <-anti_join(data, data_cog, by = from)

  # Tri des codes : fait apparaître des erreurs de cog (ex : 27258) avant des
  # des communes de l'étranger (ex : AL3031)
  intrus <- intrus %>% arrange(.data[[from]])

  if(complete==TRUE) {
    absents <- anti_join(data_cog, data, by= from)
    absents <- absents %>% arrange(.data[[from]])

  } else {
    absents <- data.frame()
  }

  # Base des anomalies
  if(data_res) {

    if(nrow(absents)>0) {
      absents <- absents %>% mutate(
        SOURCE = "COG",
        ERREUR = paste0("Dans le COG ",cog," mais pas dans les donnees"))
    }
    if(nrow(intrus)>0) {
      intrus <- intrus %>% mutate (
        SOURCE = "DATA",
        ERREUR = paste0("Dans les donnees mais pas dans le COG ",cog))
    }

    errors <- bind_rows(intrus,absents)
  }

  # Messages d'avertissements
  if(message) {
    if(nrow(intrus)>0) {
      if(nrow(intrus)>11) {
        intrus <- slice(intrus, 1:10)
        intrus[11,from] <- "[...]"
      }
      warning("\nLes communes suivantes ne sont pas dans le COG de l'annee ",
               cog," : \n",
               paste0(intrus[[from]], collapse = " "),
               call. =FALSE, immediate. = TRUE)
    }
    if(nrow(absents)>0) {
      if(nrow(absents)>11) {
          absents <- slice(absents,1:10)
          absents[11, from] <- "[...]"
      }
      warning("\nLes communes suivantes du COG de l'annee ",
              cog," ne sont pas dans la base :\n",
              paste0(absents[[from]],collapse = " "),
              call. =FALSE, immediate.=TRUE)
    }
  }

  # Renvoie la base des anomalies
  if(data_res) {
    return(errors)
  } else {

    # Renvoie VRAI ou FAUX SI on assigne la fonction a un objet
    bool <- (nrow(intrus) + nrow(absents) == 0)
    return(bool)
  }
}
