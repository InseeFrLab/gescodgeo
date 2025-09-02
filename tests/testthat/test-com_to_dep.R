test_that("Fonctions com_to_dep()", {

  # Utilitaires pour le développement :
  if(FALSE) {
    golem::detach_all_attached()
    rm(list = ls())
    devtools::document()
    devtools::load_all()
    ?com_to_dep
  }

  # devtools::run_examples(start = "com_to_dep")
  # examples(topic = com_to_dep, package = "gescodgeo")

  x <-  c("84001", "75001", "75001", "97401", "98601",
          "ZZZZZ", "YYYYY", "99999", "A1001", NA)

  # Codes spéciaux comme dans le recensement de la population
  y <- com_to_dep(x)
  expect_equal(y, c("84", "75", "75", "974", "986", "ZZZ", "999", "999", "999", "999"))

  # Pas de codes extra
  z <- com_to_dep(x, extra = NULL)
  expect_equal(z, c("84", "75", "75", "974", NA, NA, NA, NA, NA, NA))

  data <- data.frame(ID = c(1:length(x)), CODE_COM = x)
  data2 <- com_to_dep(data, from = "CODE_COM", to = "CODE_DEP")

  expect_true(is.data.frame(data2))
  expect_equal(data2$CODE_DEP, y)

  # Base complète sans Mayotte
  data_com_2010 <- data_com(2010)
  codes_dep_1 <- data_com_2010$COM %>% com_to_dep() %>% unique()
  codes_dep_2 <- c("01","02","03","04","05","06","07","08","09","10":"19","2A","2B","21":"95","971":"974")
  expect_equal(sort(codes_dep_1), sort(codes_dep_2))

  # Base complète avec Mayotte
  data_com_2013 <- data_com(2013)
  codes_dep_3 <- data_com_2013$COM %>% com_to_dep() %>% unique()
  codes_dep_4 <- c(codes_dep_2, "976")
  expect_equal(sort(codes_dep_3), sort(codes_dep_4))

})
