$LOAD_PATH.unshift File.expand_path(File.dirname(__FILE__))

require 'dotenv'
Dotenv.load

require 'rubygems'
require 'bundler/setup'
require 'sinatra/base'
require 'slim'
require 'sequel'
require 'sinatra_auth_github'
require 'byebug'
require 'pry-byebug'

DB = Sequel.connect('postgres://nilcolor@localhost:5432/steam_dev')
# DB schema
require 'schema'

# Models
require 'models/specimen'

require 'app'
