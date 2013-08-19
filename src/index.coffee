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
    
    source = source.replace(/\n/g, '\\\n').replace '\'', '\\\''
    compiled = "module.exports = function() { return '#{source}'; };"

    done compiled, null