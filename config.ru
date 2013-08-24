require File.expand_path(File.dirname(__FILE__) + '/app/boot')

require 'sprockets'

stylesheets = Sprockets::Environment.new
stylesheets.append_path 'app/assets/styles'

javascripts = Sprockets::Environment.new
javascripts.append_path 'app/assets/scripts'

map("/css")      { run stylesheets }
map("/js")       { run javascripts }

map('/') { run Steam::App }
