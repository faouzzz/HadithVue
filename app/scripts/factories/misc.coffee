'use strict'

$win  = $(@)
$body = $('body')

domFx =
  scrollTop: ->
    $body.velocity 'scroll', { duration: 300, easing: 'easeInOutQuint' }

  # hadithLoaded: ->
  #   # new WOW().init()
  #   # domFx.scrollTop()

  #   # $content = $('section.hadithView .content')


  #   # $content.find('.hadith')
  #   #   .velocity 'scroll', { duration: 1500, easing: 'spring' }
  #   #   .velocity opacity: 1

  #   # $win.scroll ->
  #   #   scroll = $win.scrollTop()

  #   #   # $sidebar.css transform: "translateY(#{scroll}px)"
  #   #   # $sidebar.css transform: "translateY(#{scroll / 1.5}px)"

  #   # # keypress
  #   # $(document).keydown (e) ->
  #   #   code = e.keyCode || e.which
  #   #   switch code
  #   #     when 37 then console.log 'left'
  #   #     when 39 then console.log 'right'

  #   return

@app.factory 'domFx', ($window, $timeout) ->
  # debounce all functions
  _.reduce domFx, ((result, fn, name) ->
    result[name] = _.debounce((->
      fn.call()
    ), 10)
    return result
  ), {}
