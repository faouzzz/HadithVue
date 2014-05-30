'use strict'
path = require 'path'

module.exports = (app) ->

  ###
  Send partial, or 404 if it doesn't exist
  ###
  partials: (req, res) ->
    stripped = req.url.split('.')[0]
    requestedView = path.join('./', stripped)
    res.render requestedView, (err, html) ->
      if err
        console.log "Error rendering partial '" + requestedView + "'\n", err
        res.status(404).send(404)
      else
        res.send html


  ###
  Assets already sent using static middleware, only got here if it doesn't exist
  ###
  assets: (req, res) ->
    res.status(404).send(404)


  ###
  Send our single page app
  ###
  index: (req, res) ->
    res.render 'index'


  ###
  Error 404
  ###
  error404: (req, res) ->
    res.status 404
    res.render '404'
