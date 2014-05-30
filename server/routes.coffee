'use strict'

module.exports = (app, express) ->
  rootRouter = express.Router()
  apiRouter = express.Router()

  # the router controllers
  api = require('./controllers/api') app
  search = require('./controllers/search') app
  index = require('./controllers') app

  # API endpoints
  apiRouter.get '/collection/:collection?', api.collection
  apiRouter.get '/book/:collection', api.book
  apiRouter.get '/hadith/:collection/:book?', api.hadith

  # simple searches
  apiRouter.get '/search/collection', search.collection
  apiRouter.get '/search/book', search.book
  apiRouter.get '/search/bab', search.bab
  apiRouter.get '/search/hadith', search.hadith

  # Assets routing
  rootRouter.get '/partials/*', index.partials
  rootRouter.get /^\/(scripts|data|bower|styles|images|vendor)\//, index.assets

  # All other routes to use Angular routing in app/scripts/app.coffee
  rootRouter.get '/*', index.index

  # apply the routes
  app.use '/v3', apiRouter
  app.use '/', rootRouter
