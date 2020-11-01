La biométrie humaine
================

<!--- do not edit readme.md ---->

## Contexte

Dans le cadre du cours de science des données biologique I, vous avez
été amené à collecter des données sur la biométrie humaine. Un an plus
tard, il vous est demandé de ré-analyser ces données à l’aide des outils
en lien avec le modèle linéaire.

Etant donnée que vous avez été des scientifiques consciencieux, vous
avez collecté vos données en y associant des métadonnées.

Les données ont été collectée via un document googlesheet dont l’url est
le suivant
    :

  - <https://docs.google.com/spreadsheets/d/1UfpZvx1_nd7d10vIMAfGVZ1vWyIuzeiKxPL0jfkNSQM/edit#gid=0>

Les métadonnées associées aux données ont été recensées dans un document
googledoc dont l’url est le suivant
    :

  - <https://docs.google.com/document/d/1lgYD39W7vmVYyS5ea0wEl9ArE1dhuDRkIIBzZ4K6d_o/edit>

Les données sont téléchargeables au fomat csv via l’url suivant
    :

  - <https://docs.google.com/spreadsheets/d/1UfpZvx1_nd7d10vIMAfGVZ1vWyIuzeiKxPL0jfkNSQM/export?format=csv>

# Objectif

Réalisez un rapport d’analyse structurée sur une question de votre choix
sur les données de biométrie humaine.

> Consignez vos résultats dans un document structuré au format R
> Markdorwn. Utilisez le template mis à votre disposition dans le
> dossier analysis.Ce document doit contenir une introduction sur la
> question de recherche que vous vous posez. Ce document doit contenir
> une section analyse avec la description des données et la réalisation
> du modèle linéaire généralisé. Chaque tableau et graphique doit avoir
> une légende claire et précise comme montré dans l’exemple. Tout comme
> dans les revues scientifiques, les tableaux et graphiques doivent être
> cité dans le texte.

## Procédures

Dans un script R :

  - Importez vos
données

<!-- end list -->

``` r
biometry <- readr::read_csv("https://docs.google.com/spreadsheets/d/1UfpZvx1_nd7d10vIMAfGVZ1vWyIuzeiKxPL0jfkNSQM/export?format=csv", locale = readr::locale(decimal_mark = ","))
```

  - Retirez les nombreuses valeurs manquantes (vous pouvez utiliser par
    exemple la fonction `drop_na()`)

  - Ajoutez les labels à vos variables. (vous pouvez utiliser par
    exemple la fonction `labelise()`).

  - Réalisez une sauvegarde locale de votre jeu de données (vous pouvez
    apr exemple employer la fonction `write()`)

Dans le template Rmd :

  - éditez votre rapport
