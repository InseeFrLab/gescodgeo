test_that("Fonctions génériques pour le changement des codes géographiques", {


  # Utilitaires pour le développement
  if(FALSE) {
    golem::detach_all_attached()
    rm(list = ls())
    devtools::document()
    devtools::load_all()
    ?codes_to_one
    ?codes_to_many
  }
  ###############################################################################
  # Progeammation orientée objet

  x <- c("B","C1","C2","A","A","Z")
  ci <- c("A","A","B","C1","C2")
  cf <-  c("a1","a2","b","c","c")
  ce <- c("Z"="z1","Z"="z2")

  #  Dimension si extra est un vecteur de scission
  y <- codes_to_many(x, codes_ini = ci, codes_fin = cf, extra = ce )

  expect_true(length(y) > length(x))
  expect_true(is.character(y))

  # Méthode pour une data frame
  dx <- data.frame(ID = c(1:length(x)), X = x)
  dy <- codes_to_many(dx, from = "X", to = "Y",
                      codes_ini = ci, codes_fin = cf, extra = ce)
  expect_true(is.data.frame(dy))
  expect_true(all.equal(dy$Y,y))

  # Emplacement de to
  dx <- data.frame(X = x, OTHER = x)
  dy <- codes_to_many(dx, from = "X", to = "Y", codes_ini = ci, codes_fin = cf, extra = ce)

  expect_equal(colnames(dy),c("X","Y","OTHER"))


  # ça marche aussi si to = from
  dy <- codes_to_many(dx, from = "X", to = "X",
                     codes_ini = ci, codes_fin = cf, extra = ce)
  expect_true(all.equal(dy$X,y))

  ###############################################################################
  # codes_to_one et codes_to_many

  x <- c("B","C1","C2","A","Z")
  c_ini <- c("A","A","B","C1","C2")
  c_fin <-  c("a1","a2","b","c","c")

  # Résultat attendu avec la fonction codes_to_many()
  y2 <- c("b","c","c","a1","a2","z1","z2")

  # Pas de warning
  y <- x |> codes_to_many(
                  codes_ini = c_ini,
                  codes_fin = c_fin,
                  extra = function(x){return(c("z1","z2"))})

  # Dimension supérieure
  expect_true(length(x) < length(y))

  # Résultat attendu
  expect_equal(y, y2)

  # Même résultat avec un autre extra
  x |>
    codes_to_many(codes_ini = c_ini,
                     codes_fin = c_fin,
                     extra = c("Z"="z1","Z"="z2")) |>
    expect_equal(y2)

})
