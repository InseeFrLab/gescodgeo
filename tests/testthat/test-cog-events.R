test_that("cog_events", {

  # Utilitaires pour le développement :
  if(FALSE) {
    golem::detach_all_attached()
    rm(list = ls())
    devtools::document()
    devtools::load_all()
    ?check_cog
  }

  data <- cog_events("14472")
  expect_true(nrow(data)>1)

  # Exemple d'une commune avec un changement de code et une fusion
  data <- cog_events("14472")
  expect_true(nrow(data)>1)

  # Exemple d'une commune avec une fusion et un retablissement (scission)
  data <- cog_events("14712")
  expect_true(nrow(data)>1)

  # Exemple d'une commune sans evenements dans le COG
  expect_warning(data <- cog_events("13001"))
  expect_true(nrow(data)==0)

  # Exemple d'un code n'aparaissant pas dans le COG
  expect_warning(data <- cog_events("13999"))
  expect_true(nrow(data)==0)


  if(FALSE) {
    # Liste des scissions
    scissions  <- data.frame(COG_INI = c(), COG_FIN = c())
    for(i in c(gescodgeo::cog_min:(gescodgeo::cog_max-1))) {

      j <- i + 1
      table_passage <- cog_transition(i, j) %>%
        filter(NB_COM_INI < NB_COM_FIN) %>%
        mutate(COG_INI = {i}, COG_FIN = {j})

      scissions <- bind_rows(scissions, table_passage) %>%
        select(COG_INI, COG_FIN, COM_INI, COM_FIN, POP_INI, POP_FIN, NB_COM_INI, NB_COM_FIN)

    }

    # Communes renommées
    communes_renommees  <- data.frame(COG_INI = c(), COG_FIN = c())
    for(i in c(gescodgeo::cog_min:(gescodgeo::cog_max-1))) {

      j <- i + 1
      table_passage <- cog_transition(i, j) %>%
        filter(NB_COM_INI == NB_COM_FIN) %>%
        mutate(COG_INI = {i}, COG_FIN = {j})

      communes_renommees <- bind_rows(communes_renommees, table_passage) %>%
        select(COG_INI, COG_FIN, COM_INI, COM_FIN, POP_INI, POP_FIN, NB_COM_INI, NB_COM_FIN)

    }
  }

})
