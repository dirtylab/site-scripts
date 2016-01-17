'use strict';

var buildDir="tmp_site";
var preBuildScript="1_prepare.sh";

var webpackConf=require("./webpack.config.js");
module.exports = function (grunt) {

    // Show elapsed time after tasks run to visualize performance
    require('time-grunt')(grunt);
    // Load all Grunt tasks that are listed in package.json automagically
    require('load-grunt-tasks')(grunt);

    grunt.initConfig({
        pkg: grunt.file.readJSON('package.json'),

        // This is where our tasks are defined and configured
        shell: {
            jekyllPrebuild: {
                command: './'+preBuildScript
            },
            jekyllBuild: {
                command: 'cd '+buildDir+' && jekyll build'
            },
            jekyllServe: {
                command: 'cd '+buildDir+' && jekyll serve'
            }
        },
        webpack: {
            build:webpackConf
        }
    });

    // Register webpack
    grunt.loadNpmTasks('grunt-webpack');

    // Register the grunt serve task
    grunt.registerTask('jkserve', [
        'shell:jekyllServe'
    ]);

    grunt.registerTask('pack', [
        'webpack:build'
    ]);
    // Register the grunt build task
    grunt.registerTask('jkbuild', [
        'shell:jekyllPrebuild',
        'shell:jekyllBuild'
    ]);
    // Register build as the default task fallback
    grunt.registerTask('default', 'pack');


};