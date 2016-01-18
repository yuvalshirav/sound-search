@App.module "Search", (Search, App, Backbone, Marionette, $, _) ->

  class Search.Controller extends App.Controllers.Application

    initialize: ->
      layout = new Search.Views.Layout()
      @show(layout)
      @showHistoryPanel()
      @setupListeners()
      
    setupListeners: ->
      App.vent.on "tracks:search", (query) =>
        App.navigate("search?q=#{query}")
        @showSearchPanel(query: query)

      App.vent.on "tracks:selected", @showTrackPanel

    showSearchPanel: ({query}) ->
      @getMainView().showChildView("search", new Search.Views.Search(query: query))
      if query?.trim()
        App.request("tracks", query).then (tracks) =>
          @getMainView().showChildView("search", new Search.Views.Search(query: query, results: tracks))
        .fail =>
          toastr.error("SoundCloud error")
      @addToHistory(query)

    showTrackPanel: (model, mode) =>
      @getMainView().showChildView("track", new Search.Views.Track(model: model, mode: mode))

    showHistoryPanel: ->
      searchHistory = App.request("searchHistory")
      @getMainView().showChildView("history", new Search.Views.SearchHistory(collection: searchHistory))

    addToHistory: (query) ->
      App.execute("searchHistory:add", query)

