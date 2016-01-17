# dirtylab-site-scripts

Ce dépot contient le nécessaire pour automatiser la publication des fichiers **.MD** 
du dépôt [sveinburne/letsplayscience](https://github.com/sveinburne/lets-play-science) vers 
le site statique [dirtylab.github.io](http://dirtylab.github.io) 
(issu du repo [dirtylab/dirtylab.github.io](https://github.com/dirtylab/dirtylab.github.io) via les [GitHub pages](https://pages.github.com/))

Dans le détail, il contient : 

* des **scripts bash** 
* **templates [Liquid](https://github.com/Shopify/liquid/wiki)** ([Jekyll](jekyllrb.com)) 
* sources javascript organisées par le gestionnaire de dépendances **npm**

## Détail des scripts :

### `1_process.sh`

#### Options

**`--prod` lance le script pour la production**

#### Séquencement

* Packetage des sources javascript depuis le répertoire `client`, via l'utilitaire [**webpack**](http://webpack.github.io/)
* Récupération des **.MD** du repo `lets-play-science` dans un répertoire temporaire `tmp_site`
* Déplacement des **.MD** dans `tmp_site/_include`
* Création de **.html** à la racine (un pour chaque **.MD**) comportant les instructions de conversion de **Markdown** vers **HTML**
* Ajout de templates header / footer / navigation / style (contenu du répertoire [jekyll-stuff](jekyll-stuff))

### Lancement 

Une fois le script lancé **depuis la racine du dépot**, on doit obtenir l'arborescence de fichier suivante  :

```
- /client <--- répertoire npm (javascript client)
- /dirtylab.github.io <--- répertoire git du site statique
- /jekyll-stuff <--- dossier jekyll
- /lets-play-science <--- répertoire git contenant le travail collaboratif
- /php_emojize <--- script php pour gérer les émoticônes 
- 1_process.sh
- 2_push.sh
```

### `2_push.sh`

* Instructions **git** permettant le commit sur le dépot du site statique + push des traitements automatiques 

## Développement client


### Présentation des outils 

[**Npm**](https://www.npmjs.com/) est un gestionnaire de dépendances javascript, originellement utilisé pour Nodejs mais fonctionne aussi bien pour gérer le code javascript client.
le projet npm est définit dans `client`.  
`package.json` définit le projet et ses dépendances.
  
[**Grunt**](http://gruntjs.com/) est un utilitaire de build très populaire! `gruntfile.js` définit les tâches de build.
[**Babel**](https://babeljs.io/) est un compilateur [ecmascript 6](http://es6-features.org) vers ecmascript 5. 
[**Webpack**](http://webpack.github.io/) est un concatenateur de modules javascript offrant beaucoup de flexibilité. `webpack.config.js` est son module de configuration.    

### Installation

Pour installer npm (debian) :  
`sudo apt-get install npm`  

Pour initialiser les dépendances npm :  
Depuis le répertoire `client` : `npm update`
  
### Utilisation

Depuis le répertoire `client`, différentes commandes Grunt sont disponibles :

* `grunt pack` génère le bundle dans `jekyll-stuff/js`
* `grunt jkbuild` appelle `jekyll build` depuis `tmp_site`  
* `grunt jkserve` appelle `jekyll serve` depuis `tmp_site`  

### Développement par modules

[Une bonne introduction à l'approche par modules en javascript.](http://webpack.github.io/docs/motivation.html)

Les sources sont rédigées en **ecamscript 6**, qui est en train de devenir le nouveau standard. Elles sont :

* compilées en ecmascript 5 via [**babel**](https://babeljs.io/), pour des raisons de compatibilité évidentes
* minifiées, [**avec source-map**](http://www.html5rocks.com/en/tutorials/developertools/sourcemaps/) 
    * vous pouvez donc les débugger sans problème avec n'importe quel navigateur moderne 
    * dans firefox, section `debugger javascript` depuis la console de développement (F12) 
* distribuées via [**webpack**](http://webpack.github.io/)



