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
#' # Region codes changing in 2016
#' new_reg <- c("27", "27", "28", "28", "32", "32", "44", "44", "44", "75", "75",
#'              "75", "76", "76", "84", "84")
#' old_reg <- c("26", "43", "25", "23", "22", "31", "21", "41", "42", "54", "74",
#'              "72", "73", "91", "82", "83")
#'
#' # A data frame with some old regions
#' data <- data.frame(REG = c("11", "26", "43", "82", "83"))
#'
#' # Convert into new regions
#' data |> codes_to_one(
#'    codes_ini = old_reg,
#'    codes_fin = new_reg,
#'    from = "REG",
#'    to = "NEW_REG",
#'    extra = function(x){x}
#' )
#'
#' # With a vector
#' codes_to_one(
#'   data = c("11", "26", "43", "82", "83"),
#'   codes_ini = old_reg,
#'   codes_fin = new_reg,
#'   extra = function(x){x}
#' )
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

  # extra est un vectgeur nommé
  else if(!is.null(names(extra))) {
    y[is.na(y)] <- extra[x[is.na(y)]]

    if("NA" %in% names(extra)) {
      y[is.na(y)] <- extra["NA"]
    }
  }

  # Valeur par défaut pour les manquants
  else if(!is.null(extra)) {
    y[is.na(y)] <- extra
  }

  # Rétablit les noms de x
  names(y) <- names(x)

  return(y)
}

