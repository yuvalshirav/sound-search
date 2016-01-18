@App.module "Entities", (Entities, App, Backbone, Marionette, $, _) ->

  class Entities.Tracks extends Backbone.PageableCollection

  	model: Entities.Track
  	url: "http://api.soundcloud.com/tracks"
  	mode: "infinite"

  	state:
  		firstPage: 0
  		pageSize: 6 # TODO let the view set this

  	queryParams:
  		pageSize: 'limit'

  	fetch: (options={}) ->
  		authenticatedOptions = _.tap _.clone(options), (authenticatedOptions) =>
  			authenticatedOptions.data = _.extend({client_id: App.request("soundcloudClientID"), linked_partitioning: 1}, options.data)
  			authenticatedOptions
  		super(authenticatedOptions)

  	query: (queryString) ->
  		@fetch(data: {q: queryString})

  	parseRecords: (response) ->
  		response.collection

  	parseLinks: (response) ->
  		{next: response.next_href}
