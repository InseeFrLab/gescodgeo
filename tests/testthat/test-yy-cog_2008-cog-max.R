test_that("Tests bases communales", {

  do_test_simple <- FALSE

  # Si on fait les tests croisés, il est recommandé d'imprimer les tests pour passer le temps
  do_test_croise <- FALSE
  print_test <- TRUE

  # dir_bc <- paste0(system.file(package="gescodgeo"),"/data-raw/bases_communales/")
  dir_bc <- "U:/workspace/gescodgeo/data-raw/bases_communales/"

  if(FALSE) {
    golem::detach_all_attached()
    rm(list=ls())
    devtools::load_all()
    library(dplyr)
  }

  print(cog_max)

  # Dernière base communale
  bc_max <- gescodgeo::cog_max-1

  # reconsitution de toutes les tables avec ou sans mayotte
  if(do_test_simple) {


    for(cog in c(gescodgeo::cog_min:bc_max)) {

      new_dt <-  data_com(cog) %>% arrange(COM)
      verif <- readRDS(paste0(dir_bc,"data_com_",cog,".rds")) %>% arrange(COM)

      errors <- dplyr::setdiff(new_dt,verif) %>% nrow() + dplyr::setdiff(verif,new_dt) %>% nrow()

      if(print_test) { print(paste0(cog," : ",errors," erreur(s)")) }
      expect_equal(errors,0)

      if(nrow(new_dt) != nrow(verif)) {
        print(paste0(nrow(new_dt)," lignes (gescodgeo) vs ",nrow(verif)," lignes (base communale)"))
      }

    }
  }

  # Vérification croisée (sans Mayotte)
  if(do_test_croise) {
    data_der <- data_com(cog=gescodgeo::cog_max)

    for(cog_from in c(gescodgeo::cog_min:gescodgeo::cog_max)) {

      dt_from <-  change_cog(data=data_der,
                             cog_from=gescodgeo::cog_max,
                             cog_to = cog_from) %>%
        distinct(COM) %>%
        arrange(COM) %>%
        filter_mayotte(cog = cog)

      for(cog_to in c(gescodgeo::cog_min:bc_max)) {

        dt_new <-  change_cog(data=dt_from,
                              cog_from=cog_from,
                              cog_to=cog_to) %>%
          distinct(COM) %>%
          arrange(COM) %>%
          filter_mayotte()

        verif <- readRDS(paste0(dir_bc,"data_com_",cog_to,".rds")) %>%
          arrange(COM) %>%
          filter_mayotte()

        errors <- dplyr::setdiff(dt_new, verif) %>% nrow() + dplyr::setdiff(verif,dt_new) %>% nrow()

        if(print_test) { print(paste0(cog_from," to ",cog_to," : ", errors," erreur(s)")) }
        expect_equal(errors,0)

        if(nrow(dt_new) != nrow(verif)) {
          print(paste0(nrow(dt_new)," lignes (gescodgeo) vs ",nrow(verif)," lignes (base communale)"))
        }
      }

    }
  }
})
