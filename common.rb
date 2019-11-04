alias then yield_self

require 'bundler/setup'
Bundler.require
require 'active_record'
require 'sinatra'
require 'sinatra/reloader'
require 'net/http'
require 'uri'
require 'open-uri'
require 'optparse'
require_relative './database.rb'
require_relative './handler.rb'

opt = OptionParser.new
opt.parse(ARGV)
