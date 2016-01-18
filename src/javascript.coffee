#= require "../vendor/jquery/dist/jquery.js"
#= require "../vendor/underscore/underscore.js"
#= require "../vendor/underscore-strings/src/underscore.strings.js"
#= require "../vendor/backbone/backbone.js"
#= require "../vendor/backbone.paginator/lib/backbone.paginator.js"
#= require "../vendor/backbone.localStorage/backbone.localStorage.js"
#= require "../vendor/backbone.stickit/backbone.stickit.js"
#= require "../vendor/marionette/lib/backbone.marionette.js"
#= require "../vendor/handlebars/handlebars.js"
#= require "../vendor/toastr/toastr.js"

#= require_tree "config/"

#= require "app/app.coffee"

#= require_tree "app/lib/utilities/"
#= require_tree "app/lib/entities/"
#= require_tree "app/lib/controllers/"
#= require_tree "app/lib/views/"
#= require_tree "app/lib/components/"
#= require_tree "app/lib/behaviors/"

#= require_tree "app/entities/"

#= require_tree "app/modules/"
