'use strict'

@app

# The parent controller
.controller 'HadithViewController',
['$rootScope', '$scope', '$location', 'utils',
($rootScope, $scope, $location, utils) ->
  # check collection validity
  unless utils.collectionExists $scope.$stateParams.collection
    $scope.$emit 'invalidCollection'

  # bind to scope
  $scope.info =
    collection: {}
    book: {}

  $scope.hadith = {}
]

# The hadith list controller
.controller 'HadithListController',
['$scope', '$location', 'hadithService', 'utils',
($scope, $location, hadithService, utils) ->

  collection = $scope.$stateParams.collection
  book_id    = utils.firstBookId $scope.$stateParams.book_id, collection
  language   = $scope.$stateParams.language ? 'english'

  # functions
  # should we show chapter?
  $scope.showBab = (index) ->
    # first condition: show if have bab_number AND bab_name
    ( !!$scope.hadith.items[index].bab_number and !!$scope.hadith.items[index].bab_name ) and

    # show if this is the first hadith on view
    ( ( !$scope.hadith.items[index - 1]? ) or

    # show if new topic
    ( $scope.hadith.items[index].bab_number isnt $scope.hadith.items[index - 1].bab_number and
      $scope.hadith.items[index].bab_name isnt $scope.hadith.items[index - 1].bab_name ) )

  # fetch all hadith for current collection
  $scope.hadith.loadMore = ->
    hadithService.loadMore (srv) ->
      $scope.hadith.items = srv.items
      $scope.hadith.total = srv.total
      $scope.hadith.loaded = srv.loaded
      $scope.hadith.busy = srv.busy

  hadithService.load collection, book_id, language, (srv) ->
    $scope.hadith.items = srv.items
    $scope.hadith.total = srv.total
    $scope.hadith.loaded = srv.loaded
    $scope.hadith.busy = srv.busy
]
