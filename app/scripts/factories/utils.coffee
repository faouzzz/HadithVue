'use strict'

@app

# utilities
.factory 'utils', ->
  # get the first gook id of a certain collection
  firstBookId: (book_id, collection) ->
    if !book_id? or !book_id
      book_id = '1'
      book_id = '-1' if collection is 'muslim' or collection is 'ibnmajah'
    book_id

  # check book if equality
  equalBookId: (book_id_left, book_id_right) ->
    parseFloat(book_id_left.toString()) is parseFloat(book_id_right.toString())

  collectionExists: (code) ->
    _.include([
      "bukhari"
      "muslim"
      "nasai"
      "abudawud"
      "tirmidhi"
      "ibnmajah"
      "malik"
      "nawawi40"
      "riyadussaliheen"
      "adab"
      "qudsi40"
      "shamail"
      "bulugh"
    ], code)
