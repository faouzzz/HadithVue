'use strict'

@app

.controller 'SearchViewController',
['$scope', '$location', '$http', 'collectionService', 'utils',
($scope, $location, $http, collectionService, utils) ->

  $scope.collection = $routeParams.collection
  $scope.book_id    = utils.firstBookId $routeParams.book_id, $scope.collection
  $scope.language   = $routeParams.language ? 'english'

  $http.get("/v3/search/bab?q=water").success (data) ->
    $scope.items = data

]
