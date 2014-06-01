'use strict'

class Service
  items: []
  total: 0
  info:
    current: null
    prev: null
    next: null
  collection: null
  book_id: null

  constructor: (@$rootScope, @$http, @formatter, @utils) ->

  get: (collection, book_id, callback = ->) ->
    @$http.get("/v3/book/#{collection}").success (data) =>
      # only load if new collection
      if @collection isnt collection
        return unless data.rows.length

        @total = data.count
        @items = []
        currentTitle = null
        titlePartNum = 1

        for book in data.rows
          book_name = @formatter.bookName book.book_name

          if currentTitle isnt book_name
            currentTitle = book_name
            titlePartNum = 1
            part_num = null
          else
            if titlePartNum is 1
              @items[@items.length - 1].part_num = titlePartNum
            part_num = ++titlePartNum

          @items.push
            book_id: book.book_id
            book_number: book.book_number
            book_name: book_name
            collection: collection
            part_num: part_num
            link: "/hadith/#{collection}/#{book.book_id}"

      if @items.length
        index = _.findIndex @items, (bk) =>
          # immediately return first index if book is 0
          return true if book_id is '-1'
          @utils.equalBookId(bk.book_id, book_id)

        @info.current = @items[index]
        @info.prev = @items[index - 1] ? null
        @info.next = @items[index + 1] ? null

        @collection = collection

    .finally =>
      callback @
      @$rootScope.$broadcast('doneLoading', 'book')

@app.service 'bookService', ['$rootScope', '$http', 'formatter', 'utils', Service]
