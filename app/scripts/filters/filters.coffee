'use strict'

@app

.filter 'titlecase', ->
  (input) ->
    input = if not input? then '' else input
    formatter.titleCase(input)

.filter 'hadithtext', ['formatter', (formatter) ->
  (input) ->
    input = if not input? then '' else input
    formatter.hadithFormat input
]

.filter 'bookname', ['formatter', (formatter) ->
  (input) ->
    input = if not input? then '' else input
    formatter.bookName input
]

.filter 'babname', ['formatter', (formatter) ->
  (input) ->
    input = if not input? then '' else input
    formatter.babName input
]
