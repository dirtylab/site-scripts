'use strict';
var jekyllJsPath ="../jekyll/js",
    webpack=require("webpack"),
    path=require("path"),
    buildPath=path.resolve(__dirname,jekyllJsPath);

module.exports=function(production){
    var plugins=[new webpack.NoErrorsPlugin()];
    if(production) plugins.push(
            new webpack.optimize.UglifyJsPlugin({minimize: true}),
            new webpack.optimize.DedupePlugin(),
            new webpack.optimize.OccurrenceOrderPlugin(true)
    );
    return {
        entry: path.resolve(__dirname,'./es6/main.es6'),
        output: {
            path: path.resolve(__dirname,buildPath),
            filename: 'dirtylab.js'
        },
        module: {
            loaders: [
                {
                    loader: 'babel-loader',
                    test: /\.es6/,
                    exclude: /node_modules/,
                    query: {
                        presets: 'es2015'
                    }
                }
            ]
        },
        resolve:{
            extensions:['','.js','.json','.es6']
        },
        plugins: plugins,
        stats: {
            // Nice colored output
            colors: true,
            modules: true,
            reasons: true
        },
        // Create Sourcemaps for the bundle
        devtool: 'source-map'
    };
};