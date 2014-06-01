'use strict'

@app

.controller 'CollectionListController',
['$rootScope', '$scope', 'collectionService',
($rootScope, $scope, collectionService) ->

  $scope.isActive = (col) -> col is $scope.$stateParams.collection

  collectionService.get (srv) ->
    $scope.collections = srv.items
    if $scope.info?
      $scope.info.collection = _.find srv.items, code: $scope.$stateParams.collection
]
