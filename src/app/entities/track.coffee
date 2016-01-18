@App.module "Entities", (Entities, App, Backbone, Marionette, $, _) ->

  class Entities.Track extends Entities.Model

    # TODO getters for abstraction

    getImage: (size="crop") ->
      @get("artwork_url")?.replace(/large(?:(\..{3,4}))$/, "#{size}$1")

    getStreamUrl: ->
     	url = @get("stream_url")
     	if url
     		"#{url}?client_id=#{App.request('soundcloudClientID')}"
