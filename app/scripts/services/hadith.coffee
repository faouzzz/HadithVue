'use strict'

class Service
  items: []
  total: 0
  loaded: 0
  busy: false

  constructor: (@$rootScope, @$http) ->

  load: (@collection, @book, @language = 'english', callback = ->) ->
    # reset and load new @items
    @busy = true
    @$http.get("/v3/hadith/#{@collection}/#{@book}")
    .success (data) =>
      @items = data.rows
      @total = parseInt data.count
    .finally =>
      @loaded = @items.length
      @busy = false
      @$rootScope.$broadcast('doneLoading', 'hadith-initial')
      callback @

  loadMore: (callback = ->) ->
    if !@busy and @loaded < @total
      # append new @items
      @busy = true
      @$http.get("/v3/hadith/#{@collection}/#{@book}?after=#{@items.length}")
      .success (data) =>
        @items.push.apply @items, data.rows
      .finally =>
        @loaded = @items.length
        @busy = false
        callback @
        @$rootScope.$broadcast('doneLoading', 'hadith-more')

  search: (query, callback = ->) ->
    @$http.get("/v3/search/hadith?q=#{query}")
    .success (data) =>
      callback data


@app.service 'hadithService', ['$rootScope', '$http', Service]
