(require 'source-map-support').install
  handleUncaughtExceptions: false

module.exports = new class Index

  polvo: true

  type: 'js'
  name: 'html'
  ext: /\.html?$/m
  exts: ['.html', '.html']

  compile:( filepath, source, debug, done )->
    
    compiled = "module.exports = function() { return '#{source}'; };"
    compiled = compiled.replace /\n/g, "\\\n"

    console.log  compiled

    done compiled, null