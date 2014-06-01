'use strict'

@app

.controller 'SearchViewController',
['$scope', '$location', '$http', 'collectionService', 'bookId',
($scope, $location, $http, collectionService, bookId) ->

  $scope.collection = $routeParams.collection
  $scope.book_id    = bookId.first $routeParams.book_id, $scope.collection
  $scope.language   = $routeParams.language ? 'english'

  $http.get("/v3/search/bab?q=water").success (data) ->
    $scope.items = data

]
