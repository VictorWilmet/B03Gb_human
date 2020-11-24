
SciViews::R

biometry <- readr::read_csv("docs/biometrie_humaine_2019 - Feuille 1.csv", locale = readr::locale(decimal_mark = ","))

biometry <- drop_na(biometry)

biometry <- labelise(biometry, label=list(
                                genre = "genre",
                                taille = "taille",
                                age = "age",
                                masse = "masse",
                                masse_perso = "masse personne",
  ))

