test_that("Fonction change_cog()", {

  # Utilitaires pour le développement :
  if(FALSE) {
    golem::detach_all_attached()
    rm(list = ls())
    devtools::document()
    devtools::load_all()
    ?change_cog
  }

  # Communes en 2019 :
  dt_2019 <- data.frame(COM=c("13001","14712","16233","16351","53239","53249","53274"))

  # change_cog(dt_2019, cog_from =2019, cog_to=2021, infos = TRUE)

  # Communes en 2021 :
  dt_2021 <- change_cog(dt_2019, cog_from =2019, cog_to = 2021, infos = FALSE)

  # Transforme une data frame en une data frame
  expect_s3_class(dt_2021,"data.frame")

  # Une ligne supplémentaire :
  expect_equal(nrow(dt_2021),8)

  # Pas de nouvelles colonnes
  expect_equal(ncol(dt_2021),1)

  # Informations sur la table de passage
  dt_2021 <- change_cog(dt_2019 , to = "COM_2022", cog_from=2019, cog_to=2021, infos = TRUE)

  # On veut connaître les noeuds :
  dt_2021 <- dt_2021 %>% mutate(NODE = paste0(NB_COM_INI," => ",NB_COM_FIN))

  # Ajout des colonnes de la table de passage
  expect_equal(colnames(dt_2021),c("COM", "COM_2022",
                                   "POP_INI","POP_FIN",
                                   "NB_COM_INI","NB_COM_FIN",
                                   "NODE"))

  # Commune en seconde position
  dt_2019_2 <- data.frame(DEP=substr(dt_2019$COM,1,2),COMMUNE=dt_2019$COM)
  dt_2021_2 <- change_cog(dt_2019_2,cog_from=2019,cog_to=2021, from="COMMUNE")
  expect_equal(nrow(dt_2021_2),8)

  # Eviter un conflit si from = "COM_FIN"
  dt_2019 |> dplyr::rename(COM_FIN = COM) |>
    change_cog(cog_from =2019, cog_to=2020) |>
    colnames() |>
    expect_equal(c("COM_FIN"))

  # Si from = "COM_INI"
  dt_2019 |> dplyr::rename(COM_INI = COM) |>
    change_cog(cog_from =2019, cog_to=2021, to = "COM_FIN2") |>
    colnames() |>
    expect_equal(c("COM_INI", "COM_FIN2"))

  # Code commune absent
  expect_error(
    object = change_cog(dt_2019_2,cog_from=2019,cog_to=2021, from = "UN_AUTRE_NOM"),
    regexp = "Column `UN_AUTRE_NOM` doesn't exist"
  )

  # Variables écrasées :
  expect_warning(
    object = change_cog(dt_2021,cog_from = 2021,cog_to = 2019, infos = TRUE),
    regexp = "ecrasee"
  )

  # Années hors-champ :
  expect_error(
    object = change_cog(dt_2021,cog_from=2021,cog_to=2032, infos = TRUE),
    info = "code officiel geographique"
  )

  # Split ratio
  dt_2021 <- change_cog(dt_2019 , to = "COM_2022", cog_from=2019, cog_to=2021, split_ratio = TRUE)

  # Nombre de communes "pondérées" constantes
  expect_equal(nrow(dt_2019),  sum(dt_2021$SPLIT_RATIO))

  ###############################################################################
  # Cas spéciaux

  new_col <- unused_col(dt_2019)
  dt_2019 |> change_cog(cog_from =2019, cog_to=2021, to = new_col)

  ##############################################################################
  # Pour un vecteur

  expect_type(
    object = change_cog(dt_2019$COM, cog_from =2019, cog_to=2021, infos = FALSE),
    type = "character"
  )

})
