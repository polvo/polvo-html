(require 'source-map-support').install
  handleUncaughtExceptions: false

path = require 'path'
fs = require 'fs'
clone = require 'regexp-clone'

module.exports = new class Index

  type: 'template'
  name: 'html'
  output: 'js'

  ext: /\.html?$/m
  exts: ['.html', '.html']

  has_includes = /\<!--#include\s*file\s*=/gm
  match_all = /\<!--#include\s*file\s*=\s*(?:"|')([^"']+)(?:"|')\s*-->/gm

  partials: on

  is_partial:( filepath )->
    /^_/m.test path.basename filepath

  compile:( filepath, source, debug, error, done )->
    
    rendered = @render_partials filepath, source, error
    escaped = rendered.replace(/\n/g, '\\\n').replace /'/g, '\\\''
    compiled = "module.exports = function() { return '#{escaped}'; };"

    done compiled, null

  resolve_dependents:(filepath, files)->
    dependents = []

    for each in files
      [has, all] = [clone(has_includes), clone(match_all)]
      continue if not has.test each.raw

      dirpath = path.dirname each.filepath
      name = path.basename each.filepath

      while (match = all.exec each.raw)?
        short_id = match[1]

        full_id_a = short_id.replace(@ext, '') + '.htm'
        full_id_b = short_id.replace(@ext, '') + '.html'

        full_id_a = path.join dirpath, full_id_a
        full_id_b = path.join dirpath, full_id_b

        if full_id_a is filepath or full_id_b is filepath
          if not @is_partial name
            dependents.push each
          else
            sub = @resolve_dependents each.filepath, files
            dependents = dependents.concat sub

    dependents

  render_partials:( filepath, source, error )->
    [has, all] = [clone(has_includes), clone(match_all)]
    return source if not has.test source

    buffer = source
    while (match = all.exec source)?
      full = match[0]
      include = match[1]

      include_path = path.join (path.dirname filepath), match[1]

      include_a = include_path.replace(@ext, '') + '.html'
      include_b = include_path.replace(@ext, '') + '.htm'

      partial_content = null
      if fs.existsSync include_a
        partial_content = fs.readFileSync(include_a).toString()
        partial_content = @render_partials include_a, partial_content, error

      else if fs.existsSync include_b
        partial_content = fs.readFileSync(include_b).toString()
        partial_content = @render_partials include_b, partial_content, error

      else
        partial_content = ''
        error "file '#{include}' do not exist for '#{filepath}'"

      buffer = buffer.replace full, partial_content

    buffer