'use strict'

@app

.directive 'hadithList', ->
  restrict: 'E'
  replace: true
  templateUrl: 'partials/hadith--list'

.directive 'hadithHeader', ->
  restrict: 'E'
  replace: true
  templateUrl: 'partials/hadith--header'

.directive 'hadithSidebar', ->
  restrict: 'E'
  replace: true
  templateUrl: 'partials/hadith--sidebar'

.directive 'hadithFooter', ['$location', 'domFx', ($location, domFx) ->
  restrict: 'E'
  replace: true
  templateUrl: 'partials/hadith--footer'
  link: (scope, elem, attr) ->
    keydown = (ev) ->
      switch ev.keyCode
        when 36
          ev.preventDefault()
          domFx.scrollTop()
        when 188
          if scope.info.book.prev?
            ev.preventDefault()
            $(document).off 'keydown', keydown
            $location.path scope.info.book.prev.link
            scope.$apply()
        when 190
          if scope.info.book.next?
            ev.preventDefault()
            $(document).off 'keydown', keydown
            $location.path scope.info.book.next.link
            scope.$apply()

    $(document).keydown keydown
]

.directive 'searchBox', ['$timeout', ($timeout) ->
  restrict: 'E'
  replace: true
  templateUrl: 'partials/hadith--searchbox'
  link: (scope, elem, attr) ->
    transitionEnd = 'webkitTransitionEnd mozTransitionEnd MSTransitionEnd otransitionend transitionend'
    input = elem.find('input')
    magnifier = elem.find('a')

    input.blur (ev) ->
      elem.removeClass('focused')
      scope.$apply()

    magnifier.click (ev) ->
      ev.preventDefault()
      elem.addClass('focused')

      input.one transitionEnd, (ev) ->
        input.off transitionEnd
        input.focus()

      scope.$apply()

]
