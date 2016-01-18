@App.module "Search.Views", (Views, App, Backbone, Marionette, $, _) ->

  class Views.Layout extends App.Views.Layout
    template: "search/layout"
    className: "page-header"
    regions:
      search: "#search-panel"
      track: "#track-panel"
      history: "#history-panel"

  class Views.Search extends App.Views.Layout
    # options: query, results
    template: "search/search"
    regions:
      searchBox: ".search-box"
      results: ".results"
    childEvents:
      search: "onSearch"
      "track:selected": "onTrackSelected"

    onShow: ->
      @showChildView "searchBox", new App.Components.SearchBox
        value: @options.query
        placeholder: "Search for tracks..."
        autofocus: _.isEmpty(@options.query)

      @showChildView "results", new Views.SearchResults(collection: @options.results)

    onSearch: (view, query) ->
      App.vent.trigger("tracks:search", query)

    onTrackSelected: (view, model) ->
      @showChildView "track", new Views.Track(model: model)

  class Views.SearchResult extends App.Views.ItemView
    tagName: "li"
    className: "list-group-item result"
    template: "search/search-result"
    triggers:
      click: "clicked"

    serializeData: ->
      _.extend @model.attributes,
        image: @model.getImage()

  class Views.SearchResults extends App.Views.CompositeView
    template: "search/search-results"
    childViewContainer: "ul"
    childView: Views.SearchResult
    events:
      "click .next": "onNext"
      "click .previous": "onPrevious"
      "click .list-mode": "onList"
      "click .grid-mode": "onGrid"
    collectionEvents:
      sync: "render"
      error: "onError"
    childEvents:
      clicked: "onTrackSelected"
    bindingsModel: "status"
    bindings:
      ".result-list":
        classes:
          grid:
            observe: "mode"
            onGet: (mode) ->
              mode == "grid"
          list:
            observe: "mode"
            onGet: (mode) ->
              mode == "list"
    behaviors:
      LoadingState:
        selector: ".result-list"
          
    # TODO emptyView, loadingView

    initialize: ->
      @status = new Backbone.Model
        mode: App.request("config:resultMode")
      @listenTo @status, "change:mode", (_, mode) ->
        App.execute("set:config:resultMode", mode)
      super

    onRender: ->
      $("body").scrollTop(0)

    serializeData: ->
      hasResults: !!@collection?.length
      hasNext: @collection?.hasNextPage()
      hasPrev: @collection?.hasPreviousPage()

    onTrackSelected: (view, {model}) ->
      App.vent.trigger("tracks:selected", model, @status.get("mode"))
      @$(".selected").removeClass("selected")
      # TODO no animation on mode change
      _.defer ->
        view.$el.addClass("selected")

    onNext: ->
      if @collection.getNextPage()
        @render()

    onPrevious: ->
      if @collection.getPreviousPage()
        @render()

    setMode: (mode) ->
      @status.set("mode", mode)
      _.defer ->
        $("body").scrollTop(0)

    onList: ->
      @setMode("list")
      
    onGrid: ->
      @setMode("grid")

    onError: ->
      toastr.error("SoundCloud error")

  class Views.Track extends App.Views.ItemView
    template: "search/track"
    className: "track"
    ui:
      player: "audio"
    events:
      "click .js-play": "onPlayToggle"
    bindingsModel: "status"
    bindings:
      ".play":
        classes:
          playing: "playing"
          list:
            observe: "mode"
            onGet: (mode) ->
              mode == "list"
      "audio":
        attributes: [{
          name: "autoplay"
          observe: "playing"
        }]
        
    initialize: ({@mode})->
      @status = new Backbone.Model
        playing: false
        mode: @mode
      super

    onRender: ->
      @ui.player.on "play.controls", =>
        @status.set("playing", true)

      @ui.player.on "pause.controls", =>
        @status.set("playing", false)

    onPlayToggle: ->
      playing = !@status.get("playing")
      @status.set("playing", playing)
      if playing
        @ui.player[0].play()
      else
        @ui.player[0].pause()

    serializeData: ->
      _.extend @model.attributes,
        image: @model.getImage()
        playerUrl: @model.getStreamUrl()

    destroy: ->
      @ui.player.off(".controls")

  class Views.SearchHistoryItem extends App.Views.ItemView
    tagName: "li"
    className: "list-group-item"
    template: "search/search-history-item"

  class Views.SearchHistory extends App.Views.CompositeView
    template: "search/search-history"
    childViewContainer: "ul"
    childView: Views.SearchHistoryItem
