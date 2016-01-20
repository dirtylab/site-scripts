// Imports de dépendances npm
import  $ from "jquery";
import  "jquery.scrollbar";
import  "tipso";
// Import de sources locales, précédées de "." == répertoire courant
// Webpack va charger ce fichier json grace à la dépendance-dev json-loader
import tooltipDefaultConfig from "json!./tooltips.json";
import hello from "./hello";


hello();

$(document).ready( () => {
    // Activation de la scrollbar sur la navigation de gauche
    $("#nav").find("> #nav-wrapper").scrollbar();
    // Activation des tooltips
    let tipsoWideConfig=Object.assign({},{
        maxWidth:Infinity,
        width:null // https://github.com/object505/tipso/pull/38
    },tooltipDefaultConfig);
    $("[data-tipso]:not(.tipso-wide)").tipso(tooltipDefaultConfig);
    $("[data-tipso].tipso-wide").tipso(tipsoWideConfig);
});