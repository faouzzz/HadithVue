'use strict'

@$DI = (arrayStr, fn) ->
  args = Array::slice.call(arguments)
  if args.length is 1 and typeof args[0] is 'function'
    args[0]
  else if args.length > 2 and typeof args[args.length - 1] is 'function'
    args
  else
    arrayStr.toString().trim().split(/\s+/).concat(fn)

# monkey-patch angular methods
'config factory directive filter run controller provider service animation'.split ' '
.forEach (method) =>
  @app["#{method}_DI"] = =>
    @app[method] $DI.apply(app, Array::slice.call(arguments))
