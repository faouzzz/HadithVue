'use strict'

@app

.controller 'MainController',
['$rootScope', '$location', 'config', 'domFx',
($rootScope, $location, config, domFx) ->
  document.title = config.appName
  $rootScope.appName = config.appName

  $rootScope.$on '$stateChangeSuccess', (event, toState, toParams) ->
    $rootScope.isHome = toState.name is 'home'

    $body = $('body')
    $body[if $rootScope.isHome then 'addClass' else 'removeClass']('homepage')

    if toState.name.indexOf('hadith') is 0
      $body.removeClass (index, classNames) ->
        (classNames.match(/\bcollection-\S+/g) or []).join ' '
      $body.addClass "collection-#{toParams.collection}"

  errorHandler = -> $rootScope.$state.go('x404')

  $rootScope.$on 'responseError', errorHandler
  $rootScope.$on 'invalidCollection', errorHandler

  $rootScope.$on 'doneLoading', (ev, type) ->
    if type is 'hadith-initial'
      domFx.scrollTop()
]
