'use strict'

@app

# Book list controller
.controller 'BookListController',
['$scope', '$location', '$timeout', 'collectionService', 'bookService', 'bookId',
($scope, $location, $timeout, collectionService, bookService, bookId) ->

  collection = $scope.$stateParams.collection
  book_id    = bookId.first $scope.$stateParams.book_id, collection
  language   = $scope.$stateParams.language ? 'english'

  $scope.isActive = (col, id) ->
    collection = $scope.$stateParams.collection
    book_id    = bookId.first $scope.$stateParams.book_id, collection

    col is collection and bookId.equal(id, book_id)

  bookService.get collection, book_id, (srv) ->
    $scope.info.book = srv.info
    $scope.books = srv.items
]
