require 'bourbon-compass'
require 'neat-compass'

Sass::Script::Number.precision = 10

sass_dir = 'app/styles'
css_dir = '.tmp/styles'
generated_images_dir = '.tmp/images/generated'
images_dir = 'app/images'
javascripts_dir = 'app/scripts'
fonts_dir = 'app/styles/fonts'
http_images_path = 'app/images'
http_generated_images_path = 'app/images/generated'
http_fonts_path = 'app/styles/fonts'
relative_assets = false

add_import_path 'app/bower/sass-toolkit/stylesheets'
add_import_path 'app/bower/scut/dist'
