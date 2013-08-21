(require 'source-map-support').install
  handleUncaughtExceptions: false

path = require 'path'
fs = require 'fs'

module.exports = new class Index

  polvo: true

  type: 'template'
  name: 'html'
  output: 'js'

  ext: /\.html?$/m
  exts: ['.html', '.html']

  partials: on
  is_partial:(filepath)-> /^_/m.test path.basename filepath

  compile:( filepath, source, debug, error, done )->
    
    rendered = @render_partials filepath, source
    escaped = rendered.replace(/\n/g, '\\\n').replace /'/g, '\\\''
    compiled = "module.exports = function() { return '#{escaped}'; };"

    done compiled, null

  resolve_dependents:(file, files)->
    dependents = []
    has_includes = /\<!--#include\s*file\s*=/gm

    for each in files

      continue if not has_includes.test each.raw

      dirpath = path.dirname each.filepath
      name = path.basename each.filepath
      match_all = /\<!--#include\s*file\s*=\s*(?:"|')([^"']+)(?:"|')\s*-->/gm

      while (match = match_all.exec each.raw)?

        short_id = match[1]
        short_id += '.jade' if '' is path.extname short_id

        full_id = path.join dirpath, short_id

        if full_id is file.filepath
          if not @is_partial name
            dependents.push each
          else
            dependents = dependents.concat @resolve_dependents each, files

    dependents

  render_partials:( filepath, source )->

    has_includes = /\<!--#include\s*file\s*=/gm
    match_all = /\<!--#include\s*file\s*=\s*(?:"|')([^"']+)(?:"|')\s*-->/gm

    if not has_includes.test source
      return source

    contents = source
    while (match = match_all.exec contents)
      include_path = path.join (path.dirname filepath), match[1]
      include_path += '.html'

      if fs.existsSync include_path
        include_contents = do (fs.readFileSync include_path).toString
      else
        include_contents = ''
        error "File #{include_path} do not exist"

      contents = contents.replace match[0], include_contents

    return contents