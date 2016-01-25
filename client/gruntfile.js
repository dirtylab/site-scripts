'use strict';

var buildDir="../jekyll-build";
var preBuildScript="../scripts/build.sh";

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
            dev:webpackConf(false),
            prod:webpackConf(true)
        }
    });

    // Register webpack
    grunt.loadNpmTasks('grunt-webpack');

    // Register the grunt serve task
    grunt.registerTask('jkserve', [
        'shell:jekyllServe'
    ]);

    grunt.registerTask('pack', function(mode){
        if(mode==="prod") grunt.task.run(["webpack:prod"]);
        else if(mode==="dev"||mode===undefined) grunt.task.run(["webpack:dev"]);
        else {
            grunt.fail.warn("Unknown option "+mode+". Falling back to dev mode");
            grunt.task.run(["webpack:dev"]);
        }
    });
    // Register the grunt build task
    grunt.registerTask('jkbuild', [
        'shell:jekyllPrebuild',
        'shell:jekyllBuild'
    ]);
    // Register build as the default task fallback
    grunt.registerTask('default', 'pack:dev');


};