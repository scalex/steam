require File.expand_path(File.dirname(__FILE__) + '/app/boot')

require 'sprockets'

stylesheets = Sprockets::Environment.new
stylesheets.append_path 'app/assets/styles'

javascripts = Sprockets::Environment.new
javascripts.append_path 'app/assets/scripts'

fonts = Sprockets::Environment.new
fonts.append_path 'app/assets/fonts'

images = Sprockets::Environment.new
images.append_path 'app/assets/images'

map("/css")      { run stylesheets }
map("/fonts")    { run fonts }
map("/font")    { run fonts }
map("/js")       { run javascripts }
map("/img")       { run images }

map('/') { run Steam::App }
