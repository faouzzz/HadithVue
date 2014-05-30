'use strict'
require 'colors'
express = require 'express'

###
Main application file
###

# Set default node environment to development
process.env.NODE_ENV = process.env.NODE_ENV or 'development'
config = require './server/config/config'

# Setup Express
app = express()

require('./server/config/express') app
require('./server/routes') app, express

# Start server
app.listen config.port, config.ip, ->
  console.log 'Express server listening on %s:%d, in %s mode'.green.bold, config.ip, config.port, app.get('env')

# Expose app
exports = module.exports = app
