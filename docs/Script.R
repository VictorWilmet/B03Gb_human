
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

# Ma thématique: étudier la relation entre la masse des individus de l'étude avec leur tour de hanche ou avec leur tour de taille

# Observons d'abord la forme du scatter plot obtenu dans chacun des deux cas

chart(biometry, masse ~ tour_hanche) +
  geom_point()

chart(biometry, masse ~ tour_taille) +
  geom_point()

# Dans les deux cas, une analyse d'une droite de régression linéaire semble appropriée. Essayons plusieurs modélisations (linéaire simple, polynomiale) et voyons lequel semble mieux représenter le nuage de points obtenu

summary(lm_sh <- lm(data = biometry, masse ~ tour_hanche))
lm_sh %>.% (function (lm, model = lm[["model"]], vars = names(model))
  chart(model, aes_string(x = vars[2], y = vars[1])) +
  geom_point() +
  stat_smooth(method = "lm", formula = y ~ x))(.)


a <- lm_sh %>.%
  chart(broom::augment(.), .resid ~ .fitted) +
  geom_point() +
  geom_hline(yintercept = 0) +
  geom_smooth(se = FALSE, method = "loess", formula = y ~ x) +
  labs(x = "Fitted values", y = "Residuals") +
  ggtitle("Residuals vs Fitted")

b <- lm_sh %>.%
  chart(broom::augment(.), sqrt(abs(.std.resid)) ~ .fitted) +
  geom_point() +
  geom_smooth(se = FALSE, method = "loess", formula = y ~ x) +
  labs(x = "Fitted values",
    y = expression(bold(sqrt(abs("Standardized residuals"))))) +
  ggtitle("Scale-Location")

c <- lm_sh %>.%
  chart(broom::augment(.), .cooksd ~ seq_along(.cooksd)) +
  geom_bar(stat = "identity") +
  geom_hline(yintercept = seq(0, 0.1, by = 0.05), colour = "darkgray") +
  labs(x = "Obs. number", y = "Cook's distance") +
  ggtitle("Cook's distance")

d <- lm_sh %>.%
  chart(broom::augment(.), .std.resid ~ .hat %size=% .cooksd) +
  geom_point(show.legend = FALSE) +
  geom_smooth(se = FALSE, size = 0.5, method = "loess", formula = y ~ x) +
  geom_vline(xintercept = 0) +
  geom_hline(yintercept = 0) +
  labs(x = "Leverage", y = "Standardized residuals") +
  ggtitle("Residuals vs Leverage")
combine_charts(list(a, b, c, d))

# Essayons maintenant de représenter la même situation mais avec une régression polynomiale. Les critères d'Akaike seront ensuite calculés afin de déterminer quel modèle est le mieux adapté.

summary(lm_ph <- lm(data = biometry, masse ~  tour_hanche + I(masse^2)))
lm_ph %>.% (function (lm, model = lm[["model"]], vars = names(model))
  chart(model, aes_string(x = vars[2], y = vars[1])) +
  geom_point() +
  stat_smooth(method = "lm", formula = y ~ x + I(x^2)))(.)

e <- lm_ph %>.%
  chart(broom::augment(.), .resid ~ .fitted) +
  geom_point() +
  geom_hline(yintercept = 0) +
  geom_smooth(se = FALSE, method = "loess", formula = y ~ x) +
  labs(x = "Fitted values", y = "Residuals") +
  ggtitle("Residuals vs Fitted")

f <- lm_ph %>.%
  chart(broom::augment(.), sqrt(abs(.std.resid)) ~ .fitted) +
  geom_point() +
  geom_smooth(se = FALSE, method = "loess", formula = y ~ x) +
  labs(x = "Fitted values",
    y = expression(bold(sqrt(abs("Standardized residuals"))))) +
  ggtitle("Scale-Location")

g <- lm_ph %>.%
  chart(broom::augment(.), .cooksd ~ seq_along(.cooksd)) +
  geom_bar(stat = "identity") +
  geom_hline(yintercept = seq(0, 0.1, by = 0.05), colour = "darkgray") +
  labs(x = "Obs. number", y = "Cook's distance") +
  ggtitle("Cook's distance")

h <- lm_ph %>.%
  chart(broom::augment(.), .std.resid ~ .hat %size=% .cooksd) +
  geom_point(show.legend = FALSE) +
  geom_smooth(se = FALSE, size = 0.5, method = "loess", formula = y ~ x) +
  geom_vline(xintercept = 0) +
  geom_hline(yintercept = 0) +
  labs(x = "Leverage", y = "Standardized residuals") +
  ggtitle("Residuals vs Leverage")
combine_charts(list(e, f, g, h))

# Calculons la valeur des critères d'Akaike associés aux deux dernièrs essais de modélisation :

AIC(lm_sh)
AIC(lm_ph)

# Le modèle polynomial semble plus approprié pour représenter la relation entre la masse des individus et leur tour de hanche

# Regardons maintenant ce qu'il en est du tour de taille :

summary(lm_st <- lm(data = biometry, masse ~ tour_taille))
lm_st %>.% (function (lm, model = lm[["model"]], vars = names(model))
  chart(model, aes_string(x = vars[2], y = vars[1])) +
    geom_point() +
    stat_smooth(method = "lm", formula = y ~ x))(.)


i <- lm_st %>.%
  chart(broom::augment(.), .resid ~ .fitted) +
  geom_point() +
  geom_hline(yintercept = 0) +
  geom_smooth(se = FALSE, method = "loess", formula = y ~ x) +
  labs(x = "Fitted values", y = "Residuals") +
  ggtitle("Residuals vs Fitted")

j <- lm_st %>.%
  chart(broom::augment(.), sqrt(abs(.std.resid)) ~ .fitted) +
  geom_point() +
  geom_smooth(se = FALSE, method = "loess", formula = y ~ x) +
  labs(x = "Fitted values",
    y = expression(bold(sqrt(abs("Standardized residuals"))))) +
  ggtitle("Scale-Location")

k <- lm_st %>.%
  chart(broom::augment(.), .cooksd ~ seq_along(.cooksd)) +
  geom_bar(stat = "identity") +
  geom_hline(yintercept = seq(0, 0.1, by = 0.05), colour = "darkgray") +
  labs(x = "Obs. number", y = "Cook's distance") +
  ggtitle("Cook's distance")

l <- lm_st %>.%
  chart(broom::augment(.), .std.resid ~ .hat %size=% .cooksd) +
  geom_point(show.legend = FALSE) +
  geom_smooth(se = FALSE, size = 0.5, method = "loess", formula = y ~ x) +
  geom_vline(xintercept = 0) +
  geom_hline(yintercept = 0) +
  labs(x = "Leverage", y = "Standardized residuals") +
  ggtitle("Residuals vs Leverage")
combine_charts(list(i, j, k, l))

# Essayons maintenant de représenter la même situation mais avec une régression polynomiale. Les critères d'Akaike seront ensuite calculés afin de déterminer quel modèle est le mieux adapté.

summary(lm_pt <- lm(data = biometry, masse ~  tour_taille + I(masse^2)))
lm_pt %>.% (function (lm, model = lm[["model"]], vars = names(model))
  chart(model, aes_string(x = vars[2], y = vars[1])) +
    geom_point() +
    stat_smooth(method = "lm", formula = y ~ x + I(x^2)))(.)

m <- lm_pt %>.%
  chart(broom::augment(.), .resid ~ .fitted) +
  geom_point() +
  geom_hline(yintercept = 0) +
  geom_smooth(se = FALSE, method = "loess", formula = y ~ x) +
  labs(x = "Fitted values", y = "Residuals") +
  ggtitle("Residuals vs Fitted")

n <- lm_pt %>.%
  chart(broom::augment(.), sqrt(abs(.std.resid)) ~ .fitted) +
  geom_point() +
  geom_smooth(se = FALSE, method = "loess", formula = y ~ x) +
  labs(x = "Fitted values",
    y = expression(bold(sqrt(abs("Standardized residuals"))))) +
  ggtitle("Scale-Location")

o <- lm_pt %>.%
  chart(broom::augment(.), .cooksd ~ seq_along(.cooksd)) +
  geom_bar(stat = "identity") +
  geom_hline(yintercept = seq(0, 0.1, by = 0.05), colour = "darkgray") +
  labs(x = "Obs. number", y = "Cook's distance") +
  ggtitle("Cook's distance")

p <- lm_pt %>.%
  chart(broom::augment(.), .std.resid ~ .hat %size=% .cooksd) +
  geom_point(show.legend = FALSE) +
  geom_smooth(se = FALSE, size = 0.5, method = "loess", formula = y ~ x) +
  geom_vline(xintercept = 0) +
  geom_hline(yintercept = 0) +
  labs(x = "Leverage", y = "Standardized residuals") +
  ggtitle("Residuals vs Leverage")
combine_charts(list(m, n, o, p))

# Calculons la valeur des critères d'Akaike associés aux deux dernièrs essais de modélisation :

AIC(lm_st)
AIC(lm_pt)

# Encore une fois, c'est le modèle polynomial qui semble le plus approprié pour représenter la relation

# Essayons cette fois de représenter la relation entre les variables qualitatives que sont le fait de fumer ou non et la classe de l'indice de masse corporelle. Sont considérés comme fumeurs les individus qui consomment plus d'une cigarette/sem. :

biometry <- mutate(biometry,
  bmi = masse/(taille/100)^2,
  bmi_classe = case_when(
    bmi < 18.5 ~ "Sous_poids",
    bmi >= 18.5 & bmi < 25 ~ "Poids_normal",
    bmi >= 25 & bmi < 30 ~ "Surpoids",
    bmi >= 30 ~ "Obèse" ),
  fumeur = case_when(
    tabac <= 1 ~ "0",
    tabac > 1 ~ "1")
  )

biometry$fumeur <- as.factor(biometry$fumeur) 

biometry <- labelise(biometry,
  label=list(bmi = "IMC", bmi_classe = "classe IMC", fumeur = "fumeur"),
  units=list(bmi = "Kg/cm²"))

biometry$bmi_classe <- ordered(biometry$bmi_classe,
  levels = c("Sous_poids", "Poids_normal", "Surpoids", "Obèse"))

# Représentons graphiquement la répartition de ces nouvelles variables au sein de notre jeu de données:

chart(biometry, ~ bmi_classe %fill=% fumeur) +
  geom_bar()

# Malheureusement le nombre de données est insuffisant que pour pouvoir interpréter correctement la situation. Essayons alors de représenter la relation entre le milieu de vie (urbain ou non) et la classe de l'indice de masse corporelle.

biometry <- mutate(biometry,
  urbain = case_when(
    milieu_vie == "urbain" ~ "1",
    milieu_vie == "rural" ~ "0"))

biometry$urbain <- as.factor(biometry$urbain) 

# Représentons graphiquement la répartition de ces nouvelles variables au sein de notre jeu de données:

chart(biometry, ~ bmi_classe %fill=% urbain) +
  geom_bar()

# Nous pouvons dès lors étudier grâce au modèle linéaire généralisé la situation en question :

biometry_glm <- glm(data = biometry, urbain ~ bmi,
  family = binomial(link = logit))
summary(biometry_glm)

# Il n'y a apparemment pas de lien significatif entre le fait d'être en surpoids et le fait d'habiter en ville.






