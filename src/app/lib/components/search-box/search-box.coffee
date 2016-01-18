@App.module "Components", (Components, App, Backbone, Marionette, $, _) ->

  class Components.SearchBox extends App.Views.ItemView
    # options: value, placeholder, autofocus
    template: "search-box/search-box"
    ui:
      searchButton: "button.js-search"
      input: "input"
    events:
      "click @ui.searchButton": "onClick"
      "keydown @ui.input": "onKeydown"
    
    serializeData: ->
      placeholder: @options.placeholder
      autofocus: @options.autofocus
      value: @options.value

    triggerSearch: ->
      @triggerMethod("search", @ui.input.val())

    onClick: ->
      @triggerSearch()

    onKeydown: (event) ->
      if event.keyCode == 13 # enter
        @triggerSearch()
        @ui.input?.blur?()
