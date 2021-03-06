'use strict'
express = require 'express'
favicon = require 'serve-favicon'
morgan = require 'morgan'
compression = require 'compression'
bodyParser = require 'body-parser'
methodOverride = require 'method-override'
cookieParser = require 'cookie-parser'
session = require 'express-session'
errorHandler = require 'errorhandler'
path = require 'path'
config = require './config'

###
Express configuration
###
module.exports = (app) ->
  env = app.get 'env'

  if 'development' is env
    app.use require('connect-livereload')()

    # Disable caching of scripts for easier testing
    app.use noCache = (req, res, next) ->
      if req.url.indexOf('/scripts/') is 0
        res.header 'Cache-Control', 'no-cache, no-store, must-revalidate'
        res.header 'Pragma', 'no-cache'
        res.header 'Expires', 0
      next()

    app.use express.static path.join(config.root, '.tmp')
    app.use express.static path.join(config.root, 'app')
    app.set 'views', config.root + '/app/views'
    app.set 'json spaces', 2

  if 'production' is env
    app.use compression()
    app.use favicon path.join(config.root, 'public', 'favicon.ico')
    app.use express.static path.join(config.root, 'public')
    app.set 'views', config.root + '/views'
    app.set 'json spaces', 0

  app.set 'view engine', 'jade'
  # app.locals.pretty = true
  app.locals.doctype = 'html'

  app.use morgan('dev')
  app.use bodyParser.urlencoded(extended: true)
  app.use bodyParser.json()
  app.use methodOverride()

  # Error handler - has to be last
  app.use errorHandler() if 'development' is app.get('env')
