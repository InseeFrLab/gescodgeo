tidy_as_cols <- function(x, size = NULL, type = NULL) {
  if(!is.null(names(x))) {
    x <- names(x)
  }
  if(length(x)==0) {
    x <- NULL
  }
  x
}

#' Unused name of column
#'
#' @param data Data frame
#' @param col Name of column
#'
#' @examples
#' # Return COL1
#' data <- data.frame(COL = c(1:5))
#' unused_col(data)
#'
#' #' Return OTHER_COLNAME
#' unused_col(data, col = "OTHER_COLNAME")
#'
#' # Return COL5
#' data[unused_col(data)] <- data$COL
#' data[unused_col(data)] <- data$COL
#' data[unused_col(data)] <- data$COL
#' data[unused_col(data)] <- data$COL
#' unused_col(data)
#'
#' @noRd
unused_col <- function(data, col = "COL") {
  if(col %in% colnames(data)) {
    return (unused_col_i(data, prefix = col))
  }
  return(col)
}

#' @noRd
unused_col_i <- function(data, prefix = "COL", i = 1) {
  col <- paste0(prefix,i)
  if(col %in% colnames(data)) {
    return (unused_col_i(data, prefix, i = i+1))
  }
  return(col)
}

#' Interrompt si l'annee n'est pas valide (genere ERREUR)
#'
#' @param annee Annee demandee
#'
#' @noRd
controles_annees_dispo <- function(annee) {

  if(annee < gescodgeo::cog_min | annee > gescodgeo::cog_max) {

    stop("Annees disponibles (code officiel geographique) : ",
         gescodgeo::cog_min, " a ", gescodgeo::cog_max,
         "\nAnnee demandee : ", annee,
         call.=FALSE)

  }
}

#' Supprime les variables qui vont etre ecrasees (genere WARNING)
#'
#' @param data data frame
#' @param cols Colonnes ecrasees
#' @param sauf Colonnes conservee
#' @param contexte Contexte pour l'avertissement
#'
#' @noRd
ecrase_cols <- function(data,cols,sauf=NULL,contexte="") {

  cols_ecs = ""

  for (x in  cols) {
    if (x %in% setdiff(names(data),sauf)) {
      data[,x] <- NULL
      cols_ecs <- paste0(cols_ecs,x," ")
    }
  }

  if(cols_ecs != "") {
    warning(paste0("Variable(s) ecrasee(s) ",contexte," : ",cols_ecs),
            call. =FALSE,immediate.=FALSE)
  }

  return(data)
}

#' Controle que les colonnes sont numeriques (genere ERROR)
#'
#' @param data Base
#' @param cols Colonnes a contrôler
#'
#' @noRd
controle_cols_num  <- function(data,cols)  {
  for (x in cols) {
    if (!is.numeric(as.data.frame(data)[,x])) {
      stop("La colonne ",x," n'est pas numerique",call.=FALSE)
    }
  }
}

#' Controle que les colonnes existent (genere ERREUR)
#'
#' @param data Base
#' @param cols Colonnes a contrôler
#'
#' @noRd
controle_cols_exist  <- function(data, cols)  {
  for (x in cols) {
    if (x %in% names(data) == FALSE) {
      stop("La colonne ",x," n'existe pas",call.=FALSE)
    }
  }
}

#' Inverted versions of in, is.null and is.na
#'
#' @noRd
#'
#' @examples
#' 1 %not_in% 1:10
#' not_null(NULL)
`%not_in%` <- Negate(`%in%`)

#' #' Initialisation des colonnes demandees (genere WARNING)
#' #'
#' #' @param cols Colonne demandee
#' #' @param cols_dispo Colonne disponible
#' #' @param pre Premiere colonne, toujours demandee
#' #' @param tout Tout ajouter
#' #'
#' #' @noRd
#' controle_cols <- function(cols,cols_dispo,pre=NULL,tout="tout") {
#'
#'   if(!is.null(cols)) {
#'     if(length(cols) > 0 && cols[1]==tout) {
#'       # On prend toutes les colonnes
#'       cols <- cols_dispo
#'     } else {
#'       # Controle des colonnes dispo
#'       cols_manquantes <- setdiff(cols,cols_dispo)
#'
#'       if(length(cols_manquantes)>0) {
#'         text_cols_manquantes <- paste0(cols_manquantes," ")
#'         warning("Colonne(s) non disponible(s) : ",text_cols_manquantes,
#'                 call. =FALSE,immediate.=FALSE)
#'       }
#'
#'       cols <- intersect(cols,cols_dispo)
#'     }
#'   }
#'
#'   # On garde toujours la colonne DEP
#'   cols <- unique(c(pre,cols))
#'
#'   return(cols)
#' }
#'
#'
#' #' Controle que les variables sont numeriques (genere WARNING)
#' #'
#' #' @param data Base
#' #' @param cols Colonnes a contrôler
#' #'
#' #' @noRd
#' controle_format_num  <- function(data,cols)  {
#'   for (x in cols) {
#'     if (!is.numeric(as.data.frame(data)[,x])) {
#'       data[,x] <- as.numeric(as.character(data[,x]))
#'       warning("Variable ",x," convertie au format numerique",
#'               call. =FALSE,immediate.=FALSE)
#'     }
#'   }
#'   return(data)
#' }

