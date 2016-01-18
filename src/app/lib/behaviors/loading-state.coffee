@App.module "Behaviors", (Behaviors, App, Backbone, Marionette, $, _) ->

  class Behaviors.LoadingState extends Marionette.Behavior
    defaults:
      selector: null
      className: "loading"
    modelEvents:
      request: "startLoadingState"
      sync: "endLoadingState"
      error: "endLoadingState"
    collectionEvents:
      request: "startLoadingState"
      sync: "endLoadingState"
      error: "endLoadingState"

    startLoadingState: ->
      @setLoadingState(true)

    endLoadingState: ->
      @setLoadingState(false)

    setLoadingState: (state) ->
      $element = if @options.selector then @$el.find(@options.selector) else @$el
      $element.toggleClass(@options.className, state)
