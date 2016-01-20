// Imports de dépendances npm
import  $ from "jquery";
import  "jquery.scrollbar";
import  "tipso";
// Import de sources locales, précédées de "." == répertoire courant
// Webpack va charger ce fichier json grace à la dépendance-dev json-loader
import tooltipConfig from "json!./tooltips.json";
import hello from "./hello";

hello();

$(document).ready( () => {
    // Activation de la scrollbar sur la navigation de gauche
    $("#nav").find("> #nav-wrapper").scrollbar();
    // Activation des tooltips
    $("[data-tipso]:not(.tipso-wide)").tipso(tooltipConfig);
    $("[data-tipso].tipso-wide").tipso(Object.assign({
        width:'',
        maxWidth:'350'
    },tooltipConfig));
});