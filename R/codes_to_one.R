#' Merge geographic codes
#'
#' Convert geographic codes while preserving the number of rows in a data frame
#' or the dimension of a vector. Merging is handled, but not splitting.
#'
#' @param data Data frame or vector
#' @param from Initial column (in a data frame)
#' @param to Final column (in a data frame)
#' @param codes_ini Initial geographic codes
#' @param codes_fin Final geographic codes
#' @param extra Other geographic codes
#' @param ... Arguments passed to or from other methods.
#'
#' @return a data frame with the same number of rows or a vector of equal dimension
#'
#' @examples
#' x <- c("B","C1","C2","A","Z")
#' codes_1 <- c("A","A","B","C1","C2")
#' codes_2 <-  c("a1","a2","b","c","c")
#'
#' # Data frame
#' dt <- data.frame(X = x)
#' codes_to_one(dt, from = "X", to = "Y", codes_ini = codes_1, codes_fin = codes_2)
#'
#' # Vector
#' codes_to_one(x, codes_ini = codes_1, codes_fin = codes_2)
#'
#' @encoding UTF-8
#' @export
codes_to_one <- function(data,
                         codes_ini,
                         codes_fin,
                         extra = NULL,
                         from = NULL,
                         to = NULL,
                         ...) {

  UseMethod("codes_to_one")

}

#' @export
#' @importFrom dplyr %>% all_of relocate
codes_to_one.data.frame <- function(data,
                                    codes_ini,
                                    codes_fin,
                                    extra = NULL,
                                    from = NULL,
                                    to = NULL,
                                    ...) {

  if(is.null(from)) { from <-  colnames(data)[1] }
  if(is.null(to)) { to <-  from }

  data[[to]] <- data[[from]] %>% codes_to_one(
      codes_ini = codes_ini,
      codes_fin = codes_fin,
      extra = extra
    )

  data <- data %>% relocate(all_of(to), .after = all_of(from))
  return(data)
}

## To do : create methods for factor or numeric

#' @export
codes_to_one.default <- function(data,
                                 codes_ini,
                                 codes_fin,
                                 extra = NULL,
                                 from = NULL,
                                 to = NULL,
                                 ...) {

  ### Object character
  x <- data

  # Correspondances entre les codes ini et les codes fin
  corresp <-  codes_fin
  names(corresp) <- codes_ini
  y <- corresp[x]

  # extra est une fonction
  if(is.function(extra)) {
    y[is.na(y)] <- extra(x[is.na(y)])
  }

  # extra est un vectgeur nomme
  else if(!is.null(names(extra))) {
    y[is.na(y)] <- extra[x[is.na(y)]]

    if("NA" %in% names(extra)) {
      y[is.na(y)] <- extra["NA"]
    }
  }

  # Valeur par defaut pour les manquants
  else if(!is.null(extra)) {
    y[is.na(y)] <- extra
  }

  # Retablit les noms de x
  names(y) <- names(x)

  return(y)
}

