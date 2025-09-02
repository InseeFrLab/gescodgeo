#' Change l'année du code officiel géographique des communes
#'
#' Convertit les codes géographiques des communes dans une autre année du code officiel géographique (COG).
#' Les années vont de 2008 au dernier millésime disponible.
#'
#' @param data Un objet de type data frame ou vecteur.
#' @param cog_from Année initiale du code officiel géographique, à partir de 2008.
#' @param cog_to Année finale du code officiel géographique, à partir de 2008.
#' @param from [`<tidy-select>`][dplyr::dplyr_tidy_select] Colonne initiale des communes.
#' Par défaut, première colonne. Sans objet si `data` est un vecteur.
#' @param to Colonne finale pour les communes.
#' Par défaut, même nom que la colonne initiale. Sans objet si `data` est un vecteur.
#' @param infos Ajouter les informations de la table de passage. Par défaut, FALSE.
#' @param split_ratio Ajouter une clé de répartition pour la réaffectation
#' des effectifs quand des communes sont scindées. Par défaut, FALSE.
#' @param one_to_one Ne garder qu'une seule commmune en cas de scission.
#' Le code est celui de la commune initiale s'il est
#' présent dans l'une des communes issues de la scission, sinon il correspond à
#' celui de la commune fille qui est la plus peuplée.
#' Cette option permet d'éviter que des lignes soient dupliquées en cas de scission.
#' Par défaut, FALSE.
#'
#' @return Un objet du même type que `data`.
#'  * Pour une data frame, une data frame avec un nombre de lignes égal ou supérieur.
#'    Le nombre de ligne est toujours égal si `one_to_one = TRUE`.
#'  * Pour un vecteur, un vecteur de dimension égale ou supérieure.
#'
#' @examples
#' # Un exemple de data frame avec quelques communes
#' data <- data.frame(COM=c("14712", "16233", "16351", "53239", "53249", "53274"))
#'
#' # Change l'annee du code officiel geographique des communes
#' data |> change_cog(from = "COM", cog_from = 2019, cog_to = 2021)
#'
#' # Variante : ne retient qu'une commune après scission
#' data |> change_cog(from = "COM", cog_from = 2019, cog_to = 2021, one_to_one = TRUE)
#'
#' # Informations de la table de passage
#' data |>
#'   change_cog(from = "COM", to = "COM_21", cog_from = 2019, cog_to = 2021, infos = TRUE)
#'
#' # Clé de répartition pour les communes scindées
#' data |>
#'   change_cog(from = "COM", to = "COM_21", cog_from = 2019, cog_to = 2021, split_ratio = TRUE)
#'
#' # Pour un vecteur
#' x <- data$COM
#' change_cog(x, cog_from = 2019, cog_to = 2021)
#'
#' @encoding UTF-8
#' @export
#' @importFrom rlang .data := enquo
#' @importFrom dplyr %>% all_of left_join mutate select rename filter arrange desc distinct
change_cog <- function (data, cog_from, cog_to,
                        from = NULL, to = NULL,
                        infos = FALSE,
                        split_ratio = FALSE,
                        one_to_one = FALSE) {

  # Table de passage
  tp <- cog_transition(cog_from = cog_from, cog_to = cog_to)

  # Option one_to_one : une seule ligne en cas de scission
  if(one_to_one) {
    scissions <-  tp %>% filter(.data$NB_COM_FIN > 1)
    autres <-  tp %>% filter(.data$NB_COM_FIN <= 1)

    # Priorité : 1) même nom, 2) Plus grande population finale
    scissions <- scissions %>%
      arrange(.data$COM_INI, .data$COM_INI != .data$COM_FIN, desc(.data$POP_FIN)) %>%
      distinct("COM_INI", .keep_all = TRUE)

    tp <- bind_rows(scissions, autres)

  }


  if(is.data.frame(data)) {

    # tidy-select pour une data frame
    from <-  tidyselect::eval_select(
      expr = enquo(from),
      data = data[unique(names(data))],
      allow_rename = FALSE) %>%
      tidy_as_cols()
    if(is.null(from)) { from <-  colnames(data)[1] }
    if(is.null(to)) { to <-  from }

    # Ajout de colonnes complémentaires de la table de passage
    if(infos | split_ratio) {

      # Simplification de la table de passage
      if(!split_ratio) {
        tp <- tp %>% select(-"SPLIT_RATIO")
      }
      if(!infos) {
        tp <- tp %>% select(-"POP_INI", -"POP_FIN", -"NB_COM_INI", -"NB_COM_FIN")
      }

      # écrase les colonnes qui sont dans la table de passage
      data <- ecrase_cols(data, cols = colnames(tp), sauf = c(from))

      # Colonne de la commune initiale dans la table de passage
      col_temp <- unused_col(data)
      tp <- tp %>% rename("{from}" := "COM_INI", "{col_temp}" := "COM_FIN")

      # Fusion avec la table de passage
      data <- data %>% left_join(y = tp, by = from, relationship = "many-to-many")

      # Commune finale
      data <- data  %>% mutate(
        "{to}" := ifelse(is.na(.data[[col_temp]]), .data[[from]], .data[[col_temp]]),
        .after = any_of(from)
      )

      if(col_temp != to) {
        data <- data %>% select(-all_of(col_temp))
      }

      # Split ratio vaut 1 si non-renseigné
      if(split_ratio) {
        data <- data %>% mutate(SPLIT_RATIO = ifelse(is.na(.data$SPLIT_RATIO),
                                                     no = .data$SPLIT_RATIO,
                                                     yes = 1))
      }

      return(data)

    }
  }

  # Pour une data.frame avec infos = FALSE ou un vecteur
  codes_to_many(
    data = data,
    from = from,
    to = to,
    codes_ini = tp$COM_INI,
    codes_fin = tp$COM_FIN,
    extra = function(x) {return(x)}
  )

}

