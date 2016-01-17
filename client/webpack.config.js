'use strict';
var webpack=require("webpack"),
    path=require("path"),
    buildPath=path.resolve(__dirname,"../jekyll-stuff/js");

module.exports={
    entry: path.resolve(__dirname,'./src/main.es6'),
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
    plugins: [
        // Avoid publishing files when compilation fails
        new webpack.NoErrorsPlugin(),
        new webpack.optimize.UglifyJsPlugin({minimize: true})
    ],
    stats: {
        // Nice colored output
        colors: true,
        modules: true,
        reasons: true
    },
    // Create Sourcemaps for the bundle
    devtool: 'source-map'
};