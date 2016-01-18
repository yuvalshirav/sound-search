@App.module "Entities", (Entities, App, Backbone, Marionette, $, _) ->

  class Entities.Settings extends Entities.Model

    localStorage: new Backbone.LocalStorage("settings")
