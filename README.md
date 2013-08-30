# Polvo HTML

[![Stories in Ready](https://badge.waffle.io/polvo/polvo-html.png)](https://waffle.io/polvo/polvo-html)

[![Build Status](https://secure.travis-ci.org/polvo/polvo-html.png)](http://travis-ci.org/polvo/polvo-html) [![Coverage Status](https://coveralls.io/repos/polvo/polvo-html/badge.png)](https://coveralls.io/r/polvo/polvo-html)

[![Dependency Status](https://gemnasium.com/polvo/polvo-html.png)](https://gemnasium.com/polvo/polvo-html) [![NPM version](https://badge.fury.io/js/polvo-html.png)](http://badge.fury.io/js/polvo-html)

# Install

You won't need to install it since it comes built in in Polvo.

# Instructions

Just put your `.html` or `.htm` files in your `input dirs` and it will be
ready for use.

Templates are compiled to strict  CJS modules, to require them just use the well
known [CJS pattern](http://nodejs.org/api/modules.html), more
info [here](http://wiki.commonjs.org/wiki/Modules/1.1).

The same resolution algorithm presented in NodeJS will be used.

## Example

````coffeescript
template = require './your/html/template'

dom = template()
console.log dom
# append it to your document, i.e:
# $('body').append dom
````

# Partials

There's a built in support for partials in your html files.

Every file starting with `_` won't be compiled alone. Instead, if some other
file that doesn't start with `_` imports it, it will be compiled within it.

The import tag follows the basic [SSI](http://en.wikipedia.org/wiki/Server_Side_Includes)
specification.


To include a partial in your `html`, just:

 1. Name your patial accordingly so it starts with `_`
 1. Include it in any of your html files by using the syntax

 ````html
 <!--#include file="_partial-name-here" -->
 ````

 Partials are referenced relatively.