# poem_challenger

Mon premier projet de logiciel écrit avec dart (propulsé par le framework Flutter).

## Le projet

Inspiré des logiciels type Notes, le but est de pouvoir créer non pas des tâches ou du texte simple, mais des poèmes, avec la possibilité d'ajouter des contraintes :
    - Se chronométrer facilement, et en plusieurs fois ;
    - Insérer des mots spécifiques, et les colorer dynamiquement.

## Gestion & ergonomie

Malheureusement, sur mobile, le bouton de retour n'est pas pris en charge (risques de bugs) ; il faut utiliser les boutons de l'application.

La page d'accueil est composée de deux listes ; les poèmes chronométrés et non-chronométrés.
Les supprimer peut se faire individuellement (appui long) ou collectivement (icône poubelle pour chaque liste).
Ajouter du contenu se fait avec les boutons-icônes [+], et naviguer entre le poème et la liste de mots à insérer avec [>>]/[<<].
Le chronomètre ne se réinitialise qu'avec l'icône-bouton chronomètre barré rouge, sur une page de poème. L'autre est un bouton marche/pause.

### Optimisation & performances

J'ai tenté au mieux de gérer intelligemment la sauvegarde dynamique des poèmes, mais compliqué de devoir colorer dynamiquement certains mots à chaque changement du poème pour de grands textes sans causer de lags. Jusqu'environ 2000 caractères (~300 mots), et pas de mot vide dans la sélection de mots à placer (colore les marques de ponctuation), ça tient la route.

## Temps

J'ai commencé à apprendre Flutter le 06/02/2026, et terminé aujourd'hui, 23/02/2026.
C'était donc un projet d'environ 2 semaines.