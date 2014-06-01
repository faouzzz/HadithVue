'use strict'

@app

.controller 'MainController',
['$rootScope', 'config',
($rootScope, config) ->
  document.title = config.appName
  $rootScope.appName = config.appName

  $rootScope.$on '$stateChangeSuccess', (event, toState, toParams, fromState, fromParams) ->
    $rootScope.isHome = toState.name is 'home'

    $body = $('body')
    $body[if $rootScope.isHome then 'addClass' else 'removeClass']('homepage')

    if toState.name.indexOf('hadith') is 0
      $body.removeClass (index, classNames) ->
        (classNames.match(/\bcollection-\S+/g) or []).join ' '
      $body.addClass "collection-#{toParams.collection}"
]
