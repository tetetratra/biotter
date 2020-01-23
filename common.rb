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

class String
  def add_a_tag
    new_str = self
    URI.extract(self, %w[https http]).each do |url|
      new_str = new_str.gsub(url, %(<a href="#{url}">#{ URI.parse(url).host }</a>))
    end
    new_str
  end
end
