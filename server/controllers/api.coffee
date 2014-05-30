'use strict'
_ = require 'lodash'
_s = require 'underscore.string'
models = require '../models/mysql'
Sequelize = models.Sequelize
DB = models.DB
sleep =

String::bool = ->
  (/^(true|yes|on|1)$/i).test(this)

module.exports = (app) ->

  sendJson = (res, json) ->
    res.set 'content-type': 'application/json; charset=utf-8'
    res.json json

  sendError = (req, res, msg) ->
    res.json 500, { error: msg, params: req.params, query: req.query }

  collection: (req, res) ->
    collection = req.params.collection

    if req.params.collection?
      DB.Collection.find
        where: code: req.params.collection

      .complete (err, data) ->
        if !!err or !data?
          sendError req, res, "No such collection: #{req.params.collection}."
        else
          sendJson res, data

    else
      DB.Collection.findAndCountAll().success (data) ->
        sendJson res, data

  book: (req, res) ->
    DB.Collection.count(where: code: req.params.collection)
    .success (count) ->
      if count > 0
        DB.HadithEnglish.findAndCountAll
          attributes: ['collection_code', 'book_number', 'book_id', 'book_name']
          where: collection_code: req.params.collection
          group: 'collection_id, book_id'
          order: 'book_id ASC'

        .complete (err, data) ->
          if !!err or !data?
            sendError req, res, 'No such collection.'
          else
            sendJson res, data

      else
        sendError req, res, "No such collection: #{req.params.collection}."

      # DB.Book.findAll
      #   where: collection: req.params.collection
      # .complete (err, data) ->
      #   if !!err or !data?
      #     sendError req, res, 'No such book.'
      #   else
      #     sendJson res, data

  hadith: (req, res) ->

    collection = req.params.collection
    book = req.params.book
    after = req.query.after

    if book?
      book_id = book
    else
      book_id = '1'
      book_id = '-1' if collection is 'muslim' or collection is 'ibnmajah'
    book_id = '35.2' if collection is 'nasai' and book is '35b'

    DB.Collection.count(where: code: collection)
    .success (count) ->
      if count > 0
        DB.HadithEnglish.findAndCountAll
          where:
            Sequelize.and(
              ['collection_code = ?', collection],
              ['book_id LIKE ?', book_id]
            )
          limit: 10
          offset: after

        .complete (err, data) ->
          if !!err or !data?
            sendError req, res, 'No data returned.'
          else
            if data.count > 0
              sendJson res, data
            else
              sendError req, res, 'No data returned.'

      else
        sendError req, res, "No such collection: #{collection}."
