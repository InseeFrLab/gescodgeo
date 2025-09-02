test_that("Fonctions com_to_arm() et arm_to_com()", {


  # Utilitaires pour le développement :
  if(FALSE) {
    golem::detach_all_attached()
    rm(list = ls())
    devtools::document()
    devtools::load_all()
    ?arm_to_com
    ?com_to_arm
  }



  ###############################################################################
  # Arrondissements -> Communes

  x <- c("13201","13202","13001","84123","75101","75102")
  y <- c("13055","13055","13001","84123","75056","75056")

  # Vecteur
  expect_equal(arm_to_com(x),y)

  # Data frame
  expect_equal(arm_to_com(data.frame(COM = x))$COM,y)

  # Data frame, gestion des colonnes
  data <- data.frame(ID = c(1:length(x)), ARM = x)

  expect_equal(arm_to_com(data, from = "ARM" )$ARM,y)
  expect_equal(arm_to_com(data, from = "ARM", to = "COM" )$COM,y)

  ###############################################################################
  # Communes -> arrondissements

  x <- c("13055","13001","84123","75056")
  expect_equal(
    x,
    x |> com_to_arm() %>% arm_to_com() %>% unique()
  )

  # Data frame
  data <- data.frame(COM = x)
  d1 <- data %>% com_to_arm()
  expect_true(is.data.frame(d1))

  # Codes extra non renseignés
  d2 <- data %>% com_to_arm(extra = NULL)
  expect_true(
    all.equal(
      dplyr::setdiff(d1,d2) %>% with(COM),
      c("13001","84123")
    )
  )

  # Code par défaut hors Paris Lyon et Marseille
  d3 <-  data %>% com_to_arm(extra = "Ni Paris, ni Lyon, ni Marseille")
  d4 <-  data %>% com_to_arm(
    extra = c("INTRU" = "???", "NA" = "Ni Paris, ni Lyon, ni Marseille")
  )
  expect_true(all.equal(d3, d4))

  #######################################################################
  # Passer d'une base communale à une base par arrondissements avec dplyr
  data <- data.frame(COM = "13055")
  expect_true(
    is.data.frame(
      if(packageVersion("dplyr") >= "1.1.2") {
        data %>%
          dplyr::reframe(
            COM = com_to_arm(COM)
          )
      } else {
        data %>% left_join(
          data_com_arm,
          by = "COM"
        )
      }
    )
  )

  ###################################################################
  # Anciens tests

  # Base avec Marseille et Brest :
  basecom <-  data.frame(COM=c("13055","29019"),
                         LIB=c("Marseille","Brest"))


  # Ajout des arrondissements sans garder Marseille
  data_arm <- com_to_arm(basecom)
  expect_equal(nrow(data_arm),17)

  # Marseille ne s'y trouve pas
  expect_false("13055" %in% data_arm$COM)

  # Retour à la commune
  data_com_2 <- arm_to_com(data_arm)
  expect_true("13055" %in% data_com_2$COM)
})
