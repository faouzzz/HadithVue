'use strict'

@app

# Book list controller
.controller 'BookListController',
['$scope', '$location', '$timeout', 'collectionService', 'bookService', 'utils',
($scope, $location, $timeout, collectionService, bookService, utils) ->

  collection = $scope.$stateParams.collection
  book_id    = utils.firstBookId $scope.$stateParams.book_id, collection
  language   = $scope.$stateParams.language ? 'english'

  $scope.isActive = (col, id) ->
    collection = $scope.$stateParams.collection
    book_id    = utils.firstBookId $scope.$stateParams.book_id, collection

    col is collection and utils.equalBookId(id, book_id)

  bookService.get collection, book_id, (srv) ->
    $scope.info.book = srv.info
    $scope.books = srv.items
]
