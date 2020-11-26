
SciViews::R

biometry <- readr::read_csv("docs/biometrie_humaine_2019 - Feuille 1.csv", locale = readr::locale(decimal_mark = ","))

biometry <- drop_na(biometry)

biometry <- labelise(biometry, 
  label=list(
    genre = "genre",
    taille = "taille",
    age = "age",
    masse = "masse",
    masse_perso = "masse personne",
    masse_ref = "masse référence",
    tour_hanche = "tour de hanche",
    tour_taille = "tour de taille",
    tour_poignet = "tour de poignet",
    activite_phy = "activité physique",
    conso_alcool = "consommation alcool",
    fast_food = "fast food",
    temps_assis = "temps assis",
    temps_sommeil = "temps sommeil",
    milieu_vie = "milieu de vie",
    soda = "soda",
    tabac = "tabac",
    profession = "profession",
    conso_eau = "consommation eau"),
  units=list(
    taille = "cm",
    age = "ans",
    masse = "Kg",
    masse_perso = "Kg",
    masse_ref = "Kg",
    tour_hanche = "m",
    tour_taille = "m",
    tour_poignet = "m",
    activite_phy = "min/sem",
    conso_alcool = "verres/sem",
    temps_assis = "h/jours",
    temps_sommeil = "h/nuits",
    soda = "l/sem",
    tabac = "cig/sem",
    conso_eau = "l/sem")
    )

# Retirons de la colonne "masse" les données implausibles (> 200 Kg). Une erreur d'encodage a manifestement eu lieu pour un certain nombre d'entre elles.
biometry <- filter(biometry, masse < 200)








