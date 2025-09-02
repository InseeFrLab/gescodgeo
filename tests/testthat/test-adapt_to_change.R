test_that("Fonction adapt_to_change()", {

  # Utilitaires pour le développement :
  if(FALSE) {
    golem::detach_all_attached()
    devtools::document()
    ?adapt_to_change
    rm(list = ls())
    devtools::load_all()
  }

  ##############################################################################
  # Test conservation des sommes en cas de scissions pour une base bilocalisée

  # cog_transition(2017,2021) %>% filter(COM_INI %in% c("14712", "16233", "16351"))
  #   COM_INI COM_FIN POP_INI POP_FIN NB_COM_INI NB_COM_FIN
  #   <chr>   <chr>     <dbl>   <dbl>      <int>      <int>
  # 1 14712   14666      5451    1912          1          2
  # 2 14712   14712      5451    3481          1          2
  # 3 16233   16233       464    1026          2          1
  # 4 16351   16233       607    1026          2          1

  # La commune 14712 va se scinder et les commune 16233 et 16351 vont fusionner
  dt2017 <- data.frame(
    COM_N = c("14712","14712","14712", "75001"),
    COM_N_1 = c("14712","16233","16351", "75002"),
    MOBILES = c(123,456,561, 312)
  )

  # sum(dt2017$MOBILES) # 1452

  # Change la géographie de COM_N
  dt2021 <- dt2017 %>% change_cog(
    from = COM_N, to = "COM_N_BIS",
    cog_from = 2017, cog_to = 2021, infos = TRUE)

  # sum(dt2021$MOBILES) # 2592

  # La somme ne change pas quand on reaclaule sans pondération
  dt2021_bis <- dt2021 %>% adapt_to_change(
    from = COM_N, to = COM_N_BIS,
    id_cols = "COM_N_1",
    sum_cols = MOBILES,
    weight_to = NULL
  )
  expect_equal(sum(dt2017$MOBILES), sum(dt2021_bis$MOBILES))

  # La somme ne change pas quand on reaclaule avec pondération
  dt2021_bis <- dt2021 %>% adapt_to_change(
    from = COM_N, to = COM_N_BIS,
    id_cols = "COM_N_1",
    sum_cols = MOBILES,
    weight_to = POP_FIN
  )
  expect_equal(sum(dt2017$MOBILES), sum(dt2021_bis$MOBILES))

  # La somme ne change pas quand on mets COM_N_1 dans from et to
  dt2021_bis <- dt2021 %>% adapt_to_change(
    from = c(COM_N_1, COM_N), to = c(COM_N_1, COM_N_BIS),
    sum_cols = MOBILES,
    weight_to = POP_FIN
  )
  expect_equal(sum(dt2017$MOBILES), sum(dt2021_bis$MOBILES))

  # Change la géographie de COM_N_1 (warning car on écrase les infos)
  expect_warning(
    dt2021_ter <- dt2021_bis %>% change_cog(
      from = COM_N_1, to = "COM_N_1_BIS",
      cog_from = 2017, cog_to = 2021, infos = TRUE)
  )
  # sum(dt2021_ter$MOBILES) # 1575

  # La somme ne change pas quand on reaclaule avec pondération
  dt2021_quater <- dt2021_ter %>% adapt_to_change(
    from = COM_N_1, to = COM_N_1_BIS,
    id_cols = "COM_N_BIS",
    sum_cols = MOBILES,
    weight_to = POP_FIN
  )
  expect_equal(sum(dt2017$MOBILES), sum(dt2021_quater$MOBILES))
  # Remarque :
  # ça ne marche pas si on prend id_cols = COM_N car dupliqué

  ##############################################################################
  # Tests divers

  # New cols if infos == TRUE
  new_cols <- c("NB_INI", "NB_FIN", "RATIO_INI", "RATIO_FIN")

  data_0 <- data.frame(C_0 = c(1,2,3,3),
                       C_1 = c(1,1,3,4),
                       S = c(10,20,30 , 30),
                       M = c(0.4, 0.5, 0.3, 0.3),
                       C = c(1,2,3,3),
                       W_0 = c(1,2,1,1),
                       W_1 = c(1,1,1,2))

  data_1 <- data_0 |>
    adapt_to_change(from = "C_0",
                    to = "C_1",
                    sum_cols = "S",
                    mean_cols = "M",
                    cat_cols = "C",
                    weight_from = "W_0",
                    weight_to = "W_1",
                    reduce = FALSE,
                    infos = TRUE)


  setdiff(colnames(data_1), colnames(data_0)) |>
    all.equal(new_cols) |>
    expect_true()

  ## To times change
  data_2 <- data_0 |>
    adapt_to_change(from = "C_0",
                    to = "C_1",
                    sum_cols = "S",
                    cat_cols = "C",
                    weight_from = "W_0",
                    weight_to = "W_1",
                    reduce = FALSE) |>
    adapt_to_change(from = "C_0",
                    to = "C_1",
                    mean_cols = "M",
                    weight_from = "W_0",
                    weight_to = "W_1",
                    reduce = FALSE,
                    infos = TRUE)

  expect_true(all.equal(data_1,data_2))

  ##############################################################################
  ### One to many

  data <- data.frame(I = c("A","A","B","B"),
                     P = c(1,3,1,1),
                     S1 = c(10,10,10,10),
                     S2 = c(20,20,30,30))

  # Pas de changement si pas de pondération
  expect_true(all.equal(data, adapt_to_change(data)))

  # Pas de pondération : divisé par le nombre de zones
  data2 <- adapt_to_change(data, from = "I", sum_cols = c("S1","S2"))
  expect_true(all.equal(data2$S1, data$S1/2))

  # Pondération
  data2 <- adapt_to_change(data, from = "I", weight_to = "P", sum_cols = c("S1","S2"))
  expect_true(all.equal(data2$S1, c(2.5, 7.5, 5, 5)))
  expect_true(all.equal(data2$S2, c(5, 15,  15,  15)))



  ##############################################################################
  ### Many to one

  ## Departements de Corse
  dep_corse <- data.frame(
    DEP = c("2A","2B"),
    POP = c(160814, 182887),
    SUP = c(4014.2	, 4665.6),
    DENS = c(40.1,39.2),
    LETTER = c("A","B")
  ) |> dep_to_reg()

  # Do nothing
  expect_true(all.equal(dep_corse, adapt_to_change(dep_corse)))

  # Reduce
  expect_equal(adapt_to_change(dep_corse, to = "REG") |> nrow(), 1)

  # Not reduce : do nothing except changing class
  dep_corse |> adapt_to_change(to = "REG", reduce = FALSE) |>
    as.data.frame() |>
    all.equal(dep_corse)

  # Recalculate data variables
  dep_corse_2 <- dep_corse |> adapt_to_change(to = "REG",
                                              sum_cols = c("POP","SUP"),
                                              mean_cols = c("DENS"),
                                              cat_cols = "LETTER",
                                              reduce = FALSE)

  # La relation DENS = POP/SUP n'est pas resperctée
  all.equal(dep_corse_2$DENS,with(dep_corse_2,POP/SUP),tolerance = 0.001)

  # Identical rows
  expect_true(all.equal(dep_corse_2[1,2:6], dep_corse_2[2,2:6]))

  # Reduce
  dep_corse_2 <- dep_corse_2 |> adapt_to_change(to = "REG")

  # Respect sum
  expect_equal(dep_corse_2$POP, sum(dep_corse$POP))
  expect_equal(dep_corse_2$SUP, sum(dep_corse$SUP))

  # Respect mean
  expect_equal(dep_corse_2$DENS, mean(dep_corse$DENS))


  # First cat
  expect_equal(dep_corse_2$LETTER, dep_corse[1,]$LETTER)

  # Use weight
  dep_corse_2 <- dep_corse |>
    adapt_to_change(to = "REG",
                    sum_cols = c("POP","SUP"),
                    weight_from = "SUP",
                    mean_cols = c("DENS"),
                    cat_cols = "LETTER")

  # La relation DENS = POP/SUP est  respectée
  expect_true(all.equal(dep_corse_2$DENS,with(dep_corse_2,POP/SUP),tolerance = 0.001))

  # Respect sum
  expect_equal(dep_corse_2$POP, sum(dep_corse$POP))
  expect_equal(dep_corse_2$SUP, sum(dep_corse$SUP))

  # Respect weihted.mean
  expect_equal(dep_corse_2$DENS, weighted.mean(dep_corse$DENS, w =dep_corse$SUP))

  # Biggest cat
  expect_equal(dep_corse_2$LETTER, "B")

  ##############################################################################
  # many to many

  # Jeu de données test
  data <- dplyr::tibble(
    ID = c("1", "2", "2", "3", "4", "5", "6", "7"),
    COM_2019 = c("13001", "14712", "14712", "16233", "16351", "53239", "53249", "53274" ),
    COM_2021 = c("13001", "14666", "14712", "16233", "16233", "53249", "53249", "53249" ),
    E1 = c(451 , 554 , 554 , 665, 2223 , 445, 4455 , 445),
    E2 = c(3514 , 1545 , 1545, NA, 52234 , 1454, 14554 , 1451),
    M1 = c(1.20 , 2.40 , 2.40 , 3.55 , 3.40 , 9.40, 11.10, 12.00 ),
    C1 = c("A", "B", "B", "B", "A", "B", "A", "C" ),
    C2 = c("A", "B", "B", "A", "B", "B", "A", "C" ),
    POND_INI = c(NA, 5428, 5428 , 451 , 594 , 421 , 463 , 237 ),
    POND_FIN = c(NA, 1912, 3481, 1026, 1026, 1121, 1121, 1121 )
  )
  data$E3 = data$E1 + data$E2
  data$M2 = data$E1/data$E2

  # On ne fait rien
  data |>
    adapt_to_change(from = "COM_2019", to = "COM_2021", reduce = FALSE) |>
    dplyr::arrange(ID) |>
    all.equal(data) |>
    expect_true()

  # Erreur : calculer une variable caractère
  expect_error(
    data |> adapt_to_change(from = "COM_2019", to = "COM_2021", sum_cols = "C1"),
    regexp = "n'est pas num"
  )

  # adapt_to_change les variables numériques et les catégories
  target <- data |>
    adapt_to_change(from = "COM_2019", to = "COM_2021",
              sum_cols = c("E1", "E2", "E3", "POND_INI"), mean_cols = c("M1", "M2"),
              cat_cols = c("C1","C2"),
              weight_from = "POND_INI", weight_to = "POND_FIN",
              reduce = TRUE) |>
    arrange(ID)

  # Sommes égales
  expect_true(all.equal(
    data  |> distinct(COM_2019, .keep_all = TRUE) |> summarise(E1 = sum(E1), E2 = sum(E2), E3 = sum(E3)),
    target  |> summarise(E1 = sum(E1), E2 = sum(E2), E3 = sum(E3)),
  ))

  # Moyennes pondérées égales
  expect_true(all.equal(
    data |> distinct(COM_2019, .keep_all = TRUE) |>
      filter(!is.na(POND_INI)) |>
      summarise(M1 = weighted.mean(M1, w = POND_INI),
                M2 = weighted.mean(M2, w = POND_INI)),
    target |>  filter(!is.na(POND_INI)) |>
      summarise(M1 = weighted.mean(M1, w = POND_INI),
                M2 = weighted.mean(M2, w = POND_INI))
  ))

  # On retrouve les relations entre les moyennes et les effectifs
  expect_true(all.equal(target$E1/target$E2,target[["M2"]], tolerance = 0.0005))

  target <- data |>
    adapt_to_change(from = "COM_2019",
              to = "COM_2021",
              sum_cols = c("E1", "E2", "E3", "POND_INI"),
              mean_cols = c("M1", "M2"),
              cat_cols = c("C1","C2"),
              reduce = TRUE) |>
    arrange(ID)

  # Le adapt_to_change des autres variables n'affecte pas celui des catégories
  expect_true(all.equal(
    data |>
      adapt_to_change(from = "COM_2019", to = "COM_2021",
                cat_cols = c("C1","C2"), reduce = TRUE) |>
      select(COM_2021,C1,C2) |>
      arrange(COM_2021),
    target |>
      select(COM_2021,C1,C2) |>
      arrange(COM_2021)
  ))

  ##############################################################################
  # Jeu de données spécial catégories

  data <- data.frame(
    P = c(1, 9999, 1, 1, 1, 1, 1, 1, 9999, 1, 1, 1, 1, 9999, 1),
    GEO_F = c(1, 1, 1, 1, 2, 2, 2, 2, 2, 3, 3, 3, 3, 3, 3)
  )
  data$C = as.character(data$P)
  data <- adapt_to_change(data, to = "GEO_F", from = NULL, reduce = TRUE, weight_from = "P", cat_cols = "C", infos = TRUE)
  expect_true(unique(data$C) == "9999")

  ##############################################################################
  # Jeu de données test : commune de dordogne qui vont fusionner

  if(FALSE) { # Initialisation
    tp <- table_passage(2020,2022)
    load("U:/workspace/gescodgeo/data-raw/archives-bases-pour-les-exemples/dordogne_modtrans_2020.rda")
    dt_2020 <- dordogne_modtrans_2020 |>
      mutate(COM_2020 = DEPCOM) |>
      mutate(COM_2022 = DEPCOM) |>
      filter(COM_2020 %in% tp$COM_INI)
    dt_2020$DEPCOM |> paste0(collapse = "', '")
    dt_2020$MODTRANS |> paste0(collapse = "', '")
    dt_2020$DIST |> paste0(collapse = ", ")
    dt_2020$NB_OBS |> paste0(collapse = ", ")
    dt_2020$IPONDI |> paste0(collapse = ", ")
    dt_2020$COM_2022 |> paste0(collapse = "', '")
  }

  dt_2020 <- data.frame(
    DEPCOM = c('24089', '24089', '24089', '24089', '24314', '24314', '24325', '24325'),
    MODTRANS = c('2', '3', '4', '5', '3', '5', '3', '5'),
    DIST = c(0.314, 5.784, 7.259, 8.54791317714561, 12.04, 17.0932857142857, 1.69563844942994, 36.0609098529412),
    NB_OBS = c(1, 1, 1, 28, 1, 7, 0, 12),
    IPONDI = c(5.03541541396609, 4.90233443909713, 5.17210906481461, 145.38312722775, 5, 35, 5.24875621890547, 89.228855721393),
    COM_2020 = c('24089', '24089', '24089', '24089', '24314', '24314', '24325', '24325')
  )

  # Passe de la géographie 2020 à la géographie 2022
  dt_2022 <- change_cog(data = dt_2020,
                              from = COM_2020, to = "COM_2022",
                              cog_from = 2020, cog_to =2022)

  ##############################################################################
  # Gérer des fusions sans weight_to

  # Agrgation à la main
  dt_2022_m <- dt_2022 |>
    group_by(COM_2022, MODTRANS) |>
    summarise(DIST=weighted.mean(DIST,IPONDI),
              NB_OBS = sum(NB_OBS),
              IPONDI = sum(IPONDI),
              .groups = "drop"
    )

  # Fonction adapt_to_change
  dt_2022_r <- dt_2022 |> adapt_to_change(from="COM_2020",
                                    to = "COM_2022",
                                    weight_from = "IPONDI",
                                    sum_cols = c("NB_OBS","IPONDI"),
                                    mean_cols = "DIST",
                                    id_cols = "MODTRANS",
                                    infos = FALSE,
                                    reduce = TRUE) |>
    arrange(MODTRANS) |>
    select(all_of(colnames(dt_2022_m)))

  expect_true(all.equal(dt_2022_r, dt_2022_m))

  ##############################################################################
  # Gérer des fusions sans weight_to ni weight_from

  # Agrgation à la main
  dt_2022_m <- dt_2022 |>
    group_by(COM_2022,MODTRANS) |>
    summarise(NB_OBS = sum(NB_OBS),
              IPONDI = sum(IPONDI),
              .groups = "drop"
    )

  # Fonction adapt_to_change
  dt_2022_r <- dt_2022 |>
    select(-DIST) |>
    adapt_to_change(from = "COM_2020", to="COM_2022",
              sum_cols = c("NB_OBS","IPONDI"),
              id_cols = "MODTRANS",
              reduce = TRUE) |>
    arrange(MODTRANS) |>
    select(all_of(colnames(dt_2022_m)))

  expect_true(all.equal(dt_2022_r, dt_2022_m))

  ##############################################################################
  # Gérer des scissions

  dt_2020 <- dt_2020 |> mutate(COM_INI = "DEPCOM")
  dt_2018 <- change_cog(dt_2020,2020,2018,infos=TRUE, from = "COM_INI", to = "COM_FIN")

  # Fonction adapt_to_change
  dt_2018_r <- dt_2018 |>
    adapt_to_change(from="COM_INI",
              to = "COM_FIN",
              weight_from = "IPONDI",
              weight_to = "POP_FIN",
              sum_cols = c("NB_OBS","IPONDI"),
              mean_cols = "DIST",
              id_cols = "MODTRANS",
              reduce = TRUE) |>
    arrange(MODTRANS)


  agregat_2020 <- dt_2020  |> group_by(MODTRANS) |>
    summarise(
      DIST=weighted.mean(DIST,IPONDI),
      NB_OBS = sum(NB_OBS),
      IPONDI = sum(IPONDI),
      .groups = "drop"
    )
  agregat_2018 <- dt_2018_r  |> group_by(MODTRANS) |>
    summarise(
      DIST=weighted.mean(DIST,IPONDI),
      NB_OBS = sum(NB_OBS),
      IPONDI = sum(IPONDI),
      .groups = "drop"
    )

  expect_true(all.equal(agregat_2018, agregat_2020))

})
