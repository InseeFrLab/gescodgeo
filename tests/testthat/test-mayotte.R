test_that("Mayotte", {

  # Utilitaires pour le développement :
  if(FALSE) {
    golem::detach_all_attached()
    rm(list = ls())
    devtools::document()
    devtools::load_all()
    ?filter_mayotte
  }

  # 2 observations, 1 colonne
  x <- data.frame(COM=c("97424","97601"))

  y <- filter_mayotte(data = x)

  expect_equal(nrow(y),1)

  y <- filter_mayotte(data = x, cog = 2008)
  expect_equal(nrow(y),1)

  y <- filter_mayotte(data = x, cog = 2018)
  expect_equal(nrow(y),2)

  y <- filter_mayotte(data = x, cog  =Inf)
  expect_equal(nrow(y),2)

  # 2 observations, 2 colonnes, commune en second
  x <- data.frame(DEP=c("974","976"),COMMUNE=c("97424","97601"))
  y <- filter_mayotte(data = x, from = "COMMUNE")
  expect_equal(nrow(y),1)

  # 2008
  data <- data_com(2008)
  expect_false("97601" %in% data$COM)

  data <- change_cog(data = data,cog_from = 2008, cog_to = 2020)

  expect_warning(
    object = check_cog(data, 2020, complete = TRUE, ignore_mayotte = FALSE),
    regexp = "97601 97602 97603 97604 97605 97606 97607 97608 97609 97610")

  expect_true(check_cog(data, 2020, complete = TRUE, ignore_mayotte = TRUE))

  # 2008 à 2020 : il manque Mayotte
  data <- data_com(2008)
  data <- change_cog(data = data,cog_from = 2008,cog_to = 2020)
  expect_warning(check_cog(data, 2020, complete = TRUE, ignore_mayotte = FALSE))

  # 2020
  data <- data_com(2020)
  expect_true(check_cog(data, 2020, complete = TRUE, ignore_mayotte = FALSE))

  # 2020 : Ne pas charger Mayotte
  data <- data_com(2020) %>% filter_mayotte(2008)
  expect_false(check_cog(data,
                         cog = 2020,
                         complete = TRUE,
                         ignore_mayotte = FALSE,
                         message = FALSE))

  # Pour un vecteur
  x <- c("97424","97601")
  expect_true(filter_mayotte(x) == "97424")
  expect_true(all.equal(filter_mayotte(x, cog = 2020),x))


})
