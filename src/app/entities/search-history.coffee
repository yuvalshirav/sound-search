@App.module "Entities", (Entities, App, Backbone, Marionette, $, _) ->

  class Entities.SearchHistoryItem extends Entities.Model

  class Entities.SearchHistory extends Entities.QueueCollection

    model: Entities.SearchHistoryItem
    localStorage: new Backbone.LocalStorage("search_history")
