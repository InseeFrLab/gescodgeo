test_that("Vérofier le COG", {

  # Utilitaires pour le développement :
  if(FALSE) {
    golem::detach_all_attached()
    rm(list = ls())
    devtools::document()
    devtools::load_all()
    ?check_cog
  }

  # Pour un veteur
  expect_true(check_cog(c("31001","32002"), cog = 2018))
  expect_warning(check_cog(1, cog = 2018))
  expect_error(check_cog(list(a = "1", b = "c"), cog = 2018))
  expect_s3_class(
    object = check_cog(c("31001","32002"), cog = 2018, data_res = TRUE),
    class = "data.frame")

  data <- data_com(2018)
  # Booléen
  expect_true(check_cog(data = data,cog = 2018))

  # Messages d'erreurs
  expect_warning(
    object = check_cog(data = data,cog = 2019),
    regexp = "Les communes suivantes ne sont pas dans le COG de l'annee 2019"
  )

  # Verifier aussi les communes manquantes
  expect_warning(
    object = check_cog(data = head(data),cog = 2018,complete = TRUE),
    regexp = "Les communes suivantes du COG de l'annee 2018 ne sont pas dans la base"
  )

  # Afficher les communes commençant par des lettres en dernier
  data2 <- data.frame(DEPCOM = c(paste0("AL",c("1001":"1900")),"01059"))
  expect_warning(
    object = check_cog(data = data2, cog = 2019),
    regexp = "01059"
  )

  # Renvoyer les resultats dans une base
  data_errors <- check_cog(data = data,
                           cog = 2009,
                           complete= TRUE,
                           data_res = TRUE,
                           message = FALSE)
  expect_equal(nrow(data_errors), 1373)


  # Ajout des arrondissement municipaux
  data <- com_to_arm(data)

  # Par défaut, ignore les arrondissements
  expect_true(check_cog(data = data, cog = 2018))

  # Ne pas ignorer les arrondissements municipaux
  expect_warning(
    object = check_cog(data = data, cog = 2018, ignore_arm = FALSE),
    regexp = "13201 13202 13203 13204 13205 13206 13207 13208 13209"
  )

  # Renvoyer les resultats dans une base
  data_errors <- check_cog(data = data,
                             cog = 2018,
                             ignore_arm = FALSE,
                             complete=TRUE,
                             data_res = TRUE,
                             message = FALSE)
})
