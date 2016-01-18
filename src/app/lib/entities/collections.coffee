@App.module "Entities", (Entities, App, Backbone, Marionette, $, _) ->

  class Entities.Collection extends Backbone.Collection

  class Entities.QueueCollection extends Backbone.Collection

  	setMaxSize: (maxSize) ->
  		@maxSize = maxSize

  	add: (models, options={}) ->
  		if @maxSize && @length == @maxSize
  			@last()?.destroy()
  		super(models, _.extend({at: 0}, options))
