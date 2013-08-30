path = require 'path'
fs = require 'fs'
fsu = require 'fs-util'

should = require('chai').should()
html = require '../../'

fixtures = path.join __dirname, '..', 'fixtures'

paths = 
  base: path.join fixtures, 'base.html'
  _d: path.join fixtures, 'sub', '_d.htm'

contents = 
  base: fs.readFileSync(paths.base).toString()
  _d: fs.readFileSync(paths._d).toString()

describe '[polvo-html]', ->
  it 'should render file and its partials, recursively, showing errors properly', ->
    count =  err: 0, out: 0
    error =(msg)->
      reg = /file 'sub\/non\/existent' do not exist for '.+\/fixtures\/_a.html'/
      reg.test msg
      count.err++
    done =( compiled )->
      count.out++
      sample = """module.exports = function() { return '<h1>Base</h1>\\
        <h1>A</h1>\\
        \\
        <h1>B</h1>\\
        <h1>C</h1>\\
        <h1>D</h1>'; };
      """
      compiled.should.equal sample

    html.compile paths.base, contents.base, null, error, done
    count.out.should.equal 1
    count.err.should.equal 1

  it 'should return all file dependents, independently on how nested it is', ->
    list = []
    for file in fsu.find fixtures, /\.html?/
      list.push filepath:file, raw: fs.readFileSync(file).toString()

    dependents = html.resolve_dependents paths._d, list
    dependents.length.should.equal 1
    dependents[0].filepath.should.equal paths.base