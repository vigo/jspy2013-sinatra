# encoding: utf-8

require 'rubygems'
require 'bundler/setup'
require 'sinatra/base'

class MyApp < Sinatra::Base
  get '/' do
    "jspy-conf #{Time.now} at the server!"
  end
  
  run! if app_file == $0
end