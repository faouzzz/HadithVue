'use strict'
path = require 'path'

Db = require('mongodb').Db
Connection = require('mongodb').Connection
Server = require('mongodb').Server

datadir = __dirname + '/../hadithdata'

db = new Db('IslamVue', new Server('localhost', 27017, {}), {native_parser:true, safe:true})

module.exports = (app) ->

  collection: (req, res) ->
    db.open (err, db) ->
      res.set 'content-type': 'application/json; charset=utf-8'

      if req.params.collection?
        db.collection('hadithCollections')
          .find({code: req.params.collection})
          .sort({_id: 1})
          .toArray (err, docs) ->
            if docs.length is 1
              res.json docs[0]
            else
              res.status 500
              res.json 500, error: "No such collection."
            db.close()

      else
        db.collection('hadithCollections')
        .find().sort({_id: 1})
        .toArray (err, docs) ->
          res.json docs
          db.close()


  hadith: (req, res) ->
    db.open (err, db) ->
      collection = req.params.collection
      book = req.params.book
      page = req.params.page ? 1

      if book?
        book_id = "#{book}.0"
      else
        book_id = '1.0'
        book_id = '-1.0' if collection is 'muslim' or collection is 'ibnmajah'
        book_id = '35.2' if collection is 'nasai' and book is '35b'

      console.log book_id

      per_page = 10

      collections =
        db.collection('hadithEnglishTexts')
          .find({collection: collection, book_id: book_id})
          .skip(per_page * (page - 1)).limit(per_page)
          .sort({_id: 1})

      collections.toArray (err, docs) ->
        res.set 'content-type': 'application/json; charset=utf-8'
        if docs.length
          res.json docs
        else
          res.status 500
          res.json 500, error: 'No such book/page.'
        db.close()

