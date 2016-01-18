@App.module "Search", (Search, App, Backbone, Marionette, $, _) ->

  queryTracks = (query) ->
    tracks = new App.Entities.Tracks()
    tracks.query(query).then ->
      tracks

  searchHistory = do ->
    collection = new App.Entities.SearchHistory()
    collection.setMaxSize(5)
    collection.fetch().then ->
      collection.models = collection.models.reverse() # backbone.localStorage order workaround
    collection

  # services
  App.reqres.setHandler "tracks", queryTracks

  App.reqres.setHandler "searchHistory", ->
    searchHistory

  App.reqres.setHandler "config:resultMode", ->
    localStorage["resultMode"] || "list"

  App.commands.setHandler "set:config:resultMode", (mode) ->
    localStorage["resultMode"] = mode

  App.commands.setHandler "searchHistory:add", (query) ->
    unless _.isEmpty(query?.trim()) || searchHistory.first()?.get("query") == query
      searchHistory.add({query: query}).save()

  App.reqres.setHandler "soundcloudClientID", ->
    "5ef9b0d607bf6196a2ecc91bf05acb6a" # should be server-side
    
  class Search.Router extends Marionette.AppRouter
    appRoutes:
      "search(?q=:query)": "search"

  API =
    search: (query) ->
      @controller ||= new Search.Controller()
      @controller.showSearchPanel(query: query)

  Search.on "start", ->
    new Search.Router
      controller: API
