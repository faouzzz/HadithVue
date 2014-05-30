'use strict'
path = require 'path'

datadir = __dirname + '/../hadithdata'

module.exports = (app) ->

  ###
  Send json data, or 404 if it doesn't exist
  ###
  data: (req, res) ->
    stripped = req.url.split('.')[0]
    requestedData = path.join('./', stripped + '.json')
    requestedData = path.join(datadir, requestedData.replace(/^api\//, ''))

    res.set('content-type': 'application/json; charset=utf-8')
    res.sendfile requestedData, (err) ->
      if err
        msg = "Error: data for '#{req.url}' doesn't exist.\n"
        console.log msg, err
        res.status(404).send(msg)
