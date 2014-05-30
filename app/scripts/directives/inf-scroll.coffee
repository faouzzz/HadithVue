'use strict'

@app

.directive "infScroll", ['$window', '$timeout', ($window, $timeout) ->
  SCROLL_THROTTLE = 50

  scope:
    callback: "&infScroll"
    distance: "=infScrollDistance"
    disabled: "=infScrollDisabled"

  link: (scope, elem, attrs) ->
    $win = angular.element($window)
    onScroll = _.throttle ->

      # Do nothing if infinite scroll has been disabled
      return  if scope.disabled
      windowHeight = $win.height()
      elementBottom = elem.offset().top + elem.height()
      windowBottom = windowHeight + $win.scrollTop()
      remaining = elementBottom - windowBottom
      shouldGetMore = (remaining - parseInt(scope.distance or 0, 10) <= 0)
      $timeout scope.callback  if shouldGetMore
      return
    , SCROLL_THROTTLE

    # Check immediately if we need more items upon reenabling.
    scope.$watch "disabled", onScroll
    $win.bind "scroll", onScroll

    # Remove window scroll handler when this element is removed.
    scope.$on "$destroy", ->
      $win.unbind "scroll", onScroll


    # Check on next event loop to give the browser a moment to paint.
    # Otherwise, the calculations may be off.
    $timeout onScroll
]
