alias then yield_self

require 'bundler/setup'
Bundler.require
require 'active_record'
require 'sinatra'
require 'sinatra/reloader'
require 'net/http'
require 'uri'
require 'optparse'

$disp_chrome_flag = false
$silent_flag      = false
opt = OptionParser.new
opt.on('--disp_chrome') { $disp_chrome_flag = true }
opt.on('--silent') { $silent_flag = true }
opt.parse(ARGV)

require_relative './database.rb'
require_relative './crawler.rb'
require_relative './parser.rb'
require_relative './handler.rb'
