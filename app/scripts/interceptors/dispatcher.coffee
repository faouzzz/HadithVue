'use strict'

@app

.config ['$httpProvider', ($httpProvider) ->
  $httpProvider.interceptors.push ['$log', '$rootScope', '$q', ($log, $rootScope, $q) ->
    request: (request) ->
      $rootScope.$broadcast "requestStart", request
      request

    requestError: (request) ->
      $rootScope.$broadcast "requestError", request
      $q.reject request

    response: (response) ->
      $rootScope.$broadcast "responseSuccess", response
      response

    responseError: (response) ->
      $rootScope.$broadcast "responseError", response
      $q.reject response
  ]
]
