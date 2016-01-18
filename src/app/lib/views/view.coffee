# # Views
#
# Add custom behaviour to all `Marionette.View` instances
@App.module "Views", (Views, App, Backbone, Marionette, $, _) ->

  # Store a reference to `remove()` method from originam
  # `Marionette.View` class.
  _remove = Marionette.View::remove
  _initialize = Marionette.View::initialize

  # Replace `remove()` method from `Marionette.View` class
  # in order to add a `console.log` of the view being removed
  # if the environment of the application is "dev". After that,
  # executes the original `remove()` method to destroy the view.
  _.extend Marionette.View::,

    # Apply stickit
    initialize: ->
      _initialize.apply(@, arguments)
      if @bindings
        @bindings = @normalizeUIKeys(_.result(@, 'bindings'))
        @on 'render', ->
          if @bindingsModel
            @stickit(@[@bindingsModel])
          else
            @stickit()
          
    remove: (args...) ->
      console.log "removing", @ if App.request("app:option", "environment") is "dev"
      _remove.apply @, args
