#' Merge or split geographic codes
#'
#' Convert geographic codes by managing splits and merges.
#' The number of rows in a data frame or the dimension of a vector are not preserved.
#'
#' @param data Data frame or vector
#' @param from Initial column (in a data frame)
#' @param to Final column (in a data frame)
#' @param codes_ini Initial geographic codes
#' @param codes_fin Final geographic codes
#' @param extra Other geographic codes
#' @param ... Arguments passed to or from other methods.
#'
#' @return A data frame with an equal or greater number of rows
#' or a vector with an equal or greater dimension.
#'
#' @examples
#' x <- c("B","C1","C2","A","Z")
#' codes_1 <- c("A","A","B","C1","C2")
#' codes_2 <-  c("a1","a2","b","c","c")
#'
#' # Data frame
#' dt <- data.frame(X = x)
#' codes_to_many(dt, from = "X", to = "Y", codes_ini = codes_1, codes_fin = codes_2)
#'
#' # Vector
#' codes_to_many(x, codes_ini = codes_1, codes_fin = codes_2)
#'
#' @encoding UTF-8
#' @export
codes_to_many <- function(data,
                          codes_ini,
                          codes_fin,
                          extra = NULL,
                          from = NULL,
                          to = NULL,
                          ...) {

  UseMethod("codes_to_many")

}

#' @export
#' @importFrom rlang .data := set_names
#' @importFrom dplyr %>% all_of any_of left_join mutate select
codes_to_many.data.frame <- function(data,
                                     codes_ini,
                                     codes_fin,
                                     extra = NULL,
                                     from = NULL,
                                     to = NULL,
                                     ...) {
  ### Data frame

  # codes_ini et codes fin
  if(is.atomic(extra) & !is.null(names(extra))) {
    codes_ini <-  c(codes_ini, names(extra))
    codes_fin <- c(codes_fin, unname(extra))

    # Si "NA" est renseigne on l'utilisera pour les valeurs manquantes
    if("NA" %in% names(extra)) {
      extra <- unname(extra["NA"])
    }
  }

  # Table de passage
  tp <- data.frame(GESCODGEO_COL_INI = codes_ini, GESCODGEO_COL_FIN = codes_fin)
  col_temp <- unused_col(data)
  colnames(tp) <- c(from, col_temp)

  # Fusion
  data <- data %>% left_join(tp, by = from, relationship = "many-to-many")

  # extra est une fonction
  if(is.function(extra)) {
    data <- data %>%
      mutate("{col_temp}" := ifelse(test = is.na(.data[[col_temp]]),
                                        yes = extra(.data[[from]]),
                                        no  = .data[[col_temp]])
      )
  }
  else if(!is.null(extra) & is.null(names(extra))) {
    data <- data %>%
      mutate("{col_temp}" := ifelse(test = is.na(.data[[col_temp]]),
                                        yes = extra,
                                        no  = .data[[col_temp]])
      )
  }

  # Colonne finale
  data <- data %>% mutate("{to}" := .data[[col_temp]], .after = any_of(from))

  if(col_temp != to) {
    data <- data %>% select(-all_of(col_temp))
  }

  return(data)

}


## To do : create methods for factor or numeric

#' @export
codes_to_many.default <- function(data,
                                  codes_ini,
                                  codes_fin,
                                  extra = NULL,
                                  from = NULL,
                                  to = NULL,
                                  ...) {

  ### Object character
  x <- data

  y <- c()
  for(i in x) {
    if(i %in% codes_ini) {
      j <- codes_fin[codes_ini == i]
    }
    # extra est une fonction
    else if(is.function(extra)) {
      j <- extra(i)
    }
    # extra est un vecteur nomme
    else if(!is.null(names(extra))) {
      if(i %in% names(extra)) {
        j <- extra[names(extra) == i]
        names(j) <- NULL
      }
      else if('NA' %in% names(extra)) {
        j <- extra["NA"]
        names(j) <- NULL
      } else {
        j <- NA
      }
    }
    # Valeur par defaut pour les valeurs manquantes
    else if(!is.null(extra)) {
      j <- extra
    }
    # Pas de correspondance
    else {
      j <- NA
    }
    y <- c(y, j)
  }
  return(y)
}

