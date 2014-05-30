'use strict'

@app

# book id helper
.factory 'bookId', ->
  first: (book_id, collection) ->
    if !book_id? or !book_id
      book_id = '1'
      book_id = '-1' if collection is 'muslim' or collection is 'ibnmajah'
    book_id

  equal: (book_id_left, book_id_right) ->
    parseFloat(book_id_left.toString()) is parseFloat(book_id_right.toString())

