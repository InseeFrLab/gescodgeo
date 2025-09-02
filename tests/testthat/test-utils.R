test_that("Utilitaires", {


  # Utilitaires pour le développement
  if(FALSE) {
    golem::detach_all_attached()
    rm(list = ls())
    devtools::document()
    devtools::load_all()
  }

  # Unused col

  data <- data.frame(COL = 0, COL0= 1, COL1= 1, COL2= 1, COL3= 1)
  expect_false(gescodgeo:::unused_col(data) %in% colnames(data))

  # Création de la colonne COL4
  col_temp <- gescodgeo:::unused_col(data)
  data <- data |> dplyr::mutate("{col_temp}" := 9)
  expect_true(data$COL4 == 9)

  # Création de la colonne NEW_COL
  col_temp <- gescodgeo:::unused_col(data, col = "NEW_COL")
  data <- data |> dplyr::mutate("{col_temp}" := 10)
  expect_true(data$NEW_COL == 10)

  # Création de la colonne NEW_COL1
  col_temp <- gescodgeo:::unused_col(data, col = "NEW_COL")
  data <- data |> dplyr::mutate("{col_temp}" := 11)
  expect_true(data$NEW_COL1 == 11)

})
