// import { test } from "./test";
import  $ from "jquery";
import  "jquery.scrollbar";
import  "tipso";

// Webpack will load this json file
var tooltipConfig=require("json!./tooltips.json");


console.info("Bienvenue sur dirtybiology!");


$(document).ready( () => {
    // Activation de la scrollbar sur la navigation de gauche
    $("#nav").find("> #nav-wrapper").scrollbar();
    // Activation des tooltips
    $("[data-tipso]:not(.tipso-wide)").tipso(tooltipConfig);
    $("[data-tipso].tipso-wide").tipso(Object.assign({
        width:'',
        maxWidth:'350'
    },tooltipConfig))
});