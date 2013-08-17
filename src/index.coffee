(require 'source-map-support').install
  handleUncaughtExceptions: false

module.exports = new class Index

  polvo: true

  type: 'template'
  name: 'html'
  output: 'js'

  ext: /\.html?$/m
  exts: ['.html', '.html']

  compile:( filepath, source, debug, error, done )->
    
    compiled = "module.exports = function() { return '#{source}'; };"
    compiled = compiled.replace /\n/g, "\\\n"

    done compiled, null