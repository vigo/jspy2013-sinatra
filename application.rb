# encoding: utf-8

require 'rubygems'
require 'bundler/setup'
require 'sinatra/base'

class MyApp < Sinatra::Base
  get '/' do
    "Merhaba Dünya! saat: #{Time.now}"
  end
  
  get '/merhaba/:user_name' do
    "Merhaba #{params[:user_name]}!"
  end
  
  get '/merhaba/*/numaran/*' do
    "#{params[:splat][0]}, #{params[:splat][1]}"
  end

  get '/indir/*.*' do |file, ext|
    "Dosya: #{file}, Tipi: #{ext}"
  end

  get %r{/kullanici/([\w]+)/?(\d+)?} do
    "Yakalananlar: #{params[:captures]}"
  end

  get '/kazanan/:user/?:id?' do
    "Kazanan #{params[:user]}, id var mı? #{!params[:id].nil?}"
  end
  
  # AppleWebKit/536.28.10
  # Sadece AppleWebKit tarayıcıları için
  get '/ajan', :agent => /AppleWebKit\/(\d+)/ do
    mversion = @params[:agent].first
    "AppleWebKit major sürümü: #{mversion}"
  end

  get '/ajan' do
    "Tüm tarayıcılar için..."
  end

  get '/request' do
    out = []
    [
      'accept',
      'scheme',
      'script_name',
      'path_info',
      'port',
      'request_method',
      'query_string',
      'content_length',
      'media_type',
      'host',
      'referrer',
      'user_agent',
      'cookies',
      'url',
      'path',
      'ip',
      'xhr?',
      'secure?',
      'forwarded?',
    ].each do |m|
      out << "<strong>%s</strong>: %s" % [m, request.send(m)]
    end
    out << "<hr/>env<hr/>"
    
    request.env.each do |k,v|
      out << "<strong>%s</strong>: %s" % [k, v]
    end
    
    "#{out.join('<br/>')}"
  end

  # get '/', :host_name => /^admin\./ do
  #   "Admin Bölümü"
  # end

  run! if app_file == $0
end