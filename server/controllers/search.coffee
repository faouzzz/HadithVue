'use strict'
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
    if !req.query.q
      return sendError req, res, 'No result'

    DB.Collection.findAll
      where: ['title_en LIKE ?', "%#{req.query.q}%"]
    .success (data) ->
      sendJson res, data

  book: (req, res) ->
    if !req.query.q
      return sendError req, res, 'No result'

    DB.HadithEnglish.findAll
      where: ['book_name LIKE ?', "%#{req.query.q}%"]
      include: [DB.Collection]
      attributes: ['id', 'book_number', 'book_id', 'book_name']
      group: 'collection_id, book_id'

    .success (data) ->
      sendJson res, data
    .error (err) ->
      sendError req, res, err

  bab: (req, res) ->
    if !req.query.q
      return sendError req, res, 'No result'

    DB.HadithEnglish.findAll
      where: ['bab_name LIKE ?', "%#{req.query.q}%"]
      include: [DB.Collection]
      attributes: ['id', 'book_number', 'book_id', 'book_name', 'bab_number', 'bab_name']
      group: 'collection_id, book_id, bab_number'
      limit: 50

    .success (data) ->
      sendJson res, data
    .error (err) ->
      sendError req, res, err

  hadith: (req, res) ->
    if !req.query.q
      return sendError req, res, 'No result'

    DB.HadithEnglish.findAll
      where: Sequelize.or(
        ['book_name LIKE ?', "%#{req.query.q}%"],
        ['bab_name LIKE ?', "%#{req.query.q}%"],
        ['hadith_text LIKE ?', "%#{req.query.q}%"])
      include: [DB.Collection]
      attributes: ['id', 'book_number', 'book_id', 'book_name', 'bab_number', 'bab_name', 'hadith_text']
      group: 'collection_id, book_id, bab_number'
      limit: 50

    .success (data) ->
      sendJson res, data
    .error (err) ->
      sendError req, res, err
