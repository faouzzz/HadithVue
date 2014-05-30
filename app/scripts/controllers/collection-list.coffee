'use strict'

@app

.controller 'CollectionListController',
['$rootScope', '$scope', 'collectionService', 'bookId',
($rootScope, $scope, collectionService, bookId) ->

  $scope.isActive = (col) -> col is $scope.$stateParams.collection

  collectionService.get (srv) ->
    $scope.collections = srv.items
    if $scope.info?
      $scope.info.collection = _.find srv.items, code: $scope.$stateParams.collection
]
