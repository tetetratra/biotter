alias then yield_self

require 'bundler/setup'
Bundler.require
require 'active_record'
require 'net/http'
require 'uri'

require_relative './database.rb'
require_relative './crawler.rb'
require_relative './parser.rb'
require_relative './handler.rb'
