<?php

// @Frosty-Z 2016-01-16
// sed ne supporte pas l'ensemble des fonctionnalités des expressions régulières type 'PCRE'
// => création de ce script pour corriger les liens relatifs (.MD => .html)

ini_set('display_errors', 1);
error_reporting(E_ALL);


// Pour tester, vérifier le contenu de TEST.MD après exécution du script,
// en décommentant les lignes suivantes et en lançant 'php fix_links.php TEST.MD' :
/*file_put_contents('TEST.MD', '
## l\'extension dans le lien doit être remplacée par ".html" (pas pour le "label" entre crochets)
- [README.MD](README.MD)
- [DIR/README.MD](DIR/README.MD)
- [DIR/README.MD](DIR/README.MD#ancre.123)
- [grosse vacherie](DIR/DIR.MD/README.MD#ancre.123.MD.456)
## rien ne doit être modifié
- [README.MD absolu 1](https://github.com/sveinburne/lets-play-science/blob/master/README.MD)
- [README.MD absolu 2](http://domaine.com/1/2/3/a/b/c/README.MD?truc=abc&bidule=123)
');*/


if (!isset($argv[1]))
{
  echo "Error: please provide a filename to process. Usage: php fix_links.php <filename>\n";
  exit;
}

$file_to_process = $argv[1];

echo "*** fix_links.php: processing file '".$file_to_process."'\n";

if (!file_exists($file_to_process))
{
  echo "Error: file '".$file_to_process."' does not exists";
  exit;
}

$content = file_get_contents($file_to_process);


$content = preg_replace_callback('/\(([^[:space:]()]+)\.MD([#?][^[:space:]()]*)?\)/', function ($match) {
  
  if (!isset($match[2]))
    $match[2] = '';
  
  if (preg_match('#^https?://#', $match[1])) // lien absolu ?
    return $match[0]; // on ne change rien
  else
    return '('.$match[1].'.html'.$match[2].')'; // renommage .MD => .html
  
  }, $content);


file_put_contents($file_to_process, $content);


