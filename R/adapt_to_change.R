#' Modifie une data frame pour prendre en compte les changements de geographie
#'
#' La fonction `adapt_to_change()` adapte une data frame
#' aux changements de geographie, pour prendre en compte les
#' zones qui ont fusionnees ou qui se sont scindees.
#' * Pour des fusions : reduit le nombre de lignes en supprimant les doublons, recalcule des effectifs et des moyennes, determine des categories majoritaires.
#' * Pour des scissions : repartit les effectifs d'un parent entre ses descendants.
#'
#' @param data Une data frame.
#' @param from [`<tidy-select>`][dplyr::dplyr_tidy_select] Colonne de la geographie initiale. Par defaut, `NULL` : les fusions ne sont pas traitees.
#' @param to [`<tidy-select>`][dplyr::dplyr_tidy_select] Colonne de la geographie finale. Par defaut, `NULL` : les scissions ne sont pas traitees.
#' @param sum_cols [`<tidy-select>`][dplyr::dplyr_tidy_select] Colonnes des sommes a recalculer. Par defaut, `NULL`.
#' @param mean_cols [`<tidy-select>`][dplyr::dplyr_tidy_select] Colonnes de moyennes a recalculer. Par defaut, `NULL`.
#' @param cat_cols [`<tidy-select>`][dplyr::dplyr_tidy_select] Colonnes des categories pour lesquelles on determine la modalite majoritaire. Par defaut, `NULL`.
#' @param weight_from [`<tidy-select>`][dplyr::dplyr_tidy_select] Colonne pour la ponderation les zones initiales, utilisee pour traiter les fusions.
#' Par defaut, `NULL` : les zones ont le meme poids.
#' @param weight_to  [`<tidy-select>`][dplyr::dplyr_tidy_select] Colonne pour la ponderation les zones finales, utilisee pour traiter les scissions.
#' Par defaut, `NULL` : les zones ont le meme poids.
#' @param id_cols [`<tidy-select>`][dplyr::dplyr_tidy_select] Colonnes identifiant de façon unique chaque observation.
#' Pris en compte pour reduire la base (option `reduce`) ou recalculer les variables.
#' Par defaut, `NULL`.
#' @param reduce Supprimer les lignes doublons en cas de fusion de zones.  Par defaut, `TRUE`.
#' @param infos Ajouter les  colonnes generees par la fonction pour les
#' calculs intermediaires. Par defaut, `FALSE`.
#'
#' @return Une data frame avec un nombre de lignes egal ou inferieur.
#'
#' @details
#' Effectifs ou sommes a recalculer (parametre `sum_cols`) : population,
#' nombre de logements, d'actifs...
#'   * En cas de scission, les descendants se partagent l'effectif
#'     de leur ascendant, selon leurs poids respectifs (colonne `weight_to`).
#'   * En cas de fusion, le descendant herite de la somme des
#'     effectifs de ses ascendants.
#'
#'  Moyennes ou ratios a recalculer (parametre `mean_cols`) : salaire moyen,
#'  nombre de personnes par logement...
#'    * En cas de scission, les descendants heritent de la moyenne
#'       de leur ascendant.
#'    * en cas de fusion, le descendant herite de la moyenne
#'       de ses ascendants, ponderee selon leurs poids respectifs (colonne `weight_from`).
#'
#' Categories a recalculer (parametre `cat_cols`) :
#'    * En cas de fusion, le descendant herite de la categorie
#'      majoritaire parmi ses ascendants, compte-tenu de leurs poids respectifs (colonne `weight_from`)
#'
#' Si `infos` vaut `TRUE`, les colonnes intermediaires suivantes,
#' generees par la fonction `adapt_to_change()`, sont conservees dans la data frame  :
#'  * `NB_INI` : Nombre d'observations initiales pour des fusions
#'  * `NB_FIN` : Nombre d'observation finales pour des scissions
#'  * `RATIO_INI` : Poids relatif d'une ligne parmi celles qui vont fusionner
#'  * `RATIo_FIN` : Poids relatif d'une ligne parmi celles qui resultent d'une scisson
#'
#'
#' @examples
#' ## Passer du departement a la region
#'
#' # Superficie, population et densite par departement en Corse
#' dep_corse <- data.frame(
#'   DEP = c("2A", "2B"),
#'   REG = c("94", "94"),
#'   POP = c(160814, 182887),
#'   SUP = c(4014.2	, 4665.6),
#'   DENS = c(40.1,39.2)
#' )
#'
#' # Recalcule les variables et fusionne les lignes
#' # La superficie (SUP) sert de ponderation pour la densite moyenne (DENS)
#' dep_corse |> adapt_to_change(
#'   from = DEP,
#'   to = REG,
#'   weight_from = SUP,
#'   sum_cols = c("POP","SUP"),
#'   mean_cols = DENS
#' )
#'
#' ## Changer la geographie des communes
#'
#' # Deplacements domicile-travail par commune en geographie 2023
#' data <- data.frame(
#'   COM23 = c("08053","08294", "60054"),
#'   IPONDI = c(855,57.1, 398),
#'   DIST = c(13.4, 22.3, 31.7),
#'   CO2_HEBDO = c(14478, 24279, 27536)
#' )
#'
#' # Changement de geographie de 2023 a 2024
#' data <- data |> change_cog(
#'   from = COM23,
#'   to = "COM24",
#'   cog_from = 2023,
#'   cog_to = 2024,
#'   infos = TRUE
#' )
#'
#' # Remarques :
#' # - les communes 08053 et 08294 fusionnent, la commune 60054 est scindee
#' # - L'argument infos = TRUE permet d'obtenir la population finale (POP_FIN),
#' #   qui servira de cle de repartition pour les communes scindees
#'
#' # Recalcule les variables numeriques et fusionne les lignes
#' data |> adapt_to_change(
#'   from = COM23,
#'   to = COM24,
#'   sum_cols = c(IPONDI, CO2_HEBDO),
#'   mean_cols = DIST,
#'
#'   #' Pondere les moyennes (mean_cols) pour les communes fusionees
#'   weight_from = IPONDI,
#'
#'   #' Repartit les effectifs (sum_cols) pour les communes scindees
#'   weight_to = POP_FIN
#' )
#'
#' ## Changer la geographie de communes avec une variable identifiante
#'
#' ## Commune 60054 par mode de trasnport (MODTRANS)
#' data <- data.frame(
#'   COM23 = c("60054","60054"),
#'   MODTRANS = c("5", "6"),
#'   IPONDI = c(374, 19.6),
#'   DIST = c(29.3, 69.1),
#'   CO2_HEBDO = c(28999, 2491)
#' )
#'
#' # Changement de geographie de 2023 a 2024
#' data <- data |> change_cog(
#'   from = COM23,
#'   to = "COM24",
#'   cog_from = 2023,
#'   cog_to = 2024,
#'   infos = TRUE
#' )
#'
#' # Recalcule les variables numeriques et fusionne les lignes
#' data |> adapt_to_change(
#'   from = COM23,
#'   to = COM24,
#'   sum_cols = c(IPONDI, CO2_HEBDO),
#'   mean_cols = DIST,
#'
#'   #' Colonne(s) identifiante(s)
#'   id_cols = MODTRANS,
#'
#'   #' Pondere les moyennes (mean_cols) pour les communes fusionees
#'   weight_from = IPONDI,
#'
#'   #' Repartit les effectifs (sum_cols) pour les communes scindees
#'   weight_to = POP_FIN
#' )
#' @encoding UTF-8
#' @importFrom rlang .data enquo
#' @importFrom dplyr %>% across anti_join all_of arrange bind_rows everything desc distinct filter left_join group_by mutate select summarise ungroup
#' @export
adapt_to_change <- function(data,
                            from = NULL,
                            to = NULL,
                            sum_cols = NULL,
                            mean_cols = NULL,
                            cat_cols = NULL,
                            weight_from = NULL,
                            weight_to = NULL,
                            id_cols = NULL,
                            reduce = TRUE,
                            infos = FALSE) {

  ### tidy-select pour une data frame
  from <-  tidyselect::eval_select(
    expr = rlang::enquo(from),
    data = data[unique(names(data))],
    allow_rename = FALSE) %>%
    tidy_as_cols()

  to <-  tidyselect::eval_select(
    expr = rlang::enquo(to),
    data = data[unique(names(data))],
    allow_rename = FALSE) %>%
    tidy_as_cols()

  weight_from <-  tidyselect::eval_select(
    expr = rlang::enquo(weight_from),
    data = data[unique(names(data))],
    allow_rename = FALSE) %>%
    tidy_as_cols()

  weight_to <-  tidyselect::eval_select(
    expr = rlang::enquo(weight_to),
    data = data[unique(names(data))],
    allow_rename = FALSE) %>%
    tidy_as_cols()

  id_cols <-  tidyselect::eval_select(
    expr = rlang::enquo(id_cols),
    data = data[unique(names(data))],
    allow_rename = FALSE) %>%
    tidy_as_cols()

  mean_cols <- tidyselect::eval_select(
    expr = rlang::enquo(mean_cols),
    data = data[unique(names(data))],
    allow_rename = FALSE) %>%
    tidy_as_cols()

  cat_cols <- tidyselect::eval_select(
    expr = rlang::enquo(cat_cols),
    data = data[unique(names(data))],
    allow_rename = FALSE) %>%
    tidy_as_cols()

  sum_cols <- tidyselect::eval_select(
    expr = rlang::enquo(sum_cols),
    data = data[unique(names(data))],
    allow_rename = FALSE, strict = TRUE) %>%
    tidy_as_cols()

  ### Initialisation des colonnes

  # Colonnes a recuperer en fin de programme
  cols_data <- colnames(data)

  # Existence et format des variables a recalculer
  # controle_cols_exist(data, cols = c(sum_cols, mean_cols, cat_cols))
  controle_cols_num(data, cols = c(sum_cols, mean_cols))

  # Ecrase les colonnes intermediaires generees dans la fonction
  data <- ecrase_cols(data, cols = c("NB_INI", "NB_FIN", "RATIO_INI", "RATIO_FIN"))

  # Infos par defaut
  if(infos) {
    data <- data %>% mutate(NB_INI = 1, NB_FIN = 1, RATIO_INI = 1, RATIO_FIN = 1)
  }

  ### One to many : from, weight_to -> sum_cols

  if(!is.null(from)) {

    # controle_cols_exist(data = data, cols = from)

    if(is.null(weight_to)) {
      weight_to <- unused_col(data, col = "WEIGHT_FIN")
      data <- data %>% mutate("{weight_to}" := 1)
    } else {
      controle_cols_exist(data = data, cols = weight_to)
    }

    # Scissions (si data variable weight_to renseignee) :
    scissions <- data %>%
      filter(is.na(.data[[weight_to]]) == FALSE) %>%
      group_by(across(all_of(c(from, id_cols)))) %>%
      mutate(NB_FIN = n(), RATIO_FIN = .data[[weight_to]] / sum(.data[[weight_to]])) %>%
      ungroup() %>%
      mutate(across(all_of(sum_cols), ~ .x * .data$RATIO_FIN))

    # Reunion des bases
    data <- bind_rows(scissions, data %>% filter(is.na(.data[[weight_to]])==TRUE))
  }

  ### Many to on : to, weight_from, reduce -> sum_cols, mean_cols, cat_cols & agregation

  if(!is.null(to)) {

    controle_cols_exist(data = data, cols = to)

    # Fusion only if weigh_ini not NA
    if(is.null(weight_from)) {
      weight_from <- unused_col(data, col = "WEIGHT_INI")
      fusions <- data %>% mutate("{weight_from}" := 1)
    } else {
      controle_cols_exist(data = data, cols = weight_from)
      fusions <- data %>% filter(is.na(.data[[weight_from]]) == FALSE)
    }

    # Fusion only if NB_INI > 1
    fusions <- fusions %>%
      group_by(across(all_of(c(to, id_cols)))) %>%
      mutate(NB_INI = n()) %>%
      filter(.data$NB_INI > 1) %>%
      mutate(RATIO_INI = .data[[weight_from]] / sum(.data[[weight_from]]))

    # Handle cat_cols
    if(!is.null(cat_cols)) {

      # Categorie majoritaire selon POND_INI pour chaque noeud meres-fille
      for(cat_x in cat_cols) {
        ref <- fusions %>%
          group_by(across(all_of(c(to, id_cols, cat_x)))) %>%
          summarise(POND_INI = sum(.data[[weight_from]]), .groups="drop") %>%
          arrange(desc(.data$POND_INI))

        fusions <- fusions %>%
          select(-all_of(cat_x)) %>%
          left_join(
            y = ref  %>%
              select(all_of(c(to,id_cols,cat_x))) %>%
              distinct(across(all_of(c(to,id_cols))), .keep_all=TRUE),
            by=c(to,id_cols),
            relationship = "many-to-one")
      }
    }

    # Handle sum_cols, mean_cols and ungroup fusion
    fusions <- fusions %>%

      # simple sum
      mutate(across(all_of(sum_cols), ~ sum(.x))) %>%

      # mean weighted by RATIO_INI
      mutate(across(all_of(mean_cols), ~ sum(.x * .data$RATIO_INI))) %>%
      ungroup()

    # No dupkey
    if(reduce  == TRUE) {
      fusions  <- fusions %>% distinct(across(all_of(c(to,id_cols))), .keep_all = TRUE)
    }

    # Rebuild data
    data <- bind_rows(
      fusions,
      data %>% anti_join(fusions,by=c(to,id_cols)),
    )

  }

  # Ordre des colonnes
  if(infos) {
    data <- data %>% select(all_of(c(cols_data, "NB_INI", "NB_FIN", "RATIO_INI", "RATIO_FIN")))
  } else {
    data <- data %>% select(all_of(cols_data))
  }

  return(data)

}

