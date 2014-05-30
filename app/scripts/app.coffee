'use strict'

# initialize app
@app = angular.module('HadithVue', [
  'ngResource'
  'ngSanitize'
  'ngRoute'

  # others
  'ui.router'
  'ui.utils'
  'angular-data.DSCacheFactory'
  'picardy.fontawesome'
  'angular-loading-bar'
  'headroom'
])

# cofigurations
.config ['$stateProvider', '$urlRouterProvider'
($stateProvider, $urlRouterProvider) ->
  $urlRouterProvider.otherwise '/'

  hadith_views =
    '':
      templateUrl: 'partials/hadith--list'
      controller: 'HadithListController'
    'header':
      templateUrl: 'partials/hadith--header'
      controller: 'CollectionListController'
    'sidebar':
      templateUrl: 'partials/hadith--sidebar'
      controller: 'BookListController'
    'footer':
      templateUrl: 'partials/hadith--footer'
      controller: 'BookListController'

  $stateProvider
    .state 'index',
      url: '/'
      templateUrl: 'partials/home'
      controller: 'CollectionListController'

    .state 'hadith',
      abstract: true
      url: '/hadith'
      templateUrl: 'partials/hadith'
      controller: 'HadithViewController'

    .state 'hadith.bookid',
      url: '/:collection/:book_id'
      views: hadith_views

    .state 'hadith.nobookid',
      url: '/:collection'
      views: hadith_views
]

.config ['$routeProvider', '$locationProvider',
($routeProvider, $locationProvider) ->
  # $routeProvider

  #   .when '/',
  #     templateUrl: 'partials/home'

  #   .when "/hadith/:collection/:book_id?",
  #     templateUrl: 'partials/hadith'
  #     controller: 'HadithViewController'

  #   .when "/search",
  #     templateUrl: 'partials/search'
  #     controller: 'SearchViewController'

  #   .otherwise
  #     templateUrl: 'partials/x404'

  $locationProvider.html5Mode true
]

.config ['cfpLoadingBarProvider',
(cfpLoadingBarProvider) ->
  cfpLoadingBarProvider.includeSpinner = false
]

# vars
.value 'appName', 'HadithVue'

# run app
.run ['$rootScope', '$http', '$state', '$stateParams', 'DSCacheFactory'
($rootScope, $http, $state, $stateParams, DSCacheFactory) ->
  $rootScope.$state = $state
  $rootScope.$stateParams = $stateParams

  DSCacheFactory 'ivCache',
    maxAge: 900000 # Items added to this cache expire after 15 minutes.
    cacheFlushInterval: 6000000 # This cache will clear itself every hour.
    deleteOnExpire: 'aggressive' # Items will be deleted from this cache right when they expire.

  $http.defaults.cache = DSCacheFactory.get 'ivCache'
]

# @$DI = (arrayStr, fn) ->
#   args = Array::slice.call(arguments)
#   if args.length is 1 and typeof args[0] is 'function'
#     args[0]
#   else if args.length > 2 and typeof args[args.length - 1] is 'function'
#     args
#   else
#     arrayStr.toString().trim().split(/\s+/).concat(fn)

# # monkey-patch angular methods
# ['config', 'factory', 'directive', 'filter', 'run', 'controller', 'provider', 'service', 'animation'].forEach (method) ->
#   app["#{method}_DI"] = ->
#     app[method] $DI.apply(app, Array::slice.call(arguments))
