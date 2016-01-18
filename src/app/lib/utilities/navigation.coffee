# Navigation Utils
#
# All utils related to navigation.
@App.module "Utilities", (Utilities, App, Backbone, Marionette, $, _) ->

  routeAnchors = ->
    $(document).on "click", "a:not([data-bypass])", (event) ->
      href = 
        prop: $(this).prop("href")
        attr: $(this).attr("href")
      root = location.protocol + "//" + location.host + Backbone.history.options.root

      if href.prop && href.prop.slice(0, root.length) == root
        event.preventDefault()
        Backbone.history.navigate(href.attr, true)
  
  removeShebang = ->
    if typeof(window.history.pushState) == 'function'
       window.history.pushState(null, "Sound Search", window.location.hash.substring(2))
    else
      window.location.hash = window.location.hash.substring(2)

  _.extend App,

    # Set an autoInitHistory to true if not defined
    autoInitHistory: App.autoInitHistory or true

    # Methot to perform a navigation on the `Backbone.history`
    navigate: (route, options = {}) ->
      Backbone.history.navigate route, options

    # Get the current route on the `Backbone.history`
    getCurrentRoute: ->
      frag = Backbone.history.fragment
      if _.isEmpty(frag) then null else frag

    # Starts the `Backbone.history`
    startHistory: ->
      Backbone.history.start(pushState: true) if Backbone.history

  if App.autoInitHistory
    App.on "start", ->

      Marionette.Behaviors.behaviorsLookup = -> App.Behaviors

      removeShebang()
      routeAnchors()

      # Starts the Backbone History
      @startHistory()

      # Navigate to the `rootRoute` of the application if there is not an active
      # route
      @navigate(@rootRoute, trigger: true) unless @getCurrentRoute()

