test_that("Fonctions reg_to_dep() et dep_to_reg()", {

  # Utilitaires pour le développement :
  if(FALSE) {
    golem::detach_all_attached()
    rm(list = ls())
    devtools::document()
    devtools::load_all()
    ?reg_to_dep
    ?dep_to_reg
  }


  ##############################################################################
  # Départements -> Régions

  x <- c("13","2A","2B","INTRU","75","ZZZ","971")

  # Utilisation d'une fonction pour extra
  expect_equal(
    dep_to_reg(x, extra = function(x) {return(substr(x,1,1))}),
    c("93", "94", "94", "I", "11", "Z", "01")
  )

  # Valeur unique pour extra
  expect_equal(
    dep_to_reg(x, extra = "NA"),
    c("93", "94", "94", "NA", "11", "NA", "01")
  )

  # Clés valeurs pour extra
  expect_equal(
    dep_to_reg(x, extra = c("ZZZ" = "ZZ", "ZZZ" = "doublon !")),
    c("93", "94", "94", NA, "11", "ZZ", "01")
  )

  # Méthodes équivalentes
  d1 <- data.frame(DEP = x)
  d2 <- d1 %>% mutate(REG = dep_to_reg(DEP))
  d3 <- d1 %>% dep_to_reg()
  expect_true(all.equal(d2,d3))

  # dep_to_reg dans group_by
  expect_true(is.data.frame(
    d1 %>% group_by(REG = dep_to_reg(DEP)) %>%
      summarise(NB_DEP = n())
  ))

  ###############################################################################
  # Régions -> départements

  x <- c("94","93","ZZ","INTRU")

  # cles-valeurs pour extra
  expect_equal(
    x |> reg_to_dep(extra = c("ZZ"="ZZ1","ZZ" = "ZZ2")),
    c("2A","2B","04","05","06","13","83","84","ZZ1","ZZ2", NA)
  )

  # valeur pour extra
  expect_equal(
    x |> reg_to_dep(extra = "NA"),
    c("2A","2B","04","05","06","13","83","84","NA","NA")
  )

  # cles-valeurs pour extra, avec gestion des valeurs manquantes
  expect_equal(
    x |> reg_to_dep(extra = c("ZZ"="ZZ1","ZZ" = "ZZ2","NA" = "MANQUANT")),
    c("2A","2B","04","05","06","13","83","84","ZZ1","ZZ2", "MANQUANT")
  )

  # fonction pour extra
  expect_equal(
    x |> reg_to_dep(extra = function(x) {return(substr(x,1,1))}),
    c("2A","2B","04","05","06","13","83","84","Z","I")
  )

  data <- data.frame(REG = c("94","93","ZZ","INTRU"))
  d2 <- reg_to_dep(data, extra = NULL)
  expect_true(is.data.frame(d2))
  d3 <-left_join(data,  data_dep_reg, by = "REG" )
  expect_true(all.equal(d2, d3))


  d3 <- data.frame(DEP = c("2A","2B","04","05","06","13","83","84")) %>%
    dep_to_reg(to = "REG2") %>%
    reg_to_dep(from = "REG2", to = "DEP2") %>%
    dep_to_reg(from = "DEP2", to = "REG3") %>%
    reg_to_dep(from = "REG3", to = "DEP3")

  expect_true(all.equal(d3$REG2, d3$REG3))

  #######################################################
  # Passer d'une base régionale à une base départementale
  data <- data.frame(REG = "93")

  # dep_to_reg dans group_by
  expect_true(is.data.frame(

    if(packageVersion("dplyr") >= "1.1.2") {
      data %>%
        dplyr::reframe(
          REG = REG,
          DEP = reg_to_dep(REG)
        )
    } else {
      data %>% left_join(
        data_dep_reg,
        by = "REG"
      )
    }

  ))

})
