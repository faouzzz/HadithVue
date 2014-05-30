'use strict'

@app

# animate links scroll to top
.directive 'backTop', ['$timeout', '$location', 'domFx', ($timeout, $location, domFx) ->
  restrict: 'A'
  link: (scope, elm, attr) ->
    elm.click (ev) ->
      if attr.href is '#' or attr.href is '#top'
        ev.preventDefault()
        domFx.scrollTop()
]


# # handle effects on header
# app.directive 'headerFx', ['$window', '$timeout', ($window, $timeout) ->
#   restrict: 'A'
#   link: (scope, elm, attr) ->
#     # $win = $($window)

#     # nearTop = (scroll) ->
#     #   if scroll < 20
#     #     elm.removeClass('not-top').addClass('top')
#     #   else
#     #     elm.addClass('not-top').removeClass('top')
#     # nearTop($win.scrollTop())
#     # lastScrollTop = 0
#     # $win.scroll _.throttle (->
#     #   scrollTop = $win.scrollTop()
#     #   nearTop(scrollTop)

#     #   # if scrollTop < 100 or scrollTop < lastScrollTop
#     #   #   elm.removeClass 'hide'
#     #   # else
#     #   #   elm.addClass 'hide'
#     #   # lastScrollTop = scrollTop
#     # ), 500
# ]


# # handle effects of footer
# app.directive 'footerFx', ['$window', '$timeout', ($window, $timeout) ->
#   restrict: 'A'
#   link: (scope, elm, attr) ->
#     # $win = $($window)
#     # $timeout (-> elm.addClass 'show'), 50

#     # lastScrollTop = 0
#     # $win.scroll _.throttle (->
#     #   scrollTop = $win.scrollTop()
#     #   if scrollTop < 20 or scrollTop < lastScrollTop
#     #     elm.addClass 'show'
#     #   else
#     #     elm.removeClass 'show'
#     #   lastScrollTop = scrollTop
#     # ), 250
# ]
