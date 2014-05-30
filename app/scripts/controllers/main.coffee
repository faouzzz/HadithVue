'use strict'

@app

.controller 'MainController',
['$route', '$rootScope', 'appName',
($route, $rootScope, appName) ->

  $rootScope.appName = appName

  $rootScope.$on '$routeChangeSuccess', ->
    $rootScope.isHome = $route?.current?.$$route?.originalPath is '/'
    $('html, body')[if $rootScope.isHome then 'addClass' else 'removeClass']('homepage')

]
